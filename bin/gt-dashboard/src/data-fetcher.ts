import { execa } from 'execa';
import { PR, Repository, PRCheck } from './types.js';

export class DataFetcher {
  async fetchRecentPRs(limit: number = 20): Promise<any[]> {
    const { stdout } = await execa('gh', [
      'search',
      'prs',
      '--author=@me',
      'state:open',
      '--sort=updated',
      `--limit=${limit}`,
      '--json',
      'repository,number,title,updatedAt,state,isDraft,url'
    ]);
    
    return JSON.parse(stdout);
  }

  async fetchPRDetails(repo: string, prNumber: number): Promise<any> {
    try {
      const { stdout } = await execa('gh', [
        'pr',
        'view',
        prNumber.toString(),
        '--repo',
        repo,
        '--json',
        'headRefName,baseRefName,statusCheckRollup,reviews,reviewRequests,reviewDecision,mergeable,mergeStateStatus'
      ]);
      
      return JSON.parse(stdout);
    } catch {
      return { headRefName: '', baseRefName: '', statusCheckRollup: null };
    }
  }

  async fetchPRChecks(repo: string, prNumber: number): Promise<PRCheck[]> {
    try {
      const { stdout } = await execa('gh', [
        'pr',
        'checks',
        prNumber.toString(),
        '--repo',
        repo,
        '--json',
        'name,state,completedAt,startedAt,link,description,workflow'
      ]);
      
      return JSON.parse(stdout);
    } catch {
      return [];
    }
  }

  async fetchPRFiles(repo: string, prNumber: number): Promise<any> {
    try {
      const { stdout } = await execa('gh', [
        'pr',
        'view',
        prNumber.toString(),
        '--repo',
        repo,
        '--json',
        'files'
      ]);
      
      return JSON.parse(stdout);
    } catch {
      return { files: [] };
    }
  }

  async fetchGraphiteStack(repoPath: string): Promise<string[]> {
    try {
      const { stdout } = await execa('gt', ['log', 'short'], {
        cwd: repoPath
      });
      
      const branches = stdout
        .split('\n')
        .filter(line => line.includes('◯') || line.includes('◉'))
        .map(line => {
          const match = line.match(/[◯◉]\s+(.+?)(?:\s+\(current\))?$/);
          return match ? match[1].trim() : null;
        })
        .filter((branch): branch is string => branch !== null);
      
      return branches;
    } catch {
      return [];
    }
  }

  async fetchGraphiteStatus(repoPath: string): Promise<{ stacks: Map<string, string[]>, needsRestack: Map<string, boolean> }> {
    const needsRestack = new Map<string, boolean>();
    const stacks = new Map<string, string[]>();
    
    try {
      const { stdout } = await execa('gt', ['log'], {
        cwd: repoPath
      });
      
      
      const lines = stdout.split('\n');
      let currentStack: string[] = [];
      let stackStarted = false;
      
      for (const line of lines) {
        // Check if this line has a branch marker
        if (line.includes('◯') || line.includes('◉')) {
          // Extract branch name - handle various formats
          let branchName: string | null = null;
          
          // Try different regex patterns
          const patterns = [
            /[◯◉]\s+(.+?)(?:\s+\(|$)/,
            /[◯◉]\s+(.+?)$/,
            /[◯◉]\s+(\S+)/
          ];
          
          for (const pattern of patterns) {
            const match = line.match(pattern);
            if (match) {
              branchName = match[1].trim();
              break;
            }
          }
          
          if (branchName) {
            
            // Check if this is the start of a stack
            if (line.includes('┌')) {
              stackStarted = true;
              currentStack = [branchName];
            } else if (line.includes('├') || line.includes('└')) {
              if (stackStarted) {
                currentStack.push(branchName);
              }
              
              // End of stack
              if (line.includes('└')) {
                for (const branch of currentStack) {
                  stacks.set(branch, [...currentStack]);
                }
                currentStack = [];
                stackStarted = false;
              }
            }
            
            if (line.includes('(needs restack)') || line.includes('⚠') || 
                line.includes('stale') || line.includes('needs rebase')) {
              needsRestack.set(branchName, true);
            }
          }
        }
      }
    } catch (error) {
      // Silently fail
    }
    
    return { stacks, needsRestack };
  }
}