//
//  InventoryView.swift
//  Kasir
//
//  Created by renaka agusta on 03/04/22.
//

import SwiftUI
import CarBode
import AVFoundation

struct InventoryView: View {
    
    @State var itemModels: [Item] = []
    
    @State private var itemId: String = ""
    @State private var itemName: String = ""
    @State private var itemCategory: String = ""
    @State private var itemPrice: String = ""
    @State private var itemQuantity: String = ""
    @State var itemList: [Item] = []
    @State var item = Item()
    @State var selectedItem = -1
    @State var addMode = false
    @State var barcodeType = CBBarcodeView.BarcodeType.qrCode
    @State var rotate = CBBarcodeView.Orientation.up
    
    func selectItem(selectedItemId: Int) {
        item = ItemDBManager().getItem(idValue: selectedItemId)
        itemId = String(item.id)
        itemName = item.name
        itemCategory = item.category
        itemPrice = String(item.price)
        itemQuantity = String(item.quantity)
        selectedItem = selectedItemId
    }
    
    var body: some View {
        VStack(){
            if(addMode) {
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
            } else {
                HStack(){
                    VStack (){
                        List (itemModels) { item in
                          Button (action: {
                              selectItem(selectedItemId: item.id)
                          }) {
                              HStack {
                                  Text(verbatim: item.name)
                                  Spacer()
                              }
                          }.background(self.item.id == item.id ? Color.lightGray : Color.white)
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
                        CBBarcodeView(data: $itemId,
                                      barcodeType: $barcodeType,
                                      orientation: $rotate)
                            .frame(minWidth: 0, maxWidth: 200, minHeight: 200, maxHeight: 200, alignment: .topLeading)
                        Button( action: {
                            if(selectedItem != -1) {
                            ItemDBManager().updateItem(idValue: item.id,nameValue: self.itemName, categoryValue: self.itemCategory, priceValue: Int(self.itemPrice) ?? 0, quantityValue: Int(self.itemQuantity) ?? 0)
                            } else {
                                ItemDBManager().addItem(nameValue: self.itemName, categoryValue: self.itemCategory, priceValue: Int(self.itemPrice) ?? 0, quantityValue: Int(self.itemQuantity) ?? 0)
                                    
                            }
                            
                            self.itemModels = ItemDBManager().getItems()
                        }, label: {
                            Text("Submit")
                        })
                    }
                }
            }
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
