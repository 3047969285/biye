<template>
  <div class="login login-page">
    <main class="login-shell">
      <section class="login-story">
        <div class="login-brand">
          <span class="login-brand-mark"><i /><i /><i /></span>
          <span>智能电网 <b>/</b> 运维平台</span>
        </div>
        <div class="login-story-copy">
          <p class="login-eyebrow">SMART GRID · ENERGY OPERATIONS</p>
          <h1>让每一度电，<br><span>都有迹可循。</span></h1>
          <p class="login-story-note">从实时感知到提前预判，<br>让复杂的能源运行，回到清晰而可靠。</p>
        </div>
        <div class="login-orbit" aria-hidden="true">
          <i class="orbit orbit-one" />
          <i class="orbit orbit-two" />
          <i class="orbit orbit-three" />
          <i class="orbit-point" />
          <span class="orbit-core">ENERGY<br>IN MOTION</span>
        </div>
        <div class="login-story-meta">
          <span>感知 · 分析 · 守护</span>
          <span>GRID / 01</span>
        </div>
      </section>

      <section class="login-access">
        <div class="login-access-top">
          <span class="login-access-label">SECURE ACCESS</span>
          <span class="system-status"><i />系统入口</span>
        </div>
        <div class="login-card">
          <div class="login-heading">
            <span class="login-step">01 <i /> SIGN IN</span>
            <h3 class="title">{{title}}</h3>
            <p>登录以继续管理你的能源网络</p>
          </div>
          <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
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
      </section>
    </main>
    <div class="el-login-footer">
      <span>© 2026 智能电网运维系统</span>
      <span>RELIABLE ENERGY · CLEAR OPERATIONS</span>
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
        username: "",
        password: "",
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
  --story-ink: #1a120e;
  --story-muted: #5c463c;
  --story-line: #e4d4c6;
  --story-orange: #e30613;
  display: flex;
  min-height: 100vh;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  padding: 30px 36px 70px;
  background:
    radial-gradient(70% 50% at 10% 0%, rgba(227, 6, 19, 0.1), transparent 55%),
    linear-gradient(160deg, #faf3eb 0%, #f4ebe2 55%, #efe2d4 100%);
  color: var(--story-ink);
  font-family: 'DM Sans', 'Noto Sans SC', 'PingFang SC', sans-serif;
}

.login-shell {
  display: grid;
  grid-template-columns: 1.08fr 0.92fr;
  width: min(1180px, 100%);
  min-height: min(630px, calc(100vh - 116px));
  overflow: hidden;
  border: 1px solid #ebe6de;
  border-radius: 12px;
  background: #fff;
  box-shadow: 0 22px 72px rgba(45, 39, 32, 0.08);
  animation: floatIn 700ms cubic-bezier(0.16, 1, 0.3, 1) both;
}

