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
import nodeMixin from './nodeMixin'
export default {
  name: 'textInput',
  mixins: [nodeMixin],
  components: {
    QInput
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