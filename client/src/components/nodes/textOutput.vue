<template>
  <div> 
    <template v-for="(socket, index) in sockets">
      <div v-if="'query' in socket.output">
        {{socket.output.query}}
      </div>
    </template>
    <q-select
      @change="onChange"
      toggle
      multiple
      v-model="socketSelection"
      :options="getSocketSelections"
    />
  </div>
</template>

<script>
import nodeMixin from './nodeMixin'
import {
  QSelect
} from 'quasar'
export default {
  name: 'textOutput',
  mixins: [nodeMixin],
  components: {
    QSelect
  },
  data () {
    return {
      title: 'Text Output',
      socketSelection: []
    }
  },
  methods: {
    onChange (newValue) {
      console.log(newValue)
    }
  }
}
</script>
<style scoped>

</style>
