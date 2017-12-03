export const addToBoxes = (state, box) => {
  if (!state.boxes.some(item => (item.id === box.id))) {
    state.boxes.push(box)
  }
}
export const removeFromBoxes = (state, box) => {
  let index = state.boxes.indexOf(box)
  if (index !== -1) state.boxes.splice(index, 1)
}
export const updateBoxes = (state, box) => {
  state.boxes.some(oldBox => {
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
