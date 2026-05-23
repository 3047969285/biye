from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import math


OUT_DIR = Path.home() / "Desktop" / "毕业" / "毕业答辩" / "图片"
OUT_DIR.mkdir(parents=True, exist_ok=True)

FONT_CANDIDATES = [
    Path("C:/Windows/Fonts/msyh.ttc"),
    Path("C:/Windows/Fonts/simhei.ttf"),
    Path("C:/Windows/Fonts/simsun.ttc"),
]
FONT_PATH = next((p for p in FONT_CANDIDATES if p.exists()), None)
if FONT_PATH is None:
    raise RuntimeError("No Chinese font found")


def make_font(size: int, bold: bool = False):
    bold_path = Path("C:/Windows/Fonts/msyhbd.ttc")
    if bold and bold_path.exists():
        return ImageFont.truetype(str(bold_path), size)
    return ImageFont.truetype(str(FONT_PATH), size)


class Diagram:
    def __init__(self, width: int, height: int, title: str):
        self.w = width
        self.h = height
        self.img = Image.new("RGB", (width, height), "white")
        self.d = ImageDraw.Draw(self.img)
        self.title_f = make_font(72, True)
        self.layer_f = make_font(48, True)
        self.box_f = make_font(42, True)
        self.small_f = make_font(34)
        self.note_f = make_font(30)
        self.border = "#2f3a45"
        self.text = "#172033"
        self.arrow_c = "#334e68"
        self.draw_title(title)

    def text_size(self, text, font):
        bbox = self.d.textbbox((0, 0), text, font=font)
        return bbox[2] - bbox[0], bbox[3] - bbox[1]

    def draw_title(self, title: str):
        tw, _ = self.text_size(title, self.title_f)
        self.d.text(((self.w - tw) / 2, 34), title, font=self.title_f, fill="#14213d")

    def center_text(self, xy, text, font=None, line_spacing=8):
        font = font or self.box_f
        x1, y1, x2, y2 = xy
        lines = text.split("\n")
        heights = [self.text_size(line, font)[1] for line in lines]
        total_h = sum(heights) + line_spacing * (len(lines) - 1)
        y = y1 + (y2 - y1 - total_h) / 2
        for line, h in zip(lines, heights):
            tw, _ = self.text_size(line, font)
            self.d.text((x1 + (x2 - x1 - tw) / 2, y), line, font=font, fill=self.text)
            y += h + line_spacing

    def box(self, cx, cy, w, h, text, fill="#ffffff", font=None, radius=16, outline=None, width=3):
        xy = (cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2)
        self.d.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline or self.border, width=width)
        self.center_text(xy, text, font or self.box_f)
        return xy

    def layer(self, x1, y1, x2, y2, title, fill="#f8fafc"):
        self.d.rounded_rectangle((x1, y1, x2, y2), radius=22, fill=fill, outline="#c9d4df", width=3)
        tw, _ = self.text_size(title, self.layer_f)
        self.d.text(((x1 + x2 - tw) / 2, y1 + 4), title, font=self.layer_f, fill="#243447")

    def diamond(self, cx, cy, w, h, text, fill="#ffffff"):
        pts = [(cx, cy - h / 2), (cx + w / 2, cy), (cx, cy + h / 2), (cx - w / 2, cy)]
        self.d.polygon(pts, fill=fill, outline=self.border)
        self.d.line(pts + [pts[0]], fill=self.border, width=3)
        self.center_text((cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2), text, self.box_f)
        return (cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2)

    def arrow(self, start, end, text=None, offset=(0, 0), width=4):
        x1, y1 = start
        x2, y2 = end
        self.d.line((x1, y1, x2, y2), fill=self.arrow_c, width=width)
        ang = math.atan2(y2 - y1, x2 - x1)
        alen = 22
        p1 = (x2 + alen * math.cos(ang + math.pi * 0.82), y2 + alen * math.sin(ang + math.pi * 0.82))
        p2 = (x2 + alen * math.cos(ang - math.pi * 0.82), y2 + alen * math.sin(ang - math.pi * 0.82))
        self.d.polygon([end, p1, p2], fill=self.arrow_c)
        if text:
            tx = (x1 + x2) / 2 + offset[0]
            ty = (y1 + y2) / 2 + offset[1]
            tw, th = self.text_size(text, self.note_f)
            self.d.rounded_rectangle((tx - tw / 2 - 10, ty - th / 2 - 6, tx + tw / 2 + 10, ty + th / 2 + 6), radius=8, fill="white", outline="#d5dde5")
            self.d.text((tx - tw / 2, ty - th / 2), text, font=self.note_f, fill="#334e68")

    def poly_arrow(self, points, text=None, text_pos=None, width=4):
        for i in range(len(points) - 1):
            self.d.line((points[i], points[i + 1]), fill=self.arrow_c, width=width)
        self.arrow(points[-2], points[-1], width=width)
        if text and text_pos:
            tw, th = self.text_size(text, self.note_f)
            x, y = text_pos
            self.d.rounded_rectangle((x - tw / 2 - 10, y - th / 2 - 6, x + tw / 2 + 10, y + th / 2 + 6), radius=8, fill="white", outline="#d5dde5")
            self.d.text((x - tw / 2, y - th / 2), text, font=self.note_f, fill="#334e68")

    def save(self, filename: str):
        path = OUT_DIR / filename
        self.img.save(path, quality=95)
        print(path)


