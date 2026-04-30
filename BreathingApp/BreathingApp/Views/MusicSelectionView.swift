import SwiftUI

struct MusicSelectionView: View {
    @StateObject private var musicManager = MusicManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0A0E1C").edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Image(systemName: "music.note.list")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(L10n.musicTitle)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text(L10n.musicSubtitle)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 12) {
                            ForEach(MeditationMusic.allCases) { music in
                                MusicRow(music: music, isSelected: musicManager.currentMusic == music) {
                                    musicManager.setMusic(music)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, musicManager.currentMusic != .none ? 220 : 120)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    if musicManager.currentMusic != .none {
                        VStack(spacing: 12) {
                            Text(L10n.volumeControl)
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.85))
                            
                            HStack(spacing: 12) {
                                Image(systemName: "speaker.low")
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Slider(value: $musicManager.volume, in: 0...1)
                                    .accentColor(Color(hex: "6B73FF"))
                                    .onChange(of: musicManager.volume) { newVolume in
                                        musicManager.setVolume(newVolume)
                                    }
                                
                                Image(systemName: "speaker.high")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Text("\(Int(musicManager.volume * 100))%")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.08))
                        )
                    }
                    
                    VStack(spacing: 6) {
                        Text(L10n.hint)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text(L10n.loopingHint)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.4))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 20)
                .background(Color(hex: "0A0E1C").opacity(0.96))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.done) {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "6B73FF"))
                }
            }
        }
    }
}

struct MusicRow: View {
    let music: MeditationMusic
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: music.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? Color(hex: "6B73FF") : .white.opacity(0.7))
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(music.displayName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if music != .none {
                        Text(L10n.relaxingBackground)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    } else {
                        Text(L10n.hapticOnly)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "6B73FF"))
                        .font(.title2)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.white.opacity(0.3))
                        .font(.title2)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(hex: "6B73FF").opacity(0.2) : Color.white.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(hex: "6B73FF").opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
    }
}