#!/bin/bash
# Quality: 编辑 ObjC 文件后自动格式化
# event: afterFileEdit
# 参数 $1 = 被编辑的文件路径

FILE="$1"

# 只处理 ObjC 文件
if [[ "$FILE" == *.m ]] || [[ "$FILE" == *.h ]]; then
  # 如果安装了 clang-format
  if command -v clang-format &&>/dev/null; then
    clang-format -i -style="{BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 120}" "$FILE"
    echo "[FORMAT] 已格式化: $FILE"
  else
    echo "[FORMAT] clang-format 未安装，跳过格式化"
  fi
fi

exit 0
