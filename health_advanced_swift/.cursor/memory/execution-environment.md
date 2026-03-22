---
name: execution-environment
type: long-term
description: HealthDashboard 项目的执行环境约束和工具调用规范
last-updated: 2026/3/21
---

# 执行环境与工具调用规范

## 执行环境约束

### 代码执行环境

```
开发环境
├─ 操作系统：macOS 10.15+
├─ Xcode：13.0+
├─ iOS 最低版本：12.0
├─ Swift 版本：不使用（纯 ObjC）
└─ 编译器：Clang

运行时环境
├─ 主线程：UI 操作必须在主线程
├─ 后台线程：耗时操作必须在后台线程
├─ 内存：无特殊限制（iOS 12+ 足够）
└─ 存储：使用 UserDefaults（无数据库）
```

### 代码执行的限制

```
禁止事项（硬限制）
├─ 禁止在主线程做耗时操作（> 100ms）
├─ 禁止使用第三方库（除非明确确认）
├─ 禁止修改 Info.plist 关键字段
├─ 禁止使用 performSelector
├─ 禁止硬编码字符串和颜色值
└─ 禁止删除现有的 applyTheme 实现

允许事项（软限制）
├─ 允许使用 UIKit 原生 API
├─ 允许使用 Foundation 框架
├─ 允许使用 GCD（dispatch_async 等）
├─ 允许使用 NSNotification
└─ 允许使用 UserDefaults
```

### 代码执行的保护措施

```
自动保护
├─ Hooks 脚本自动检查危险命令
├─ Hooks 脚本自动屏蔽敏感文件
├─ Hooks 脚本自动格式化代码
├─ Hooks 脚本自动检查质量门禁
└─ Rules 自动注入约束

手动保护
├─ Code Review 检查必检项
├─ Quality Gate 检查质量指标
├─ Guardrails 拦截危险操作
└─ Human-in-the-Loop 确认重大决策
```

---

## 工具调用规范

### 可用工具清单

```
工具 1: guard.sh（危险命令拦截）
├─ 用途：拦截危险的 Shell 命令
├─ 触发时机：执行 Shell 命令前
├─ 拦截的命令：rm -rf, rm *, dd, mkfs 等
├─ 优先级：最高（第一道防线）
└─ 调用方式：自动（无需手动调用）

工具 2: block-sensitive.sh（敏感文件屏蔽）
├─ 用途：屏蔽敏感文件的读取
├─ 触发时机：读取文件前
├─ 屏蔽的文件：.env, *.p12, *.mobileprovision 等
├─ 优先级：高（第二道防线）
└─ 调用方式：自动（无需手动调用）

工具 3: format.sh（代码自动格式化）
├─ 用途：自动格式化 ObjC 代码
├─ 触发时机：编辑 .m/.h 文件后
├─ 格式化工具：clang-format
├─ 优先级：中（改进代码质量）
└─ 调用方式：自动（无需手动调用）

工具 4: quality-gate.sh（质量检查）
├─ 用途：检查代码是否符合质量标准
├─ 触发时机：提交代码时（Git Hook pre-commit）
├─ 检查项：NS_ASSUME_NONNULL、performSelector 等
├─ 优先级：中（保证质量）
└─ 调用方式：自动（Git Hook，失败则阻止提交）
```

### 工具调用流程

```
代码编辑
    ↓
format.sh 自动运行
（编辑后自动格式化）
    ↓
提交 PR
    ↓
quality-gate.sh 自动运行（Git Hook）
（质量检查，失败则阻止提交）
    ↓
guard.sh 自动检查
（危险命令拦截）
    ↓
block-sensitive.sh 自动检查
（敏感文件屏蔽）
    ↓
Code Review
    ↓
合并到 main
```

### 工具的依赖关系

```
format.sh（低优先级）
    ↓ 自动运行
quality-gate.sh（中优先级）
    ↓ 必须通过（Git Hook）
guard.sh（最高优先级）
    ↓ 必须通过
block-sensitive.sh（高优先级）
    ↓ 必须通过
Code Review（高优先级）
    ↓ 必须通过
合并
```

### 工具的调用顺序

**开发阶段**：
1. 编辑代码
2. format.sh 自动运行（格式化）
3. 本地测试

**提交阶段**：
1. `git commit` 提交代码
2. quality-gate.sh 自动运行（Git Hook pre-commit）
   - 如果检查失败，阻止提交
   - 如果检查通过，继续提交
3. guard.sh 自动检查（危险命令）
4. block-sensitive.sh 自动检查（敏感文件）

**审查阶段**：
1. Code Review（人工审查）
2. 修改反馈
3. 重新提交（quality-gate.sh 再次自动运行）
4. 合并

