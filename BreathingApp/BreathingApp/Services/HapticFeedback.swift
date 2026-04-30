import UIKit

class HapticFeedback {
    static let shared = HapticFeedback()
    
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let selection = UISelectionFeedbackGenerator()
    private let notification = UINotificationFeedbackGenerator()
    
    private init() {
        prepare()
    }
    
    func prepare() {
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        selection.prepare()
        notification.prepare()
    }
    
    func inhale() {
        impactMedium.impactOccurred()
    }
    
    func hold() {
        impactLight.impactOccurred()
    }
    
    func exhale() {
        impactHeavy.impactOccurred()
    }
    
    func phaseChange() {
        selection.selectionChanged()
    }
    
    func complete() {
        notification.notificationOccurred(.success)
    }
    
    func error() {
        notification.notificationOccurred(.error)
    }
}