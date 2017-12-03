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
export const addToSockets = (state, socket) => {
  state.sockets.push(socket)
}
export const removeFromSockets = (state, socket) => {
  let index = state.sockets.indexOf(socket)
  if (index !== -1) state.sockets.splice(index, 1)
}
export const updateSockets = (state, socket) => {
  state.sockets.some(oldSocket => {
    if (oldSocket.id === socket.id) {
      Object.assign(oldSocket, socket)
      return true
    }
  })
}
