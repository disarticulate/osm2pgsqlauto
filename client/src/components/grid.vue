<template>
  <div class="layout-padding row justify-center">
    <container
      ref="container"
      :layout.sync="boxes">

      <template
        v-for="(box, index) in boxes">
        <box
          class="box shadow-8"
          v-bind:key="box.id"
          v-inview:enter="() => visible(box)"
          drag-selector=".drag"
          v-on:dragEnd="dragEnd = true"
          v-on:resizeEnd="resizeEnd = true"
          :box-id="box.id">
          <node-box
            v-bind:key="box.id"
            :box="box">
          </node-box>
        </box>
      </template>   
    </container>
  </div>
</template>

<style scoped>
  .box {
    border-style: solid;
    border-width: 1px;
    padding-bottom:0.1em;
  }
</style>

<script>
  import {
    Container,
    Box
  } from '@dattn/dnd-grid'

  import {
    mapGetters,
    mapActions,
    mapMutations
  } from 'vuex'

  import nodeSocket from './socket'
  import nodeBox from './nodeBox'

  export default {
    components: {
      nodeSocket,
      nodeBox,
      Container,
      Box
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
        'createSocket'
      ]),
      ...mapMutations([
        'addToBoxes'
      ]),
      save (box) {
        return this.saveBox({ box, table: this.table })
      },
      visible (box) {
        console.log('visible', box)
        // this.addToLayouts(box)
        // this.saveBox(box)
      }
    }
  }
</script>