.login-story {
  position: relative;
  display: flex;
  min-height: 100%;
  flex-direction: column;
  justify-content: space-between;
  overflow: hidden;
  padding: clamp(30px, 4vw, 58px);
  background:
    radial-gradient(circle at 78% 79%, rgba(227, 6, 19, 0.14), transparent 29%),
    radial-gradient(circle at 20% 10%, rgba(196, 163, 90, 0.12), transparent 40%),
    linear-gradient(145deg, #2a1812 0%, #120c0a 100%);
  color: #f7f0e6;
}

.login-brand,
.login-story-meta,
.login-access-top {
  position: relative;
  z-index: 2;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.login-brand {
  justify-content: flex-start;
  gap: 12px;
  color: #f7f0e6;
  font-size: 13px;
  font-weight: 650;
  letter-spacing: 0.03em;
}

.login-brand b {
  padding: 0 5px;
  color: var(--story-orange);
  font-weight: 500;
}

.login-brand-mark {
  display: flex;
  align-items: center;
  gap: 3px;
  height: 20px;
}

.login-brand-mark i {
  width: 3px;
  height: 11px;
  border-radius: 2px;
  background: var(--story-orange);
  transform: skew(-20deg);
}

.login-brand-mark i:nth-child(2) {
  height: 18px;
  opacity: 0.72;
}

.login-brand-mark i:nth-child(3) {
  height: 14px;
  opacity: 0.46;
}

.login-story-copy {
  position: relative;
  z-index: 1;
  max-width: 570px;
  margin: auto 0;
  padding: 68px 0 62px;
}

.login-eyebrow,
.login-access-label,
.login-step {
  color: #9a7e65;
  font-size: 10px;
  font-weight: 650;
  letter-spacing: 0.19em;
}

.login-eyebrow {
  margin: 0 0 24px;
}

.login-story-copy h1 {
  margin: 0;
  color: #f7f0e6;
  font-family: 'Cormorant Garamond', 'Noto Serif SC', 'Songti SC', serif;
  font-size: clamp(38px, 5vw, 62px);
  font-weight: 700;
  line-height: 1.26;
  letter-spacing: -0.02em;
}

.login-story-copy h1 span {
  color: var(--story-orange);
}

.login-story-note {
  margin: 22px 0 0;
  color: rgba(247, 240, 230, 0.72);
  font-size: 14px;
  line-height: 1.9;
  letter-spacing: 0.035em;
}

.login-orbit {
  position: absolute;
  right: -44px;
  bottom: 72px;
  width: clamp(180px, 24vw, 300px);
  aspect-ratio: 1;
  color: var(--story-orange);
}

.orbit {
  position: absolute;
  inset: 0;
  border: 1px solid rgba(204, 135, 81, 0.24);
  border-radius: 50%;
}

.orbit-two {
  inset: 13%;
  border-color: rgba(204, 135, 81, 0.2);
}

.orbit-three {
  inset: 27%;
  border-color: rgba(204, 135, 81, 0.2);
}

.orbit-point {
  position: absolute;
  top: 13%;
  left: 56%;
  width: 9px;
  height: 9px;
  border: 2px solid #fff;
  border-radius: 50%;
  background: var(--story-orange);
  box-shadow: 0 0 0 4px rgba(233, 130, 53, 0.14);
}

.orbit-core {
  position: absolute;
  inset: 36%;
  display: grid;
  place-content: center;
  border-radius: 50%;
  background: rgba(233, 130, 53, 0.09);
  color: #a96e3e;
  font-size: 8px;
  font-weight: 700;
  line-height: 1.65;
  letter-spacing: 0.13em;
  text-align: center;
}

.login-story-meta {
  color: #858987;
  font-size: 10px;
  letter-spacing: 0.12em;
}

.login-access {
  display: flex;
  flex-direction: column;
  padding: 30px clamp(28px, 4vw, 54px);
  background: #fff;
}

.login-access-top {
  min-height: 26px;
}

.login-access-label {
  color: #989b9c;
  font-size: 9px;
  letter-spacing: 0.18em;
}

.system-status {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  color: #777e7e;
  font-size: 11px;
}

.system-status i {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #4e9a73;
  box-shadow: 0 0 0 3px rgba(78, 154, 115, 0.1);
}

.login-card {
  width: min(370px, 100%);
  margin: auto;
  animation: floatIn 850ms 80ms cubic-bezier(0.16, 1, 0.3, 1) both;
}

.login-heading {
  margin-bottom: 30px;
}

.login-step {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  color: #b78257;
  font-size: 9px;
}

.login-step i {
  width: 28px;
  height: 1px;
  background: #d5b69b;
}

.login-heading .title {
  margin: 17px 0 8px;
  color: #20252b;
  font-size: 25px;
  font-weight: 700;
  letter-spacing: -0.025em;
}

.login-heading p {
  margin: 0;
  color: #858a8c;
  font-size: 13px;
}

.login-form {
  width: 100%;
  padding: 0;
  border: 0;
  background: transparent;
  box-shadow: none;
  animation: none;
}

.login-form .el-form-item {
  margin-bottom: 19px;
}

.login-form .el-input,
.login-form .el-input input {
  height: 46px;
}

.login-form .el-input input {
  border: 1px solid #e6e1d9;
  border-radius: 6px;
  background: #fff;
  color: #292f33;
  box-shadow: none;
}

.login-form .el-input input:focus {
  border-color: #e98235;
  box-shadow: 0 0 0 3px rgba(233, 130, 53, 0.1);
}

.login-form .input-icon {
  height: 46px;
  color: #9a9d9e;
}

.login-form .el-checkbox {
  margin: 0 0 17px !important;
}

.login-form .el-checkbox__label {
  color: #6c7377;
  font-size: 12px;
}

.login-form .el-button--primary {
  min-height: 45px;
  border: 0;
  border-radius: 6px !important;
  background: #e98235 !important;
  box-shadow: 0 8px 18px rgba(233, 130, 53, 0.18) !important;
  color: #fff !important;
  letter-spacing: 0.1em;
}

.login-form .el-button--primary:hover {
  background: #d97527 !important;
  box-shadow: 0 10px 22px rgba(233, 130, 53, 0.22) !important;
  transform: translateY(-1px);
}

.login-form .link-type {
  margin-top: 10px;
  color: #b8611d;
  font-size: 12px;
}

.login-code {
  width: 33%;
  height: 38px;
  float: right;
}

.login-code img {
  cursor: pointer;
  vertical-align: middle;
}

.el-login-footer {
  position: absolute;
  right: 36px;
  bottom: 17px;
  left: 36px;
  display: flex;
  justify-content: space-between;
  color: #989b9c;
  font-size: 9px;
  letter-spacing: 0.11em;
}

.login-code-img {
  height: 38px;
}

@keyframes floatIn {
  from { opacity: 0; transform: translateY(18px); }
  to { opacity: 1; transform: translateY(0); }
}

@media (max-width: 900px) {
  .login {
    overflow-y: auto;
    padding: 20px 18px 58px;
  }

  .login-shell {
    grid-template-columns: 1fr;
    max-width: 560px;
    min-height: 0;
  }

  .login-story {
    min-height: 270px;
    padding: 25px 30px 23px;
  }

  .login-story-copy {
    padding: 30px 0 25px;
  }

  .login-story-copy h1 {
    font-size: clamp(34px, 8vw, 48px);
  }

  .login-story-note {
    margin-top: 12px;
    font-size: 12px;
  }

  .login-orbit {
    right: -70px;
    bottom: -82px;
    width: 220px;
  }

  .login-access {
    min-height: 400px;
    padding: 22px 30px 32px;
  }

  .login-card {
    margin: 34px auto 0;
  }

  .el-login-footer {
    right: 18px;
    bottom: 13px;
    left: 18px;
    justify-content: center;
  }

  .el-login-footer span:last-child {
    display: none;
  }
}
</style>
