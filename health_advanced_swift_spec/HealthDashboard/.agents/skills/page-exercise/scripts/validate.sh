#!/bin/bash
# Exercise 模块质量门禁检查脚本
# 用法: ./validate-exercise.sh

set -e

EXERCISE_DIR="HealthDashboard/Controllers"
ERRORS=0

echo "🔍 Exercise 模块质量门禁检查..."
echo ""

# 检查 1: 所有 Exercise VC 是否有 applyTheme 方法
echo "✓ 检查 1: applyTheme 方法实现"
for file in $EXERCISE_DIR/HDExercise*.m; do
    if [ -f "$file" ]; then
        if ! grep -q "- (void)applyTheme" "$file"; then
            echo "  ❌ $file 缺少 applyTheme 方法"
            ((ERRORS++))
        else
            echo "  ✅ $(basename $file)"
        fi
    fi
done
echo ""

# 检查 2: 是否有硬编码颜色值
echo "✓ 检查 2: 硬编码颜色值"
for file in $EXERCISE_DIR/HDExercise*.m; do
    if [ -f "$file" ]; then
        if grep -q "colorWithRed:" "$file" || grep -q "0x[0-9A-Fa-f]" "$file"; then
            echo "  ⚠️  $(basename $file) 可能有硬编码颜色"
        else
            echo "  ✅ $(basename $file)"
        fi
    fi
done
echo ""

# 检查 3: 是否直接修改 Model 数据
echo "✓ 检查 3: 直接修改 Model 数据"
for file in $EXERCISE_DIR/HDExercise*.m; do
    if [ -f "$file" ]; then
        if grep -q "\.exerciseMinutes\s*=" "$file" || grep -q "\.exerciseRecords\s*=" "$file"; then
            echo "  ❌ $(basename $file) 直接修改了 Model 数据"
            ((ERRORS++))
        else
            echo "  ✅ $(basename $file)"
        fi
    fi
done
echo ""

# 检查 4: 是否使用了 performSelector
echo "✓ 检查 4: performSelector 使用"
for file in $EXERCISE_DIR/HDExercise*.m; do
    if [ -f "$file" ]; then
        if grep -q "performSelector" "$file"; then
            echo "  ❌ $(basename $file) 使用了 performSelector"
            ((ERRORS++))
        else
            echo "  ✅ $(basename $file)"
        fi
    fi
done
echo ""

# 检查 5: Delegate 是否声明为 weak
echo "✓ 检查 5: Delegate weak 声明"
for file in $EXERCISE_DIR/HDExercise*.h; do
    if [ -f "$file" ]; then
        if grep -q "delegate" "$file"; then
            if grep -q "weak.*delegate" "$file"; then
                echo "  ✅ $(basename $file)"
            else
                echo "  ⚠️  $(basename $file) delegate 可能未声明为 weak"
            fi
        fi
    fi
done
echo ""

# 检查 6: 是否有 NS_ASSUME_NONNULL
echo "✓ 检查 6: NS_ASSUME_NONNULL 包裹"
for file in $EXERCISE_DIR/HDExercise*.h; do
    if [ -f "$file" ]; then
        if grep -q "NS_ASSUME_NONNULL_BEGIN" "$file"; then
            echo "  ✅ $(basename $file)"
        else
            echo "  ⚠️  $(basename $file) 缺少 NS_ASSUME_NONNULL_BEGIN"
        fi
    fi
done
echo ""

# 总结
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ]; then
    echo "✅ 所有检查通过！"
    exit 0
else
    echo "❌ 发现 $ERRORS 个错误，请修复后重试"
    exit 1
fi
