export const saveBox = ({ commit }, { box, table }) => {
  commit('updateLayouts', box)
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
  commit('removeFromLayouts', box)
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
export const loadBox = (store, key) => {
  return new Promise((resolve, reject) => {
    store._vm.$db.layouts
      .get({ key })
      .then(result => resolve(result))
      .catch(err => reject(err))
  })
}

export const createBox = (store, properties) => {
  return new Promise((resolve, reject) => {
    resolve({
      properties,
      id: 'box-' + require('uuid/v4')(),
      hidden: false,
      pinned: false,
      position: {
        x: 0,
        y: 0,
        w: 4,
        h: 2
      }
    })
  })
}