def draw_rag():
    g = Diagram(2100, 2350, "RAG 知识库问答流程图")
    # main columns
    g.layer(90, 230, 930, 1510, "知识库构建", "#fff7e8")
    g.layer(1170, 230, 2010, 1980, "检索增强问答", "#edf7ff")
    g.box(510, 330, 330, 90, "资料上传\nTXT / PDF / DOCX", font=g.small_f)
    g.box(510, 500, 360, 90, "文档解析与清洗\n过滤空行、页眉页脚", font=g.small_f)
    g.box(510, 670, 330, 90, "文本切分\nTokenTextSplitter", font=g.small_f)
    g.box(510, 840, 350, 90, "向量化 Embedding", font=g.small_f)
    g.box(510, 1025, 400, 110, "SimpleVectorStore\n向量知识库", font=g.small_f)
    g.box(510, 1235, 420, 100, "ai_rag_document\n文档元数据记录", font=g.small_f)
    g.box(510, 1410, 330, 90, "知识库清空 / 重建", font=g.small_f)
    for y1, y2 in [(375,455),(545,625),(715,795),(885,970),(1080,1185),(1285,1365)]:
        g.arrow((510, y1), (510, y2))

    g.box(1590, 330, 330, 90, "用户提问", font=g.small_f)
    g.box(1590, 500, 390, 100, "前端问答页\nruoyi-ui", font=g.small_f)
    g.box(1590, 690, 450, 105, "RagController\n/springai/rag/ask", font=g.small_f)
    g.box(1590, 880, 360, 90, "RagAppService", font=g.small_f)
    g.box(1590, 1070, 410, 95, "ChromaRagService\n相似度检索 TopK", font=g.small_f)
    g.box(1590, 1270, 420, 105, "Prompt 组装\n问题 + 检索片段", font=g.small_f)
    g.box(1590, 1490, 470, 105, "通义大模型\nDashScope / ChatClient", font=g.small_f)
    g.box(1590, 1690, 330, 90, "结果后处理\n格式清理", font=g.small_f)
    g.box(1380, 1890, 420, 95, "同步返回 / SSE 流式返回", font=g.small_f)
    g.box(1810, 1890, 360, 95, "ai_chat_record\n对话记录落库", font=g.small_f)
    for y1, y2 in [(405,500),(600,708),(813,925),(1015,1132),(1228,1358),(1463,1598),(1703,1825)]:
        g.arrow((1730, y1), (1730, y2))
    g.arrow((1590, 1735), (1380, 1842))
    g.arrow((1590, 1735), (1810, 1842))
    g.arrow((1385, 1070), (710, 1025), "读取相似片段", offset=(-80, -35))
    g.arrow((710, 1025), (1385, 1070), "返回 TopK", offset=(80, 35))
    g.arrow((300, 1410), (300, 1080), "清理索引", offset=(-80, 0))
    g.save("RAG流程图_清晰版.png")


