//
//  CashlessPaymentChannel.swift
//  Kasir
//
//  Created by renaka agusta on 04/04/22.
//

import Foundation

struct CashlessPaymentChannel: Codable, Hashable, Identifiable {
    public var id: Int = 0
    public var name: String = ""
    public var image: String = ""
}
