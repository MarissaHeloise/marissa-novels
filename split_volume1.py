import os

# 读取第一卷初稿文件
file_path = 'd:\\novels\\百合小说\\第一卷初稿.txt'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 识别章节标题，分割章节
chapters = []
current_chapter = []
lines = content.split('\n')

# 找到第一章开始
first_chapter_found = False
for line in lines:
    # 检查是否是章节标题（格式：第X章 标题）
    if line.startswith('第') and '章' in line:
        if not first_chapter_found:
            # 第一个章节，添加标题到当前章节
            current_chapter.append(line)
            first_chapter_found = True
        else:
            # 新章节，保存当前章节并开始新章节
            if current_chapter:
                chapters.append('\n'.join(current_chapter))
                current_chapter = [line]
    else:
        # 普通内容，添加到当前章节
        current_chapter.append(line)

# 保存最后一个章节
if current_chapter:
    chapters.append('\n'.join(current_chapter))

# 只保留前24个章节
chapters = chapters[:24]

# 确保有24个章节
while len(chapters) < 24:
    chapters.append('')

# 写入volume1目录
output_dir = 'd:\\novels\\百合小说\\chapters\\volume1'
os.makedirs(output_dir, exist_ok=True)

# 清除旧文件
for file in os.listdir(output_dir):
    if file.startswith('chapter-') and file.endswith('.md'):
        os.remove(os.path.join(output_dir, file))

# 写入新文件
for i, chapter_content in enumerate(chapters, 1):
    chapter_file = os.path.join(output_dir, f'chapter-{i:03d}.md')
    
    # 处理章节内容，给章节标题加上markdown标题符号
    lines = chapter_content.split('\n')
    processed_lines = []
    for line in lines:
        if line.startswith('第') and '章' in line:
            # 给章节标题加上markdown标题符号
            processed_lines.append(f'# {line}')
        else:
            processed_lines.append(line)
    
    processed_content = '\n'.join(processed_lines)
    
    with open(chapter_file, 'w', encoding='utf-8') as f:
        f.write(processed_content.strip())

print(f'已成功按照章节标题分割并写入{len(chapters)}个章节到 {output_dir}')
