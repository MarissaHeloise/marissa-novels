import re

file_path = r'd:\novels\百合小说\.novelkit\memory\constitution.md'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace the psychological description section
old_text = """#### 心理活动标点

- **人物说话用双引号""；人物内心戏用「」。** 对话（说出来的话）一律用 **""**；心理活动、内心判断、内心打算一律用 **「」**（直角引号），以便读者一眼区分。
- **强调与设定用语用""**：系统名、镜面/面板显示文字、叙述中引用的设定或表面说法（如"灵衍""天命未启、机缘未至""病体初愈"等）一律用**双引号""**。"""

new_text = """#### 心理活动标点

- **人物说话用双引号""**。心理描写可直接融入叙述，无需特殊标点标记。
- **强调与设定用语用""**：系统名、镜面/面板显示文字、叙述中引用的设定或表面说法（如"灵衍""天命未启、机缘未至""病体初愈"等）一律用**双引号""**。"""

content = content.replace(old_text, new_text)

# Also update the version history
content = content.replace(
    '| 3.11 | 2026-03-02 | §3 风格基调新增**标点强制规范（严禁违反）**：人物对话一律用双引号""、内心独白用「」，不得混用。据此修订第四章《炼体与药浴》中误用「」的对话与引用为""。 | - |',
    '| 3.12 | 2026-03-25 | 修订标点规范：取消心理描写必须用「」的规定，心理描写可直接融入叙述，无需特殊标点标记。§3、§8.4、§8.14同步更新。 | - |'
)

# Update version number
content = content.replace('**版本**: 3.11', '**版本**: 3.12')
content = content.replace('**最后更新**: 2026-03-02', '**最后更新**: 2026-03-25')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('Done')
