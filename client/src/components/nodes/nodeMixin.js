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
  },
  methods: {
    read (property) {
      return this.sockets.map(socket => {
        if (property in socket.input) return socket.input[property]
      })
    },
    write (value, property) {
      return this.sockets.map(socket => {
        socket.output[property] = value
        return socket.output
      })
    }
  }
}
