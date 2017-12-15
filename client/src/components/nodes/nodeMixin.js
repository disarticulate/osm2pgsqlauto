import { mapGetters, mapMutations } from 'vuex'
export default {
  props: {
    box: {
      type: Object
    }
  },
  mounted () {
    this.socket = this.getSocketsByBoxId(this.box.id)
  },
  computed: {
    ...mapGetters([
      'getSocketsByBoxId',
      'getSocketSelections'
    ]),
    sockets () {
      return this.$store.getters.getSocketsByBoxId(this.box.id)
    }
  },
  methods: {
    ...mapMutations([
      'updateSockets'
    ])
  }
}
