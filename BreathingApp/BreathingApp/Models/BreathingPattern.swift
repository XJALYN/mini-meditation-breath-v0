import Foundation

struct BreathingPattern: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let phases: [Phase]
    let cycles: Int
    let isPremium: Bool
    let benefits: String
    
    var totalDuration: Int {
        let phaseDuration = phases.reduce(0) { $0 + $1.duration }
        return phaseDuration * cycles
    }
    
    var formattedDuration: String {
        L10n.formattedDuration(totalSeconds: totalDuration)
    }
    
    var localizedName: String {
        switch id {
        case "4-7-8": return L10n.localized(zh: "4-7-8 呼吸法", en: "4-7-8 Breathing")
        case "box": return L10n.localized(zh: "箱式呼吸", en: "Box Breathing")
        case "calm": return L10n.localized(zh: "减压呼吸", en: "Calm Breathing")
        case "focus": return L10n.localized(zh: "专注力呼吸", en: "Focus Breathing")
        case "energy": return L10n.localized(zh: "活力呼吸", en: "Energy Breathing")
        case "sleep": return L10n.localized(zh: "助眠呼吸", en: "Sleep Breathing")
        case "resonance": return L10n.localized(zh: "共振呼吸", en: "Resonance Breathing")
        case "sigh": return L10n.localized(zh: "长叹舒缓", en: "Relaxing Sigh")
        case "antipanic": return L10n.localized(zh: "快速镇定", en: "Anti-Panic")
        case "deepunwind": return L10n.localized(zh: "深度释放", en: "Deep Unwind")
        default: return name
        }
    }
    
    var localizedDescription: String {
        switch id {
        case "4-7-8": return L10n.localized(zh: "经典的放松呼吸法，帮助快速入睡和缓解焦虑", en: "A classic calming pattern for sleep and anxiety relief")
        case "box": return L10n.localized(zh: "海豹突击队使用的压力管理呼吸法", en: "A stress-control breathing method used for focus and steadiness")
        case "calm": return L10n.localized(zh: "温和的呼吸节奏，适合日常放松", en: "A gentle rhythm for everyday relaxation")
        case "focus": return L10n.localized(zh: "快速提升专注力和警觉性", en: "Quickly boosts focus and alertness")
        case "energy": return L10n.localized(zh: "快速提升能量和活力", en: "Quickly lifts energy and vitality")
        case "sleep": return L10n.localized(zh: "深度放松，帮助入睡", en: "Deep relaxation to help you fall asleep")
        case "resonance": return L10n.localized(zh: "平衡神经系统，提升心率变异性", en: "Balances nervous system and improves HRV")
        case "sigh": return L10n.localized(zh: "模拟生理长叹，快速消解压力", en: "Mimics a physiological sigh to dissolve stress")
        case "antipanic": return L10n.localized(zh: "阻断恐慌发作，重建安全感", en: "Stops panic blocks and rebuilds a sense of safety")
        case "deepunwind": return L10n.localized(zh: "深长呼吸，彻底释放全天疲惫", en: "Long, deep breaths to release daily fatigue")
        default: return description
        }
    }
    
    var localizedBenefits: String {
        switch id {
        case "4-7-8": return L10n.localized(zh: "缓解焦虑、助眠、降低心率", en: "Reduces anxiety, supports sleep, and slows heart rate")
        case "box": return L10n.localized(zh: "提升专注力、缓解压力、稳定情绪", en: "Improves focus, relieves stress, and stabilizes mood")
        case "calm": return L10n.localized(zh: "放松身心、缓解紧张、平稳情绪", en: "Relaxes body and mind, eases tension, and steadies emotion")
        case "focus": return L10n.localized(zh: "提升专注、增强警觉、清醒头脑", en: "Sharpens focus, raises alertness, and clears the mind")
        case "energy": return L10n.localized(zh: "提升活力、快速清醒、补充能量", en: "Boosts vitality, wakes you up, and restores energy")
        case "sleep": return L10n.localized(zh: "快速入睡、深度放松、改善睡眠", en: "Helps you sleep faster, deeply relax, and rest better")
        case "resonance": return L10n.localized(zh: "心身和谐、提升专注、自主神经平衡", en: "Mind-body harmony, sharper focus, autonomic balance")
        case "sigh": return L10n.localized(zh: "重启神经、释放紧绷、平息焦躁", en: "Nervous system reset, releases tension, calms nerves")
        case "antipanic": return L10n.localized(zh: "迅速急救、重夺控制、停止换气过度", en: "First aid for panic, regain control, stop hyperventilation")
        case "deepunwind": return L10n.localized(zh: "深层解压、扩张肺部、拥抱宁静", en: "Deep unwinding, lung expansion, embrace peace")
        default: return benefits
        }
    }
}

