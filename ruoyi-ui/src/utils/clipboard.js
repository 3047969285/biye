/**
 * 简单的复制到剪贴板工具
 * @param {string} text 文本内容
 * @param {Event} [event] 事件对象（可选）
 */
export default function clipboard(text, event) {
  const content = text == null ? '' : String(text);

  if (navigator && navigator.clipboard && navigator.clipboard.writeText) {
    return navigator.clipboard.writeText(content);
  }

  const textarea = document.createElement('textarea');
  textarea.readOnly = true;
  textarea.value = content;
  textarea.style.position = 'absolute';
  textarea.style.left = '-9999px';
  document.body.appendChild(textarea);
  textarea.select();
  document.execCommand('copy');
  document.body.removeChild(textarea);
  return Promise.resolve();
}
