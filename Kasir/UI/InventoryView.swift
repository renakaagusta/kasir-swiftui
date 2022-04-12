//
//  InventoryView.swift
//  Kasir
//
//  Created by renaka agusta on 03/04/22.
//

import SwiftUI

struct InventoryView: View {
    
    @State var itemModels: [Item] = []
    
    @State private var itemName: String = ""
    @State private var itemCategory: String = ""
    @State private var itemPrice: String = ""
    @State private var itemQuantity: String = ""
    
    var body: some View {
        HStack(){
            VStack (){
                List (itemModels) { item in
                  Button (action: {
                      print(item.id)
                  }) {
                      HStack {
                          Text(verbatim: item.name)
                          Spacer()
                      }
                  }
                }
            }.onAppear(perform: {
                self.itemModels = ItemDBManager().getItems()
            })
            VStack () {
                Text("Form Input barang")
                    .font(Font.headline.weight(.bold))
                TextField("Nama barang", text: $itemName).padding().textFieldStyle(.roundedBorder)
                TextField("Kategory barang", text: $itemCategory).padding().textFieldStyle(.roundedBorder)
                TextField("Harga barang", text: $itemPrice).padding().textFieldStyle(.roundedBorder)
                TextField("Jumlah barang", text: $itemQuantity).padding().textFieldStyle(.roundedBorder)
                Button( action: {
                    ItemDBManager().addItem(nameValue: self.itemName, categoryValue: self.itemCategory, priceValue: Int(self.itemPrice) ?? 0, quantityValue: Int(self.itemQuantity) ?? 0)
                    
                    self.itemModels = ItemDBManager().getItems()
                }, label: {
                    Text("Submit")
                })
            }
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
