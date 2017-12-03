<template>
  <div class="layout-padding row justify-center">
    <container 
      :layout.sync="boxes">
      <template
        v-for="(item, index) in boxes">
        <box
          class="box"
          v-inview:enter="() => visible(item)"
          drag-selector=".drag"
          v-on:dragEnd="dragEnd = true"
          v-on:resizeEnd="resizeEnd = true"
          :box-id="item.id">
          <q-toolbar class="drag bg-negative">
            <q-icon
              class="drag"
              name="fa-arrows"/>
            <q-toolbar-title 
              class="drag">
              <q-input
                v-model="item.properties.title"
                readonly/>
            </q-toolbar-title>
            <q-btn
              flat
              @click="remove(item.id)">
              <q-icon 
                name="fa-window-close" />
            </q-btn>
          </q-toolbar>
          <component
            :is="item.properties.component">
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
  QList,
  QItemSide,
  QToolbar,
  QBtn,
  QToolbarTitle,
  QIcon
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
    QList,
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
      isMounted: false,
      dragEnd: false,
      resizeEnd: false,
      table: null,
      links: []
    }
  },
  mounted () {
    this.table = this.$db.layouts
    this.table.each((item, cursor) => {
      if (item.active) {
        this.addToBoxes(item.box)
        this.createSocket(item.box)
      }
    }).then(() => (this.isMounted = true))
  },
  watch: {
    getBoxes (boxes) {
      if (this.isMounted) {
        boxes.map(box => this.save(box))
      }
    }
  },
  computed: {
    ...mapGetters([
      'getBoxes'
    ]),
    boxes: {
      get () {
        return this.getBoxes
      },
      set (boxes) {
        if (this.dragEnd || this.resizeEnd) {
          boxes.forEach(box => this.save(box))
          this.dragEnd = false
          this.resizeEnd = false
        }
      }
    }
  },
  methods: {
    ...mapActions([
      'saveBox',
      'removeBox',
      'createSocket'
    ]),
    ...mapMutations([
      'addToBoxes',
      'updateBoxes',
      'removeFromBoxess'
    ]),
    setLinks (box) {
      console.log(box)
    },
    visible (box) {
      console.log('visible', box)
      // this.addToLayouts(box)
      // this.saveBox(box)
    },
    save (box) {
      return this.saveBox({ box, table: this.table })
    },
    remove (id) {
      this.boxes.some(box => {
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
