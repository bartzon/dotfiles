export interface Repository {
  name: string;
  owner: string;
  fullName: string;
  slice?: string; // For monorepo slices (e.g., "core" in shop/world)
}

export interface PRCheck {
  name: string;
  state: 'SUCCESS' | 'FAILURE' | 'PENDING' | 'SKIPPED' | 'NEUTRAL' | 'ERROR';
  completedAt?: string;
  startedAt?: string;
  link?: string;
  description?: string;
  workflow?: string;
}

export interface PRStatus {
  state: 'success' | 'failure' | 'pending' | 'neutral';
  totalCount: number;
  failedCount: number;
  pendingCount: number;
  successCount: number;
  checks: PRCheck[];
}

export interface PR {
  number: number;
  title: string;
  repository: Repository;
  state: 'open' | 'closed' | 'merged';
  isDraft: boolean;
  updatedAt: Date;
  branch: string;
  baseBranch: string;
  url: string;
  status?: PRStatus;
  reviewStatus?: ReviewStatus;
  stack?: StackInfo;
  mergeable?: 'MERGEABLE' | 'CONFLICTING' | 'UNKNOWN';
  mergeStateStatus?: 'BEHIND' | 'UNSTABLE' | 'CLEAN' | 'BLOCKED' | 'DIRTY' | 'UNKNOWN';
}

export interface ReviewStatus {
  required: boolean;
  approved: number;
  changesRequested: number;
  pending: number;
  dismissed: number;
  status: 'approved' | 'needs_more_reviews' | 'needs_more_reviewers' | 'changes_requested' | 'ready';
}

export interface StackInfo {
  position?: number;  // Position in stack if known
  total?: number;     // Total PRs in stack if known
  isBottom?: boolean; // Is this the bottom of the stack?
  isTop?: boolean;    // Is this the top of the stack?
  hasStack: boolean;  // Is this PR part of a stack?
  stackId?: string;   // Unique identifier for the stack
  depth?: number;     // Depth in the stack tree (0 = base, 1 = first child, etc)
  parent?: number;    // PR number of the parent in the stack
  children?: number[]; // PR numbers of children in the stack
  needsRestack?: boolean; // Does this branch need restacking (Graphite-specific)
  treeDepth?: number; // Nesting level for rendering (0 = root level, 1 = nested once, etc)
  graphDepth?: number; // Original depth in the dependency graph
}

export interface GraphiteStack {
  repository: Repository;
  branches: GraphiteBranch[];
}

export interface GraphiteBranch {
  name: string;
  prNumber?: number;
  isCurrent: boolean;
  isTracked: boolean;
}