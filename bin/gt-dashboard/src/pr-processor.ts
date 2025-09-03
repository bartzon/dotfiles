import { PR, Repository, PRStatus, PRCheck, StackInfo, ReviewStatus } from './types.js';
import { DataFetcher } from './data-fetcher.js';
import { CacheManager } from './cache.js';
import graphlib from 'graphlib';
const { Graph, alg } = graphlib;

export class PRProcessor {
  private fetcher: DataFetcher;
  private cache: CacheManager;

  constructor(cache?: CacheManager) {
    this.fetcher = new DataFetcher();
    this.cache = cache || new CacheManager();
  }

  async getProcessedPRs(limit: number = 20): Promise<PR[]> {
    const rawPRs = await this.fetcher.fetchRecentPRs(limit);
    const basicPRs = rawPRs
      .map((pr: any) => this.parseBasicPR(pr))
      .filter((pr: PR) => pr.state === 'open');
    return basicPRs;
  }

  async enrichPRs(prs: PR[], preserveOrder: boolean = false): Promise<PR[]> {
    const enrichedPRs = await Promise.all(prs.map(pr => this.enrichPR(pr)));
    const prsWithStacks = this.detectStacks(enrichedPRs, preserveOrder);
    
    // Check for restack status by repository
    const repoGroups = new Map<string, PR[]>();
    for (const pr of prsWithStacks) {
      const key = pr.repository.fullName;
      const group = repoGroups.get(key) || [];
      group.push(pr);
      repoGroups.set(key, group);
    }
    
    for (const [repo, repoPRs] of repoGroups) {
      const repoPath = this.getRepoPath(repoPRs[0].repository);
      const { stacks: graphiteStacks, needsRestack } = await this.fetcher.fetchGraphiteStatus(repoPath);
      
      for (const pr of repoPRs) {
        if (pr.branch) {
          // Check if PR is in a Graphite stack
          const stackBranches = graphiteStacks.get(pr.branch);
          if (stackBranches && stackBranches.length > 1) {
            // This PR is in a stack according to Graphite
            if (!pr.stack || !pr.stack.hasStack) {
              // Create stack info if missing
              const position = stackBranches.indexOf(pr.branch);
              pr.stack = {
                hasStack: true,
                depth: position,
                total: stackBranches.length,
                isBottom: position === 0,
                isTop: position === stackBranches.length - 1,
                needsRestack: needsRestack.has(pr.branch)
              };
            }
          }
          
          if (pr.stack && needsRestack.has(pr.branch)) {
            pr.stack.needsRestack = true;
          }
        }
      }
    }
    
    return prsWithStacks;
  }

  async enrichPR(pr: PR, skipCache: boolean = false): Promise<PR> {
    const [details, checks, slice] = await Promise.all([
      this.fetcher.fetchPRDetails(pr.repository.fullName, pr.number),
      this.fetcher.fetchPRChecks(pr.repository.fullName, pr.number),
      this.getSliceInfo(pr.repository.fullName, pr.number)
    ]);
    
    if (slice) {
      pr.repository.slice = slice;
    }
    
    const enrichedPR = {
      ...pr,
      branch: details.headRefName || pr.branch,
      baseBranch: details.baseRefName || pr.baseBranch,
      status: this.parseStatus(details.statusCheckRollup, checks),
      reviewStatus: this.parseReviewStatus(details),
      mergeable: details.mergeable,
      mergeStateStatus: details.mergeStateStatus
    };

    return enrichedPR;
  }

  private parseBasicPR(rawPR: any): PR {
    const [owner, name] = rawPR.repository.nameWithOwner.split('/');
    
    return {
      number: rawPR.number,
      title: rawPR.title,
      repository: {
        name,
        owner,
        fullName: rawPR.repository.nameWithOwner
      },
      state: rawPR.state.toLowerCase() as PR['state'],
      isDraft: rawPR.isDraft,
      updatedAt: new Date(rawPR.updatedAt),
      branch: '',
      baseBranch: '',
      url: rawPR.url || `https://github.com/${rawPR.repository.nameWithOwner}/pull/${rawPR.number}`,
      status: undefined
    };
  }

