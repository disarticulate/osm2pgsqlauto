<template>
  <div>
    {{socket.output}}
  </div>
</template>

<script>
export default {
  name: 'textOutput',
  props: {
    socketId: {
      type: String
    }
  },
  computed: {
    socket () {
      return this.$store.getters.getSocketsById(this.socketId)
    }
  },
  data () {
    return {
      title: 'Text Output'
    }
  }
}
</script>
<style scoped>

</style>
