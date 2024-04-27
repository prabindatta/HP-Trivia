//
//  Store.swift
//  HP Trivia
//
//  Created by Apple on 26/04/24.
//

import StoreKit

enum BookStatus: Codable {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    @Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
    @Published var products: [Product] = []
    @Published var purchaseIDs = Set<String>()
    
    private var productIDs = ["hp4", "hp5", "hp6", "hp7"]
    private var updates: Task<Void, Never>? = nil
    private var savePath = FileManager.documentsDirectory.appending(path: "SavedBookStatus")
    
    init() {
        updates = watchForUpdates()
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Couldn't fetch those products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            // Purchase successful, but now we have to verify receipt
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType): \(verificationError)")
                case .verified(let signedType):
                    purchaseIDs.insert(signedType.productID)
                }
            
            // User cancelled or parent disapproved a child's purchase
            case .userCancelled:
                break
            
            // Waiting for approval
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            print("Couldn't purchase that products: \(error)")
        }
    }
    
    func loadStatus() {
        do {
            let data = try Data(contentsOf: savePath)
            books = try JSONDecoder().decode([BookStatus].self, from: data)
        } catch {
            print("Couldnt load book statuses: \(error)")
        }
    }
    
    func saveStatus() {
        do {
            let data = try JSONEncoder().encode(books)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data: \(error)")
        }
    }
    
    private func checkPurchased() async {
        for product in products {
            guard let state = await product.currentEntitlement else { return }
            
            switch state {
            case .unverified(let signedType, let verificationError):
                print("Error on \(signedType): \(verificationError)")
            case .verified(let signedType):
                if signedType.revocationDate == nil {
                    purchaseIDs.insert(signedType.productID)
                } else {
                    purchaseIDs.remove(signedType.productID)
                }
            }
        }
    }
    
    private func watchForUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }

}
