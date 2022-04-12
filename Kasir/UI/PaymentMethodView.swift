//
//  PaymentMethodView.swift
//  Kasir
//
//  Created by renaka agusta on 04/04/22.
//

import SwiftUI

struct PaymentMethodView: View {
    
    var transaction = Transaction()
    var transactionItemList: [TransactionItem] = []
    
    @State var paymentAmount: String = "0"
    @State var paymentReturn: String = "0"
    @State var selectedCashlessPaymentChannelId = 0
    @State var showSuccessView = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack() {
                Spacer()
                Text("Metode Pembayaran").foregroundColor(.blue)
                Spacer()
            }
            TabView() {
                VStack(){
                   Text("Nominal bayar")
                            .font(Font.headline.weight(.bold)).padding(.leading, 10)
                    Text("Rp "+String(transaction.totalPrice)).padding(.leading, 10)
                    HStack {
                        ForEach(0..<cashlessPaymentChannelList.count) { i in
                            VStack {
                                Image(cashlessPaymentChannelList[i].image).resizable().frame( width: 140,height: 100)
                                Spacer().frame(height: 20)
                                Button(action: {
                                    selectedCashlessPaymentChannelId = cashlessPaymentChannelList[i].id
                                }, label: {
                                    Text(cashlessPaymentChannelList[i].name).padding().foregroundColor(selectedCashlessPaymentChannelId != cashlessPaymentChannelList[i].id ? .blue : .white)
                                }).background(selectedCashlessPaymentChannelId == cashlessPaymentChannelList[i].id ? .blue : .white ).border(.blue, width: 1)
                            }.padding()
                        }
                      }
                    Spacer().frame(height: 20)
                    NavigationLink(destination: TransactionSuccessView().onAppear{
                        let transactionItemId =
                        TransactionDBManager().addTransaction(dateValue: Date(), totalPriceValue: transaction.totalPrice, paymentMethodValue: "Cashless",
                        cashlessCannelValue: selectedCashlessPaymentChannelId)
                        for transactionItem in transactionItemList {
                            TransactionItemDBManager().addTransactionItem(itemIdValue: transactionItem.itemId, quantityValue: transactionItem.quantity, transactionIdValue: transactionItemId)
                        }
                        self.showSuccessView = true
                    },  isActive: $showSuccessView) {
                        Text("Bayar").foregroundColor(.white).padding()
                    }.background(.blue).padding()
            }.tabItem {
               Text("Non tunai")
            }.tag(1).background(.white).padding()
                HStack{
                    Spacer()
                        VStack(){
                            Text("Nominal bayar")
                                .font(Font.headline.weight(.bold)).padding(.leading, 10)
                            TextField("Nominal bayar",text: Binding(
                            get: { String(self.transaction.totalPrice) }, set:{_,_ in })).padding().textFieldStyle(.roundedBorder)
                            Text("Nominal dibayarkan")
                                .font(Font.headline.weight(.bold)).padding(.leading, 10)
                            TextField("Nominal dibayarkan",text: $paymentAmount).onChange(of: paymentAmount){ paymentAmount in
                                paymentReturn = String(Int(paymentAmount)! - transaction.totalPrice)
                            }.padding().textFieldStyle(.roundedBorder)
                            Text("Nominal kembalian")
                                .font(Font.headline.weight(.bold)).padding(.leading, 10)
                            TextField("Nominal kembalian",text: $paymentReturn).padding().textFieldStyle(.roundedBorder)
                            NavigationLink(destination: TransactionSuccessView()) {
                                Button( action: {
                                    let transactionItemId =
                                    TransactionDBManager().addTransaction(dateValue: Date(), totalPriceValue: transaction.totalPrice, paymentMethodValue: "Cashless",
                                    cashlessCannelValue: selectedCashlessPaymentChannelId)
                                    for transactionItem in transactionItemList {
                                        TransactionItemDBManager().addTransactionItem(itemIdValue: transactionItem.itemId, quantityValue: transactionItem.quantity, transactionIdValue: transactionItemId)
                                    }
                                }, label: {
                                    Text("Bayar").foregroundColor(.white).padding()
                                }).background(.blue).padding()
                            }
                        }.frame(width: 200).padding()
                    
                    Spacer()
                }
                 .tabItem {
                     Text("Tunai")
                 }.tag(1)
                
            }
        }
    }
}

struct PaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodView()
    }
}
