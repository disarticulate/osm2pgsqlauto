<template>
  <div class="layout-padding row justify-center">
    <container
      ref="container"
      :layout.sync="boxes">
      <template
        v-for="(box, index) in boxes">
        <node-box
          v-bind:key="box.id"
          :box="box">
        </node-box>
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
    Container
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
      Container
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
      }
    }
  }
</script>

