import { describe, it } from 'mocha'
import { doNothing, doNothingAsync } from '../src/none'
import { expect } from 'chai'

describe(
  '@kei-g/none',
  () => {
    it(
      'doNothing',
      () => {
        const result = doNothing()
        expect(result).equals(undefined)
      }
    )
    it(
      'doNothingAsync',
      async () => {
        const result = await doNothingAsync()
        expect(result).equals(undefined)
      }
    )
  }
)
