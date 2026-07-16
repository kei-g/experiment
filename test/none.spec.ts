import { describe, it } from 'node:test'
import { doNothing, doNothingAsync } from '../src/none.ts'
import { equal } from 'node:assert'

describe(
  '@kei-g/none',
  () => {
    it(
      'doNothing',
      () => {
        const result = doNothing()
        equal(result, undefined)
      }
    )
    it(
      'doNothingAsync',
      async () => {
        const result = await doNothingAsync()
        equal(result, undefined)
      }
    )
  }
)
