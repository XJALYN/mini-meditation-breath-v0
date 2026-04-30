import Foundation

enum AppLanguage {
    case simplifiedChinese
    case english
    
    static var current: AppLanguage {
        let preferred = Locale.preferredLanguages.first?.lowercased() ?? "en"
        return preferred.hasPrefix("zh") ? .simplifiedChinese : .english
    }
}

enum L10n {
    static var appName: String {
        localized(zh: "便携微冥想", en: "Pocket Micro Meditation")
    }
    
    static var tagline: String {
        localized(zh: "1分钟极速焦虑疏导", en: "One-minute calm reset")
    }
    
    static var done: String {
        localized(zh: "完成", en: "Done")
    }
    
    static var close: String {
        localized(zh: "返回", en: "Back")
    }
    
    static var startPractice: String {
        localized(zh: "开始练习", en: "Start")
    }
    
    static var practiceCompleteTitle: String {
        localized(zh: "练习完成", en: "Session Complete")
    }
    
    static var oneMoreRound: String {
        localized(zh: "再来一次", en: "Again")
    }
    
    static var prepare: String {
        localized(zh: "准备", en: "Ready")
    }
    
    static var musicTitle: String {
        localized(zh: "冥想音乐", en: "Meditation Audio")
    }
    
    static var musicSubtitle: String {
        localized(zh: "选择背景音乐，提升冥想体验", en: "Choose background audio for your session")
    }
    
    static var volumeControl: String {
        localized(zh: "音量调节", en: "Volume")
    }
    
    static var hint: String {
        localized(zh: "提示", en: "Tip")
    }
    
    static var loopingHint: String {
        localized(zh: "音乐将在呼吸练习时循环播放", en: "Audio loops during the breathing session")
    }
    
    static var relaxingBackground: String {
        localized(zh: "舒缓背景音", en: "Relaxing background audio")
    }
    
    static var hapticOnly: String {
        localized(zh: "仅使用震动引导", en: "Haptics only")
    }
    
    static var unlockAllPatterns: String {
        localized(zh: "解锁全部呼吸模式", en: "Unlock all breathing modes")
    }
    
    static var oneTimePurchase: String {
        localized(zh: "一次购买，永久使用", en: "One-time purchase, lifetime access")
    }
    
    static func price(_ value: String) -> String {
        localized(zh: "仅需 \(value)", en: "Only \(value)")
    }
    
    static func cycles(_ count: Int) -> String {
        localized(zh: "\(count)个循环", en: "\(count) cycles")
    }
    
    static func phaseDuration(_ instruction: String, _ duration: Int) -> String {
        switch AppLanguage.current {
        case .simplifiedChinese:
            return "\(instruction)\(duration)秒"
        case .english:
            return "\(instruction) \(duration)s"
        }
    }
    
    static func seconds(_ value: Int) -> String {
        localized(zh: "\(value)秒", en: "\(value)s")
    }
    
    static func formattedDuration(totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        switch AppLanguage.current {
        case .simplifiedChinese:
            return minutes > 0 ? "\(minutes)分\(seconds)秒" : "\(seconds)秒"
        case .english:
            return minutes > 0 ? "\(minutes)m \(seconds)s" : "\(seconds)s"
        }
    }
    
    static func completionMessage(cycles: Int, duration: String) -> String {
        localized(
            zh: "太棒了！你完成了\(cycles)个循环，共\(duration)的呼吸练习",
            en: "Great job! You completed \(cycles) cycles for a total of \(duration)."
        )
    }
    
    static func localized(zh: String, en: String) -> String {
        switch AppLanguage.current {
        case .simplifiedChinese:
            return zh
        case .english:
            return en
        }
    }
}
