<template>
  <div>
    <q-toolbar class="drag bg-negative">
      <q-icon
        class="drag"
        name="fa-arrows"/>
      <q-toolbar-title 
        class="drag">
        <q-input
          v-model="box.properties.title"
          readonly/>
      </q-toolbar-title>
      <q-btn
        flat
        @click="removeFromBoxes(box)">
        <q-icon 
          name="fa-window-close"/>
      </q-btn>
    </q-toolbar>
    <component
      :box-id="box.id"
      :is="box.properties.component">
    </component>
    <node-socket
      v-bind:key="socketItem.id"
      v-for="(socketItem, socketIndex) in getSocketsByBoxId(box.id)"
      :socket-id="socketItem.id">
    </node-socket>
  </div>
</template>
<style scoped>
  .box {
    padding: 0.1em;
    border-style: solid;
    border-width: 1px;
  }
</style>
<script>
  import nodeTextOutput from './nodes/textOutput'
  import nodeQueryInput from './nodes/queryInput'
  import nodeSocket from './socket'
  
  import {
    mapGetters,
    mapMutations
  } from 'vuex'
  
  import {
    QInput,
    QToolbar,
    QToolbarTitle,
    QBtn,
    QIcon
  } from 'quasar'
  
  export default {
    name: 'node-box',
    props: {
      box: {
        type: Object
      }
    },
    components: {
      nodeSocket,
      nodeQueryInput,
      nodeTextOutput,
      QToolbar,
      QToolbarTitle,
      QBtn,
      QIcon,
      QInput
    },
    mounted () {
      console.log(this.container)
    },
    computed: {
      ...mapGetters([
        'getSocketsByBoxId'
      ])
    },
    methods: {
      ...mapMutations([
        'removeFromBoxes'
      ])
    }
  }
</script>
<style scoped>
    @import '../../node_modules/@dattn/dnd-grid/dist/index.css';
</style>