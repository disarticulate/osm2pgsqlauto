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
  name: 'textInput',
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
      console.log(newVal)
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