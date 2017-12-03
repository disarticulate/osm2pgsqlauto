export const saveBox = ({ commit }, { box, table }) => {
  commit('updateBoxes', box)
  return new Promise((resolve, reject) => {
    table.put({
      key: box.id,
      ...box.properties,
      box
    }).then(result => resolve(result))
      .catch(err => reject(err))
  })
}
export const removeBox = ({ commit }, { box, table }) => {
  commit('removeFromBoxes', box)
  return new Promise((resolve, reject) => {
    box.properties.active = false
    table.put({
      key: box.id,
      ...box.properties,
      box
    }).then(result => resolve(result))
      .catch(err => reject(err))
  })
}
export const createBox = ({ commit, dispatch }, properties) => {
  let box = {
    properties,
    component: properties.component,
    id: 'box-' + require('uuid/v4')(),
    hidden: false,
    pinned: false,
    position: {
      x: 0,
      y: 0,
      w: 4,
      h: 2
    }
  }
  commit('addToBoxes', box)
  return new Promise((resolve, reject) => {
    resolve(box)
  })
}

export const createSocket = ({ commit }, box) => {
  let socket = {
    id: require('uuid/v4')(),
    self: box.id,
    nodes: [],
    output: {},
    input: {}
  }
  commit('addToSockets', socket)
  return new Promise((resolve, reject) => {
    resolve(socket)
  })
}
