#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
From https://github.com/QSCTech/zju-icicles
"""

import os
import shutil
from urllib.parse import quote

EXCLUDE_DIRS = ['.git', 'docs', '.vscode', '.circleci', 'site', '.github', 'assets']
README_MD = ['README.md', 'readme.md', 'index.md']

TXT_EXTS = ['md', 'txt']
TXT_URL_PREFIX = '/'
BIN_URL_PREFIX = '/'


def list_files(course: str):
    filelist_texts = '## 文件列表 {.file_list}\n\n'
    filelist_texts += '??? 点击展开文件列表\n'
    readme_path = ''
    for root, dirs, files in os.walk(course):
        files.sort()
        level = root.replace(course, '').count(os.sep) + 1
        indent = ' ' * 4 * level
        filelist_texts += '{}- {}\n'.format(indent, os.path.basename(root))
        subindent = ' ' * 4 * (level + 1)
        for f in files:
            if f not in README_MD:
                # open in new tab
                if f.split('.')[-1] in TXT_EXTS:
                    filelist_texts += '{}- <a href="{}" target="_blank">{}</a>\n'.format(subindent,
                                                                                         TXT_URL_PREFIX + quote('{}/{}'.format(root, f)), f)
                else:
                    filelist_texts += '{}- <a href="{}" target="_blank">{}</a>\n'.format(subindent,
                                                                                         BIN_URL_PREFIX + quote('{}/{}'.format(root, f)), f)
            elif root == course and readme_path == '':
                readme_path = '{}/{}'.format(root, f)
    return filelist_texts, readme_path

def move_files(course: str):
    # if not in github action, return
    if not os.environ.get('GITHUB_ACTIONS'):
        return
    for root, dirs, files in os.walk(course):
        files.sort()
        for f in files:
            if not f in README_MD:
                if not os.path.isdir(os.path.join('site', root)):
                    os.makedirs(os.path.join('site', root))
                # shutil.copyfile(os.path.join(root, f), os.path.join('site', root, f))
                # move instead of copy
                shutil.move(os.path.join(root, f), os.path.join('site', root, f))


def generate_md(course: str, filelist_texts: str, readme_path: str):
    final_texts = ['\n\n', filelist_texts]
    if readme_path:
        with open(readme_path, 'r') as file:
            final_texts = file.readlines() + final_texts
    with open('docs/{}.md'.format(course), 'w') as file:
        file.writelines(final_texts)


if __name__ == '__main__':
    if not os.path.isdir('docs'):
        os.mkdir('docs')

    courses = list(filter(lambda x: os.path.isdir(x) and (
        x not in EXCLUDE_DIRS), os.listdir('.')))  # list courses

    for course in courses:
        filelist_texts, readme_path = list_files(course)
        generate_md(course, filelist_texts, readme_path)

    with open('README.md', 'r') as file:
        mainreadme_lines = file.readlines()

    with open('docs/index.md', 'w') as file:
        file.writelines(mainreadme_lines)

    shutil.copytree('assets', 'docs/assets', dirs_exist_ok=True)

    os.system('mkdocs build')

    for course in courses:
        move_files(course)