**Git Hook 配置**：
```bash
# 创建 .git/hooks/pre-commit
#!/bin/bash
.cursor/hooks/quality-gate.sh
if [ $? -ne 0 ]; then
    echo "❌ 质量检查失败，无法提交"
    exit 1
fi
```

---

## 执行环境的约束详解

### 主线程约束

```
❌ 禁止在主线程做的操作
├─ 网络请求（> 100ms）
├─ 文件 I/O（> 100ms）
├─ 数据库查询（> 100ms）
├─ 复杂计算（> 100ms）
└─ 循环操作（> 100ms）

✅ 允许在主线程做的操作
├─ UI 更新（必须在主线程）
├─ 事件处理（必须在主线程）
├─ 简单计算（< 100ms）
├─ 数据读取（< 100ms）
└─ 方法调用（< 100ms）

正确做法
dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
    // 耗时操作
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI 更新
        self.label.text = @"完成";
    });
});
```

### 内存管理约束

```
❌ 禁止的做法
├─ 循环引用（delegate 不用 weak）
├─ 过度释放（多次 release）
├─ 野指针（使用已释放的对象）
└─ 内存泄漏（持有不释放）

✅ 正确做法
├─ delegate 用 weak
├─ block 内 self 用 weak
├─ 及时释放大对象
└─ 使用 @autoreleasepool 管理内存

检查工具
├─ Xcode Memory Debugger
├─ Instruments（Leaks）
└─ quality-gate.sh（自动检查）
```

### 文件操作约束

```
允许的操作
├─ 读取 Bundle 中的文件
├─ 读写 Documents 目录
├─ 读写 Caches 目录
├─ 使用 UserDefaults
└─ 使用 Keychain（敏感数据）

禁止的操作
├─ 读取 .env 文件
├─ 读取证书文件（.p12）
├─ 读取 provisioning profile
├─ 修改 Info.plist
└─ 删除系统文件

正确做法
// ✅ 读取 Bundle 文件
NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
NSData *data = [NSData dataWithContentsOfFile:path];

// ✅ 写入 Documents
NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
NSString *filePath = [docPath stringByAppendingPathComponent:@"data.json"];
[data writeToFile:filePath atomically:YES];

// ✅ 使用 UserDefaults
[[NSUserDefaults standardUserDefaults] setObject:@"value" forKey:@"key"];
```

---

## 执行环境的监控

### 自动监控

```
Hooks 脚本自动监控
├─ guard.sh：监控危险命令
├─ block-sensitive.sh：监控敏感文件
├─ format.sh：监控代码格式
└─ quality-gate.sh：监控代码质量
```

### 手动监控

```
Code Review 手动监控
├─ 检查主线程操作
├─ 检查内存管理
├─ 检查文件操作
├─ 检查 API 使用
└─ 检查性能问题
```

### 问题上报

```
发现问题时
1. 在 feedback.md 中记录
2. 分析根本原因
3. 提交修复 PR
4. 更新 known-issues.md
5. 改进 Hooks 或 Rules
```

---

## 常见问题

### Q: 代码在哪个线程执行？
A: 
- UI 操作必须在主线程
- 耗时操作必须在后台线程
- 使用 dispatch_async 切换线程

### Q: 如何检查代码是否符合环境约束？
A:
1. 提交代码时 quality-gate.sh 自动运行
2. 如果检查失败，修改代码后重新提交
3. 进行 Code Review
4. 使用 Xcode Memory Debugger 检查内存

### Q: quality-gate.sh 检查失败怎么办？
A:
1. 查看错误信息
2. 根据错误修改代码
3. 重新提交（quality-gate.sh 再次自动运行）
4. 如果仍然失败，查看 known-issues.md 或 feedback.md

### Q: 如何处理敏感文件？
A:
- 不要读取 .env 文件
- 不要读取证书文件
- 使用 Keychain 存储敏感数据

### Q: 如何避免主线程阻塞？
A:
```objc
// ❌ 错误：主线程阻塞
NSData *data = [NSData dataWithContentsOfURL:url];

// ✅ 正确：后台线程
dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
    NSData *data = [NSData dataWithContentsOfURL:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新 UI
    });
});
```

### Q: 如何配置 Git Hook？
A:
```bash
# 创建 .git/hooks/pre-commit 文件
mkdir -p .git/hooks
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
.cursor/hooks/quality-gate.sh
if [ $? -ne 0 ]; then
    echo "❌ 质量检查失败，无法提交"
    exit 1
fi
EOF

# 添加执行权限
chmod +x .git/hooks/pre-commit
```

---

## 总结

**执行环境约束**：
- 主线程用于 UI 操作
- 后台线程用于耗时操作
- 内存管理要谨慎
- 文件操作有限制

**工具调用规范**：
- 4 个 Hooks 脚本自动保护
- 按顺序调用，依赖关系清晰
- 提交前必须通过 quality-gate.sh
- Code Review 是最后一道防线
