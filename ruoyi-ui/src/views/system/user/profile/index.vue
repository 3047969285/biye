<template>
  <div class="app-container">
    <el-row :gutter="20">
      <el-col :span="6" :xs="24">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>个人信息</span>
          </div>
          <div>
            <div class="text-center">
              <userAvatar />
            </div>
            <ul class="list-group list-group-striped">
              <li class="list-group-item">
                <svg-icon icon-class="user" />用户名称
                <div class="pull-right">{{ user.userName }}</div>
              </li>
              <li class="list-group-item">
                <svg-icon icon-class="phone" />手机号码
                <div class="pull-right">{{ user.phonenumber }}</div>
              </li>
              <li class="list-group-item">
                <svg-icon icon-class="email" />用户邮箱
                <div class="pull-right">{{ user.email }}</div>
              </li>
              <li class="list-group-item">
                <svg-icon icon-class="tree" />所属部门
                <div class="pull-right" v-if="user.dept">{{ user.dept.deptName }} / {{ postGroup }}</div>
              </li>
              <li class="list-group-item">
                <svg-icon icon-class="peoples" />所属角色
                <div class="pull-right">{{ roleGroup }}</div>
              </li>
              <li class="list-group-item">
                <svg-icon icon-class="date" />创建日期
                <div class="pull-right">{{ user.createTime }}</div>
              </li>
            </ul>
          </div>
        </el-card>
      </el-col>
      <el-col :span="18" :xs="24">
        <el-card>
          <div slot="header" class="clearfix">
            <span>基本资料</span>
          </div>
          <el-tabs v-model="selectedTab">
            <el-tab-pane label="基本资料" name="userinfo">
              <userInfo :user="user" />
            </el-tab-pane>
            <el-tab-pane label="修改密码" name="resetPwd">
              <resetPwd />
            </el-tab-pane>
          </el-tabs>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import userAvatar from "./userAvatar"
import userInfo from "./userInfo"
import resetPwd from "./resetPwd"
import { getUserProfile } from "@/api/system/user"

export default {
  name: "Profile",
  components: { userAvatar, userInfo, resetPwd },
  data() {
    return {
      user: {},
      roleGroup: {},
      postGroup: {},
      selectedTab: "userinfo"
    }
  },
  created() {
    const activeTab = this.$route.params && this.$route.params.activeTab
    if (activeTab) {
      this.selectedTab = activeTab
    }
    this.getUser()
  },
  methods: {
    getUser() {
      getUserProfile().then(response => {
        this.user = response.data
        this.roleGroup = response.roleGroup
        this.postGroup = response.postGroup
      })
    }
  }
}
</script>

<style scoped lang="scss">
@import "~@/assets/styles/variables.scss";

.app-container {
  color: $text-primary !important;
  
  .el-card {
    background: $secondary-bg !important;
    border-color: $border-color !important;
    
    .el-card__header {
      background: $primary-bg !important;
      border-bottom-color: $border-color !important;
      color: $text-primary !important;
      font-weight: 600 !important;
      font-size: 16px !important;
      
      span {
        color: $text-primary !important;
        font-weight: 600 !important;
      }
    }
    
    .el-card__body {
      background: $secondary-bg !important;
      color: $text-primary !important;
    }
  }
  
  .list-group {
    .list-group-item {
      background: $secondary-bg !important;
      border-color: $border-color !important;
      color: $text-primary !important;
      font-weight: 400 !important;
      font-size: 14px !important;
      
      .pull-right {
        color: $text-primary !important;
        font-weight: 500 !important;
      }
      
      .svg-icon {
        color: $accent-color !important;
        margin-right: 8px;
      }
    }
  }
  
  .text-center {
    color: $text-primary !important;
  }
  
  .clearfix {
    color: $text-primary !important;
    
    span {
      color: $text-primary !important;
      font-weight: 600 !important;
      font-size: 16px !important;
    }
  }
}
</style>