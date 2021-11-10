export type Experiment = {
  id: number
  name: string
}

export const experiment = (param?: Experiment) => {
  return typeof param === 'undefined'
}
