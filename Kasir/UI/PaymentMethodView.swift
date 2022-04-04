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
    
    @State var paymentAmount: String = ""
    @State var paymentReturn: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            HStack() {
                Spacer()
                Text("Metode Pembayaran").foregroundColor(.blue)
                Spacer()
            }
            TabView() {
                VStack(){
                    TextField("Total yang harus dibayarkan",text: Binding(
                    get: { String(self.transaction.totalPrice) }, set:{_,_ in }))
                  TextField("Total dibayarkan",text: $paymentAmount)
                    TextField("Total kembalian",text: $paymentReturn)
                }
                 .tabItem {
                     Image(systemName: "timelapse")
                     Text("Tunai")
                 }.tag(1)
                VStack(){
                    
                }.tabItem {
                   Image(systemName: "list.bullet")
                   Text("Non tunai")
                }.tag(1).background(.white).padding()
            }
        }
    }
}

struct PaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodView()
    }
}
