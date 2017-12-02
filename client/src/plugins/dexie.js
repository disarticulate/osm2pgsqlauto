import Dexie from 'dexie'

const openStore = (name, version, schema) => {
  return new Promise((resolve, reject) => {
    let dbStore = new Dexie(name)
    dbStore.on('versionchange', function (event) {
      console.log('openStore:worker:versionchange')
    })
    dbStore
      .version(version)
      .stores(schema)
    dbStore.open().then(() => {
      console.log(`openStore:${name}`, name, version, schema)
      resolve(dbStore)
    })
  })
}

export const dexiePlugin = {
  install (Vue, Options) {
    openStore('persistence', 1, {
      layouts: 'key, title, active, box'
    }).then(db => (Vue.prototype.$db = db))
  }
}
