export const doNothing = () => {
}

export const doNothingAsync = () => new Promise<void>(
  (resolve) => resolve()
)
