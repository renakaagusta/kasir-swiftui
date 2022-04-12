import Foundation

struct Transaction: Codable, Hashable, Identifiable {
    public var id: Int = 0
    public var totalPrice: Int = 0
    public var paymentMethod: String = ""
    public var cashlessChannel: Int = 0
    public var date: Date = Date()
}
