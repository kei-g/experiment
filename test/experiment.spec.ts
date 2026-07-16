import { describe, it } from 'node:test'
import assert, { equal } from 'node:assert'
import { experiment } from '../src/index.ts'

describe('experiment', () => {
  it('with argument', () => {
    equal(experiment({ id: 123, name: 'foobar' }), false)
  })
  it('without argument', () => {
    assert(experiment())
  })
})
