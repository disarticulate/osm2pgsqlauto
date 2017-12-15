<template>
  <div>
    <q-input
      v-model="input"
      type="textarea"
      float-label="Textarea"
      :max-height="100"
      :min-rows="6"
    />
  </div>
</template>
<script>
import {
  QInput
} from 'quasar'

import nodeMixin from './nodeMixin'
export default {
  name: 'queryInput',
  mixins: [nodeMixin],
  components: {
    QInput
  },
  data () {
    return {
      title: 'Query Input',
      input: '',
      socket: null
    }
  },
  watch: {
    input (newVal, oldVal) {
      this.socket.forEach(socket => {
        socket.input[this.$parent.box.id] = newVal
        this.updateSockets(socket)
      })
    }
  }
}
</script>
<style scoped>

</style>