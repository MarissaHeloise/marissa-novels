# -*- coding: utf-8 -*-
"""古风取名备选库生成脚本 - 《灵衍万华录》
每次运行生成一个新文件（取名备选库_001.md、_002.md…），不覆盖旧库，便于多次生成后人工筛选。
"""
import random
import os
import re
import time

# 每次运行使用不同种子，便于多次生成不同结果
random.seed(int(time.time() * 1000) % (2**32))
COUNT_PER_CATEGORY = 100   # 每类数量（坊市/驿站/城池等，待筛选）
COUNT_NPC = 300

# 古风用字库（偏修真/古典）
FANG_SHI = "坊市街肆墟集阑阑榭阁楼台轩廊巷弄"  # 坊市用字
YI_ZHAN = "驿亭站铺递关津渡口栈道亭台"  # 驿站
CHENG_CI = "城邑郡郭都京府州镇关堡寨"  # 城池
CUN_LUO = "村庄屯里社寨堡圩聚落坞"  # 村落
XIAO_ZHEN = "镇集埠圩铺驿亭关堡"  # 小镇后缀（详见 gen_xiaozhen 前）
SHANG_PU_A = "宝珍奇玉锦华云霞金玉翠"  # 商铺前缀
SHANG_PU_B = "斋阁轩堂坊铺庄号栈"  # 商铺后缀
ORG_A = "会盟社堂阁楼殿坊局司"  # 组织
ORG_B = "商武文药器阵符丹剑"  # 组织类型
FORCE_A = "帮派门堂会盟"  # 势力
FORCE_B = "青云赤焰碧水玄金紫霄"  # 势力风格
SECT_A = "谷山庄院阁殿观庵堂"  # 宗门
SECT_B = "灵玄青霞云剑丹器阵符"  # 宗门风格

# 二字词根（古风常用，大幅扩充以减少重复感）
ROOTS_2 = [
    "青云", "碧落", "紫霄", "玄冥", "赤焰", "苍梧", "丹霞", "翠微", "银汉", "金阙",
    "玉京", "瑶台", "蓬莱", "方丈", "瀛洲", "昆仑", "太华", "青城", "峨眉", "武当",
    "长河", "落日", "孤烟", "寒山", "古道", "西风", "明月", "清风", "流云", "飞雪",
    "听雨", "望江", "栖霞", "枕流", "漱石", "问心", "守静", "归元", "凝丹", "炼器",
    "天机", "玄机", "造化", "乾坤", "阴阳", "五行", "八卦", "九宫", "万象", "归一",
    "忘忧", "解语", "知秋", "听松", "观潮", "揽月", "摘星", "踏雪", "寻梅", "采薇",
    "锦瑟", "瑶琴", "玉笛", "金箫", "铁马", "冰河", "霜刃", "寒锋", "烈酒", "清茶",
    "墨香", "纸鸢", "竹影", "松涛", "梅骨", "兰心", "菊魂", "莲意", "枫火", "桂子",
    "沧溟", "碧波", "烟渚", "芦荻", "雁门", "玉关", "阳关", "敦煌", "楼兰", "凉州",
    "姑苏", "金陵", "长安", "洛阳", "汴梁", "临安", "巴陵", "荆楚", "吴越", "燕赵",
    "雁荡", "黄山", "庐山", "雁塔", "钟鼓", "琴台", "书阁", "墨池", "砚田", "笔林",
    "杏林", "橘井", "芝兰", "蕙芷", "杜若", "蘅芜", "薜荔", "藤萝", "薜萝", "菡萏",
    "梧桐", "楸枰", "桑麻", "榆柳", "槐荫", "樟楠", "梓桐", "杞梓", "荆杞", "楚棘",
    "鹤唳", "猿啼", "鹿鸣", "凤鸣", "龙吟", "虎啸", "莺啼", "燕语", "蝉鸣", "蛩声",
    "晓月", "残星", "朝露", "夕照", "暮烟", "晨钟", "暮鼓", "更漏", "烛影", "灯花",
    "素心", "禅意", "梵音", "法雨", "慈航", "般若", "菩提", "明镜", "止水", "空谷",
]

def pick(chars, n=1):
    return "".join(random.choices(chars, k=n))


def _no_repeat_char(name):
    """名称内无重复用字（每个字最多出现一次）。"""
    return len(name) == len(set(name))


