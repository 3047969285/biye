from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import math


OUT_DIR = Path.home() / "Desktop" / "毕业" / "毕业答辩" / "图片"
OUT_DIR.mkdir(parents=True, exist_ok=True)
OUT_FILE = OUT_DIR / "系统逻辑架构图_清晰版.png"

W, H = 3200, 2300
img = Image.new("RGB", (W, H), "white")
d = ImageDraw.Draw(img)

FONT_CANDIDATES = [
    Path("C:/Windows/Fonts/msyh.ttc"),
    Path("C:/Windows/Fonts/simhei.ttf"),
    Path("C:/Windows/Fonts/simsun.ttc"),
]
FONT_PATH = next((p for p in FONT_CANDIDATES if p.exists()), None)
if FONT_PATH is None:
    raise RuntimeError("No Chinese font found")


def font(size: int, bold: bool = False):
    bold_path = Path("C:/Windows/Fonts/msyhbd.ttc")
    if bold and bold_path.exists():
        return ImageFont.truetype(str(bold_path), size)
    return ImageFont.truetype(str(FONT_PATH), size)


F_TITLE = font(58, True)
F_LAYER = font(36, True)
F_BOX = font(31, True)
F_SMALL = font(26)
F_NOTE = font(24)

COLORS = {
    "border": "#2f3a45",
    "text": "#1f2933",
    "arrow": "#34495e",
    "user": "#f8fafc",
    "front": "#edf7ff",
    "security": "#f2f7ff",
    "service": "#f4fff5",
    "ai": "#fff7e8",
    "data": "#f7f4ff",
    "box": "#ffffff",
}


def text_size(text, f):
    bbox = d.textbbox((0, 0), text, font=f)
    return bbox[2] - bbox[0], bbox[3] - bbox[1]


def rounded_rect(xy, fill, outline=COLORS["border"], width=3, radius=18):
    d.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=width)


def draw_center_text(xy, text, f=F_BOX, fill=COLORS["text"], line_spacing=8):
    x1, y1, x2, y2 = xy
    lines = text.split("\n")
    heights = [text_size(line, f)[1] for line in lines]
    total_h = sum(heights) + line_spacing * (len(lines) - 1)
    y = y1 + (y2 - y1 - total_h) / 2
    for line, h in zip(lines, heights):
        w, _ = text_size(line, f)
        d.text((x1 + (x2 - x1 - w) / 2, y), line, font=f, fill=fill)
        y += h + line_spacing


def box(cx, cy, w, h, text, fill=COLORS["box"], f=F_BOX, radius=14):
    xy = (cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2)
    rounded_rect(xy, fill=fill, radius=radius)
    draw_center_text(xy, text, f=f)
    return xy


def layer(x1, y1, x2, y2, title, fill):
    rounded_rect((x1, y1, x2, y2), fill=fill, outline="#c9d4df", width=3, radius=24)
    tw, _ = text_size(title, F_LAYER)
    d.text(((x1 + x2 - tw) / 2, y1 + 18), title, font=F_LAYER, fill="#243447")


def arrow(start, end, text=None, offset=(0, 0), width=4):
    x1, y1 = start
    x2, y2 = end
    d.line((x1, y1, x2, y2), fill=COLORS["arrow"], width=width)
    ang = math.atan2(y2 - y1, x2 - x1)
    alen = 22
    p1 = (x2 + alen * math.cos(ang + math.pi * 0.82), y2 + alen * math.sin(ang + math.pi * 0.82))
    p2 = (x2 + alen * math.cos(ang - math.pi * 0.82), y2 + alen * math.sin(ang - math.pi * 0.82))
    d.polygon([end, p1, p2], fill=COLORS["arrow"])
    if text:
        tx = (x1 + x2) / 2 + offset[0]
        ty = (y1 + y2) / 2 + offset[1]
        tw, th = text_size(text, F_NOTE)
        d.rounded_rectangle((tx - tw / 2 - 10, ty - th / 2 - 6, tx + tw / 2 + 10, ty + th / 2 + 6), radius=8, fill="white", outline="#d5dde5")
        d.text((tx - tw / 2, ty - th / 2), text, font=F_NOTE, fill="#34495e")


def cylinder(cx, cy, w, h, text, fill="#ffffff"):
    x1, y1, x2, y2 = cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2
    d.rectangle((x1, y1 + 22, x2, y2 - 22), fill=fill, outline=COLORS["border"], width=3)
    d.ellipse((x1, y1, x2, y1 + 44), fill=fill, outline=COLORS["border"], width=3)
    d.arc((x1, y2 - 44, x2, y2), 0, 180, fill=COLORS["border"], width=3)
    d.line((x1, y1 + 22, x1, y2 - 22), fill=COLORS["border"], width=3)
    d.line((x2, y1 + 22, x2, y2 - 22), fill=COLORS["border"], width=3)
    draw_center_text((x1, y1, x2, y2), text, f=F_SMALL)


