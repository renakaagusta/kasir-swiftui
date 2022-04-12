import SwiftUI

struct HistoryView: View {
    
    @State var transactionModels: [Transaction] = []
    @State var transaction: Transaction?
    @State var transactionItemList: [TransactionItem] = []
    @State var itemList: [Item] = []
    let dateFormatterPrint = DateFormatter()
    
    var body: some View {
        VStack {
            HStack {
                VStack (){
                    Text("Riwayat Transaksi").font(Font.headline.weight(.bold))
                    List (transactionModels) { transaction in
                      Button (action: {
                          self.transaction = transaction
                          transactionItemList = TransactionItemDBManager().getTransactionItemsByTransaction(transactionIdValue: transaction.id)
                      }) {
                          HStack {
                              Text(dateFormatterPrint.string(from: transaction.date))
                            Spacer()
                              Text("Total: Rp. "+String(transaction.totalPrice)).foregroundColor(Color.black)
                        }
                      }.foregroundColor(self.transaction != nil ? (self.transaction!.id == transaction.id ? .white : .blue) : .blue).background(self.transaction != nil ? (self.transaction!.id == transaction.id ? .blue : .white) : .white)
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading).background(.white).onAppear{
                    self.transactionModels = TransactionDBManager().getTransactions()
                    print(transactionModels)
                }
                VStack {
                    if(transaction != nil) {
                        VStack(alignment: .leading) {
                            Text("Detail Transaksi").font(Font.headline.weight(.bold))
                            Spacer().frame(height: 20)
                            Text("Tanggal")
                                .font(Font.headline.weight(.bold))
                            Text(DateFormatter().string(from: transaction!.date))
                            Text("Total Pembayaran")
                                .font(Font.headline.weight(.bold))
                            Text("Rp "+String(transaction!.totalPrice))
                            Text("Metode Pembayaran")
                                .font(Font.headline.weight(.bold))
                            Text(transaction?.paymentMethod == "Cashless" ? "Non tunai" : "Tunai")
                            if(transaction?.paymentMethod == "Cashless") {
                                Image(cashlessPaymentChannelList.first(where: { $0.id == transaction?.cashlessChannel})!.image).resizable().frame( width: 140,height: 100)
                            }
                            List (transactionItemList) { transactionItem in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(itemList.first(where: {$0.id == transactionItem.itemId})!.name)
                                        Text("Jumlah: "+String(transactionItem.quantity))
                                    }
                                    Spacer()
                                    Text("Rp "+String(transactionItem.quantity * itemList.first(where: {$0.id == transactionItem.itemId})!.price))
                              }

                            }.background(.white)
                        }
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading).background(.white).padding()
            }
        }.onAppear{
            let items = ItemDBManager().getItems()
            
            itemList = items
            self.dateFormatterPrint.dateFormat = "hh:mm, d MMMM yyyy"
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
