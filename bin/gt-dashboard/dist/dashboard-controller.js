import { PRProcessor } from './pr-processor.js';
import { CacheManager } from './cache.js';
import { getAction } from './actions.js';
import { filterPRs } from './filter.js';
export class DashboardController {
    processor;
    cache;
    renderer;
    state;
    refreshInterval = null;
    isExiting = false;
    inputProcessor;
    nonInteractive;
    renderDebounceTimer;
    pendingRenderUpdate = false;
    constructor(renderer, options) {
        this.cache = new CacheManager();
        this.processor = new PRProcessor(this.cache);
        this.renderer = renderer;
        this.nonInteractive = options?.nonInteractive || false;
        this.state = {
            prs: [],
            lastRefreshTime: null,
            selectedIndex: 0,
            statusMessage: '',
            isLoading: false,
            loadingProgress: undefined,
            filterMode: false,
            filterQuery: '',
            filteredPRs: []
        };
    }
    setInputProcessor(processor) {
        this.inputProcessor = processor;
    }
    async start() {
        this.render();
        const cachedPRs = await this.cache.loadCache();
        if (cachedPRs && cachedPRs.length > 0) {
            this.state.prs = cachedPRs;
            this.state.filteredPRs = filterPRs(cachedPRs, this.state.filterQuery);
            this.state.lastRefreshTime = new Date();
            this.render();
        }
        if (this.nonInteractive) {
            if (!cachedPRs || cachedPRs.length === 0) {
                await this.loadPRs();
            }
            setTimeout(async () => {
                await this.executeAction('q', this.state.prs[0]);
            }, 50);
            return;
        }
        setTimeout(() => {
            this.loadPRs();
        }, 0);
        this.refreshInterval = setInterval(async () => {
            await this.loadPRs();
        }, 5 * 60 * 1000);
    }
    stop() {
        if (this.isExiting)
            return;
        this.isExiting = true;
        if (this.refreshInterval) {
            clearInterval(this.refreshInterval);
        }
        if (this.renderer.cleanup) {
            this.renderer.cleanup();
        }
        process.exit(0);
    }
    async loadPRs() {
        this.state.isLoading = true;
        this.state.statusMessage = '';
        this.render();
        const basicPRs = await this.processor.getProcessedPRs(20);
        const hasExistingPRs = this.state.prs.length > 0;
        let mergedPRs;
        if (hasExistingPRs) {
            mergedPRs = this.state.prs.map(existingPR => {
                const basicPR = basicPRs.find(bp => bp.repository.fullName === existingPR.repository.fullName &&
                    bp.number === existingPR.number);
                if (basicPR) {
                    return {
                        ...existingPR,
                        title: basicPR.title,
                        state: basicPR.state,
                        isDraft: basicPR.isDraft,
                        updatedAt: basicPR.updatedAt
                    };
                }
                return existingPR;
            });
            for (const basicPR of basicPRs) {
                const exists = mergedPRs.find(pr => pr.repository.fullName === basicPR.repository.fullName &&
                    pr.number === basicPR.number);
                if (!exists) {
                    mergedPRs.push(basicPR);
                }
            }
        }
        else {
            mergedPRs = basicPRs;
        }
        this.state.prs = mergedPRs;
        this.state.filteredPRs = filterPRs(mergedPRs, this.state.filterQuery);
        if (this.state.selectedIndex >= this.state.filteredPRs.length) {
            this.state.selectedIndex = Math.max(0, this.state.filteredPRs.length - 1);
        }
        this.render();
        const totalCount = mergedPRs.length;
        this.state.loadingProgress = { completed: 0, total: totalCount };
        this.render();
        const BATCH_SIZE = 10;
        const batches = [];
        for (let i = 0; i < mergedPRs.length; i += BATCH_SIZE) {
            batches.push(mergedPRs.slice(i, i + BATCH_SIZE));
        }
        const enrichedPRs = [...mergedPRs];
        let completedCount = 0;
        for (const batch of batches) {
            const batchPromises = batch.map(async (pr) => {
                const index = mergedPRs.indexOf(pr);
                const enrichedPR = await this.processor.enrichPR(pr, true);
                enrichedPRs[index] = enrichedPR;
                completedCount++;
                this.state.loadingProgress = { completed: completedCount, total: totalCount };
                this.debouncedRender();
            });
            await Promise.all(batchPromises);
        }
        const finalPRs = await this.processor.enrichPRs(enrichedPRs, false);
        this.state.prs = finalPRs;
        this.state.filteredPRs = filterPRs(finalPRs, this.state.filterQuery);
        this.state.lastRefreshTime = new Date();
        this.state.isLoading = false;
        this.state.loadingProgress = undefined;
        this.render();
        await this.cache.saveCache(finalPRs);
    }
    async refresh() {
        await this.loadPRs();
    }
    async executeAction(key, selectedPR) {
        const action = getAction(key);
        if (!action)
            return null;
        if (action.key === 'r') {
            await this.refresh();
            return null;
        }
        try {
            await action.execute(selectedPR);
            return { success: true, message: `✓ ${action.name} completed` };
        }
        catch (error) {
            return { success: false, message: `✗ Error: ${error}` };
        }
    }
    getState() {
        return { ...this.state };
    }
    render() {
        this.renderer.render({ ...this.state });
    }
    debouncedRender() {
        this.pendingRenderUpdate = true;
        if (this.renderDebounceTimer) {
            clearTimeout(this.renderDebounceTimer);
        }
        this.renderDebounceTimer = setTimeout(() => {
            if (this.pendingRenderUpdate) {
                this.render();
                this.pendingRenderUpdate = false;
            }
        }, 50);
    }
    onKeyPress(input, key) {
    }
    onNavigate(direction) {
        const prs = this.state.filteredPRs;
        if (prs.length === 0)
            return;
        if (direction === 'up') {
            this.state.selectedIndex = Math.max(0, this.state.selectedIndex - 1);
        }
        else {
            this.state.selectedIndex = Math.min(prs.length - 1, this.state.selectedIndex + 1);
        }
        this.render();
    }
    async onAction(key) {
        const selectedPR = this.state.filteredPRs[this.state.selectedIndex];
        if (!selectedPR)
            return;
        const result = await this.executeAction(key, selectedPR);
        if (result) {
            this.state.statusMessage = result.message;
            this.render();
            setTimeout(() => {
                this.state.statusMessage = '';
                this.render();
            }, 3000);
        }
    }
    onQuit() {
        this.stop();
    }
    onFilter() {
        this.state.filterMode = true;
        this.state.filterQuery = '';
        if (this.inputProcessor) {
            this.inputProcessor.setFilterMode(true);
        }
        this.applyFilter();
    }
    onFilterInput(input) {
        if (input === '\b' || input === '\x7f') {
            this.state.filterQuery = this.state.filterQuery.slice(0, -1);
        }
        else {
            this.state.filterQuery += input;
        }
        this.applyFilter();
    }
    onFilterEscape() {
        this.state.filterMode = false;
        this.state.filterQuery = '';
        this.state.filteredPRs = [...this.state.prs];
        this.state.selectedIndex = 0;
        if (this.inputProcessor) {
            this.inputProcessor.setFilterMode(false);
        }
        this.render();
    }
    onFilterEnter() {
        this.state.filterMode = false;
        if (this.inputProcessor) {
            this.inputProcessor.setFilterMode(false);
        }
        this.render();
    }
    applyFilter() {
        this.state.filteredPRs = filterPRs(this.state.prs, this.state.filterQuery);
        this.state.selectedIndex = 0;
        this.render();
    }
}
