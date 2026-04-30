import Foundation
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    static let shared = StoreManager()
    
    @Published var isPremium: Bool = false
    @Published var products: [Product] = []
    @Published var isPurchasing = false
    
    private let productID = "com.xujie.breathingapp.premium"
    private let isPremiumKey = "isPremiumUnlocked"
    
    private init() {
        loadPremiumStatus()
        Task {
            await loadProducts()
            await checkPurchases()
        }
    }
    
    private func loadPremiumStatus() {
        isPremium = UserDefaults.standard.bool(forKey: isPremiumKey)
    }
    
    func loadProducts() async {
        do {
            let storeProducts = try await Product.products(for: [productID])
            products = storeProducts
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    func checkPurchases() async {
        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result {
                if transaction.productID == productID {
                    await unlockPremium()
                    return
                }
            }
        }
    }
    
    func purchase() async -> Bool {
        guard let product = products.first else { return false }
        
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                if case let .verified(transaction) = verification {
                    await unlockPremium()
                    await transaction.finish()
                    return true
                }
            case .userCancelled:
                return false
            case .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            print("Purchase failed: \(error)")
            return false
        }
        
        return false
    }
    
    func unlockPremium() async {
        isPremium = true
        UserDefaults.standard.set(true, forKey: isPremiumKey)
    }
    
    func restorePurchases() async {
        try? await AppStore.sync()
        await checkPurchases()
    }
}