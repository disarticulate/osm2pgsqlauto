<template>
  <box
    class="box"
    ref="box"
    v-inview:enter="() => visible(box)"
    drag-selector=".drag"
    v-on:dragEnd="$parent.dragEnd = true"
    v-on:resizeEnd="$parent.resizeEnd = true"
    :container="container"
    :box-id="box.id">
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
  </box>
</template>
<style scoped>
  .box {
    padding: 0.1em;
    border-style: solid;
    border-width: 1px;
  }
</style>
<script>
  import {
    Box
  } from '@dattn/dnd-grid'

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
      },
      container: {
        type: Object
      }
    },
    components: {
      Box,
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
      ]),
      visible (box) {
        console.log('visible', box)
        // this.addToLayouts(box)
        // this.saveBox(box)
      }
    }
  }
</script>
<style scoped>
    @import '../../node_modules/@dattn/dnd-grid/dist/index.css';
</style>