#!/usr/bin/env node
import { InkRenderer } from './ink-renderer.js';
import { DashboardController } from './dashboard-controller.js';
import { InputProcessor } from './input-handler.js';

async function main() {
  const args = process.argv.slice(2);
  const nonInteractive = args.includes('--non-interactive') || args.includes('-n');
  
  let controller: DashboardController | null = null;
  
  const cleanup = () => {
    if (controller) {
      controller.stop();
    }
  };

  process.on('exit', cleanup);
  process.on('SIGINT', cleanup);
  process.on('SIGTERM', cleanup);
  process.on('uncaughtException', (error) => {
    console.error('Uncaught error:', error);
    cleanup();
  });

  try {
    const renderer = new InkRenderer();
    controller = new DashboardController(renderer, { nonInteractive });
    
    const inputProcessor = new InputProcessor(controller);
    controller.setInputProcessor(inputProcessor);
    renderer.setInputProcessor(inputProcessor);
    
    await controller.start();
    
  } catch (error) {
    console.error('Error:', error);
    cleanup();
  }
}

main();