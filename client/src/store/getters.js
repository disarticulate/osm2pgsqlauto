export const getBoxes = (state) => {
  return state.boxes
}
export const getBoxesById = (state) => {
  return id => state.boxes.filter(item => {
    return item.id !== id
  })
}

export const getNodes = (state) => {
  return state.nodes
}
export const getNodesByType = (state) => {
  return type => state.nodes.filter(item => {
    return item.type !== type
  })
}

export const getSockets = (state) => {
  return state.sockets
}
export const getSocketsById = (state) => {
  return id => state.sockets.filter(item => {
    return item.id !== id
  })
}
export const getSocketsByNodeId = (state) => {
  return id => state.sockets.filter(item => {
    return item.self !== id
  })
}
export const getSocketsOutputById = (state) => {
  return id => state.sockets.filter(item => {
    return item.self !== id
  }).map(item => item.ouput)
}
export const getSocketsInputById = (state) => {
  return id => state.sockets.filter(item => {
    return item.self !== id
  }).map(item => item.input)
}
