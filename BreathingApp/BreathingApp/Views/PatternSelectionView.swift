import SwiftUI

struct PatternSelectionView: View {
    @StateObject private var storeManager = StoreManager.shared
    @StateObject private var musicManager = MusicManager.shared
    @State private var selectedPattern: BreathingPattern?
    @State private var showMusicSelection = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0A0E1C").edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text(L10n.appName)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text(L10n.tagline)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Button(action: { showMusicSelection = true }) {
                                HStack(spacing: 8) {
                                    Image(systemName: musicManager.currentMusic.icon)
                                        .font(.caption)
                                    
                                    Text(musicManager.currentMusic.displayName)
                                        .font(.caption)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption2)
                                }
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .padding(.top, 8)
                        }
                        .padding(.top, 20)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 340, maximum: 460), spacing: 20)], spacing: 20) {
                            ForEach(BreathingPattern.patterns) { pattern in
                                PatternCard(
                                    pattern: pattern,
                                    isLocked: pattern.isPremium && !storeManager.isPremium
                                ) {
                                    if pattern.isPremium && !storeManager.isPremium {
                                        selectedPattern = nil
                                    } else {
                                        selectedPattern = pattern
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .frame(maxWidth: 1200)
                        
                        if !storeManager.isPremium {
                            VStack(spacing: 16) {
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                    .padding(.horizontal)
                                
                                PremiumCard(isPurchasing: storeManager.isPurchasing) {
                                    Task {
                                        let success = await storeManager.purchase()
                                        if success {
                                            HapticFeedback.shared.complete()
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                            .padding(.horizontal, 24)
                            .frame(maxWidth: 600)
                        }
                    }
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(item: $selectedPattern) { pattern in
                BreathingView(pattern: pattern)
            }
            .sheet(isPresented: $showMusicSelection) {
                MusicSelectionView()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct PatternCard: View {
    let pattern: BreathingPattern
    let isLocked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(pattern.localizedName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            if isLocked {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                        
                        Text(pattern.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        Text(pattern.formattedDuration)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text(L10n.cycles(pattern.cycles))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                HStack(spacing: 8) {
                    ForEach(pattern.phases, id: \.name) { phase in
                        PhaseBadge(phase: phase)
                    }
                }
                
                Text(pattern.localizedBenefits)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.2),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
        }
        .disabled(false)
    }
}

struct PhaseBadge: View {
    let phase: Phase
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(phaseColor)
                .frame(width: 8, height: 8)
            
            Text(L10n.phaseDuration(phase.name.instruction, phase.duration))
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.15))
        .cornerRadius(8)
    }
    
    var phaseColor: Color {
        switch phase.name {
        case .inhale: return Color.blue
        case .hold: return Color.purple
        case .exhale: return Color.green
        case .holdAfterExhale: return Color.orange
        }
    }
}

struct PremiumCard: View {
    let isPurchasing: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                
                VStack(spacing: 8) {
                    Text(L10n.unlockAllPatterns)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(L10n.price("¥6.00"))
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.yellow)
                    
                    Text(L10n.oneTimePurchase)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: "6B73FF").opacity(0.3),
                        Color(hex: "9B7FFF").opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [Color.yellow.opacity(0.5), Color.orange.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
        }
        .disabled(isPurchasing)
        .opacity(isPurchasing ? 0.6 : 1)
    }
}