def draw_rbac_model():
    g = Diagram(2100, 1450, "RBAC 权限模型图")
    g.layer(90, 220, 2010, 1260, "用户—角色—菜单—权限关系", "#f8fafc")
    g.box(320, 450, 300, 90, "用户 User\nsys_user", font=g.small_f)
    g.box(720, 450, 360, 90, "用户-角色关联\nsys_user_role", font=g.small_f)
    g.box(1120, 450, 270, 90, "角色 Role\nsys_role", font=g.small_f)
    g.box(1520, 450, 380, 90, "角色-菜单关联\nsys_role_menu", font=g.small_f)
    g.box(1880, 450, 270, 90, "菜单 Menu\nsys_menu", font=g.small_f)
    g.box(1120, 770, 360, 90, "数据权限范围\n部门 / 岗位 / 本人", font=g.small_f)
    g.box(1880, 770, 340, 90, "按钮 / 操作 Action\nperms 标识", font=g.small_f)
    g.box(1520, 1080, 360, 100, "权限 Permission\n菜单权限 + 按钮权限", font=g.small_f)
    g.box(760, 1280, 440, 110, "后端接口鉴权\n@PreAuthorize / hasPermi", font=g.small_f)
    g.box(1520, 1280, 440, 110, "前端可见性控制\nv-hasPermi / 路由过滤", font=g.small_f)
    g.arrow((470, 450), (540, 450), "绑定角色")
    g.arrow((900, 450), (985, 450), "获得角色")
    g.arrow((1255, 450), (1330, 450), "分配菜单")
    g.arrow((1710, 450), (1745, 450), "包含")
    g.arrow((1120, 495), (1120, 725), "限定数据")
    g.arrow((1880, 495), (1880, 725), "按钮权限")
    g.arrow((1880, 815), (1610, 1030))
    g.arrow((1120, 815), (1430, 1030))
    g.arrow((1440, 1130), (910, 1225), "后端拦截")
    g.arrow((1600, 1130), (1520, 1225), "前端控制")
    g.save("RBAC模型_清晰版.png")


def draw_permission_flow():
    g = Diagram(2200, 1900, "权限校验流程图")
    g.box(420, 260, 330, 90, "用户登录", font=g.small_f)
    g.box(420, 470, 410, 105, "登录认证\nJWT + Spring Security", font=g.small_f)
    g.box(420, 700, 370, 95, "生成 Token\n返回用户权限集合", font=g.small_f)
    g.box(1040, 470, 390, 100, "前端路由过滤\n菜单与按钮渲染", font=g.small_f)
    g.box(1040, 700, 410, 100, "发起接口请求\n携带 Token", font=g.small_f)
    g.box(1040, 940, 420, 100, "安全过滤链\n解析 Token / 获取用户", font=g.small_f)
    g.box(1040, 1180, 440, 100, "鉴权决策\n@PreAuthorize / hasPermi", font=g.small_f)
    g.diamond(1040, 1430, 320, 190, "是否具备权限？")
    g.box(630, 1660, 310, 90, "允许访问\nController API", font=g.small_f)
    g.box(1450, 1660, 310, 90, "拒绝访问\n返回 403", font=g.small_f)
    g.box(1700, 940, 390, 100, "操作日志\n审计留痕", font=g.small_f)
    g.arrow((420, 305), (420, 418))
    g.arrow((420, 523), (420, 652))
    g.arrow((605, 700), (835, 700), "Token")
    g.arrow((1040, 520), (1040, 650))
    g.arrow((1040, 750), (1040, 890))
    g.arrow((1040, 990), (1040, 1130))
    g.arrow((1040, 1230), (1040, 1335))
    g.arrow((940, 1505), (700, 1615), "是")
    g.arrow((1140, 1505), (1380, 1615), "否")
    g.arrow((1260, 1180), (1510, 940), "记录关键操作")
    g.save("权限模型图_清晰版.png")


