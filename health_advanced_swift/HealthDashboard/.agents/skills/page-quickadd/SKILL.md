---
name: page-quickadd
description: 快速录入页面（HDQuickAddViewController）业务逻辑、Delegate 回调、表单校验 SOP。
---

# page-quickadd · 快速录入知识库

## 完整录入 SOP

```
1. 用户选择类型（水/步数/心情）
2. 用户输入数值
3. 表单校验
4. 调用 Model 写入
5. 调用 Delegate 回调
6. dismiss VC
```

## 标准实现

```objc
- (IBAction)didTapConfirm:(id)sender {
    NSInteger value = [self.inputField.text integerValue];
    if (![self validateInput:value]) { [self showValidationError]; return; }

    switch (self.selectedType) {
        case HDRecordTypeWater:
            [[HDHealthDataModel shared] addWater:(CGFloat)value]; break;
        case HDRecordTypeSteps:
            [[HDHealthDataModel shared] addSteps:value]; break;
        case HDRecordTypeMood:
            [[HDHealthDataModel shared] addMood:value]; break;
    }

    // 必须在 dismiss 前调用
    if ([self.delegate respondsToSelector:@selector(quickAddDidUpdateData)]) {
        [self.delegate quickAddDidUpdateData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validateInput:(NSInteger)value {
    switch (self.selectedType) {
        case HDRecordTypeWater: return value >= 100 && value <= 2000;
        case HDRecordTypeSteps: return value >= 1   && value <= 50000;
        case HDRecordTypeMood:  return value >= 1   && value <= 5;
        default: return NO;
    }
}
```

## 校验规则

| 类型 | 最小值 | 最大值 | 单位 |
|---|---|---|---|
| 喝水 | 100 | 2000 | ml |
| 步数 | 1 | 50000 | 步 |
| 心情 | 1 | 5 | 级 |

## 心情 emoji

通过 `HDMoodRecord.emojiString` 获取，禁止硬编码：
`1=😞 2=😕 3=😐 4=🙂 5=😄`

## 常见问题

- **Delegate 无效**：检查 delegate 是否为 `weak`，是否在 TabBar 中正确设置
- **dismiss 过早**：确保 delegate 回调在 dismiss **之前**调用
- **数值为0**：检查 inputField 是否为数字键盘类型
