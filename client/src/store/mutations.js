export const addToLayouts = (state, box) => {
  state.layouts.push(box)
}
export const removeFromLayouts = (state, box) => {
  let index = state.layouts.indexOf(box)
  if (index !== -1) state.layouts.splice(index, 1)
}
export const updateLayouts = (state, box) => {
  state.layouts.some(oldBox => {
    if (oldBox.id === box.id) {
      Object.assign(oldBox, box)
      return true
    }
  })
}
