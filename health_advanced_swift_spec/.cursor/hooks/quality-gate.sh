#!/bin/bash
# Quality Gate: Agent 完成任务前的质量检查
# event: stop

set -e

echo "[QG] 开始 Swift 质量门禁检查..."

# 0. 确保在仓库根目录执行
ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT_DIR"

# 1. 检查 TODO/FIXME/HACK（Swift + ObjC）
TODO_COUNT=$(rg -n "TODO|FIXME|HACK" HealthDashboard --glob "*.swift" --glob "*.m" --glob "*.h" 2>/dev/null | wc -l | tr -d ' ')
if [ "$TODO_COUNT" -gt "0" ]; then
  echo "[QG] ⚠️  发现 $TODO_COUNT 处 TODO/FIXME/HACK，请确认是否需要处理"
fi

# 2. 检查禁止模式：performSelector
if rg -n "performSelector" HealthDashboard --glob "*.swift" --glob "*.m" --glob "*.h" 2>/dev/null > /tmp/qg_performselector.txt; then
  echo "[QG] ❌ 检测到禁止使用的 performSelector:"
  cat /tmp/qg_performselector.txt
  rm -f /tmp/qg_performselector.txt
  exit 1
fi

# 3. 检查第三方库引入（项目规则禁止）
if rg -n "^import\s+(Alamofire|RxSwift|SnapKit|SDWebImage|Kingfisher|Moya)" HealthDashboard --glob "*.swift" 2>/dev/null > /tmp/qg_thirdparty.txt; then
  echo "[QG] ❌ 检测到未授权第三方库引入:"
  cat /tmp/qg_thirdparty.txt
  rm -f /tmp/qg_thirdparty.txt
  exit 1
fi

# 4. 检查 Combine 闭包强引用 self（硬规则）
if rg -n "sink\s*\{\s*\[self\]" HealthDashboard --glob "*.swift" 2>/dev/null > /tmp/qg_strongself.txt; then
  echo "[QG] ❌ 检测到 Combine 订阅中强引用 self（应使用 [weak self]）:"
  cat /tmp/qg_strongself.txt
  rm -f /tmp/qg_strongself.txt
  exit 1
fi

# 5. 检查 ViewController 是否实现 applyTheme（硬规则）
VC_FILES=$(rg --files HealthDashboard/Controllers --glob "*ViewController.swift" 2>/dev/null || true)
MISSING_THEME=0

for file in $VC_FILES; do
  if ! rg -n "func\s+applyTheme\s*\(" "$file" > /dev/null 2>&1; then
    echo "[QG] ❌ 缺少 applyTheme() 实现: $file"
    MISSING_THEME=1
  fi
done

if [ "$MISSING_THEME" -eq "1" ]; then
  exit 1
fi

# 6. 检查明显硬编码 RGB 颜色（warning，不阻断）
COLOR_COUNT=$(rg -n "UIColor\s*\(\s*red\s*:|\.init\(\s*red\s*:" HealthDashboard --glob "*.swift" 2>/dev/null | wc -l | tr -d ' ')
if [ "$COLOR_COUNT" -gt "0" ]; then
  echo "[QG] ⚠️  检测到 $COLOR_COUNT 处硬编码 RGB 颜色，建议替换为语义色"
fi

echo "[QG] ✅ Swift 质量门禁检查通过"
exit 0