struct Phase: Codable {
    let name: PhaseType
    let duration: Int
    
    var formattedDuration: String {
        L10n.seconds(duration)
    }
}

enum PhaseType: String, Codable {
    case inhale = "吸气"
    case hold = "屏息"
    case exhale = "呼气"
    case holdAfterExhale = "屏息后"
    
    var instruction: String {
        switch self {
        case .inhale: return L10n.localized(zh: "吸气", en: "Inhale")
        case .hold: return L10n.localized(zh: "屏息", en: "Hold")
        case .exhale: return L10n.localized(zh: "呼气", en: "Exhale")
        case .holdAfterExhale: return L10n.localized(zh: "屏息", en: "Hold")
        }
    }
}

extension BreathingPattern {
    static let patterns: [BreathingPattern] = [
        BreathingPattern(
            id: "4-7-8",
            name: "4-7-8 呼吸法",
            description: "经典的放松呼吸法，帮助快速入睡和缓解焦虑",
            phases: [
                Phase(name: .inhale, duration: 4),
                Phase(name: .hold, duration: 7),
                Phase(name: .exhale, duration: 8)
            ],
            cycles: 4,
            isPremium: false,
            benefits: "缓解焦虑、助眠、降低心率"
        ),
        BreathingPattern(
            id: "box",
            name: "箱式呼吸",
            description: "海豹突击队使用的压力管理呼吸法",
            phases: [
                Phase(name: .inhale, duration: 4),
                Phase(name: .hold, duration: 4),
                Phase(name: .exhale, duration: 4),
                Phase(name: .holdAfterExhale, duration: 4)
            ],
            cycles: 4,
            isPremium: false,
            benefits: "提升专注力、缓解压力、稳定情绪"
        ),
        BreathingPattern(
            id: "calm",
            name: "减压呼吸",
            description: "温和的呼吸节奏，适合日常放松",
            phases: [
                Phase(name: .inhale, duration: 4),
                Phase(name: .exhale, duration: 6)
            ],
            cycles: 6,
            isPremium: true,
            benefits: "放松身心、缓解紧张、平稳情绪"
        ),
        BreathingPattern(
            id: "focus",
            name: "专注力呼吸",
            description: "快速提升专注力和警觉性",
            phases: [
                Phase(name: .inhale, duration: 3),
                Phase(name: .hold, duration: 3),
                Phase(name: .exhale, duration: 3)
            ],
            cycles: 8,
            isPremium: true,
            benefits: "提升专注、增强警觉、清醒头脑"
        ),
        BreathingPattern(
            id: "energy",
            name: "活力呼吸",
            description: "快速提升能量和活力",
            phases: [
                Phase(name: .inhale, duration: 2),
                Phase(name: .exhale, duration: 2)
            ],
            cycles: 10,
            isPremium: true,
            benefits: "提升活力、快速清醒、补充能量"
        ),
        BreathingPattern(
            id: "sleep",
            name: "助眠呼吸",
            description: "深度放松，帮助入睡",
            phases: [
                Phase(name: .inhale, duration: 5),
                Phase(name: .hold, duration: 5),
                Phase(name: .exhale, duration: 7)
            ],
            cycles: 5,
            isPremium: true,
            benefits: "快速入睡、深度放松、改善睡眠"
        ),
        BreathingPattern(
            id: "resonance",
            name: "共振呼吸",
            description: "平衡神经系统，提升心率变异性",
            phases: [
                Phase(name: .inhale, duration: 5),
                Phase(name: .exhale, duration: 5)
            ],
            cycles: 10,
            isPremium: true,
            benefits: "心身和谐、提升专注、自主神经平衡"
        ),
        BreathingPattern(
            id: "sigh",
            name: "长叹舒缓",
            description: "模拟生理长叹，快速消解压力",
            phases: [
                Phase(name: .inhale, duration: 4),
                Phase(name: .exhale, duration: 8)
            ],
            cycles: 6,
            isPremium: true,
            benefits: "重启神经、释放紧绷、平息焦躁"
        ),
        BreathingPattern(
            id: "antipanic",
            name: "快速镇定",
            description: "阻断恐慌发作，重建安全感",
            phases: [
                Phase(name: .inhale, duration: 4),
                Phase(name: .hold, duration: 4),
                Phase(name: .exhale, duration: 4),
                Phase(name: .holdAfterExhale, duration: 4)
            ],
            cycles: 5,
            isPremium: true,
            benefits: "迅速急救、重夺控制、停止换气过度"
        ),
        BreathingPattern(
            id: "deepunwind",
            name: "深度释放",
            description: "深长呼吸，彻底释放全天疲惫",
            phases: [
                Phase(name: .inhale, duration: 5),
                Phase(name: .hold, duration: 2),
                Phase(name: .exhale, duration: 5),
                Phase(name: .holdAfterExhale, duration: 2)
            ],
            cycles: 6,
            isPremium: true,
            benefits: "深层解压、扩张肺部、拥抱宁静"
        )
    ]
}

