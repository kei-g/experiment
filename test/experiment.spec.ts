import { describe, it } from 'mocha'
import assert, { equal } from 'node:assert'
import { experiment } from '../src'

describe('experiment', () => {
  it('with argument', () => {
    equal(experiment({ id: 123, name: 'foobar' }), false)
  })
  it('without argument', () => {
    assert(experiment())
  })
})