title = "智能电网运维平台系统逻辑架构图"
tw, _ = text_size(title, F_TITLE)
d.text(((W - tw) / 2, 38), title, font=F_TITLE, fill="#14213d")

# 用户与入口
box(1260, 170, 280, 90, "运维人员", fill=COLORS["user"])
box(1940, 170, 280, 90, "系统管理员", fill=COLORS["user"])
box(1600, 320, 360, 90, "浏览器（B/S）")
arrow((1260, 215), (1510, 285))
arrow((1940, 215), (1690, 285))

# 展示层
layer(980, 420, 2220, 760, "展示层", COLORS["front"])
box(1240, 595, 300, 85, "Vue2\nElement UI", f=F_SMALL)
box(1600, 595, 300, 85, "Vue Router\nVuex", f=F_SMALL)
box(1960, 595, 350, 85, "Axios / EventSource\nECharts", f=F_SMALL)
arrow((1600, 365), (1600, 420))

# 安全层
layer(980, 820, 2220, 1160, "接口与安全层", COLORS["security"])
box(1160, 995, 290, 80, "Spring Security\n过滤链", f=F_SMALL)
box(1460, 995, 230, 80, "JWT 认证", f=F_SMALL)
box(1740, 995, 260, 80, "RBAC\n权限控制", f=F_SMALL)
box(2040, 995, 260, 80, "操作审计\n日志", f=F_SMALL)
arrow((1600, 760), (1600, 820))

# 业务层
layer(110, 1220, 3090, 1505, "业务服务层（Spring Boot 多模块）", COLORS["service"])
for args in [
    (380, 1390, 360, 90, "spring-ai\n对话 / RAG / 自然语言查库"),
    (830, 1390, 360, 90, "ruoyi-system\n业务服务与 Mapper"),
    (1280, 1390, 360, 90, "ruoyi-admin\nController 入口"),
    (1730, 1390, 300, 90, "ruoyi-quartz\n定时任务"),
    (2160, 1390, 360, 90, "ruoyi-framework\n缓存 / 日志 / 安全支撑"),
    (2620, 1390, 320, 90, "ruoyi-meter\n采集相关"),
]:
    box(*args, f=F_SMALL)
arrow((1600, 1160), (1600, 1220))

# 智能与外部服务
layer(110, 1600, 1480, 1940, "智能与外部服务", COLORS["ai"])
box(320, 1800, 360, 85, "通义大模型\nDashScope", f=F_SMALL)
box(730, 1800, 310, 85, "SimpleVectorStore\n向量检索", f=F_SMALL)
box(1160, 1800, 410, 85, "Python 预测服务\nFastAPI + TensorFlow GRU", f=F_SMALL)
arrow((380, 1435), (320, 1758), "模型调用", offset=(-80, -10))
arrow((380, 1435), (730, 1758), "向量检索", offset=(30, -12))
arrow((1280, 1435), (1160, 1758), "HTTP 调用", offset=(65, -8))

# 数据与基础设施
layer(1600, 1600, 3090, 2060, "数据与基础设施层", COLORS["data"])
cylinder(1850, 1870, 190, 130, "MySQL")
cylinder(2320, 1870, 190, 130, "Redis")
box(2760, 1870, 310, 85, "日志与审计存储", f=F_SMALL)
arrow((830, 1435), (1790, 1810), "业务数据", offset=(-100, -20))
arrow((1280, 1435), (1870, 1810), "接口数据", offset=(20, -35))
arrow((2160, 1435), (2310, 1810), "缓存读写", offset=(80, -20))
arrow((1730, 1435), (2250, 1810), "任务状态", offset=(-70, -15))
arrow((2160, 1435), (2710, 1828), "日志写入", offset=(70, -20))
arrow((1160, 1845), (1770, 1900), "预测结果写回\\neq_device_stat / eq_prediction", offset=(90, 20))

note = "说明：前端通过 Axios/SSE 调用后端接口；后端按安全控制、业务服务、AI 服务和数据持久化分层，实现设备管理、告警联动、工单闭环、知识问答和风电预测。"
tw, th = text_size(note, F_NOTE)
d.rounded_rectangle((210, 2190, W - 210, 2245), radius=18, fill="#f8fafc", outline="#d9e2ec")
d.text(((W - tw) / 2, 2206), note, font=F_NOTE, fill="#334e68")

img.save(OUT_FILE, quality=95)
print(OUT_FILE)

