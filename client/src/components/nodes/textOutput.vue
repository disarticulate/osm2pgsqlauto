<template>
  <div>
    {{output}}
  </div>
</template>

<script>
export default {
  name: 'textOutput',
  props: {
    input: {
      type: Object
    }
  },
  computed: {
    output () {
      return this.input.output
    }
  },
  data () {
    return {
      title: 'Text Output'
    }
  }
}
</script>
<style scoped>

</style>
