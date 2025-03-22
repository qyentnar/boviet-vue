<template>
  <div :class="classObj" class="app-wrapper" :style="{'--current-color': theme}">
    <el-container>
      <el-aside v-if="!sidebar.hide" class="sidebar-container" :style="{backgroundColor: sideTheme === 'theme-dark' ? variables.menuBackground : variables.menuLightBackground, width: sidebarWidth + 'px' }">
        <div class="resize-handle" @mousedown="handleMouseDown"></div>
        <sidebar />
      </el-aside>
      
      <el-container class="main-container" :class="{hasTagsView:needTagsView, sidebarHide:sidebar.hide}">
        <el-header height="auto" :class="{'fixed-header':fixedHeader}">
          <navbar />
          <tags-view v-if="needTagsView" />
        </el-header>
        
        <el-main>
          <app-main />
        </el-main>
      </el-container>
    </el-container>

    <div v-if="device==='mobile'&&sidebar.opened" class="drawer-bg" @click="handleClickOutside"/>
    <right-panel>
      <settings />
    </right-panel>
  </div>
</template>

<script>
import RightPanel from '@/components/RightPanel'
import { AppMain, Navbar, Settings, Sidebar, TagsView } from './components'
import ResizeMixin from './mixin/ResizeHandler'
import { mapState } from 'vuex'
import variables from '@/assets/styles/variables.scss'

export default {
  name: 'Layout',
  components: {
    AppMain,
    Navbar,
    RightPanel,
    Settings,
    Sidebar,
    TagsView
  },
  mixins: [ResizeMixin],
  computed: {
    ...mapState({
      theme: state => state.settings.theme,
      sideTheme: state => state.settings.sideTheme,
      sidebar: state => state.app.sidebar,
      device: state => state.app.device,
      needTagsView: state => state.settings.tagsView,
      fixedHeader: state => state.settings.fixedHeader
    }),
    classObj() {
      return {
        hideSidebar: !this.sidebar.opened,
        openSidebar: this.sidebar.opened,
        withoutAnimation: this.sidebar.withoutAnimation,
        mobile: this.device === 'mobile'
      }
    },
    variables() {
      return variables;
    }
  },
  data() {
    return {
      sidebarWidth: 200,
      isDragging: false,
      startX: 0,
      startWidth: 0
    }
  },
  methods: {
    handleClickOutside() {
      this.$store.dispatch('app/closeSideBar', { withoutAnimation: false })
    },
    handleMouseDown(e) {
      this.isDragging = true
      this.startX = e.clientX
      this.startWidth = this.sidebarWidth
      document.addEventListener('mousemove', this.handleMouseMove)
      document.addEventListener('mouseup', this.handleMouseUp)
    },
    handleMouseMove(e) {
      if (!this.isDragging) return
      const deltaX = e.clientX - this.startX
      this.sidebarWidth = Math.max(200, Math.min(600, this.startWidth + deltaX))
    },
    handleMouseUp() {
      this.isDragging = false
      document.removeEventListener('mousemove', this.handleMouseMove)
      document.removeEventListener('mouseup', this.handleMouseUp)
    }
  }
}
</script>

<style lang="scss" scoped>
  @import "~@/assets/styles/mixin.scss";
  @import "~@/assets/styles/variables.scss";

  .app-wrapper {
    @include clearfix;
    position: relative;
    height: 100%;
    width: 100%;

    .el-container {
      height: 100%;
    }

    .el-aside {
      position: relative;
      overflow: hidden;

      .resize-handle {
        position: absolute;
        right: 0;
        top: 0;
        bottom: 0;
        width: 4px;
        background-color: transparent;
        cursor: col-resize;
        z-index: 10;
        user-select: none; // Prevent text selection during resize

        &:hover {
          background-color: var(--current-color);
          opacity: 0.4;
        }
      }
    }

    .el-main {
      padding: 10px;
      overflow: auto;
    }

    &.mobile.openSidebar {
      position: fixed;
      top: 0;
    }
  }

  .drawer-bg {
    background: #000;
    opacity: 0.3;
    width: 100%;
    top: 0;
    height: 100%;
    position: absolute;
    z-index: 999;
  }

  .fixed-header {
    position: fixed;
    top: 0;
    right: 0;
    z-index: 9;
    width: calc(100% - #{$base-sidebar-width});
    transition: width 0.28s;
  }

  .hideSidebar .fixed-header {
    width: calc(100% - 54px);
  }

  .sidebarHide .fixed-header {
    width: 100%;
  }

  .mobile .fixed-header {
    width: 100%;
  }

  .el-aside {
    line-height: 0;
    padding: 0;
  }

  .el-header {
    padding: 0;
  }
</style>
