import Foundation

import SQLite
 
class TransactionDBManager {
    
    private var db: Connection?
    
    let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    let fm = FileManager.default
     
    private var transactions: Table!
 
    private var id: Expression<Int>!
    private var date: Expression<Date>!
    private var totalPrice: Expression<Int>!
    private var paymentMethod: Expression<String>!
    private var cashlessCannel: Expression<Int>!
     
    init () {
        do {
            db = try Connection("\(path)/cashier.sqlite3")
             
            transactions = Table("transactions")
             
            id = Expression<Int>("id")
            date = Expression<Date>("date")
            totalPrice = Expression<Int>("totalPrice")
            paymentMethod = Expression<String>("paymentMethod")
            cashlessCannel = Expression<Int>("cashlessCannel")

            if (!UserDefaults.standard.bool(forKey: "is_transaction_table_created")) {
                do {
                    try db?.run(transactions.create { (t) in
                        t.column(id, primaryKey: true)
                        t.column(date)
                        t.column(totalPrice)
                        t.column(paymentMethod)
                        t.column(cashlessCannel)
                    })
                } catch let error {
                    print(error)
                }
                 
                UserDefaults.standard.set(true, forKey: "is_transaction_table_created")
            }
             
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func addTransaction(dateValue: Date, totalPriceValue: Int, paymentMethodValue: String, cashlessCannelValue: Int) -> Int {
        do {
            print("cashless cannel")
            print(cashlessCannelValue)
            try db?.run(transactions.insert(date <- dateValue, totalPrice <- totalPriceValue, paymentMethod <- paymentMethodValue, cashlessCannel <- cashlessCannelValue))
            return Int(db?.lastInsertRowid ?? 0)
        } catch {
            print(error)
            return 0
        }
    }
    
    public func getTransactions() -> [Transaction] {
        var transactionModels: [Transaction] = []
     
        transactions = transactions.order(id.desc)
     
        do {
            if(db != nil) {
                for transaction in try db!.prepare(transactions) {
         
                    var transactionModel: Transaction = Transaction()
         
                    transactionModel.id = transaction[id]
                    transactionModel.date = transaction[date]
                    transactionModel.totalPrice = transaction[totalPrice]
                    transactionModel.paymentMethod = transaction[paymentMethod]
                    transactionModel.cashlessChannel = 0
         
                    transactionModels.append(transactionModel)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return transactionModels
    }
    
    public func getTransaction(idValue: Int) -> Transaction {
        var transactionModel: Transaction = Transaction()
        
        do {
            if(db != nil) {
                var transaction: AnySequence<Row> = try db!.prepare(transactions.filter(id == idValue))
         
                try transaction.forEach({ (rowValue) in
                    transactionModel.id = try rowValue.get(id)
                    transactionModel.date = try rowValue.get(date)
                    transactionModel.totalPrice = try rowValue.get(totalPrice)
                    transactionModel.paymentMethod = try rowValue.get(paymentMethod)
                    transactionModel.cashlessChannel = try rowValue.get(cashlessCannel)
                })
            }
        } catch {
            print(error)
        }
        
        return transactionModel
    }
    
    public func updateTransaction(idValue: Int, totalPriceValue: Int, paymentMethodValue: String, cashlessCannelValue: Int) {
        do {
            let transaction: Table = transactions.filter(id == idValue)
            
            try db?.run(transaction.update(totalPrice <- totalPriceValue, paymentMethod <- paymentMethodValue, cashlessCannel <- cashlessCannelValue))
        } catch {
            print(error)
        }
    }
    
    public func deleteTransaction(idValue: Int) {
        do {
            let transaction: Table = transactions.filter(id == idValue)
             
            try db?.run(transaction.delete())
        } catch {
            print(error)
        }
    }
}
