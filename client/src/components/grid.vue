<template>
  <div class="layout-padding row justify-center">
    <container :layout.sync="layouts">
      <template v-for="(item, index) in layouts">
        <box 
          class="box"
          drag-selector=".drag"
          v-on:dragEnd="dragEnd = true"
          v-on:resizeEnd="resizeEnd = true"
          :box-id="item.id">
          <q-toolbar class="drag">
            <q-toolbar-title class="drag">
              {{item.properties.title}}
            </q-toolbar-title>
            <q-btn flat @click="remove(item.id)">
              <q-icon name="fa-window-close" />
            </q-btn>
          </q-toolbar>
          <p>{{item.id}}</p>
        </box>
      </template>   
    </container>
  </div>
</template>

<style scoped>
  .box {
    border-style: solid;
    border-width: 1px;
  }
</style>

<script>
import { Container, Box } from '@dattn/dnd-grid'
import { QToolbar,
  QBtn,
  QToolbarTitle,
  QIcon
} from 'quasar'
import {
  mapGetters,
  mapActions,
  mapMutations
} from 'vuex'

export default {
  components: {
    Box,
    Container,
    QToolbar,
    QToolbarTitle,
    QBtn,
    QIcon
  },
  data () {
    return {
      dragEnd: false,
      resizeEnd: false,
      table: this.$db.layouts
    }
  },
  mounted () {
    this.table.each((item, cursor) => {
      if (item.active) this.addToLayouts(item.box)
    })
  },
  computed: {
    ...mapGetters([
      'getLayouts'
    ]),
    layouts: {
      get () {
        return this.getLayouts
      },
      set (layouts) {
        if (this.dragEnd || this.resizeEnd) {
          layouts.forEach(box => {
            this.save(box)
          })
          this.dragEnd = false
          this.resizeEnd = false
        }
      }
    }
  },
  methods: {
    ...mapActions([
      'saveBox',
      'removeBox'
    ]),
    ...mapMutations([
      'addToLayouts',
      'updateLayouts',
      'removeFromLayouts'
    ]),
    save (box) {
      return this.saveBox({ box, table: this.table })
    },
    remove (id) {
      this.layouts.some(box => {
        if (box.id === id) {
          this.removeBox({ box, table: this.table })
          return true
        }
      })
    }
  }
}
</script>

<style>
@import '../../node_modules/@dattn/dnd-grid/dist/index.css'
</style>
