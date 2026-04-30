import Foundation
import AVFoundation

enum MeditationMusic: String, CaseIterable, Identifiable, Codable {
    case none = "关闭"
    case forest = "森林鸟鸣"
    case ocean = "海浪轻拍"
    case rain = "细雨轻声"
    case wind = "微风拂面"
    case bells = "冥想铃声"
    case ambient = "氛围音乐"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .none: return L10n.localized(zh: "关闭", en: "Off")
        case .forest: return L10n.localized(zh: "森林鸟鸣", en: "Forest Birds")
        case .ocean: return L10n.localized(zh: "海浪轻拍", en: "Ocean Waves")
        case .rain: return L10n.localized(zh: "细雨轻声", en: "Soft Rain")
        case .wind: return L10n.localized(zh: "微风拂面", en: "Gentle Wind")
        case .bells: return L10n.localized(zh: "冥想铃声", en: "Meditation Bells")
        case .ambient: return L10n.localized(zh: "氛围音乐", en: "Ambient Tone")
        }
    }
    
    var fileName: String? {
        switch self {
        case .none: return nil
        case .forest: return "forest.wav"
        case .ocean: return "ocean.wav"
        case .rain: return "rain.wav"
        case .wind: return "wind.wav"
        case .bells: return "bells.wav"
        case .ambient: return "ambient.wav"
        }
    }
    
    var icon: String {
        switch self {
        case .none: return "speaker.slash"
        case .forest: return "leaf"
        case .ocean: return "water.waves"
        case .rain: return "cloud.rain"
        case .wind: return "wind"
        case .bells: return "bell"
        case .ambient: return "music.note"
        }
    }
}

@MainActor
class MusicManager: ObservableObject {
    static let shared = MusicManager()
    
    @Published var currentMusic: MeditationMusic = .none
    @Published var isPlaying: Bool = false
    @Published var volume: Float = 0.5
    
    private var audioPlayer: AVAudioPlayer?
    private let musicPreferenceKey = "selectedMusic"
    private let volumePreferenceKey = "musicVolume"
    
    private init() {
        loadPreferences()
        setupAudioSession()
    }
    
    private func loadPreferences() {
        if let savedMusic = UserDefaults.standard.string(forKey: musicPreferenceKey),
           let music = MeditationMusic(rawValue: savedMusic) {
            currentMusic = music
        }
        volume = UserDefaults.standard.float(forKey: volumePreferenceKey)
        if volume == 0 { volume = 0.5 }
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func play() {
        guard currentMusic != .none,
                            let fileName = currentMusic.fileName,
                            let url = Bundle.main.url(forResource: fileName, withExtension: nil, subdirectory: "Music") else {
            print("Music file not found or music is disabled")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Failed to play music: \(error)")
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func resume() {
        audioPlayer?.play()
        isPlaying = true
    }
    
    func setMusic(_ music: MeditationMusic) {
        stop()
        currentMusic = music
        UserDefaults.standard.set(music.rawValue, forKey: musicPreferenceKey)
        
        if music != .none {
            play()
        }
    }
    
    func setVolume(_ newVolume: Float) {
        volume = newVolume
        audioPlayer?.volume = newVolume
        UserDefaults.standard.set(newVolume, forKey: volumePreferenceKey)
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            if audioPlayer != nil {
                resume()
            } else {
                play()
            }
        }
    }
}