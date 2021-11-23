import { experiment } from '..'
import { getInput } from '@actions/core'

(() => {
  const arg = {
    id: Number.parseInt(getInput('id')),
    name: getInput('name'),
  }
  experiment(arg)
  console.log(arg)
})()
