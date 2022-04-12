import Foundation

import SQLite
 
class TransactionItemDBManager {
    
    private var db: Connection?
    
    let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    let fm = FileManager.default
     
    private var transactionItems: Table!
 
    private var id: Expression<Int>!
    private var transactionId: Expression<Int>!
    private var itemId: Expression<Int>!
    private var quantity: Expression<Int>!
     
    init () {
        do {
            db = try Connection("\(path)/cashier.sqlite3")
             
            transactionItems = Table("transactionItems")
             
            id = Expression<Int>("id")
            transactionId = Expression<Int>("transactionId")
            itemId = Expression<Int>("itemId")
            quantity = Expression<Int>("quantity")

            if (!UserDefaults.standard.bool(forKey: "is_transaction_item_table_created")) {
                do {
                    try db?.run(transactionItems.create { (t) in
                        t.column(id, primaryKey: true)
                        t.column(transactionId)
                        t.column(itemId)
                        t.column(quantity)
                    })
                } catch let error {
                    print(error)
                }
                 
                UserDefaults.standard.set(true, forKey: "is_transaction_item_table_created")
            }
             
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func addTransactionItem(itemIdValue: Int, quantityValue: Int, transactionIdValue: Int) {
        do {
            try db?.run(transactionItems.insert(transactionId <- transactionIdValue, itemId <- itemIdValue, quantity <- quantityValue))
        } catch {
            print(error)
        }
    }
    
    public func getTransactionItems() -> [TransactionItem] {
        var transactionItemModels: [TransactionItem] = []
     
        transactionItems = transactionItems.order(id.desc)
     
        do {
            if(db != nil) {
                for transactionItem in try db!.prepare(transactionItems) {
         
                    var transactionItemModel: TransactionItem = TransactionItem()
         
                    transactionItemModel.id = transactionItem[id]
                    transactionItemModel.transactionId = transactionItem[transactionId]
                    transactionItemModel.itemId = transactionItem[itemId]
                    transactionItemModel.quantity = transactionItem[quantity]
         
                    transactionItemModels.append(transactionItemModel)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return transactionItemModels
    }
    
    public func getTransactionItemsByTransaction(transactionIdValue: Int) -> [TransactionItem] {
        var transactionItemModels: [TransactionItem] = []
     
        transactionItems = transactionItems.order(id.desc)
     
        do {
            if(db != nil) {
                for transactionItem in try db!.prepare(transactionItems.filter(transactionId == transactionIdValue)) {
         
                    var transactionItemModel: TransactionItem = TransactionItem()
         
                    transactionItemModel.id = transactionItem[id]
                    transactionItemModel.transactionId = transactionItem[transactionId]
                    transactionItemModel.itemId = transactionItem[itemId]
                    transactionItemModel.quantity = transactionItem[quantity]
         
                    transactionItemModels.append(transactionItemModel)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return transactionItemModels
    }
    
    public func getTransactionItem(idValue: Int) -> TransactionItem {
        var transactionItemModel: TransactionItem = TransactionItem()
        
        do {
            if(db != nil) {
                var transactionItem: AnySequence<Row> = try db!.prepare(transactionItems.filter(id == idValue))
         
                try transactionItem.forEach({ (rowValue) in
                    transactionItemModel.id = try rowValue.get(id)
                    transactionItemModel.transactionId = try rowValue.get(transactionId)
                    transactionItemModel.itemId = try rowValue.get(itemId)
                    transactionItemModel.quantity = try rowValue.get(quantity)
                })
            }
        } catch {
            print(error)
        }
        
        return transactionItemModel
    }
    
    public func updateTransactionItem(idValue: Int, transactionIdValue: Int, itemIdValue: Int, quantityValue: Int) {
        do {
            let transactionItem: Table = transactionItems.filter(id == idValue)
            
            try db?.run(transactionItem.update(transactionId <- transactionIdValue, itemId <- itemIdValue, quantity <- quantityValue))
        } catch {
            print(error)
        }
    }
    
    public func deleteTransactionItem(idValue: Int) {
        do {
            let transactionItem: Table = transactionItems.filter(id == idValue)
             
            try db?.run(transactionItem.delete())
        } catch {
            print(error)
        }
    }
}
