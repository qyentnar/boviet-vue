<template>
  <div class="dashboard-editor-container">
    <img src="../assets/images/home.jpg" alt="Home" class="home-image" />
  </div>
</template>

<script>
export default {
  name: 'Index'
}
</script>

<style lang="scss" scoped>
.dashboard-editor-container {
  background-color: rgb(240, 242, 245);
  position: relative;
  height: calc(100vh - 105px);

  .home-image {
    width: 100%;
    height: auto;
    display: block;
    margin: 0 auto;
  }
}
</style>