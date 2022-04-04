import SwiftUI

struct HistoryView: View {
    
    @State var transactionModels: [Transaction] = []
    
    var body: some View {
        VStack (){
            List (transactionModels) { transaction in
              Button (action: {
                  print(transaction.id)
              }) {
                  HStack {
                      Text(DateFormatter().string(from: transaction.date))
                    Spacer()
                      Text("Total: Rp. "+String(transaction.totalPrice))
                }
              }
            }
        }.onAppear{
            self.transactionModels = TransactionDBManager().getTransactions()
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
