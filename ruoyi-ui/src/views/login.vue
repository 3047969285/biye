<template>
  <div class="login">
    <div class="login-card">
      <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
        <h3 class="title">{{title}}</h3>
      <el-form-item prop="username">
        <el-input
          v-model="loginForm.username"
          type="text"
          auto-complete="off"
          placeholder="账号"
        >
          <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input
          v-model="loginForm.password"
          type="password"
          auto-complete="off"
          placeholder="密码"
          @keyup.enter.native="handleLogin"
        >
          <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
        </el-input>
      </el-form-item>
      <el-checkbox v-model="loginForm.rememberMe" style="margin:0px 0px 25px 0px;">记住密码</el-checkbox>
      <el-form-item style="width:100%;">
        <el-button
          :loading="loading"
          size="medium"
          type="primary"
          style="width:100%;"
          @click.native.prevent="handleLogin"
        >
          <span v-if="!loading">登 录</span>
          <span v-else>登 录 中...</span>
        </el-button>
        <div style="float: right;" v-if="register">
          <router-link class="link-type" :to="'/register'">立即注册</router-link>
        </div>
      </el-form-item>
    </el-form>
    </div>
    <!--  底部  -->
    <div class="el-login-footer">
      <span>Copyright © 2018-2025 智能电网运维系统. All Rights Reserved.</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from '@/utils/jsencrypt'

export default {
  name: "Login",
  data() {
    return {
      title: '智能电网运维系统',
      codeUrl: "",
      loginForm: {
        username: "admin",
        password: "admin123",
        rememberMe: false,
        code: "",
        uuid: ""
      },
      loginRules: {
        username: [
          { required: true, trigger: "blur", message: "请输入您的账号" }
        ],
        password: [
          { required: true, trigger: "blur", message: "请输入您的密码" }
        ]
      },
      loading: false,
      // 验证码开关
      captchaEnabled: false,
      // 注册开关
      register: false,
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  created() {
    this.getCookie()
  },
  methods: {
    getCookie() {
      const username = Cookies.get("username")
      const password = Cookies.get("password")
      const rememberMe = Cookies.get('rememberMe')
      this.loginForm = {
        username: username === undefined ? this.loginForm.username : username,
        password: password === undefined ? this.loginForm.password : decrypt(password),
        rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
      }
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          if (this.loginForm.rememberMe) {
            Cookies.set("username", this.loginForm.username, { expires: 30 })
            Cookies.set("password", encrypt(this.loginForm.password), { expires: 30 })
            Cookies.set('rememberMe', this.loginForm.rememberMe, { expires: 30 })
          } else {
            Cookies.remove("username")
            Cookies.remove("password")
            Cookies.remove('rememberMe')
          }
          this.$store.dispatch("Login", this.loginForm).then(() => {
            this.$router.push({ path: this.redirect || "/" }).catch(()=>{})
          }).catch(() => {
            this.loading = false
          })
        }
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss">
.login {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background: transparent; /* 交给全局背景 */
  background-attachment: fixed;
}
.login-card {
  animation: floatIn 0.9s cubic-bezier(0.16, 1, 0.3, 1);
  transform-origin: center;
  width: 420px;
}
.title {
  margin: 0px auto 30px auto;
  text-align: center;
  color: var(--text-1);
  font-size: 26px;
  font-weight: 650;
  letter-spacing: 0.6px;
  text-shadow: 0 10px 24px rgba(0, 0, 0, 0.25);
}

.login-form {
  border-radius: var(--radius);
  background: var(--surface-1);
  backdrop-filter: blur(14px);
  width: 400px;
  padding: 30px 30px 15px 30px;
  z-index: 1;
  border: 1px solid var(--border-1);
  box-shadow: var(--shadow-1);
  animation: floatIn 1s cubic-bezier(0.16, 1, 0.3, 1);
  .el-input {
    height: 40px;
    input {
      height: 40px;
      border-radius: 0;
      border: 1px solid rgba(99, 102, 241, 0.25);
      background: rgba(15, 23, 42, 0.8);
      color: #E2E8F0;
      
      &:focus {
        border-color: #6366F1;
        box-shadow: 0 0 0 1px rgba(99, 102, 241, 0.4);
      }
    }
  }
  .input-icon {
    height: 40px;
    width: 14px;
    margin-left: 2px;
    color: #64748B;
  }
}
.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}
.login-code {
  width: 33%;
  height: 38px;
  float: right;
  img {
    cursor: pointer;
    vertical-align: middle;
  }
}
.el-login-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  color: #CBD5E1;
  font-size: 12px;
  letter-spacing: 0;
}
.login-code-img {
  height: 38px;
}

/* 进入动画 */
@keyframes floatIn {
  0% {
    opacity: 0;
    transform: translateY(24px) scale(0.98);
  }
  60% {
    opacity: 1;
    transform: translateY(-4px) scale(1.005);
  }
  100% {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}
</style>