import SwiftUI

enum SpaceTheme: String, CaseIterable, Identifiable {
    case cosmic = "cosmic"
    case forest = "forest"
    case ocean = "ocean"
    case sunset = "sunset"
    case dawn = "dawn"
    
    var id: String { rawValue }
    
    var localizedName: String {
        switch self {
        case .cosmic: return L10n.localized(zh: "深邃宇宙", en: "Cosmic Space")
        case .forest: return L10n.localized(zh: "幽静绿林", en: "Quiet Forest")
        case .ocean: return L10n.localized(zh: "深海沉浸", en: "Deep Ocean")
        case .sunset: return L10n.localized(zh: "温暖日落", en: "Warm Sunset")
        case .dawn: return L10n.localized(zh: "破晓晨曦", en: "Breaking Dawn")
        }
    }
    
    var icon: String {
        switch self {
        case .cosmic: return "moon.stars.fill"
        case .forest: return "leaf.fill"
        case .ocean: return "water.waves"
        case .sunset: return "sun.max.fill"
        case .dawn: return "sun.and.horizon.fill"
        }
    }
    
    // Background color for the space
    var backgroundColor: Color {
        switch self {
        case .cosmic: return Color(hex: "0A0A12") // Deeper black/purple
        case .forest: return Color(hex: "081C10") // Dark green
        case .ocean: return Color(hex: "05131C") // Dark blue
        case .sunset: return Color(hex: "1C0E0A") // Dark red/brown
        case .dawn: return Color(hex: "120D1A") // Dark purple
        }
    }
    
    // Gradient colors for the breathing animation Canvas
    var animationColors: [Color] {
        switch self {
        case .cosmic:
            return [Color(hex: "6B73FF"), Color(hex: "9B7FFF"), Color(hex: "4ECDC4")]
        case .forest:
            return [Color(hex: "43A047"), Color(hex: "66BB6A"), Color(hex: "81C784")]
        case .ocean:
            return [Color(hex: "0288D1"), Color(hex: "26C6DA"), Color(hex: "4DD0E1")]
        case .sunset:
            return [Color(hex: "E65100"), Color(hex: "FF7043"), Color(hex: "FFCA28")]
        case .dawn:
            return [Color(hex: "EC407A"), Color(hex: "AB47BC"), Color(hex: "7E57C2")]
        }
    }
}

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: SpaceTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedSpaceTheme")
        }
    }
    
    init() {
        let saved = UserDefaults.standard.string(forKey: "selectedSpaceTheme") ?? "cosmic"
        self.currentTheme = SpaceTheme(rawValue: saved) ?? .cosmic
    }
    
    func select(theme: SpaceTheme, isPremium: Bool) {
        if theme == .cosmic || isPremium {
            currentTheme = theme
        }
    }
}
