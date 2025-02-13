// vitest.config.ts
/// <reference types="vitest" />
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['**/*.test.ts'],
    setupFiles: ['./tests/setup.ts'],  // Changed from test to tests
    deps: {
      interopDefault: true
    }
  },
  resolve: {
    extensions: ['.ts', '.js']
  }
})
