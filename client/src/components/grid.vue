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
          <q-toolbar class="drag bg-negative">
            <q-toolbar-title 
              class="drag">
              <q-input 
                class="text-primary"
                v-model="item.properties.title" />
            </q-toolbar-title>
            <q-btn
              flat
              @click="remove(item.id)">
              <q-icon 
                name="fa-window-close" />
            </q-btn>
          </q-toolbar>
          <component
            :is="item.properties.component"
            :socket-id="item.properties">
          </component>
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
import {
  Container,
  Box
} from '@dattn/dnd-grid'
import {
  QInput,
  QSelect,
  QList,
  QItem,
  QPopover,
  QItemSide,
  QToolbar,
  QBtn,
  QToolbarTitle,
  QIcon,
  QItemMain
} from 'quasar'
import {
  mapGetters,
  mapActions,
  mapMutations
} from 'vuex'
import nodeTextOutput from './nodes/textOutput'
import nodeQueryInput from './nodes/queryInput'
export default {
  components: {
    QInput,
    QSelect,
    QItemMain,
    QList,
    QItem,
    QPopover,
    QItemSide,
    nodeTextOutput,
    nodeQueryInput,
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
      table: null,
      links: []
    }
  },
  mounted () {
    this.table = this.$db.layouts
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
          layouts.forEach(box => this.save(box))
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
    setLinks (box) {
      console.log(box)
    },
    getLayoutsByType (type) {
      return this.$store.getters.getLayoutsByType(type)
    },
    getLayoutsSelectionsByType (type) {
      return this.$store.getters.getLayoutsSelectionsByType(type)
    },
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
