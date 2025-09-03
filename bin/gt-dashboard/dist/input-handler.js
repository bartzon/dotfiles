export class InputProcessor {
    handler;
    isFilterMode = false;
    constructor(handler) {
        this.handler = handler;
    }
    setFilterMode(enabled) {
        this.isFilterMode = enabled;
    }
    processInput(input, key) {
        if (this.isFilterMode) {
            this.processFilterInput(input, key);
            return;
        }
        if (key.ctrl && input === 'c') {
            this.handler.onQuit();
            return;
        }
        if (key.upArrow || input === 'k') {
            this.handler.onNavigate('up');
            return;
        }
        if (key.downArrow || input === 'j') {
            this.handler.onNavigate('down');
            return;
        }
        if (input === 'q') {
            this.handler.onQuit();
            return;
        }
        if (input === '/') {
            this.handler.onFilter();
            return;
        }
        if (input) {
            this.handler.onAction(input);
        }
    }
    processFilterInput(input, key) {
        if (key.escape) {
            this.handler.onFilterEscape();
            return;
        }
        if (key.return) {
            this.handler.onFilterEnter();
            return;
        }
        if (key.ctrl && input === 'c') {
            this.handler.onQuit();
            return;
        }
        if (key.backspace || key.delete) {
            this.handler.onFilterInput('\b');
            return;
        }
        if (input) {
            this.handler.onFilterInput(input);
        }
    }
}
