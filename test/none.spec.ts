import { describe, it } from 'mocha'
import { doNothing, doNothingAsync } from '../src/none'
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
