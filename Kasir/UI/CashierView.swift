import SwiftUI
import CarBode
import AVFoundation

struct CashierView: View {
    
    @State private var quantity: String = "0"
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
        if let index = transactionItemList.firstIndex(where: {$0.itemId == selectedItem}) {
            quantity = String(transactionItemList[index].quantity)
        }
        print(item.id)
    }

    var body: some View {
        HStack (){
            VStack(alignment:.leading){
                Text("Produk")
                        .font(Font.headline.weight(.bold)).padding(.leading, 10)
                VStack(){
                    CBScanner(
                        supportBarcode: .constant([.qr, .code128]),
                        scanInterval: .constant(1.0)){
                            print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                            let randomItemIndex = Int.random(in: 0..<itemList.count)
                            selectItem(selectedItemId: self.itemList[randomItemIndex].id)
                            if(transactionItemList.first(where: {$0.id == self.itemList[randomItemIndex].id}) == nil) {
                                var newTransactionItem = TransactionItem()
                                newTransactionItem.quantity = 0
                                newTransactionItem.itemId = selectedItem
                                newTransactionItem.id = Int.random(in: 0..<1200)
                                transactionItemList.append(newTransactionItem)
                                transaction.totalPrice += newTransactionItem.quantity * item.price
                                quantity = "0"
                            }
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 120, maxHeight: 150)
                Spacer().frame(height: 20)
                Text("Harga Satuan")
                    .font(Font.headline.weight(.bold)).padding(.leading, 10)
                Text("Rp "+String(item.price)).padding(.leading, 10)
                Spacer().frame(height: 50)
                HStack(){
                    Spacer()
                    Button(action: {
                        var minusQuantity = Int(quantity) ?? 0
                        minusQuantity-=1
                        quantity = String(minusQuantity)
                        
                        if let index = transactionItemList.firstIndex(where: {$0.itemId == selectedItem}) {
                            transactionItemList[index].quantity = Int(quantity)!
                        }
                        
                        transaction.totalPrice -=  item.price
                    }, label: {
                        Text("-").foregroundColor(Color.white).padding()
                    }).frame(width: 60, height: 50).background(Color.blue).cornerRadius(10)
                    TextField("Jumlah barang", text: $quantity).padding().textFieldStyle(.roundedBorder).frame(width: 200, height: 80)
                    Button(action: {
                            var addQuantity = Int(quantity) ?? 0
                            addQuantity+=1
                            quantity = String(addQuantity)
                        
                        if let index = transactionItemList.firstIndex(where: {$0.itemId == selectedItem}) {
                            transactionItemList[index].quantity = Int(quantity)!
                        }
                        transaction.totalPrice += item.price
                        }, label: {
                            Text("+")
                                .foregroundColor(Color.white)
                                .padding()
                        }).frame(width: 60, height: 50)
                        .background(Color.blue).cornerRadius(10).frame(width: 80, height: 30)
                    Spacer()
                }
                HStack{
                    Spacer()
                    VStack(alignment: .leading){
                        HStack(){
                            Button(action: {
                                quantity += "1"
                            }, label: {
                                Text("1")
                                    .foregroundColor(Color.white).frame(width: 140, height: 30)
                                    .padding()
                            })
                                .background(Color.blue)
                                .cornerRadius(10)
                            Spacer()
                            Button(action: {
                                quantity += "2"
                            }, label: {
                                Text("2")
                                    .foregroundColor(Color.white).frame(width: 140, height: 30)
                                    .padding()
                            })
                                .background(Color.blue).cornerRadius(10)
                                Spacer()
                            Button(action: {
                                quantity += "3"}, label: {
                                Text("3").foregroundColor(Color.white).frame(width: 140, height: 30).padding()
                            }).background(Color.blue).cornerRadius(10)
                            }.frame(width: 200)
                        HStack(){
                            Button(action: {
                                quantity += "4"
                            }, label: {
                                Text("4")
                                    .foregroundColor(Color.white).frame(width: 140, height: 30)
                                    .padding()
                            })
                                .background(Color.blue).cornerRadius(10)
                            Spacer()
                            Button(action: {
                                quantity += "5"
                            }, label: {
                                Text("5").foregroundColor(Color.white).frame(width: 140, height: 30)
                                    .padding()
                            })
                                .background(Color.blue).cornerRadius(10)
                            Spacer()
                            Button(action: {
                                quantity += "6"}, label: {
                                Text("6").foregroundColor(Color.white).frame(width: 140, height: 30).padding()
                            }).background(Color.blue).cornerRadius(10)
                        }.frame(width: 200)
                        HStack(){
                            Button(action: {
                                quantity += "7"
                            }, label: {
                                Text("7")
                                    .foregroundColor(Color.white).frame(width: 140, height: 30)
                                    .padding()
                            })
                                .background(Color.blue).cornerRadius(10)
                            Spacer()
                            Button(action: {
                                quantity += "8"
                            }, label: {
                                Text("8")
                                    .foregroundColor(Color.white).frame(width: 140, height: 30)
                                    .padding()
                            })
                                .background(Color.blue).cornerRadius(10)
                            Spacer()
                            Button(action: {
                                quantity += "9"}, label: {
                                    Text("9").foregroundColor(Color.white).frame(width: 140, height: 30).padding()
                            }).background(Color.blue).cornerRadius(10)}.frame(width: 200)
                        HStack(){
                            Button(action: {
                            }, label: {
                                Text("")
                                    .foregroundColor(Color.white).frame(width: 140, height: 30)
                                    .padding()
                            })
                                .background(Color.white).cornerRadius(10)
                            Spacer()
                            Button(action: {
                                quantity += "0"
                            }, label: {
                                Text("0")
                                    .foregroundColor(Color.white).frame(width: 140, height: 30)
                                    .padding()
                            })
                                .background(Color.blue).cornerRadius(10)
                            Spacer()
                            Button(action: {
                                quantity += "0"}, label: {
                                    Image(systemName: "delete.left").foregroundColor(.white).frame(width: 140, height: 30).padding()
                            }).background(Color.blue).cornerRadius(10)}.frame(width: 200)
                            }
                    Spacer()
                }
                Spacer().frame(height: 50)
            }.padding()
            VStack{
                List(transactionItemList) { transactionItem in
                        VStack(alignment: .leading) {
                                Text(itemList.first(where: { $0.id == transactionItem.itemId})!.name).frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, maxHeight: 20, alignment: .topLeading)
                                HStack (){
                                    Text(String(transactionItem.quantity) + " x " + "Rp "+String(itemList.first(where: { $0.id == transactionItem.itemId})!.price))
                                    Spacer()
                                    Text("Rp " + String(transactionItem.quantity * itemList.first(where: { $0.id == transactionItem.itemId})!.price))
                                }
                            }.padding().frame(minWidth: 0, maxWidth: .infinity, minHeight: 120, maxHeight: 150).background(selectedItem == transactionItem.itemId ? Color.lightGray : Color.white).onTapGesture{
                                selectItem(selectedItemId: transactionItem.itemId)
                            }
                        }
                    .edgesIgnoringSafeArea(.all)
                    .listStyle(.plain)
                    .background(.white).padding()
                VStack(alignment: .leading){
                    Text("Total")
                        .font(Font.headline.weight(.bold))
                    Text("Rp " + String(transaction.totalPrice))
                    NavigationLink(destination: PaymentMethodView(transaction: self.transaction, transactionItemList: self.transactionItemList)) {
                        Text("Bayar").foregroundColor(.white)
                    }.padding()
                        .background(Color.blue).cornerRadius(10)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100, alignment: .topLeading).padding().padding().overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.gray), alignment: .top)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).background(Color.white).overlay(Rectangle().frame(width: 1, height: nil, alignment: .top).foregroundColor(Color.gray), alignment: .leading)
        }.onAppear{
            let items = ItemDBManager().getItems()
            
            itemList = items
            selectItem(selectedItemId: items[items.count - 1].id)
        }
    }
}

struct CashierView_Previews: PreviewProvider {
    static var previews: some View {
        CashierView()
.previewInterfaceOrientation(.landscapeLeft)
    }
}