def _pick_different(pool, k, exclude=""):
    """从 pool 中随机取 k 个不重复的字，且不在 exclude 中。pool 可为 str 或 list。"""
    pool = list(pool) if isinstance(pool, str) else list(pool)
    available = [c for c in pool if c not in exclude]
    if len(available) < k:
        return None
    return random.sample(available, k)


def from_roots(roots, count):
    seen = set()
    out = []
    while len(out) < count:
        w = random.choice(roots)
        w2 = random.choice(roots)
        if w != w2:
            name = w + w2
            if name not in seen:
                seen.add(name)
                out.append(name)
    return out

# 坊市用字（3–5 字名，扩充；生成后校验名内不重字）
FANG_SHI_PREFIX = "东西南北中上下" + "青锦云玉金银长永福禄寿安宁" + "碧紫玄翠丹霞" + "墨朱素乌"
FANG_SHI_MID = "云霞玉锦华清风月" + "长乐永安福" + "龙虎鹤凤" + "雁燕雀麟鹿" + "梅兰竹菊荷" + "霜露雪雨烟波"
FANG_SHI_SUFFIX = "坊市街肆集阑榭阁巷弄台轩廊" + "阙槛"

def gen_fangshi(n=1000):
    """坊市名称：3–5 个字，名称内不重复用字。"""
    out = set()
    attempts, max_attempts = 0, n * 80
    while len(out) < n and attempts < max_attempts:
        attempts += 1
        length = random.choices([3, 4, 5], weights=[0.35, 0.45, 0.2])[0]
        if length == 3:
            a = random.choice(list(FANG_SHI_PREFIX))
            b = random.choice(list(FANG_SHI_MID))
            c = random.choice(list(FANG_SHI_SUFFIX))
            name = a + b + c
        elif length == 4:
            if random.random() < 0.5:
                name = random.choice(ROOTS_2) + random.choice(list(FANG_SHI_MID)) + random.choice(list(FANG_SHI_SUFFIX))
            else:
                name = random.choice(list(FANG_SHI_PREFIX)) + random.choice(ROOTS_2) + random.choice(list(FANG_SHI_SUFFIX))
        else:
            if random.random() < 0.5:
                r = random.choice(ROOTS_2)
                m1 = random.choice(list(FANG_SHI_MID))
                m2 = random.choice(list(FANG_SHI_MID))
                c = random.choice(list(FANG_SHI_SUFFIX))
                name = r + m1 + m2 + c
            else:
                a = random.choice(list(FANG_SHI_PREFIX))
                r = random.choice(ROOTS_2)
                m = random.choice(list(FANG_SHI_MID))
                c = random.choice(list(FANG_SHI_SUFFIX))
                name = a + r + m + c
        if 3 <= len(name) <= 5 and _no_repeat_char(name):
            out.add(name)
    return list(out)[:n]

# 驿站用字扩充
YIZHAN_PRE = "东西南北中上下" + "青云赤碧苍玄" + "长永平安福" + "白墨金玉"
YIZHAN_MID = "风霜雪雨云霞" + "龙虎鹤马" + "雁燕雀麟" + "梅竹松柏" + "日月星"
YIZHAN_SUF = ["驿", "亭", "站", "铺", "关", "津", "栈", "渡", "埠", "口"]

def gen_yizhan(n=1000):
    """驿站：3–5 字。"""
    out = set()
    attempts, max_attempts = 0, n * 60
    while len(out) < n and attempts < max_attempts:
        attempts += 1
        length = random.choices([3, 4, 5], weights=[0.4, 0.4, 0.2])[0]
        if length == 3:
            name = random.choice(list(YIZHAN_PRE)) + random.choice(list(YIZHAN_MID)) + random.choice(YIZHAN_SUF)
        elif length == 4:
            pre, r, suf = random.choice(list(YIZHAN_PRE)), random.choice(ROOTS_2), random.choice(YIZHAN_SUF)
            name = pre + r + suf
        else:
            r = random.choice(ROOTS_2)
            m = random.choice(list(YIZHAN_MID))
            suf = random.choice(YIZHAN_SUF)
            pre = random.choice(list(YIZHAN_PRE))
            name = pre + r + m + suf
        if 3 <= len(name) <= 5 and _no_repeat_char(name):
            out.add(name)
    return list(out)[:n]

# 城池用字扩充
CHENGCHI_PRE = "东西南北中上京天" + "云青赤金玉碧玄" + "长永安阳阴" + "白墨丹朱"
CHENGCHI_SUF = ["城", "邑", "郡", "郭", "都", "府", "州", "关", "堡", "寨", "镇", "圩"]

