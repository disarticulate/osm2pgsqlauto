<template>
  <q-layout
    ref="layout"
    view="lHh Lpr fff"
    :left-class="{'bg-grey-2': true}"
  >
    <q-toolbar slot="header" class="glossy">
      <q-btn
        flat
        @click="$refs.layout.toggleLeft()"
      >
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
        <q-item @click="newBox()">
          <q-item-side icon="fa-plus-square" />
          <q-item-main label="Add Window" sublabel="Open new query window" />
        </q-item>
        <q-collapsible label="Windows">
          <q-item v-for="(item,index) in layouts">
            <q-item-side icon="fa-window-maximize" />
            <q-item-main label="Window" :sublabel="item.properties.title" />
          </q-item>
        </q-collapsible>
      </q-list>
    </div>

    <!--
      Replace following <div> with
      <router-view /> component
      if using subRoutes
    -->
    <router-view/>
  </q-layout>
</template>

<script>
import {
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
      orienting: window.DeviceOrientationEvent && !this.$q.platform.is.desktop,
      rotating: window.DeviceMotionEvent && !this.$q.platform.is.desktop
    }
  },
  computed: {
    layouts: {
      get () {
        return this.$store.getters.getLayouts
      }
    }
  },
  methods: {
    ...mapMutations([
      'addToLayouts'
    ]),
    ...mapActions([
      'createBox'
    ]),
    newBox (url) {
      let vm = this
      vm.createBox({
        title: 'new Box',
        active: true
      })
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
