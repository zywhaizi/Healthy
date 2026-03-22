#!/bin/bash
# Quality Gate: Agent 完成任务前的质量检查
# event: stop

echo "[QG] 开始质量门禁检查..."

# 1. 检查是否有语法错误（ObjC 头文件基础检查）
HEADER_ERRORS=0
find . -name "*.h" | while read f; do
  if ! grep -q "NS_ASSUME_NONNULL_BEGIN" "$f" 2>/dev/null; then
    echo "[QG] ⚠️  缺少 NS_ASSUME_NONNULL_BEGIN: $f"
    HEADER_ERRORS=$((HEADER_ERRORS+1))
  fi
done

# 2. 检查是否有 TODO/FIXME 遗留
TODO_COUNT=$(grep -r "TODO\|FIXME\|HACK" --include="*.m" --include="*.h" . 2>/dev/null | wc -l | tr -d ' ')
if [ "$TODO_COUNT" -gt "0" ]; then
  echo "[QG] ⚠️  发现 $TODO_COUNT 处 TODO/FIXME，请确认是否需要处理"
fi

# 3. 检查禁止模式
if grep -r "performSelector" --include="*.m" . 2>/dev/null | grep -v "//"; then
  echo "[QG] ❌ 检测到禁止使用的 performSelector，请替换"
  exit 1
fi

echo "[QG] ✅ 质量检查通过"
exit 0
