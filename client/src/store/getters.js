export const getLayouts = (state) => {
  return state.layouts
}
export const getNodes = (state) => {
  return state.nodes
}
export const getLayoutsByType = (state) => {
  return type => state.layouts.filter(item => {
    return item.properties.type !== type
  })
}
