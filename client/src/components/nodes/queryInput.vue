<template>
  <q-input
    v-model="output"
    type="textarea"
    float-label="Textarea"
    :max-height="100"
    :min-rows="6"
  />
</template>
<script>
import {
  QInput
} from 'quasar'
export default {
  name: 'textInput',
  components: {
    QInput
  },
  props: {
    socketId: {
      type: String
    }
  },
  mounted () {
    console.log('queryInput', this.$parent.$parent)
  },
  data () {
    return {
      title: 'Query Input',
      output: ''
    }
  },
  methods: {
  }
}
</script>
<style scoped>

</style>