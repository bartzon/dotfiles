import { PR } from './types.js';
import { execa } from 'execa';
import open from 'open';

export interface Action {
  key: string;
  name: string;
  description: string;
  execute: (pr: PR) => Promise<void>;
}

export const actions: Action[] = [
  {
    key: 'o',
    name: 'Open in Graphite',
    description: 'Open PR in Graphite',
    execute: async (pr: PR) => {
      const graphiteUrl = `https://app.graphite.dev/github/${pr.repository.owner}/${pr.repository.name}/pull/${pr.number}`;
      await open(graphiteUrl);
    }
  },
  {
    key: 'c',
    name: 'Copy Branch',
    description: 'Copy branch name to clipboard',
    execute: async (pr: PR) => {
      await execa('pbcopy', [], {
        input: pr.branch
      });
    }
  },
  {
    key: 'b',
    name: 'CI Runs',
    description: 'Open CI runs (Bitrise/Buildkite)',
    execute: async (pr: PR) => {
      if (pr.status?.checks && pr.status.checks.length > 0) {
        const mainCheck = pr.status.checks.find(check => 
          check.name?.includes('Bitrise') || 
          check.name?.includes('Buildkite') ||
          check.workflow?.includes('main')
        ) || pr.status.checks[0];
        
        if (mainCheck?.link) {
          await open(mainCheck.link);
          return;
        }
      }
      
      if (!pr.branch) {
        const checksUrl = `${pr.url}/checks`;
        await open(checksUrl);
        return;
      }
      
      if (pr.repository.name === 'pos-next-react-native') {
        const bitriseUrl = `https://app.bitrise.io/app/cef4169c-117c-4c39-b5e6-b76fe1e8a778/pipelines?branch=${encodeURIComponent(pr.branch)}`;
        await open(bitriseUrl);
      } else if (pr.repository.fullName === 'shop/world' || pr.repository.owner === 'Shopify') {
        const buildkiteUrl = `https://buildkite.com/shopify/${pr.repository.name}/builds?branch=${encodeURIComponent(pr.branch)}`;
        await open(buildkiteUrl);
      } else {
        const actionsUrl = `${pr.url}/checks`;
        await open(actionsUrl);
      }
    }
  },
  {
    key: 'r',
    name: 'Refresh',
    description: 'Refresh PR data',
    execute: async () => {
    }
  },
  {
    key: 'q',
    name: 'Quit',
    description: 'Quit the application',
    execute: async () => {
      process.exit(0);
    }
  }
];

export function getAction(key: string): Action | undefined {
  return actions.find(action => action.key === key);
}
