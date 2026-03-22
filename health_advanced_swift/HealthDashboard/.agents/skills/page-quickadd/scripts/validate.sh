#!/bin/bash
# QuickAdd 数据校验脚本
# 用法：./validate.sh <type> <value>
# type: water | steps | mood
# 退出码：0=通过，1=失败

TYPE="$1"
VALUE="$2"

if ! [[ "$VALUE" =~ ^[0-9]+$ ]]; then
  echo "[VALIDATE] 错误：输入值必须为正整数"
  exit 1
fi

case "$TYPE" in
  water)
    if [ "$VALUE" -lt 100 ] || [ "$VALUE" -gt 2000 ]; then
      echo "[VALIDATE] 喝水量必须在 100~2000 ml 之间"
      exit 1
    fi
    ;;
  steps)
    if [ "$VALUE" -lt 1 ] || [ "$VALUE" -gt 50000 ]; then
      echo "[VALIDATE] 步数必须在 1~50000 之间"
      exit 1
    fi
    ;;
  mood)
    if [ "$VALUE" -lt 1 ] || [ "$VALUE" -gt 5 ]; then
      echo "[VALIDATE] 心情等级必须在 1~5 之间"
      exit 1
    fi
    ;;
  *)
    echo "[VALIDATE] 未知类型：$TYPE（支持 water/steps/mood）"
    exit 1
    ;;
esac

echo "[VALIDATE] ✅ 校验通过：$TYPE=$VALUE"
exit 0
