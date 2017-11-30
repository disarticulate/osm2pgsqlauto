<template>
  <div class="layout-padding row justify-center">
    <container :layout.sync="layout">
      <box
        class="box"
        box-id="box-a">
        <q-toolbar>
          <q-toolbar-title>
            Toolbar
          </q-toolbar-title>
          <q-btn flat>
            <q-icon name="fa-window-close" />
          </q-btn>
        </q-toolbar>
        <h1>Box 1</h1>  
      </box>
      <box box-id="box-b">
        <h1>Box 2</h1>
      </box>
    </container>
  </div>
</template>

<style>
  .box {
    border-style: solid;
    border-width: 1px;
  }
</style>

<script>
// import Container and Box components
import { Container, Box } from '@dattn/dnd-grid'
import { QToolbar, QBtn, QToolbarTitle, QIcon } from 'quasar'
// minimal css for the components to work properly
export default {
  components: {
    'box': Box,
    'container': Container,
    QToolbar,
    QToolbarTitle,
    QBtn,
    QIcon
  },
  data () {
    return {
      layout: [
        {
          id: 'box-a',
          hidden: false,
          pinned: false,
          position: {
            x: 0,
            y: 0,
            w: 4,
            h: 2
          }
        },
        {
          id: 'box-b',
          hidden: false,
          pinned: false,
          position: {
            x: 4,
            y: 0,
            w: 2,
            h: 1
          }
        }
      ]
    }
  }
}
</script>

<style>
@import '../../node_modules/@dattn/dnd-grid/dist/index.css'
</style>
