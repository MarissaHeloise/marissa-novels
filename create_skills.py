#!/usr/bin/env python3
import os
import re

def main():
    commands_dir = r".\.trae\commands"
    skills_dir = r".\.trae\skills"
    
    if not os.path.exists(commands_dir):
        print(f"Commands directory not found: {commands_dir}")
        return
    
    os.makedirs(skills_dir, exist_ok=True)
    
    command_files = [f for f in os.listdir(commands_dir) if f.endswith('.md')]
    
    print(f"Found {len(command_files)} command files")
    
    for cmd_file in command_files:
        process_command_file(commands_dir, skills_dir, cmd_file)
    
    print("\n✅ All skills created successfully!")

def process_command_file(commands_dir, skills_dir, cmd_file):
    cmd_path = os.path.join(commands_dir, cmd_file)
    
    skill_name = os.path.splitext(cmd_file)[0]
    skill_name = skill_name.replace('.', '-')
    
    skill_dir = os.path.join(skills_dir, skill_name)
    os.makedirs(skill_dir, exist_ok=True)
    
    skill_file = os.path.join(skill_dir, "SKILL.md")
    
    with open(cmd_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    description = extract_description(content, cmd_file)
    
    skill_content = f'''---
name: "{skill_name}"
description: "{description}"
---

# {skill_name.replace('-', ' ').title()}

{content}
'''
    
    with open(skill_file, 'w', encoding='utf-8') as f:
        f.write(skill_content)
    
    print(f"Created skill: {skill_name}")

def extract_description(content, cmd_file):
    lines = content.split('\n')
    first_paragraph = ''
    
    for i, line in enumerate(lines):
        line = line.strip()
        if line and not line.startswith('##') and not line.startswith('```') and not line.startswith('#'):
            first_paragraph = line
            break
    
    if not first_paragraph:
        first_paragraph = cmd_file.replace('.md', '').replace('.', ' ')
    
    if len(first_paragraph) > 150:
        first_paragraph = first_paragraph[:147] + '...'
    
    description = f"{first_paragraph} Invoke when user wants to use {cmd_file.replace('.md', '')} command."
    
    return description.replace('"', "'")

if __name__ == "__main__":
    main()
