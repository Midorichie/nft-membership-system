// tests/setup.ts
import { beforeAll, afterAll, vi } from 'vitest'

// Mock setup for testing environment
const mockSimnet = {
  init: vi.fn(),
  teardown: vi.fn()
}

beforeAll(async () => {
  // Initialize test setup
  await mockSimnet.init()
})

afterAll(async () => {
  // Cleanup after tests
  await mockSimnet.teardown()
})

export { mockSimnet }
