#!/bin/bash
# Guardrail: 拦截危险 Shell 命令
# event: beforeShellExecution
# 参数 $1 = 即将执行的命令字符串

CMD="$1"

# 危险命令黑名单
DANGEROUS_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf ."
  "format"
  "dd if="
  "> /dev/"
  "chmod -R 777 /"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$CMD" | grep -q "$pattern"; then
    echo "[GUARD] 危险命令被拦截: $CMD"
    echo "[GUARD] 请人工确认后手动执行"
    exit 1  # exit 1 = 阻止执行
  fi
done

exit 0  # exit 0 = 允许执行
