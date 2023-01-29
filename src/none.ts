export const doNothing = (..._args: unknown[]) => {
}

export const doNothingAsync = (..._args: unknown[]) => new Promise<void>(
  (resolve) => resolve()
)
