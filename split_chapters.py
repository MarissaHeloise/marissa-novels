import os
import re

# 配置信息
input_file = "d:\\novels\\百合小说\\百合小说_20260304_183931.txt"
output_dir = "d:\\novels\\百合小说\\chapters"

# 每卷章节数
chapters_per_volume = 75

# 中文数字转阿拉伯数字的函数
def cn_to_num(cn_num):
    # 基本数字映射
    basic_map = {'零': 0, '一': 1, '二': 2, '三': 3, '四': 4, '五': 5, '六': 6, '七': 7, '八': 8, '九': 9}
    # 进位映射
    carry_map = {'十': 10, '百': 100, '千': 1000, '万': 10000}
    
    # 特殊情况处理
    special_map = {
        '十': 10, '十一': 11, '十二': 12, '十三': 13, '十四': 14, '十五': 15,
        '十六': 16, '十七': 17, '十八': 18, '十九': 19, '二十': 20
    }
    
    if cn_num in special_map:
        return special_map[cn_num]
    
    # 处理复杂情况
    result = 0
    temp = 0
    
    for char in cn_num:
        if char in basic_map:
            temp = basic_map[char]
        elif char in carry_map:
            if temp == 0:
                temp = 1  # 处理如"十"、"百"等情况
            result += temp * carry_map[char]
            temp = 0
    
    if temp > 0:
        result += temp
    
    return result

# 处理章节
def process_chapters():
    # 确保输出目录存在
    os.makedirs(output_dir, exist_ok=True)
    
    # 检查输入文件是否存在
    if not os.path.exists(input_file):
        print(f"输入文件不存在: {input_file}")
        return
    
    # 读取小说内容
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"读取文件时出错: {str(e)}")
        return
    
    # 提取章节
    # 匹配章节标题，格式如：第一章 标题
    chapter_pattern = re.compile(r'(第[一二三四五六七八九十百]+章 .*?)(?=第[一二三四五六七八九十百]+章 |$)', re.DOTALL)
    chapters = chapter_pattern.findall(content)
    
    if not chapters:
        print("未找到章节")
        return
    
    print(f"找到 {len(chapters)} 个章节")
    
    # 处理章节
    for i, chapter_content in enumerate(chapters, 1):
        # 提取章节标题
        title_match = re.match(r'第([一二三四五六七八九十百]+章 .*)', chapter_content)
        if title_match:
            title = title_match.group(1)
            # 提取章节序号（中文）
            cn_num_match = re.match(r'([一二三四五六七八九十百]+)章 ', title)
            if cn_num_match:
                cn_num = cn_num_match.group(1)
                # 使用中文数字转阿拉伯数字的函数
                try:
                    original_chapter_num = cn_to_num(cn_num)
                    print(f"章节 {cn_num} 转换为数字: {original_chapter_num}")
                except:
                    original_chapter_num = i
            else:
                cn_num = f"{i}"
                original_chapter_num = i
            # 使用顺序编号
            chapter_num = i
            
            # 计算卷号
            volume_num = (chapter_num - 1) // chapters_per_volume + 1
            volume_dir = f"volume{volume_num}"
            volume_path = os.path.join(output_dir, volume_dir)
            
            # 确保卷目录存在
            os.makedirs(volume_path, exist_ok=True)
            
            # 提取正文内容
            content_part = chapter_content[len(title):].strip()
            
            # 计算字数
            word_count = len(content_part)
            
            # 生成文件名
            filename = f"chapter-{chapter_num:03d}.md"
            filepath = os.path.join(volume_path, filename)
            
            # 生成markdown内容
            markdown_content = f"# 第{cn_num}章 {title.split('章 ')[1]}\n\n"
            markdown_content += "**Status**: Written  \\n"
            markdown_content += f"**Word Count**: 约 {word_count}  \\n"
            markdown_content += f"**Volume**: {volume_num}  \\n"

            markdown_content += "---\n\n"
            markdown_content += f"{content_part}\n\n"
            markdown_content += "---\n\n"
            
            # 写入文件
            try:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(markdown_content)
                print(f"生成章节文件：{volume_dir}/{filename}")
            except Exception as e:
                print(f"写入文件时出错: {str(e)}")
        else:
            print(f"无法提取章节 {i} 的标题")
    
    print("章节分割完成！")

if __name__ == "__main__":
    process_chapters()