def draw_er():
    g = Diagram(2600, 1900, "系统核心数据库 E-R 图")
    g.box(1300, 230, 310, 95, "eq_device\n设备主表", font=g.small_f, fill="#fff7e8")
    g.layer(80, 420, 1120, 1030, "AI 与消息主线", "#f7f4ff")
    g.box(330, 600, 360, 95, "ai_maintenance_form\nAI 运维表单", font=g.small_f)
    g.box(800, 600, 270, 95, "sys_user\n用户主表", font=g.small_f)
    g.box(330, 850, 340, 95, "sys_user_message\n站内消息", font=g.small_f)
    g.box(800, 850, 330, 95, "ai_chat_record\nAI 对话记录", font=g.small_f)

    g.layer(1450, 420, 2520, 1680, "设备业务主线", "#f2f7ff")
    y = 570
    chain = [
        ("eq_device_status\n状态历史", 570),
        ("eq_device_rule\n规则配置", 760),
        ("eq_alert_record\n告警记录", 950),
        ("eq_fault_record\n故障记录", 1140),
        ("eq_maintenance_record\n维护记录", 1330),
        ("eq_prediction\n预测结果", 1520),
        ("eq_wind_forecast_bind\n风电绑定", 1710),
    ]
    last_y = None
    for text, cy in chain:
        g.box(1985, cy, 390, 90, text, font=g.small_f)
        if last_y is not None:
            g.arrow((1985, last_y + 45), (1985, cy - 45))
        last_y = cy

    g.box(1300, 690, 440, 330, "扩展数据汇总\neq_sensor\neq_device_param\neq_mechanical_data\neq_operational_data\neq_technology_data\neq_electrical_data\neq_environment_data\neq_climate_data\neq_economic_data", font=g.note_f)
    g.poly_arrow([(1230, 275), (980, 330), (480, 555)], "工单关联", text_pos=(850, 355))
    g.poly_arrow([(1370, 275), (1740, 335), (1985, 525)], "状态数据", text_pos=(1740, 360))
    g.arrow((1300, 278), (1300, 525), "扩展属性")
    g.arrow((330, 648), (330, 802), "生成消息")
    g.arrow((800, 648), (420, 805), "接收人")
    g.arrow((800, 648), (800, 802), "会话用户")
    g.save("数据库E-R图_清晰版.png")


def draw_work_order():
    g = Diagram(1600, 2600, "运维工单全生命周期流程图")
    x = 800
    g.box(x, 210, 430, 90, "告警触发 / 人工上报", font=g.small_f)
    g.box(x, 420, 520, 105, "待维护设备聚合\nmaintenance-form/devices", font=g.small_f)
    g.box(x, 640, 320, 95, "生成工单\n单台 / 批量", font=g.small_f)
    g.box(x, 860, 470, 105, "工单入库\nai_maintenance_form", font=g.small_f)
    g.box(420, 1100, 390, 95, "站内消息通知\nsys_user_message", font=g.small_f)
    g.box(1040, 1100, 330, 95, "工单列表查询", font=g.small_f)
    g.box(1040, 1320, 330, 95, "指派与处理", font=g.small_f)
    g.box(800, 1540, 330, 95, "现场执行维护", font=g.small_f)
    g.diamond(800, 1780, 300, 210, "是否通过验收")
    g.box(600, 2050, 330, 95, "状态：已完成", font=g.small_f)
    g.box(1150, 2050, 360, 95, "状态：退回处理", font=g.small_f)
    g.box(600, 2260, 380, 95, "归档与可追溯查询", font=g.small_f)
    g.box(600, 2450, 280, 90, "流程结束", font=g.small_f)
    for y1, y2 in [(255, 368), (472, 592), (688, 808)]:
        g.arrow((x, y1), (x, y2))
    g.arrow((680, 912), (470, 1052), "提醒")
    g.arrow((920, 912), (1040, 1052), "查询")
    g.arrow((1040, 1148), (1040, 1272))
    g.arrow((960, 1368), (830, 1492), "派工")
    g.arrow((800, 1588), (800, 1675))
    g.arrow((720, 1870), (610, 2002), "是")
    g.arrow((880, 1870), (1130, 2002), "否")
    g.poly_arrow([(1150, 2002), (1360, 1900), (1360, 1320), (1205, 1320)], "退回重处理", text_pos=(1410, 1640))
    g.arrow((600, 2098), (600, 2212))
    g.arrow((600, 2308), (600, 2405))
    g.save("运维工单_清晰版.png")


if __name__ == "__main__":
    draw_rag()
    draw_rbac_model()
    draw_permission_flow()
    draw_er()
    draw_work_order()






