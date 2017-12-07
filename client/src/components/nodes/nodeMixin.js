import { mapGetters, mapMutations } from 'vuex'
export default {
  props: {
    box: {
      type: Object
    }
  },
  mounted () {
    console.log(this)
    this.socket = this.getSocketsByBoxId(this.box.id)
  },
  computed: {
    ...mapGetters([
      'getSocketsByBoxId'
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
