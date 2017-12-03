<template>
  <q-layout
    ref="layout"
    view="lHh Lpr fff"
    :left-class="{'bg-grey-2': true}">
    <q-toolbar slot="header" class="glossy">
      <q-btn
        flat
        @click="$refs.layout.toggleLeft()">
        <q-icon name="fa-bars" />
      </q-btn>

      <q-toolbar-title>
        Osm 2 postgresql query window
        <div slot="subtitle">Running on Quasar v{{$q.version}}</div>
      </q-toolbar-title>
    </q-toolbar>

    <div slot="left">
      <!--
        Use <q-side-link> component
        instead of <q-item> for
        internal vue-router navigation
      -->
      <q-list no-border link inset-delimiter>
        <q-list-header>Query Manager</q-list-header>
        <q-item>
          <q-item-side icon="fa-window-maximize" />
          <q-item-main label="Add Node" sublabel="Open new query window" />
          <q-item-side right icon="fa-bars">
            <q-popover ref="popover">
              <q-list link>
                <q-item 
                  v-for="(item, index) in nodes">
                  <q-item-main 
                    :label="item.text"
                    @click="newBox(item)"/>
                </q-item>
              </q-list>
            </q-popover>
          </q-item-side>
        </q-item>
        <q-collapsible label="Windows">
          <q-item v-for="(item, index) in boxes">
            <q-item-side icon="fa-window-maximize" />
            <q-item-main 
              :label="item.component.text"
              :sublabel="item.properties.title" />
          </q-item>
        </q-collapsible>
      </q-list>
    </div>
    <router-view/>
  </q-layout>
</template>

<script>
import {
  QPopover,
  QSelect,
  QCollapsible,
  QLayout,
  QToolbar,
  QToolbarTitle,
  QBtn,
  QIcon,
  QList,
  QListHeader,
  QItem,
  QItemSide,
  QItemMain
} from 'quasar'
import {
  mapActions,
  mapMutations
} from 'vuex'

export default {
  name: 'index',
  components: {
    QPopover,
    QSelect,
    QCollapsible,
    QLayout,
    QToolbar,
    QToolbarTitle,
    QBtn,
    QIcon,
    QList,
    QListHeader,
    QItem,
    QItemSide,
    QItemMain
  },
  data () {
    return {
      select: '',
      orienting: window.DeviceOrientationEvent && !this.$q.platform.is.desktop,
      rotating: window.DeviceMotionEvent && !this.$q.platform.is.desktop
    }
  },
  computed: {
    boxes () {
      return this.$store.getters.getBoxes
    },
    nodes () {
      return this.$store.getters.getNodes
    }
  },
  methods: {
    ...mapMutations([
      'addToBoxes'
    ]),
    ...mapActions([
      'createBox',
      'createSocket'
    ]),
    newBox (component) {
      let vm = this
      vm.createBox({
        title: component.text,
        type: component.type,
        component: component.name,
        active: true
      }).then(box => vm.createSocket(box))
    }
  },
  mounted () {
    console.log(this)
  },
  beforeDestroy () {
  }
}
</script>

<style lang="stylus">
</style>
