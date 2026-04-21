<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
#app {
  font-family: 'Microsoft YaHei', Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  height: 100vh;
  margin: 0;
  padding: 0;
  font-size: 16px; /* 增加应用基础字体大小 */
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  margin: 0;
  padding: 0;
  font-size: 16px; /* 增加body字体大小 */
}

/* 增加Element Plus组件的字体大小 */
.el-button {
  font-size: 16px !important;
}

.el-input__inner,
.el-textarea__inner,
.el-select .el-input__inner {
  font-size: 16px !important;
}

.el-table {
  font-size: 16px !important;
}

.el-table td,
.el-table th {
  font-size: 16px !important;
}

.el-form-item__label {
  font-size: 16px !important;
}

.el-menu-item,
.el-sub-menu__title {
  font-size: 16px !important;
}

.el-dialog__title {
  font-size: 18px !important;
}

.el-card__header {
  font-size: 16px !important;
}

.el-pagination {
  font-size: 16px !important;
}

.el-message {
  font-size: 16px !important;
}

.el-breadcrumb {
  font-size: 16px !important;
}
</style>

