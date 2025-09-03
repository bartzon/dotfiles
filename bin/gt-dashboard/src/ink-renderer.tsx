import React, { useState, useEffect } from 'react';
import { render, Box, Text, useInput } from 'ink';
import { format } from 'timeago.js';
import { PR } from './types.js';
import { Renderer, RendererState } from './renderer.js';
import { InputProcessor } from './input-handler.js';
import { actions } from './actions.js';


const PRRow: React.FC<{ pr: PR; isSelected: boolean }> = ({ pr, isSelected }) => {
  let repo = pr.repository.name;
  if (pr.repository.fullName === 'shop/world' && pr.repository.slice) {
    repo = `world/${pr.repository.slice}`;
  } else if (pr.repository.owner !== 'Shopify') {
    repo = pr.repository.fullName;
  }

  let stackDisplay = '';
  let stackColor: string | undefined;
  if (pr.stack?.hasStack) {
    const isBottom = pr.stack.isBottom;
    const isTop = pr.stack.isTop;
    const depth = pr.stack.depth || 0;
    const total = pr.stack.total || 0;
    const treeDepth = pr.stack.treeDepth || 0;

    if (treeDepth > 0) {
      stackDisplay = `  └─ ${depth + 1}/${total}`;
    } else if (isBottom && total > 1) {
      stackDisplay = `┌─ Stack (${total})`;
    } else if (depth > 0) {
      if (isTop) {
        stackDisplay = `└─ ${depth + 1}/${total}`;
      } else {
        stackDisplay = `├─ ${depth + 1}/${total}`;
      }
    } else {
      stackDisplay = '─ Stack';
    }
    
    stackColor = 'cyan';
  } else {
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
  } else if (pr.reviewStatus && pr.state === 'open' && !pr.isDraft) {
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
  let checksColor: string | undefined = undefined;
  if (pr.status) {
    const { state, successCount, totalCount, failedCount, pendingCount } = pr.status;
    const symbol =
      state === 'success' ? '✓' : state === 'failure' ? '✗' : state === 'pending' ? '○' : '-';

    checksDisplay = `${symbol} ${successCount}/${totalCount}`;

    if (failedCount > 0) {
      checksDisplay += ` (${failedCount} failed)`;
      checksColor = 'red';
    } else if (pendingCount > 0) {
      checksDisplay += ` (${pendingCount} pending)`;
      checksColor = 'yellow';
    } else if (state === 'success') {
      checksColor = 'green';
    }
  } else {
    checksDisplay = 'Pending';
    checksColor = 'yellow';
  }

  return (
    <Box>
      <Box width={2}>
        <Text inverse={isSelected}>{isSelected ? '▶' : ' '}</Text>
      </Box>
      <Box width={8}>
        <Text color={isSelected ? undefined : 'blue'} inverse={isSelected}>#{pr.number.toString().padEnd(6)}</Text>
      </Box>
      <Box width={66}>
        <Text wrap="truncate-end" inverse={isSelected}>
          {pr.stack?.treeDepth ? '  '.repeat(pr.stack.treeDepth) : ''}{pr.title}{pr.mergeable === 'CONFLICTING' ? ' ⚡' : ''}
        </Text>
      </Box>
      <Box width={25}>
        <Text color={isSelected ? undefined : 'cyan'} wrap="truncate-end" inverse={isSelected}>
          {repo}
        </Text>
      </Box>
      <Box width={15}>
        <Text color={isSelected ? undefined : stackColor} inverse={isSelected}>{stackDisplay || '·'}</Text>
      </Box>
      <Box width={22}>
        <Text color={isSelected ? undefined : statusColor} dimColor={!isSelected && !statusColor} inverse={isSelected}>
          {statusText}
        </Text>
      </Box>
      <Box width={20}>
        <Text color={isSelected ? undefined : checksColor} dimColor={!isSelected && !checksColor} inverse={isSelected}>
          {checksDisplay}
        </Text>
      </Box>
      <Box width={16}>
        <Text inverse={isSelected}>{format(pr.updatedAt)}</Text>
      </Box>
    </Box>
  );
};

interface DashboardProps {
  state: RendererState;
  inputProcessor?: InputProcessor;
}

const InteractiveDashboard: React.FC<DashboardProps> = ({ state, inputProcessor }) => {
  useInput((input, key) => {
    if (inputProcessor) {
      inputProcessor.processInput(input, key);
    }
  });

  return <DashboardContent state={state} />;
};

const NonInteractiveDashboard: React.FC<DashboardProps> = ({ state }) => {
  return <DashboardContent state={state} />;
};

const Dashboard: React.FC<DashboardProps> = ({ state, inputProcessor }) => {
  if (process.stdin.isTTY && inputProcessor) {
    return <InteractiveDashboard state={state} inputProcessor={inputProcessor} />;
  }
  return <NonInteractiveDashboard state={state} />;
};

const DashboardContent: React.FC<{ state: RendererState }> = ({ state }) => {
  return (
    <Box flexDirection="column" width="100%">
      <Box>
        <Text bold color="cyan">
          🚀 Graphite PR Dashboard
        </Text>
      </Box>

      <Box flexDirection="column" width="100%">
        {state.filteredPRs.length === 0 && state.filterQuery ? (
          <Box paddingY={2}>
            <Text color="gray">No PRs match '{state.filterQuery}'</Text>
          </Box>
        ) : (
          state.filteredPRs.map((pr: any, index) => (
            <PRRow key={`${pr.repository.fullName}-${pr.number}`} pr={pr as PR} isSelected={index === state.selectedIndex} />
          ))
        )}
      </Box>

      <Box justifyContent="space-between">
        <Text color="gray">
          Showing {state.filteredPRs.length} 
          {state.filterQuery && ` of ${state.prs.length}`} pull requests
          {state.filterQuery && ' (filtered)'}
        </Text>
        {state.lastRefreshTime && (
          <Text color="gray">Last refresh: {format(state.lastRefreshTime)}</Text>
        )}
      </Box>

      <Box marginTop={1}>
        <Text dimColor>
          Keys: {actions.map(a => `${a.key}=${a.name}`).join(' | ')} | /=Filter
        </Text>
      </Box>

      {state.isLoading && state.loadingProgress && (
        <Box marginTop={1}>
          <Text color="yellow">
            Fetching latest data... {state.loadingProgress.total - state.loadingProgress.completed} remaining
          </Text>
        </Box>
      )}

      {state.filterMode && (
        <Box flexDirection="column" marginTop={1}>
          <Box>
            <Text color="cyan">Filter: </Text>
            <Text>{state.filterQuery}</Text>
            <Text color="gray">_</Text>
          </Box>
          <Box marginTop={1}>
            <Text dimColor>
              Syntax: text | repo:name | status:open/draft | checks:failed | review:approved | restack | conflicts | -exclude
            </Text>
          </Box>
        </Box>
      )}

      {state.statusMessage && (
        <Box marginTop={1}>
          <Text color="yellow">{state.statusMessage}</Text>
        </Box>
      )}
    </Box>
  );
};

export class InkRenderer implements Renderer {
  private app: any;
  private updateHandler?: (state: RendererState) => void;
  private inputProcessor?: InputProcessor;

  setInputProcessor(processor: InputProcessor): void {
    this.inputProcessor = processor;
  }

  render(state: RendererState): void {
    if (!this.app) {
      const inputProc = this.inputProcessor;
      const Component = () => {
        const [currentState, setCurrentState] = useState(state);
        
        useEffect(() => {
          this.updateHandler = (newState) => {
            setCurrentState(newState);
          };
        }, []);
        
        return (
          <Dashboard 
            state={currentState}
            inputProcessor={inputProc}
          />
        );
      };
      
      this.app = render(<Component />);
    } else if (this.updateHandler) {
      this.updateHandler(state);
    }
  }

  clear(): void {
  }

  cleanup(): void {
    if (this.app) {
      this.app.unmount();
      this.app = null;
    }
  }
}
