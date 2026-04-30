import SwiftUI
import Combine

struct BreathingView: View {
    let pattern: BreathingPattern
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = BreathingViewModel()
    @StateObject private var musicManager = MusicManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var storeManager = StoreManager.shared
    
    @State private var showCompletion = false
    @State private var showMusicSelection = false
    @State private var showThemeSelection = false
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                HStack {
                    Button(action: { 
                        musicManager.stop()
                        dismiss() 
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showThemeSelection = true
                    }) {
                        Image(systemName: themeManager.currentTheme.icon)
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                            .padding()
                    }
                    
                    if musicManager.currentMusic != .none {
                        Button(action: {
                            musicManager.togglePlayPause()
                        }) {
                            Image(systemName: musicManager.isPlaying ? "pause.circle" : "play.circle")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                                .padding()
                        }
                    }
                    
                    Text("\(viewModel.currentCycle)/\(pattern.cycles)")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))
                        .padding()
                }
                .padding(.horizontal)
                
                Spacer()
                
                ZStack {
                    BreathingAnimationView(
                        phase: viewModel.currentPhase?.name ?? .inhale,
                        duration: TimeInterval(viewModel.currentPhase?.duration ?? 4),
                        phaseStartTime: viewModel.phaseStartTime,
                        theme: themeManager.currentTheme
                    )
                    
                    VStack(spacing: 20) {
                        Text(viewModel.currentPhase?.name.instruction ?? L10n.prepare)
                            .font(.system(size: 48, weight: .light, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("\(viewModel.countdown)")
                            .font(.system(size: 72, weight: .ultraLight, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(0.9)
                    }
                }
                
                Spacer()
                
                if !viewModel.isBreathing {
                    let btnColors: [Color] = [
                        themeManager.currentTheme.animationColors.first ?? Color(hex: "6B73FF"),
                        themeManager.currentTheme.animationColors.dropFirst().first ?? Color(hex: "9B7FFF")
                    ]
                    
                    Button(action: {
                        viewModel.startBreathing(pattern: pattern)
                    }) {
                        Text(L10n.startPractice)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(width: 200, height: 60)
                            .background(
                                LinearGradient(
                                    colors: btnColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .alert(L10n.practiceCompleteTitle, isPresented: $showCompletion) {
            Button(L10n.close) {
                dismiss()
            }
            Button(L10n.oneMoreRound) {
                viewModel.reset()
                viewModel.startBreathing(pattern: pattern)
            }
        } message: {
            Text(L10n.completionMessage(cycles: pattern.cycles, duration: pattern.formattedDuration))
        }
        .sheet(isPresented: $showThemeSelection) {
            ThemeSelectionView()
        }
        .onReceive(viewModel.$isComplete) { complete in
            if complete {
                musicManager.stop()
                showCompletion = true
            }
        }
        .onAppear {
            if musicManager.currentMusic != .none {
                musicManager.play()
            }
        }
        .onDisappear {
            musicManager.stop()
        }
    }
}

class BreathingViewModel: ObservableObject {
    @Published var currentPhase: Phase?
    @Published var currentCycle: Int = 0
    @Published var countdown: Int = 0
    @Published var isBreathing: Bool = false
    @Published var isComplete: Bool = false
    @Published var phaseStartTime: Date = .now
    
    private var timer: Timer?
    private var pattern: BreathingPattern?
    private var phaseIndex: Int = 0
    private var elapsedInPhase: Int = 0
    
    func startBreathing(pattern: BreathingPattern) {
        self.pattern = pattern
        isBreathing = true
        isComplete = false
        currentCycle = 1
        phaseIndex = 0
        currentPhase = pattern.phases[0]
        countdown = currentPhase?.duration ?? 0
        elapsedInPhase = 0
        phaseStartTime = .now
        triggerHapticForCurrentPhase()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func tick() {
        guard let pattern = pattern else { return }
        
        countdown -= 1
        elapsedInPhase += 1
        
        if countdown <= 0 {
            phaseIndex += 1
            
            if phaseIndex >= pattern.phases.count {
                phaseIndex = 0
                currentCycle += 1
                
                if currentCycle > pattern.cycles {
                    stopBreathing()
                    isComplete = true
                    return
                }
            }
            
            currentPhase = pattern.phases[phaseIndex]
            countdown = currentPhase?.duration ?? 0
            elapsedInPhase = 0
            phaseStartTime = .now
            
            HapticFeedback.shared.phaseChange()
            triggerHapticForCurrentPhase()
        }
    }
    
    func stopBreathing() {
        timer?.invalidate()
        timer = nil
        isBreathing = false
    }
    
    func reset() {
        stopBreathing()
        currentCycle = 0
        currentPhase = nil
        countdown = 0
        isComplete = false
        phaseStartTime = .now
    }
    
    private func triggerHapticForCurrentPhase() {
        switch currentPhase?.name {
        case .inhale:
            HapticFeedback.shared.inhale()
        case .hold, .holdAfterExhale:
            HapticFeedback.shared.hold()
        case .exhale:
            HapticFeedback.shared.exhale()
        case .none:
            break
        }
    }
}

struct ThemeSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var storeManager = StoreManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0A0E1C").edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        themeGrid
                        
                        if !storeManager.isPremium {
                            premiumSection
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle(L10n.localized(zh: "选择空间主题", en: "Select Space Theme"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L10n.close) {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private var themeGrid: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                themeButton(.cosmic)
                themeButton(.forest)
            }

            HStack(spacing: 16) {
                themeButton(.ocean)
                themeButton(.sunset)
            }

            HStack(spacing: 16) {
                themeButton(.dawn)
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal)
    }

    private func themeButton(_ theme: SpaceTheme) -> some View {
        ThemeItemButton(
            theme: theme,
            isLocked: theme != .cosmic && !storeManager.isPremium,
            isActive: themeManager.currentTheme == theme,
            action: {
                if theme == .cosmic || storeManager.isPremium {
                    themeManager.select(theme: theme, isPremium: storeManager.isPremium)
                    HapticFeedback.shared.phaseChange()
                    dismiss()
                }
            }
        )
    }
    
    @ViewBuilder
    private var premiumSection: some View {
        PremiumCard(isPurchasing: storeManager.isPurchasing) {
            Task {
                let success = await storeManager.purchase()
                if success {
                    HapticFeedback.shared.complete()
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ThemeItemButton: View {
    let theme: SpaceTheme
    let isLocked: Bool
    let isActive: Bool
    let action: () -> Void
    
    var borderColor: Color {
        isActive ? (theme.animationColors.first ?? .white) : Color.clear
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: theme.animationColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: theme.icon)
                        .font(.title)
                        .foregroundColor(.white)
                    
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.yellow)
                            .padding(6)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .offset(x: 30, y: 30)
                    }
                }
                
                Text(theme.localizedName)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor, lineWidth: 3)
            )
        }
        .buttonStyle(.plain)
    }
}