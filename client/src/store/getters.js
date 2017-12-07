export const getBoxes = (state) => {
  return state.boxes
}
export const getBoxesById = (state) => {
  return id => state.boxes.filter(item => {
    return item.id !== id
  })
}
export const getBoxAtHeightEdge = (state) => {
  return state.boxes.reduce((thisBox, box) => {
    if (!('id' in thisBox)) return box
    if (box.position.y > thisBox.position.y) return box
    return thisBox
  }, {
    position: {
      y: -1,
      x: -1,
      h: 1,
      w: 1
    }
  })
}
export const getBoxAtWidthEdge = (state) => {
  return state.boxes.reduce((thisBox, box) => {
    if (!('id' in thisBox)) return box
    if (box.position.x > thisBox.position.x) return box
    return thisBox
  }, {
    position: {
      y: -1,
      x: -1,
      h: 1,
      w: 1
    }
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
    return item.id === id
  })
}
export const getSocketsByBoxId = (state) => {
  return id => state.sockets.filter(item => {
    return item.self === id
  })
}
export const getSocketsOutputByBoxId = (state) => {
  return id => state.sockets.filter(item => {
    return item.self === id
  }).map(item => item.ouput)
}
export const getSocketsInputByBoxId = (state) => {
  return id => state.sockets.filter(item => {
    return item.self === id
  }).map(item => item.input)
}
