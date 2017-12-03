export default {
  props: {
    boxId: {
      type: String
    }
  },
  computed: {
    sockets () {
      return this.$store.getters.getSocketsByBoxId(this.boxId)
    }
  }
}