def gen_chengchi(n=1000):
    """城池：3–5 字。"""
    out = set()
    attempts, max_attempts = 0, n * 50
    while len(out) < n and attempts < max_attempts:
        attempts += 1
        length = random.choices([3, 4, 5], weights=[0.35, 0.45, 0.2])[0]
        suf = random.choice(CHENGCHI_SUF)
        if length == 3:
            name = random.choice(list(CHENGCHI_PRE)) + random.choice(ROOTS_2)[0] + suf
        elif length == 4:
            name = random.choice(ROOTS_2) + suf
        else:
            pre = random.choice(list(CHENGCHI_PRE))
            r = random.choice(ROOTS_2)
            mid = random.choice(list(CHENGCHI_PRE))
            name = pre + r + mid + suf
        if 3 <= len(name) <= 5 and _no_repeat_char(name):
            out.add(name)
    return list(out)[:n]

# 村落用字扩充
CUNLUO_PRE = "东西南北上下" + "李王张刘陈杨赵黄周吴徐孙" + "青竹梅桃杏柳枫" + "大小林"
CUNLUO_MID = "庄屯里" + "".join(c[0] for c in ROOTS_2[:30])  # 单字
CUNLUO_SUF = ("村", "庄", "屯", "里", "社", "寨", "堡", "圩", "聚", "坞", "店", "铺")

def gen_cunluo(n=1000):
    """村落：3–5 字。"""
    out = set()
    attempts, max_attempts = 0, n * 50
    while len(out) < n and attempts < max_attempts:
        attempts += 1
        length = random.choices([3, 4, 5], weights=[0.4, 0.4, 0.2])[0]
        if length == 3:
            name = random.choice(list(CUNLUO_PRE)) + random.choice(list(CUNLUO_MID)) + random.choice(CUNLUO_SUF)
        elif length == 4:
            name = random.choice(list(CUNLUO_PRE)) + random.choice(ROOTS_2) + random.choice(CUNLUO_SUF)
        else:
            name = random.choice(list(CUNLUO_PRE)) + random.choice(ROOTS_2) + random.choice(list(CUNLUO_MID)) + random.choice(CUNLUO_SUF)
        if 3 <= len(name) <= 5 and _no_repeat_char(name):
            out.add(name)
    return list(out)[:n]

# 地形用字扩充
TERRAIN_B = "青碧翠苍玄赤金银白墨丹朱紫" + "绯绛赭"
TERRAIN_A = "云霞雾岚峰峦崖岭岗丘山岳川江河溪涧泉湖泽渊潭池林谷壑洞窟" + "瀑滩洲"
TERRAIN_C = "龙凤麟虎雀鹤松竹梅兰莲枫" + "鹿雁燕"
TERRAIN_END = ["峰", "岭", "谷", "渊", "涧", "潭", "林", "原", "岗", "崖", "溪", "江", "河", "湖", "泽", "瀑", "滩"]

def gen_terrain(n=1000):
    """地形：3–5 字。"""
    out = set()
    for _ in range(n * 8):
        length = random.choices([3, 4, 5], weights=[0.4, 0.4, 0.2])[0]
        if length == 3:
            a, b = random.choice(list(TERRAIN_B)), random.choice(list(TERRAIN_A))
            c = random.choice(TERRAIN_END)
            name = a + b + c
        elif length == 4:
            r = random.choice(ROOTS_2)
            m = random.choice(list(TERRAIN_A))
            c = random.choice(TERRAIN_END)
            name = r + m + c
        else:
            pre = random.choice(list(TERRAIN_B))
            r = random.choice(ROOTS_2)
            c = random.choice(TERRAIN_END)
            name = pre + r + c
        if name and 3 <= len(name) <= 5 and _no_repeat_char(name):
            out.add(name)
    return list(out)[:n]

# 小镇用字扩充
XIAOZHEN_SUF = ["镇", "集", "埠", "圩", "铺", "驿", "亭", "关", "堡", "场", "口", "渡"]

def gen_xiaozhen(n=1000):
    """小镇：3–5 字。"""
    out = set()
    attempts, max_attempts = 0, n * 50
    pre_list = list(YIZHAN_PRE)
    while len(out) < n and attempts < max_attempts:
        attempts += 1
        length = random.choices([3, 4, 5], weights=[0.4, 0.4, 0.2])[0]
        r, suf = random.choice(ROOTS_2), random.choice(XIAOZHEN_SUF)
        if length == 3:
            name = r + suf
        elif length == 4:
            pre = random.choice(pre_list)
            name = pre + r + suf
        else:
            pre = random.choice(pre_list)
            m = random.choice(list(YIZHAN_MID))
            name = pre + r + m + suf
        if 3 <= len(name) <= 5 and _no_repeat_char(name):
            out.add(name)
    return list(out)[:n]

