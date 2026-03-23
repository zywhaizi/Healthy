#!/bin/bash
# Guardrail: 屏蔽敏感文件读取
# event: beforeReadFile
# 参数 $1 = 即将读取的文件路径

FILE="$1"

# 敏感文件模式
SENSITIVE_PATTERNS=(
  "\.env"
  "secrets/"
  "\.p12"
  "\.mobileprovision"
  "Certificates"
  "private_key"
  "api_key"
)

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  if echo "$FILE" | grep -q "$pattern"; then
    echo "[GUARD] 敏感文件访问被阻止: $FILE"
    exit 1
  fi
done

exit 0
