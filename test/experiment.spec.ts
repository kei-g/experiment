import { describe, it } from 'mocha'
import { expect } from 'chai'
import { experiment } from '../src'

describe('experiment', () => {
  it('with argument', () => {
    expect(experiment({ id: 123, name: 'foobar' })).to.be.false
  })
  it('without argument', () => {
    expect(experiment()).to.be.true
  })
})