# 商铺用字扩充（前缀二字+后缀，名内不重字）
SHANG_PU_PRE = "宝珍奇玉锦华" + "云霞金翠" + "墨香丹朱" + "素雪银" + "松竹梅兰" + "鹤鹿凤麟" + "清风明月"
SHANG_PU_SUF = ["斋", "阁", "轩", "堂", "坊", "铺", "庄", "号", "栈", "楼", "居", "舍", "庐", "苑"]

def gen_shangpu(n=1000):
    """商铺：3–5 字。"""
    out = set()
    attempts, max_attempts = 0, n * 60
    pre_list = list(SHANG_PU_PRE)
    while len(out) < n and attempts < max_attempts:
        attempts += 1
        length = random.choices([3, 4, 5], weights=[0.35, 0.45, 0.2])[0]
        s = random.choice(SHANG_PU_SUF)
        if length == 3:
            p1 = random.choice(pre_list)
            p2 = _pick_different(pre_list, 1, exclude=p1)
            if not p2:
                continue
            name = p1 + p2[0] + s
        elif length == 4:
            r = random.choice(ROOTS_2)
            m = random.choice(list(FANG_SHI_MID))
            name = r + m + s
        else:
            pre = random.choice(pre_list)
            r = random.choice(ROOTS_2)
            m = random.choice(list(FANG_SHI_MID))
            name = pre + r + m + s
        if 3 <= len(name) <= 5 and _no_repeat_char(name):
            out.add(name)
    return list(out)[:n]

# 组织用字扩充
ORG_PRE = "商武文药器阵符丹剑" + "玄灵" + "镖行盐" + "经籍"  # 类型/风格
ORG_SUF = ["会", "盟", "社", "堂", "阁", "楼", "殿", "坊", "局", "司", "院", "馆", "所"]

def gen_org(n=1000):
    """组织：3–5 字。"""
    out = set()
    attempts, max_attempts = 0, n * 60
    pre_list = list(ORG_PRE)
    while len(out) < n and attempts < max_attempts:
        attempts += 1
        length = random.choices([3, 4, 5], weights=[0.35, 0.45, 0.2])[0]
        s = random.choice(ORG_SUF)
        if length == 3:
            c1 = random.choice(pre_list)
            c2 = _pick_different(pre_list, 1, exclude=c1)
            a = (c1 + c2[0]) if c2 else random.choice(ROOTS_2)[:2]
            name = a + s
        elif length == 4:
            name = random.choice(ROOTS_2) + s
        else:
            name = random.choice(pre_list) + random.choice(ROOTS_2) + s
        if 3 <= len(name) <= 5 and _no_repeat_char(name):
            out.add(name)
    return list(out)[:n]

# 势力用字扩充
FORCE_PRE = ROOTS_2 + ["青云", "赤焰", "碧水", "玄金", "紫霄", "白鹤", "墨衣", "丹心", "朱门"]  # 可重复从 ROOTS_2 取
FORCE_SUF = ["帮", "派", "门", "堂", "会", "盟", "舵", "旗", "营"]

def gen_force(n=1000):
    """势力：3–5 字。"""
    out = set()
    attempts, max_attempts = 0, n * 50
    while len(out) < n and attempts < max_attempts:
        attempts += 1
        length = random.choices([3, 4, 5], weights=[0.4, 0.4, 0.2])[0]
        r, s = random.choice(ROOTS_2), random.choice(FORCE_SUF)
        if length == 3:
            name = r + s
        elif length == 4:
            name = random.choice(list(YIZHAN_PRE)) + r + s
        else:
            name = random.choice(list(YIZHAN_PRE)) + r + random.choice(list(YIZHAN_MID)) + s
        if 3 <= len(name) <= 5 and _no_repeat_char(name):
            out.add(name)
    return list(out)[:n]

# 宗门用字扩充
SECT_PRE = "灵玄青霞云剑丹器阵符" + "碧紫" + "霜雪" + "凌霄"  # 单字组合或 ROOTS_2
SECT_SUF = ["谷", "山", "庄", "院", "阁", "殿", "观", "庵", "堂", "峰", "洞", "崖"]

