<template>
  <div class="app-container form-gen">
    <el-row :gutter="20">
      <el-col :span="14" :xs="24">
        <el-card>
          <div slot="header" class="card-header">
            <span>智能运维表单生成</span>
          </div>

          <el-form :model="form" label-width="100px">
            <el-form-item label="问题/故障">
              <el-input
                type="textarea"
                :rows="4"
                v-model="form.question"
                placeholder="描述设备、故障现象或需求，例如：变压器温度过高如何检修"
              />
            </el-form-item>
            <el-form-item label="TopK">
              <el-input-number v-model="form.topK" :min="1" :max="10" />
            </el-form-item>
            <el-form-item label="保存到库">
              <el-switch v-model="form.saveToDb" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" :loading="loading" @click="generate">生成表单</el-button>
              <el-button @click="reset">清空</el-button>
            </el-form-item>
          </el-form>

          <div v-if="resultText" class="result-block">
            <div class="result-header">
              <span>生成结果</span>
              <el-button size="mini" type="text" @click="copyResult($event)">复制</el-button>
            </div>
            <pre>{{ resultText }}</pre>
          </div>
        </el-card>
      </el-col>

      <el-col :span="10" :xs="24">
        <el-card>
          <div slot="header" class="card-header">
            <span>提示</span>
          </div>
          <ul class="tips">
            <li>先在“知识库问答”里添加文档，能提升表单准确性。</li>
            <li>保存到库会写入表 ai_maintenance_form，生成状态为 draft。</li>
            <li>TopK 控制参考文档条数，建议 3~5。</li>
          </ul>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { generateForm } from "@/api/ai/chat";
import clipboard from "@/utils/clipboard";

export default {
  name: "AiMaintenanceForm",
  data() {
    return {
      loading: false,
      form: {
        question: "",
        topK: 3,
        saveToDb: false
      },
      resultText: ""
    };
  },
  methods: {
    async generate() {
      if (!this.form.question.trim()) {
        this.$modal.msgWarning("请输入问题/故障描述");
        return;
      }
      this.loading = true;
      try {
        const res = await generateForm(this.form.question, this.form.topK, this.form.saveToDb);
        if (res.code === 200) {
          const data = res.data;
          this.resultText = typeof data === "string" ? data : JSON.stringify(data, null, 2);
          this.$modal.msgSuccess("生成完成");
        } else {
          this.$modal.msgError(res.msg || "生成失败");
        }
      } catch (e) {
        this.$modal.msgError("生成失败：" + e.message);
      } finally {
        this.loading = false;
      }
    },
    reset() {
      this.form.question = "";
      this.resultText = "";
    },
    copyResult(e) {
      clipboard(this.resultText, e);
      this.$modal.msgSuccess("已复制");
    }
  }
};
</script>

<style scoped lang="scss">
@import "~@/assets/styles/variables.scss";

.form-gen {
  .card-header {
    font-weight: 600;
    color: $text-primary;
  }
  .tips {
    margin: 0;
    padding-left: 20px;
    line-height: 1.8;
    color: $text-secondary;
  }
  .result-block {
    margin-top: 16px;
    border: 1px solid $border-color;
    padding: 12px;
    pre {
      white-space: pre-wrap;
      word-break: break-word;
      margin: 0;
      color: $text-primary;
    }
    .result-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 8px;
      color: $text-primary;
    }
  }
}
</style>
