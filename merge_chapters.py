import os
import re
import time

# 小说名称
novel_name = "百合小说"

# 章节目录根目录
chapters_root_dir = f"d:\\novels\\{novel_name}\\chapters"

# 生成带时间戳的输出文件路径
timestamp = time.strftime("%Y%m%d_%H%M%S")
output_file = f"{novel_name}_{timestamp}.txt"

# 按卷号排序的函数
def get_volume_number(volume_dir):
    match = re.search(r"volume(\d+)", volume_dir)
    if match:
        return int(match.group(1))
    return 0

# 按章节号排序的函数
def get_chapter_number(filename):
    match = re.search(r"chapter-(\d+).md", filename)
    if match:
        return int(match.group(1))
    return 0

# 合并章节
def merge_chapters():
    # 确保输出目录存在
    output_dir = os.path.dirname(output_file)
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir, exist_ok=True)
    
    # 检查章节目录是否存在
    if not os.path.exists(chapters_root_dir):
        print(f"章节目录不存在: {chapters_root_dir}")
        return
    
    # 获取所有卷目录并排序
    volume_dirs = []
    for item in os.listdir(chapters_root_dir):
        item_path = os.path.join(chapters_root_dir, item)
        if os.path.isdir(item_path) and item.startswith("volume"):
            volume_dirs.append(item)
    
    # 按卷号排序
    volume_dirs.sort(key=get_volume_number)
    
    # 如果没有卷目录，直接检查根目录
    if not volume_dirs:
        print("未找到卷目录，检查根目录是否有章节文件...")
        chapter_files = []
        for file in os.listdir(chapters_root_dir):
            if file.startswith("chapter-") and file.endswith(".md"):
                chapter_files.append(file)
        
        if chapter_files:
            print(f"找到 {len(chapter_files)} 个章节文件")
            chapter_files.sort(key=get_chapter_number)
            
            with open(output_file, "w", encoding="utf-8") as out:
                for chapter_file in chapter_files:
                    chapter_path = os.path.join(chapters_root_dir, chapter_file)
                    process_chapter(chapter_path, out)
        else:
            print("未找到章节文件")
            return
    else:
        print(f"找到 {len(volume_dirs)} 个卷目录")
        
        with open(output_file, "w", encoding="utf-8") as out:
            # 遍历每个卷
            for volume_dir in volume_dirs:
                volume_path = os.path.join(chapters_root_dir, volume_dir)
                volume_number = get_volume_number(volume_dir)
                
                # 写入卷标题
                out.write(f"第{volume_number}卷\n\n")
                print(f"处理第 {volume_number} 卷...")
                
                # 获取当前卷的所有章节文件
                chapter_files = []
                for file in os.listdir(volume_path):
                    if file.startswith("chapter-") and file.endswith(".md"):
                        chapter_files.append(file)
                
                if not chapter_files:
                    print(f"第 {volume_number} 卷没有章节文件")
                    continue
                
                # 按章节号排序
                chapter_files.sort(key=get_chapter_number)
                print(f"第 {volume_number} 卷有 {len(chapter_files)} 个章节")
                
                # 遍历当前卷的所有章节
                for chapter_file in chapter_files:
                    chapter_path = os.path.join(volume_path, chapter_file)
                    process_chapter(chapter_path, out)
    
    print(f"\n已将所有章节合并到 {output_file} 文件中")

# 处理单个章节
def process_chapter(chapter_path, out):
    try:
        with open(chapter_path, "r", encoding="utf-8") as f:
            content = f.read()
            
            # 提取章节标题和内容
            lines = content.split("\n")
            chapter_title = ""
            chapter_content = []
            skip_metadata = False
            
            for line in lines:
                stripped_line = line.strip()
                if stripped_line.startswith("# "):
                    chapter_title = stripped_line[2:].strip()
                    skip_metadata = False
                elif stripped_line.startswith("---"):
                    # 跳过元数据部分
                    continue
                elif stripped_line.startswith("Chapter Metadata") or stripped_line.startswith("## Chapter Metadata"):
                    # 开始跳过metadata部分
                    skip_metadata = True
                    continue
                elif skip_metadata:
                    # 跳过所有metadata内容
                    continue
                elif stripped_line:
                    chapter_content.append(stripped_line)
            
            # 写入章节标题和内容
            if chapter_title:
                out.write(chapter_title + "\n\n")
            if chapter_content:
                out.write("\n".join(chapter_content) + "\n\n")
    except Exception as e:
        print(f"处理章节文件 {chapter_path} 时出错: {str(e)}")

if __name__ == "__main__":
    merge_chapters()
