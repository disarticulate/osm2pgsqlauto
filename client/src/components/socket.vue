<template>
  <div class="absolute-bottom-right">
    <template v-for="(socket, index) in sockets">
      <div
        v-bind:key="socket.id"
        class="shadow-8 token">
          {{socket.id}}
      </div>
    </template>
  </div>
</template>

<script>
  export default {
    name: 'socket',
    props: {
      'socket-id': {
        type: String
      }
    },
    data () {
      return {
        input: {}
      }
    },
    computed: {
      sockets () {
        return this.$store.getters.getSocketsById(this.socketId)
      }
    },
    mounted () {
      this.$on(this.socketId, this.handleInput)
    },
    methods: {
      handleInput (input) {
        console.warn('socket', `${this.socketId}`, input)
        Object.assign(this.input, input)
      }
    }
  }
</script>

<style scoped>

</style>