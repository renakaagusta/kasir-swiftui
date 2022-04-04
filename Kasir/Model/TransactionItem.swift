//
//  TransactionItem.swift
//  Kasir
//
//  Created by renaka agusta on 03/04/22.
//

import Foundation

struct TransactionItem: Codable, Hashable, Identifiable {
  public var id: Int = 0
  public var transactionId: Int = 0
  public var itemId: Int = 0
  public var quantity: Int = 0
}
