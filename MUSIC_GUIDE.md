# 冥想音乐配置指南

## 功能说明

应用已集成冥想音乐功能，支持：
- ✅ 7种背景音乐选项（包括关闭）
- ✅ 用户自由选择和切换
- ✅ 音量调节（0-100%）
- ✅ 播放/暂停控制
- ✅ 循环播放
- ✅ 自动保存用户偏好

---

## 音乐类型

| 音乐类型 | 文件名 | 说明 |
|---------|--------|------|
| 关闭 | - | 仅使用震动引导 |
| 森林鸟鸣 | forest.wav | 自然森林环境音 |
| 海浪轻拍 | ocean.wav | 海边海浪声 |
| 细雨轻声 | rain.wav | 温和雨声 |
| 微风拂面 | wind.wav | 自然风声 |
| 冥想铃声 | bells.wav | 传统冥想铃声 |
| 氛围音乐 | ambient.wav | 舒缓氛围音乐 |

---

## 如何添加音乐文件

### 步骤1：准备音乐文件

1. 准备以下音频文件（当前项目默认使用 WAV 格式）：
   - `forest.wav` (森林鸟鸣)
   - `ocean.wav` (海浪声)
   - `rain.wav` (雨声)
   - `wind.wav` (风声)
   - `bells.wav` (铃声)
   - `ambient.wav` (氛围音乐)

2. 文件要求：
   - 格式：优先 WAV
   - 长度：建议 2-5 分钟（会循环播放）
   - 音质：中等质量即可（控制文件大小）
   - 文件大小：每个文件建议 < 2MB

### 步骤2：获取音乐资源

**免费音乐资源网站**（可商用）：

1. **Freesound** - https://freesound.org
   - 搜索关键词：`forest`, `ocean`, `rain`, `wind`
   - 注意查看许可证（选择 CC0 或 CC-BY）

2. **Free Music Archive** - https://freemusicarchive.org
   - 搜索：`ambient`, `meditation`, `nature`
   - 选择可商用的音乐

3. **Mixkit** - https://mixkit.co/free-stock-music/
   - 提供免费可商用的环境音乐

4. **YouTube Audio Library** - https://studio.youtube.com/channel/UC...
   - 需要YouTube账号
   - 大量免费音乐素材

**推荐音乐示例**：
- 森林：鸟鸣声、森林环境音
- 海浪：温和的海浪声（不要太激烈）
- 雨声：细雨、小雨声
- 风声：自然微风声
- 铃声：西藏铃声、冥想钵声
- 氛围：低频舒缓音乐、冥想背景音乐

### 步骤3：导入到Xcode项目

1. 在Xcode中，打开项目导航器
2. 找到 `BreathingApp` → `Resources` 文件夹
3. 右键点击 → `Add Files to "BreathingApp"...`
4. 选择所有音乐文件
5. 确保勾选：
   - ✅ `Copy items if needed`
   - ✅ `Create groups`
   - ✅ `BreathingApp` target

### 步骤4：验证文件导入

在代码中，音乐文件通过以下方式加载：

```swift
Bundle.main.url(forResource: "forest.wav", withExtension: nil, subdirectory: "Music")
```

确保文件已正确导入：
1. Build 项目 (⌘B)
2. 在模拟器或真机运行
3. 点击主界面的音乐按钮
4. 选择一个音乐选项测试

---

## 临时测试方案

如果暂时没有音乐文件，可以使用以下方法：

### 方案1：使用系统声音（简单）

修改 `MusicManager.swift`，添加系统声音测试：

```swift
// 在 play() 方法中添加
import AudioToolbox

// 使用系统声音测试
func playSystemSound() {
    AudioServicesPlaySystemSound(1057) // 系统提示音
}
```

### 方案2：生成简单的音频（高级）

使用 `AVAudioEngine` 生成简单的音调：

```swift
import AVFoundation

class SimpleAudioGenerator {
    let engine = AVAudioEngine()
    let player = AVAudioPlayerNode()
    
    func startTone(frequency: Float) {
        let format = engine.outputNode.outputFormat(forBus: 0)
        engine.attach(player)
        engine.connect(player, to: engine.outputNode, format: format)
        
        player.play()
        engine.start()
    }
}
```

---

## 用户界面位置

### 主界面

顶部显示当前音乐选择：
```
便携微冥想
1分钟极速焦虑疏导
[🎵 森林鸟鸣 >]  ← 点击进入音乐选择
```

### 音乐选择界面

点击音乐按钮后显示：
```
冥想音乐
选择背景音乐，提升冥想体验

[✓] 关闭          仅使用震动引导
[○] 森林鸟鸣      舒缓背景音
[○] 海浪轻拍      舒缓背景音
[○] 细雨轻声      舒缓背景音
[○] 微风拂面      舒缓背景音
[○] 冥想铃声      舒缓背景音
[○] 氛围音乐      舒缓背景音

音量调节：[slider] 50%

提示：音乐将在呼吸练习时循环播放
```

### 练习界面

如果音乐开启，显示播放控制：
```
[X 关闭]  [暂停]  [1/4循环]
```

---

## 数据持久化

用户选择会自动保存：
- 音乐类型：`UserDefaults` key: `selectedMusic`
- 音量大小：`UserDefaults` key: `musicVolume`

下次打开应用时自动恢复上次设置。

---

## 注意事项

### 1. 文件大小控制

- 所有音乐文件总大小建议 < 10MB
- 使用中等音质（128-192kbps）
- 考虑用户下载体验

### 2. 音频版权

- 使用免费可商用的音乐
- 检查许可证类型：
  - CC0：完全免费
  - CC-BY：需署名
  - CC-BY-NC：不可商用

### 3. 性能优化

- 使用 `prepareToPlay()` 预加载
- 及时释放音频资源
- 不要同时播放多个音频

### 4. 音频会话配置

代码已配置：
```swift
AVAudioSession.sharedInstance().setCategory(.playback)
```

这确保：
- 与其他音乐应用共存
- 后台播放支持
- 铃声不打断播放

---

## 完整配置流程

1. ✅ 代码已完成（MusicManager + MusicSelectionView）
2. ✅ 已内置 6 个 WAV 音频文件
3. ✅ 已加入 Xcode 资源打包
4. ⏳ 测试播放功能
5. ⏳ 真机测试（确保音频播放正常）

---

## 快速开始

如果想快速测试功能，可以先：

1. 直接运行项目
2. 在音乐选择页选择任一音频
3. 开始一次呼吸练习验证循环播放
4. 如需替换，再放入同名 WAV 文件

音乐功能代码与内置音频已就绪，可直接使用。