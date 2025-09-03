import { PR } from './types.js';
import { promises as fs } from 'fs';
import { homedir } from 'os';
import { join } from 'path';

const CACHE_FILE = join(homedir(), '.gt-dashboard-pr-cache.json');
const CACHE_TTL = 30 * 60 * 1000; // 30 minutes

interface CacheData {
  prs: PR[];
  timestamp: number;
  version: number;
}

export class CacheManager {
  private static readonly CACHE_VERSION = 2;
  
  async loadCache(): Promise<PR[] | null> {
    try {
      const data = await fs.readFile(CACHE_FILE, 'utf-8');
      const cacheData: CacheData = JSON.parse(data);
      
      if (cacheData.version !== CacheManager.CACHE_VERSION) {
        return null;
      }
      
      const age = Date.now() - cacheData.timestamp;
      if (age > CACHE_TTL) {
        return null;
      }
      
      const prs = cacheData.prs.map(pr => ({
        ...pr,
        updatedAt: new Date(pr.updatedAt)
      }));
      
      return prs;
    } catch {
      return null;
    }
  }

  async saveCache(prs: PR[]): Promise<void> {
    const cacheData: CacheData = {
      prs,
      timestamp: Date.now(),
      version: CacheManager.CACHE_VERSION
    };
    
    await fs.writeFile(CACHE_FILE, JSON.stringify(cacheData, null, 2));
  }
  
  getCachedPRs(): PR[] {
    return [];
  }
  
  getCachedPR(repo: string, number: number): PR | null {
    return null;
  }
  
  setCachedPR(pr: PR): void {
  }
}