import SwiftUI

struct BreathingAnimationView: View {
    let phase: PhaseType
    let duration: TimeInterval
    let phaseStartTime: Date
    let theme: SpaceTheme
    
    let particles: [(angle: Double, speed: Double, offset: Double, size: Double, opacity: Double)] = (0..<80).map { _ in
        (Double.random(in: 0...2 * .pi), Double.random(in: 0.6...1.8), Double.random(in: 0...1), Double.random(in: 2...7), Double.random(in: 0.2...0.9))
    }
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            let progress = phaseProgress(at: timeline.date)
            let visualState = visualState(for: progress, at: timeline.date)
            let time = timeline.date.timeIntervalSinceReferenceDate
            
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                
                // Draw Halo / Glow circles
                let colors = theme.animationColors.enumerated().map { index, color in
                    color.opacity(index == 0 ? 0.82 : (index == 1 ? 0.52 : 0.26))
                }
                
                let gradient = Gradient(colors: colors)
                let radius = 130.0 * visualState.scale
                
                for index in 0..<3 {
                    let r = radius - CGFloat(index) * 20.0
                    if r > 0 {
                        var path = Path()
                        path.addArc(center: center, radius: r, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
                        context.opacity = max(0.08, visualState.opacity - Double(index) * 0.14)
                        context.fill(path, with: .radialGradient(gradient, center: center, startRadius: 0, endRadius: r))
                        // Apply blur via filter or let gradient be smooth enough
                    }
                }
                
                // Draw central core
                let coreGradient = Gradient(colors: [
                    Color.white.opacity(0.18),
                    theme.animationColors.first?.opacity(0.12) ?? Color.clear,
                    Color.clear
                ])
                let coreRadius = 110.0 * visualState.innerScale
                var corePath = Path()
                corePath.addArc(center: center, radius: coreRadius, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
                context.opacity = visualState.opacity * 0.9
                context.fill(corePath, with: .linearGradient(coreGradient, startPoint: CGPoint(x: center.x - coreRadius, y: center.y - coreRadius), endPoint: CGPoint(x: center.x + coreRadius, y: center.y + coreRadius)))
                
                // Draw Particles
                context.opacity = 1.0
                for p in particles {
                    let particleProgress = (p.offset + time * p.speed * 0.2).truncatingRemainder(dividingBy: 1.0)
                    
                    // Modify distance based on phase. Inhale: particles flow outwards or inwards?
                    // Let's make particles flow outwards during inhale, inwards during exhale
                    let directionMultiplier: Double
                    switch phase {
                    case .inhale: directionMultiplier = progress
                    case .exhale: directionMultiplier = 1.0 - progress
                    case .hold, .holdAfterExhale: directionMultiplier = phase == .hold ? 1.0 : 0.0
                    }
                    
                    let distance = 50 + (150 * p.offset) + (directionMultiplier * 100 * p.speed)
                    let x = center.x + cos(p.angle) * distance
                    let y = center.y + sin(p.angle) * distance
                    
                    let pSize = p.size * (0.5 + 0.5 * visualState.scale)
                    var pPath = Path()
                    pPath.addArc(center: CGPoint(x: x, y: y), radius: pSize / 2, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
                    
                    let pAlpha = p.opacity * (1 - particleProgress) * visualState.opacity
                    context.fill(pPath, with: .color(Color.white.opacity(pAlpha)))
                }
            }
        }
        .frame(width: 350, height: 350)
    }
    
    private func phaseProgress(at date: Date) -> Double {
        guard duration > 0 else { return 1 }
        let elapsed = date.timeIntervalSince(phaseStartTime)
        return min(max(elapsed / duration, 0), 1)
    }
    
    private func easedProgress(_ progress: Double) -> Double {
        progress * progress * (3 - 2 * progress)
    }
    
    private func visualState(for progress: Double, at date: Date) -> (scale: CGFloat, innerScale: CGFloat, opacity: Double) {
        let eased = easedProgress(progress)
        
        switch phase {
        case .inhale:
            return (
                scale: 0.72 + CGFloat(eased) * 0.58,
                innerScale: 0.86 + CGFloat(eased) * 0.34,
                opacity: 0.42 + eased * 0.5
            )
        case .exhale:
            return (
                scale: 1.3 - CGFloat(eased) * 0.58,
                innerScale: 1.2 - CGFloat(eased) * 0.34,
                opacity: 0.92 - eased * 0.5
            )
        case .hold, .holdAfterExhale:
            let pulse = 0.02 * sin(date.timeIntervalSince(phaseStartTime) * .pi * 1.5)
            return (
                scale: 1.3 + CGFloat(pulse),
                innerScale: 1.2 + CGFloat(pulse * 0.8),
                opacity: 0.88 + pulse
            )
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}