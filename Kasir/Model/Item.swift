import Foundation

struct Item: Codable, Hashable, Identifiable {
  public var id: Int = 0
  public var name: String = ""
  public var category: String = ""
  public var quantity: Int = 0
  public var price: Int = 0
}
