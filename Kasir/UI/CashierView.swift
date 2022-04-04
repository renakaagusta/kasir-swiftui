import SwiftUI

struct CashierView: View {
    
    @State private var quantity: String = ""
    @State var text = "Hello World"
    @State var itemOptions: [DropdownOption] = []
    @State var item: Item = Item()
    @State var transaction: Transaction = Transaction()
    @State var transactionItemList: [TransactionItem] = []
    @State var itemList: [Item] = []
    @State var selectedItem = 0
    
    func selectItem(selectedItemId: Int) {
        item = ItemDBManager().getItem(idValue: selectedItemId)
        selectedItem = selectedItemId
    }

    var body: some View {
        HStack (){
            VStack(alignment:.leading){
                Text("Produk").padding(.leading, 10)
                DropdownSelector(
                    placeholder: "Nama Produk",
                    options: itemOptions,
                    onOptionSelected: { option in
                        selectItem(selectedItemId: Int(option.key) ?? 0)
                    })
                .padding(.horizontal)
                Spacer().frame(height: 20)
                Text("Harga Satuan").padding(.leading, 10)
                Text(item.id != 0 ? String(item.price) : "-").padding(.leading, 10)
                Spacer().frame(height: 50)
                HStack(){
                    Spacer()
                    Button(action: {
                            var addQuantity = Int(quantity) ?? 0
                            addQuantity+=1
                            quantity = String(addQuantity)
                        }, label: {
                            Text("+")
                                .foregroundColor(Color.white)
                                .padding()
                        })
                        .background(Color.blue)
                    Spacer()
                    TextField("Jumlah barang", text: $quantity).padding().textFieldStyle(.roundedBorder)
                    Button(action: {
                        var minusQuantity = Int(quantity) ?? 0
                        minusQuantity-=1
                        quantity = String(minusQuantity)
                    }, label: {
                        Text("-").foregroundColor(Color.white).padding()
                    }).background(Color.blue)
                    Spacer()
                }
                HStack{
                    Spacer()
                    VStack{
                        HStack(){
                            Button(action: {
                            }, label: {
                                Text("1")
                                    .foregroundColor(Color.white)
                                    .padding()
                            })
                                .background(Color.blue)
                                .cornerRadius(10)
                            Spacer()
                            Button(action: {
                            }, label: {
                                Text("2")
                                    .foregroundColor(Color.white)
                                    .padding()
                            })
                                .background(Color.blue).cornerRadius(10)
                                Spacer()
                            Button(action: {}, label: {
                                Text("3").foregroundColor(Color.white).padding()
                            }).background(Color.blue).cornerRadius(10)
                            }.padding().frame(width: 200)
                        HStack(){
                            Button(action: {
                            }, label: {
                                Text("4")
                                    .foregroundColor(Color.white)
                                    .padding()
                            })
                                .background(Color.blue).cornerRadius(10)
                            Spacer()
                            Button(action: {
                            }, label: {
                                Text("5").foregroundColor(Color.white)
                                    .padding()
                            })
                                .background(Color.blue).cornerRadius(10)
                            Spacer()
                            Button(action: {}, label: {
                                Text("6").foregroundColor(Color.white).padding()
                                
                            }).background(Color.blue).cornerRadius(10)
                        }.padding().frame(width: 200)
                        HStack(){
                            Button(action: {
                            }, label: {
                                Text("7")
                                    .foregroundColor(Color.white)
                                    .padding()
                            })
                                .background(Color.blue).cornerRadius(10)
                            Spacer()
                            Button(action: {
                            }, label: {
                                Text("8")
                                    .foregroundColor(Color.white)
                                    .padding()
                            })
                                .background(Color.blue).cornerRadius(10)
                            Spacer()
                            Button(action: {}, label: {
                            Text("9").foregroundColor(Color.white).padding()
                            }).background(Color.blue).cornerRadius(10)}.padding().frame(width: 200)
                            }
                    Spacer()
                }
                
                Button( action: {
                    var newTransactionItem = TransactionItem()
                    newTransactionItem .quantity = Int(quantity) ?? 0
                    newTransactionItem.itemId = selectedItem
                    transactionItemList.append(newTransactionItem)
                    transaction.totalPrice += newTransactionItem.quantity * item.price
                    item = Item()
                    quantity = "0"
                }, label: {
                    Text("Submit")
                })
            }.padding()
            VStack{
                List(transactionItemList) { transactionItem in
                            VStack(alignment: .leading) {
                                Text(itemList.first(where: { $0.id == transactionItem.itemId})!.name)
                                Text(String(itemList.first(where: { $0.id == transactionItem.itemId})!.price))
                                
                                Text(String(transactionItem.quantity))
                            }
                        }.frame(maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .listStyle(.plain)
                    .background(Color.white)
                VStack(alignment: .trailing){
                    Text("Total")
                    Text("Rp "+String(transaction.totalPrice))
                    Button( action: {
                        NavigationLink(destination: PaymentMethodView(transaction: self.transaction, transactionItemList: self.transactionItemList)) {
                            
                        }
                    }, label: {
                        Text("Bayar").foregroundColor(Color.white)
                    })
                        .background(Color.blue)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150, alignment: .topLeading).padding()
            }.background(Color.white)
        }.onAppear{
            let items = ItemDBManager().getItems()
            
            itemList = items
            for item in items {
                itemOptions.append(DropdownOption(key: String(item.id), value: item.name))
            }
        }
    }
}

struct CashierView_Previews: PreviewProvider {
    static var previews: some View {
        CashierView()
    }
}
