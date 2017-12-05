<template>
  <div>
    <q-input
      v-for="(item, index) in query"
      v-bind:key="index"
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
  mounted () {
    console.log('queryInput', this.$parent.$parent)
  },
  data () {
    return {
      title: 'Query Input'
    }
  },
  computed: {
    query: {
      get () {
        this.read('query')
      },
      set (val) {
        console.log('write', this.write(val, 'query'))
      }
    }
  }
}
</script>
<style scoped>

</style>