def gen_sect(n=1000):
    """宗门：3–5 字。"""
    out = set()
    attempts, max_attempts = 0, n * 50
    pre_list = list(SECT_PRE)
    while len(out) < n and attempts < max_attempts:
        attempts += 1
        length = random.choices([3, 4, 5], weights=[0.4, 0.4, 0.2])[0]
        s = random.choice(SECT_SUF)
        if length == 3:
            c1 = random.choice(pre_list)
            c2 = _pick_different(pre_list, 1, exclude=c1)
            a = (c1 + c2[0]) if c2 else random.choice(ROOTS_2)
            name = a + s
        elif length == 4:
            name = random.choice(ROOTS_2) + s
        else:
            name = random.choice(pre_list) + random.choice(ROOTS_2) + s
        if 3 <= len(name) <= 5 and _no_repeat_char(name):
            out.add(name)
    return list(out)[:n]

# 姓氏 + 名字用字（古风）
SURNAMES = [
    "李", "王", "张", "刘", "陈", "杨", "赵", "黄", "周", "吴", "徐", "孙", "胡", "朱", "高", "林", "何", "郭", "马", "罗",
    "梁", "宋", "郑", "谢", "唐", "韩", "曹", "许", "邓", "萧", "冯", "曾", "程", "蔡", "彭", "潘", "袁", "董", "余", "苏",
    "叶", "吕", "魏", "蒋", "田", "杜", "丁", "沈", "姜", "范", "江", "傅", "钟", "卢", "汪", "戴", "崔", "任", "陆", "廖",
    "薛", "石", "姚", "谭", "邹", "熊", "金", "陆", "郝", "孔", "白", "崔", "康", "毛", "邱", "秦", "江", "史", "顾", "侯",
    "邵", "孟", "龙", "万", "段", "漕", "钱", "汤", "尹", "黎", "易", "常", "武", "乔", "贺", "赖", "龚", "文", "庞", "樊",
    "兰", "殷", "施", "陶", "洪", "翟", "安", "颜", "倪", "严", "牛", "温", "芦", "季", "俞", "章", "鲁", "韦", "昌", "马",
    "苗", "凤", "花", "方", "俞", "任", "袁", "柳", "酆", "鲍", "史", "唐", "费", "廉", "岑", "薛", "雷", "贺", "倪", "汤",
    "滕", "殷", "罗", "毕", "郝", "邬", "安", "常", "乐", "于", "时", "傅", "皮", "卞", "齐", "康", "伍", "余", "元", "卜",
    "顾", "孟", "平", "黄", "和", "穆", "萧", "尹", "姚", "邵", "湛", "汪", "祁", "毛", "禹", "狄", "米", "贝", "明", "臧",
    "计", "伏", "成", "戴", "谈", "宋", "茅", "庞", "熊", "纪", "舒", "屈", "项", "祝", "董", "梁", "杜", "阮", "蓝", "闵",
]
NAME_CHARS = [
    "轩", "宇", "涵", "泽", "睿", "晨", "浩", "俊", "杰", "博", "文", "斌", "志", "明", "强", "磊", "洋", "勇", "军", "敏",
    "静", "丽", "娟", "艳", "芳", "玲", "霞", "萍", "红", "梅", "琳", "燕", "云", "琴", "慧", "秀", "英", "华", "玉", "春",
    "青", "松", "竹", "柏", "枫", "桐", "梧", "桑", "柳", "杨", "槐", "桂", "兰", "莲", "荷", "菊", "梅", "杏", "桃", "李",
    "风", "月", "星", "辰", "雨", "雪", "霜", "露", "霞", "霓", "岚", "雾", "云", "雷", "电", "冰", "寒", "冷", "暖", "温",
    "清", "明", "朗", "澈", "澄", "净", "幽", "玄", "妙", "灵", "真", "道", "心", "意", "念", "思", "悟", "觉", "修", "行",
    "安", "宁", "平", "和", "泰", "康", "乐", "喜", "悦", "欢", "欣", "怡", "然", "若", "如", "似", "宛", "犹", "亦", "且",
    "子", "之", "以", "于", "兮", "尔", "其", "何", "若", "乃", "则", "故", "因", "由", "自", "从", "向", "往", "来", "去",
    "长", "永", "久", "远", "深", "高", "广", "大", "微", "细", "轻", "重", "缓", "急", "迟", "速", "早", "晚", "初", "末",
    "墨", "砚", "笔", "纸", "书", "剑", "琴", "棋", "画", "诗", "酒", "茶", "香", "花", "影", "光", "色", "声", "韵", "律",
    "昭", "曜", "晖", "煜", "灼", "炎", "灿", "焕", "朗", "照", "映", "鉴", "镜", "观", "望", "瞻", "顾", "盼", "睐", "眸",
]

