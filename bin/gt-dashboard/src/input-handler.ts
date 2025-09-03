import { Key } from 'ink';

export interface InputHandler {
  onKeyPress: (input: string, key: Key) => void;
  onNavigate: (direction: 'up' | 'down') => void;
  onAction: (key: string) => void;
  onQuit: () => void;
  onFilter: () => void;
  onFilterInput: (input: string) => void;
  onFilterEscape: () => void;
  onFilterEnter: () => void;
}

export class InputProcessor {
  private handler: InputHandler;
  private isFilterMode = false;

  constructor(handler: InputHandler) {
    this.handler = handler;
  }

  setFilterMode(enabled: boolean) {
    this.isFilterMode = enabled;
  }

  processInput(input: string, key: Key) {
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

  private processFilterInput(input: string, key: Key) {
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