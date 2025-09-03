import React, { useState, useEffect } from 'react';
import { render, Box, Text, useInput } from 'ink';
import { format } from 'timeago.js';
import { actions } from './actions.js';
const PRRow = ({ pr, isSelected }) => {
    let repo = pr.repository.name;
    if (pr.repository.fullName === 'shop/world' && pr.repository.slice) {
        repo = `world/${pr.repository.slice}`;
    }
    else if (pr.repository.owner !== 'Shopify') {
        repo = pr.repository.fullName;
    }
    let stackDisplay = '';
    let stackColor;
    if (pr.stack?.hasStack) {
        const isBottom = pr.stack.isBottom;
        const isTop = pr.stack.isTop;
        const depth = pr.stack.depth || 0;
        const total = pr.stack.total || 0;
        const treeDepth = pr.stack.treeDepth || 0;
        if (treeDepth > 0) {
            stackDisplay = `  └─ ${depth + 1}/${total}`;
        }
        else if (isBottom && total > 1) {
            stackDisplay = `┌─ Stack (${total})`;
        }
        else if (depth > 0) {
            if (isTop) {
                stackDisplay = `└─ ${depth + 1}/${total}`;
            }
            else {
                stackDisplay = `├─ ${depth + 1}/${total}`;
            }
        }
        else {
            stackDisplay = '─ Stack';
        }
        stackColor = 'cyan';
    }
    else {
        stackDisplay = '·';
        stackColor = 'gray';
    }
    const statusColor = pr.state === 'open' ? 'green' : undefined;
    let statusText = pr.isDraft
        ? 'Draft'
        : pr.state === 'open'
            ? 'Open'
            : pr.state === 'closed'
                ? 'Closed'
                : 'Merged';
    if (pr.stack?.needsRestack) {
        statusText = 'Needs rebase';
    }
    else if (pr.reviewStatus && pr.state === 'open' && !pr.isDraft) {
        switch (pr.reviewStatus.status) {
            case 'needs_more_reviews':
                statusText = 'Needs more reviews';
                break;
            case 'needs_more_reviewers':
                statusText = 'Needs more reviewers';
                break;
            case 'changes_requested':
                statusText = 'Changes requested';
                break;
            case 'approved':
                statusText = 'Approved';
                break;
        }
    }
    let checksDisplay = '';
    let checksColor = undefined;
    if (pr.status) {
        const { state, successCount, totalCount, failedCount, pendingCount } = pr.status;
        const symbol = state === 'success' ? '✓' : state === 'failure' ? '✗' : state === 'pending' ? '○' : '-';
        checksDisplay = `${symbol} ${successCount}/${totalCount}`;
        if (failedCount > 0) {
            checksDisplay += ` (${failedCount} failed)`;
            checksColor = 'red';
        }
        else if (pendingCount > 0) {
            checksDisplay += ` (${pendingCount} pending)`;
            checksColor = 'yellow';
        }
        else if (state === 'success') {
            checksColor = 'green';
        }
    }
    else {
        checksDisplay = 'Pending';
        checksColor = 'yellow';
    }
    return (React.createElement(Box, null,
        React.createElement(Box, { width: 2 },
            React.createElement(Text, { inverse: isSelected }, isSelected ? '▶' : ' ')),
        React.createElement(Box, { width: 8 },
            React.createElement(Text, { color: isSelected ? undefined : 'blue', inverse: isSelected },
                "#",
                pr.number.toString().padEnd(6))),
        React.createElement(Box, { width: 66 },
            React.createElement(Text, { wrap: "truncate-end", inverse: isSelected },
                pr.stack?.treeDepth ? '  '.repeat(pr.stack.treeDepth) : '',
                pr.title,
                pr.mergeable === 'CONFLICTING' ? ' ⚡' : '')),
        React.createElement(Box, { width: 25 },
            React.createElement(Text, { color: isSelected ? undefined : 'cyan', wrap: "truncate-end", inverse: isSelected }, repo)),
        React.createElement(Box, { width: 15 },
            React.createElement(Text, { color: isSelected ? undefined : stackColor, inverse: isSelected }, stackDisplay || '·')),
        React.createElement(Box, { width: 22 },
            React.createElement(Text, { color: isSelected ? undefined : statusColor, dimColor: !isSelected && !statusColor, inverse: isSelected }, statusText)),
        React.createElement(Box, { width: 20 },
            React.createElement(Text, { color: isSelected ? undefined : checksColor, dimColor: !isSelected && !checksColor, inverse: isSelected }, checksDisplay)),
        React.createElement(Box, { width: 16 },
            React.createElement(Text, { inverse: isSelected }, format(pr.updatedAt)))));
};
const InteractiveDashboard = ({ state, inputProcessor }) => {
    useInput((input, key) => {
        if (inputProcessor) {
            inputProcessor.processInput(input, key);
        }
    });
    return React.createElement(DashboardContent, { state: state });
};
const NonInteractiveDashboard = ({ state }) => {
    return React.createElement(DashboardContent, { state: state });
};
const Dashboard = ({ state, inputProcessor }) => {
    if (process.stdin.isTTY && inputProcessor) {
        return React.createElement(InteractiveDashboard, { state: state, inputProcessor: inputProcessor });
    }
    return React.createElement(NonInteractiveDashboard, { state: state });
};
const DashboardContent = ({ state }) => {
    return (React.createElement(Box, { flexDirection: "column", width: "100%" },
        React.createElement(Box, null,
            React.createElement(Text, { bold: true, color: "cyan" }, "\uD83D\uDE80 Graphite PR Dashboard")),
        React.createElement(Box, { flexDirection: "column", width: "100%" }, state.filteredPRs.length === 0 && state.filterQuery ? (React.createElement(Box, { paddingY: 2 },
            React.createElement(Text, { color: "gray" },
                "No PRs match '",
                state.filterQuery,
                "'"))) : (state.filteredPRs.map((pr, index) => (React.createElement(PRRow, { key: `${pr.repository.fullName}-${pr.number}`, pr: pr, isSelected: index === state.selectedIndex }))))),
        React.createElement(Box, { justifyContent: "space-between" },
            React.createElement(Text, { color: "gray" },
                "Showing ",
                state.filteredPRs.length,
                state.filterQuery && ` of ${state.prs.length}`,
                " pull requests",
                state.filterQuery && ' (filtered)'),
            state.lastRefreshTime && (React.createElement(Text, { color: "gray" },
                "Last refresh: ",
                format(state.lastRefreshTime)))),
        React.createElement(Box, { marginTop: 1 },
            React.createElement(Text, { dimColor: true },
                "Keys: ",
                actions.map(a => `${a.key}=${a.name}`).join(' | '),
                " | /=Filter")),
        state.isLoading && state.loadingProgress && (React.createElement(Box, { marginTop: 1 },
            React.createElement(Text, { color: "yellow" },
                "Fetching latest data... ",
                state.loadingProgress.total - state.loadingProgress.completed,
                " remaining"))),
        state.filterMode && (React.createElement(Box, { flexDirection: "column", marginTop: 1 },
            React.createElement(Box, null,
                React.createElement(Text, { color: "cyan" }, "Filter: "),
                React.createElement(Text, null, state.filterQuery),
                React.createElement(Text, { color: "gray" }, "_")),
            React.createElement(Box, { marginTop: 1 },
                React.createElement(Text, { dimColor: true }, "Syntax: text | repo:name | status:open/draft | checks:failed | review:approved | restack | conflicts | -exclude")))),
        state.statusMessage && (React.createElement(Box, { marginTop: 1 },
            React.createElement(Text, { color: "yellow" }, state.statusMessage)))));
};
export class InkRenderer {
    app;
    updateHandler;
    inputProcessor;
    setInputProcessor(processor) {
        this.inputProcessor = processor;
    }
    render(state) {
        if (!this.app) {
            const inputProc = this.inputProcessor;
            const Component = () => {
                const [currentState, setCurrentState] = useState(state);
                useEffect(() => {
                    this.updateHandler = (newState) => {
                        setCurrentState(newState);
                    };
                }, []);
                return (React.createElement(Dashboard, { state: currentState, inputProcessor: inputProc }));
            };
            this.app = render(React.createElement(Component, null));
        }
        else if (this.updateHandler) {
            this.updateHandler(state);
        }
    }
    clear() {
    }
    cleanup() {
        if (this.app) {
            this.app.unmount();
            this.app = null;
        }
    }
}
