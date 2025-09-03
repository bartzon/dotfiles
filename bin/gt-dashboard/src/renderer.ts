export interface RendererState {
  prs: any[];
  lastRefreshTime: Date | null;
  selectedIndex: number;
  statusMessage: string;
  isLoading: boolean;
  loadingProgress?: {
    completed: number;
    total: number;
  };
  filterMode: boolean;
  filterQuery: string;
  filteredPRs: any[];
}

export interface Renderer {
  render(state: RendererState): void;
  clear(): void;
  cleanup?: () => void;
  setInputProcessor?: (processor: any) => void;
}