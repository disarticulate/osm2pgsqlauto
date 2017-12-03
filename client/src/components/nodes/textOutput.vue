<template>
  <div> 
    <template v-for="(socket, index) in sockets">
      <div v-if="'query' in socket.output">
        {{socket.output.query}}
      </div>
    </template>
  </div>
</template>

<script>
import nodeMixin from './nodeMixin'
export default {
  name: 'textOutput',
  mixins: [nodeMixin],
  data () {
    return {
      title: 'Text Output'
    }
  }
}
</script>
<style scoped>

</style>
