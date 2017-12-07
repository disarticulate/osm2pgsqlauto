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
        @click="remove(box)">
        <q-icon 
          name="fa-window-close"/>
      </q-btn>
    </q-toolbar>
    <component
      :box="box"
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
    mapMutations,
    mapActions,
    mapGetters
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
    data () {
      return {
        table: null
      }
    },
    mounted () {
      this.table = this.$db.layouts
    },
    computed: {
      ...mapGetters([
        'getSocketsByBoxId'
      ])
    },
    methods: {
      ...mapMutations([

      ]),
      ...mapActions([
        'removeBox'
      ]),
      remove (box) {
        this.removeBox({ box, table: this.table })
      }
    }
  }
</script>
<style scoped>
    @import '../../node_modules/@dattn/dnd-grid/dist/index.css';
</style>