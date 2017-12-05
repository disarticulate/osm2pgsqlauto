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
    computed: {
      sockets () {
        return this.$store.getters.getSocketsById(this.socketId)
      }
    }
  }
</script>

<style scoped>

</style>