  private async getSliceInfo(repo: string, prNumber: number): Promise<string | undefined> {
    if (repo !== 'shop/world') {
      return undefined;
    }
    
    const data = await this.fetcher.fetchPRFiles(repo, prNumber);
    const files = data.files || [];
    
    for (const file of files) {
      const match = file.path?.match(/^areas\/([^\/]+)\//);
      if (match) {
        return match[1];
      }
    }
    
    return undefined;
  }

  private parseStatus(rollup: any, checks: PRCheck[]): PRStatus | undefined {
    if (checks && checks.length > 0) {
      let successCount = 0;
      let failedCount = 0;
      let pendingCount = 0;
      
      for (const check of checks) {
        const state = check.state;
        
        if (state === 'PENDING') {
          pendingCount++;
        } else if (state === 'SUCCESS') {
          successCount++;
        } else if (state === 'FAILURE' || state === 'ERROR') {
          failedCount++;
        }
      }
      
      const totalCount = checks.length;
      
      let state: PRStatus['state'] = 'neutral';
      if (failedCount > 0) {
        state = 'failure';
      } else if (pendingCount > 0) {
        state = 'pending';
      } else if (successCount === totalCount && totalCount > 0) {
        state = 'success';
      }
      
      return {
        state,
        totalCount,
        failedCount,
        pendingCount,
        successCount,
        checks
      };
    }
    
    if (!rollup || !Array.isArray(rollup)) return undefined;
    
    let successCount = 0;
    let failedCount = 0;
    let pendingCount = 0;
    
    for (const check of rollup) {
      const state = check.state?.toLowerCase();
      const conclusion = check.conclusion?.toLowerCase();
      
      if (state === 'pending' || state === 'queued') {
        pendingCount++;
      } else if (conclusion === 'success') {
        successCount++;
      } else if (conclusion === 'failure' || conclusion === 'cancelled') {
        failedCount++;
      }
    }
    
    const totalCount = rollup.length;
    
    let state: PRStatus['state'] = 'neutral';
    if (failedCount > 0) {
      state = 'failure';
    } else if (pendingCount > 0) {
      state = 'pending';
    } else if (successCount === totalCount && totalCount > 0) {
      state = 'success';
    }
    
    return {
      state,
      totalCount,
      failedCount,
      pendingCount,
      successCount,
      checks: []
    };
  }

  private detectStacks(prs: PR[], preserveOrder: boolean = false): PR[] {
    const g = new Graph({ directed: true });
    const branchToPR = new Map<string, PR>();
    const numberToPR = new Map<number, PR>();
    
    for (const pr of prs) {
      if (pr.branch) {
        branchToPR.set(pr.branch, pr);
      }
      numberToPR.set(pr.number, pr);
      g.setNode(pr.number.toString(), pr);
    }
    
    for (const pr of prs) {
      if (!pr.branch || !pr.baseBranch) continue;
      
      const parentPR = branchToPR.get(pr.baseBranch);
      if (parentPR && parentPR.number !== pr.number) {
        g.setEdge(parentPR.number.toString(), pr.number.toString());
      }
      
    }
    
    const orphanedPRs = prs.filter(pr => 
      pr.baseBranch?.startsWith('graphite-base/') && 
      g.predecessors(pr.number.toString())?.length === 0
    );
    
    for (const orphan of orphanedPRs) {
      const repoPRs = prs
        .filter(pr => pr.repository.fullName === orphan.repository.fullName)
        .sort((a, b) => a.number - b.number);
      
      let bestParent: PR | null = null;
      let minDistance = Infinity;
      
      for (const candidate of repoPRs) {
        if (candidate.number >= orphan.number) continue;
        
        const distance = orphan.number - candidate.number;
        if (distance < minDistance) {
          minDistance = distance;
          bestParent = candidate;
        }
      }
      
      if (bestParent) {
        g.setEdge(bestParent.number.toString(), orphan.number.toString());
      }
    }
    
    const components = alg.components(g);
    
    const componentRoots = new Map<string, string>();
    for (const component of components) {
      if (component.length > 1) {
        const lowestPRNumber = Math.min(...component.map(n => parseInt(n)));
        const rootNode = lowestPRNumber.toString();
        
        for (const node of component) {
          componentRoots.set(node, rootNode);
        }
      }
    }
    
    for (const pr of prs) {
      const root = componentRoots.get(pr.number.toString());
      
      if (root) {
        const componentNodes = components.find(comp => comp.includes(pr.number.toString()))!;
        const pred = g.predecessors(pr.number.toString());
        const succ = g.successors(pr.number.toString());
        
        let depth = 0;
        let current = pr.number.toString();
        while (true) {
          const preds = g.predecessors(current);
          if (!preds || preds.length === 0 || !componentNodes.includes(preds[0])) break;
          depth++;
          current = preds[0];
        }
        
        let treeDepth = 0;
        if (pr.baseBranch?.startsWith('graphite-base/') && pred && pred.length > 0) {
          const parentPR = numberToPR.get(parseInt(pred[0]));
          if (parentPR && parentPR.stack?.depth === 1) {
            treeDepth = 1;
          }
        }
        
        pr.stack = {
          hasStack: true,
          stackId: `stack-${root}`,
          depth: depth,
          parent: pred && pred.length > 0 ? parseInt(pred[0]) : undefined,
          children: succ && succ.length > 0 ? succ.map(s => parseInt(s)) : undefined,
          isBottom: pr.number.toString() === root,
          isTop: !succ || succ.length === 0,
          total: componentNodes.length,
          treeDepth: treeDepth,
          graphDepth: depth
        };
      }
    }
    
    if (!preserveOrder) {
      prs.sort((a, b) => {
        const aHasStack = a.stack?.hasStack || false;
        const bHasStack = b.stack?.hasStack || false;
        
        if (aHasStack !== bHasStack) {
          return aHasStack ? -1 : 1;
        }
        
        if (aHasStack && bHasStack) {
          const aStackId = a.stack!.stackId!;
          const bStackId = b.stack!.stackId!;
          
          if (aStackId !== bStackId) {
            const aRoot = parseInt(aStackId.replace('stack-', ''));
            const bRoot = parseInt(bStackId.replace('stack-', ''));
            return aRoot - bRoot;
          }
          
          const aDepth = a.stack!.graphDepth || 0;
          const bDepth = b.stack!.graphDepth || 0;
          return aDepth - bDepth;
        }
        
        return a.number - b.number;
      });
    }
    
    // After sorting, update stack positions to reflect actual order
    const stackPositions = new Map<string, number>();
    for (const pr of prs) {
      if (pr.stack?.hasStack) {
        const stackId = pr.stack.stackId!;
        if (!stackPositions.has(stackId)) {
          stackPositions.set(stackId, 0);
        }
        const position = stackPositions.get(stackId)!;
        pr.stack.depth = position;
        stackPositions.set(stackId, position + 1);
      }
    }
    
    return prs;
  }

  getRepoPath(repo: Repository): string {
    return `/Users/bartzonneveld/src/github.com/${repo.owner}/${repo.name}`;
  }

  private parseReviewStatus(details: any): ReviewStatus | undefined {
    if (!details.reviews && !details.reviewRequests && !details.reviewDecision) {
      return undefined;
    }

    const reviews = details.reviews || [];
    const reviewRequests = details.reviewRequests || [];
    const reviewDecision = details.reviewDecision;

    let approved = 0;
    let changesRequested = 0;
    let pending = 0;
    let dismissed = 0;

    const reviewsByAuthor = new Map<string, any>();
    for (const review of reviews) {
      const author = review.author?.login;
      if (!author) continue;

      const existing = reviewsByAuthor.get(author);
      if (!existing || new Date(review.submittedAt) > new Date(existing.submittedAt)) {
        reviewsByAuthor.set(author, review);
      }
    }

    for (const review of reviewsByAuthor.values()) {
      switch (review.state) {
        case 'APPROVED':
          approved++;
          break;
        case 'CHANGES_REQUESTED':
          changesRequested++;
          break;
        case 'DISMISSED':
          dismissed++;
          break;
        case 'PENDING':
          pending++;
          break;
      }
    }

    const hasReviewRequests = reviewRequests.length > 0;
    const hasAnyReviews = approved + changesRequested + pending + dismissed > 0;

    let status: ReviewStatus['status'] = 'ready';

    if (reviewDecision === 'APPROVED') {
      status = 'approved';
    } else if (changesRequested > 0) {
      status = 'changes_requested';
    } else if (reviewDecision === 'REVIEW_REQUIRED') {
      if (hasReviewRequests) {
        status = 'needs_more_reviews';
      } else if (!hasAnyReviews && !hasReviewRequests) {
        status = 'needs_more_reviewers';
      } else {
        status = 'needs_more_reviews';
      }
    }

    return {
      required: reviewDecision === 'REVIEW_REQUIRED',
      approved,
      changesRequested,
      pending,
      dismissed,
      status
    };
  }
}