def gen_npc_names(count=3000):
    """NPC 姓名：2–4 字（姓+名）。"""
    seen = set()
    out = []
    max_attempts = count * 25
    attempts = 0
    name_chars_list = list(NAME_CHARS)
    while len(out) < count and attempts < max_attempts:
        attempts += 1
        surname = random.choice(SURNAMES)
        name_len = random.choices([2, 3, 4], weights=[0.25, 0.5, 0.25])[0]
        if name_len == 2:
            c1 = _pick_different(name_chars_list, 1, exclude=surname)
            if not c1:
                continue
            name = surname + c1[0]
        elif name_len == 3:
            c1 = random.choice(name_chars_list)
            c2 = _pick_different(name_chars_list, 1, exclude=c1 + surname)
            if not c2:
                continue
            name = surname + c1 + c2[0]
        else:
            c1 = random.choice(name_chars_list)
            c2 = _pick_different(name_chars_list, 1, exclude=c1 + surname)
            c3 = _pick_different(name_chars_list, 1, exclude=c1 + c2[0] + surname) if c2 else None
            if not c2 or not c3:
                continue
            name = surname + c1 + c2[0] + c3[0]
        if name not in seen and 2 <= len(name) <= 4 and _no_repeat_char(name):
            seen.add(name)
            out.append(name)
    return out

def _next_bank_number(dir_path):
    """返回下一个可用的编号 001, 002, ..."""
    pattern = re.compile(r"^取名备选库_(\d+)\.md$")
    existing = []
    for f in os.listdir(dir_path or "."):
        m = pattern.match(f)
        if m:
            existing.append(int(m.group(1)))
    return max(existing, default=0) + 1


def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    os.makedirs(base_dir, exist_ok=True)
    num = _next_bank_number(base_dir)
    out_path = os.path.join(base_dir, f"取名备选库_{num:03d}.md")

    lines = [
        "# 灵衍世界 · 取名备选名称库",
        "",
        f"**说明**：本库编号 **{num:03d}**。以下为随机生成的古风备选名：**地点/组织/商铺等均为 3–5 字**，**NPC 姓名为 2–4 字**。可任意选用或再组合；多次运行脚本会生成新编号文件，便于人工筛选。",
        "",
        "---",
        "",
    ]

    def section(title, names, per_line=10):
        lines.append(f"## {title}")
        lines.append("")
        for i in range(0, len(names), per_line):
            chunk = names[i:i + per_line]
            lines.append("、".join(chunk))
            lines.append("")
        lines.append("")

    n = COUNT_PER_CATEGORY
    section(f"一、坊市（{n}，3–5 字）", gen_fangshi(n))
    section(f"二、驿站（{n}）", gen_yizhan(n))
    section(f"三、城池（{n}）", gen_chengchi(n))
    section(f"四、村落（{n}）", gen_cunluo(n))
    section(f"五、地形（{n}）", gen_terrain(n))
    section(f"六、小镇（{n}）", gen_xiaozhen(n))
    section(f"七、商铺（{n}）", gen_shangpu(n))
    section(f"八、中小组织（{n}）", gen_org(n))
    section(f"九、中小势力（{n}）", gen_force(n))
    section(f"十、中小宗门（{n}）", gen_sect(n))

    lines.append("---")
    lines.append("")
    lines.append(f"## 十一、NPC 备选名字（{COUNT_NPC}，2–4 字）")
    lines.append("")
    npc = gen_npc_names(COUNT_NPC)
    for i in range(0, len(npc), 15):
        chunk = npc[i:i + 15]
        lines.append("、".join(chunk))
        lines.append("")
    lines.append("")
    lines.append(f"*生成完毕 · 库编号 {num:03d}*")

    with open(out_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"已生成: {out_path}")
    print(f"坊市/驿站/城池/村落/地形/小镇/商铺/组织/势力/宗门 各 {COUNT_PER_CATEGORY} 条（均为 3–5 字），NPC {COUNT_NPC} 条（2–4 字）。再次运行将生成 取名备选库_{num+1:03d}.md")

if __name__ == "__main__":
    main()
