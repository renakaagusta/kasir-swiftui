import Foundation

import SQLite
 
class ItemDBManager {
    
    private var db: Connection?
    
    let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    let fm = FileManager.default
     
    private var items: Table!
 
    private var id: Expression<Int>!
    private var name: Expression<String>!
    private var category: Expression<String>!
    private var price: Expression<Int>!
    private var quantity: Expression<Int>!
     
    init () {
        do {
            db = try Connection("\(path)/cashier.sqlite3")
             
            items = Table("items")
             
            id = Expression<Int>("id")
            name = Expression<String>("name")
            category = Expression<String>("category")
            price = Expression<Int>("price")
            quantity = Expression<Int>("quantity")

            if (!UserDefaults.standard.bool(forKey: "is_item_table_created")) {
                do {
                    try db?.run(items.create { (t) in
                        t.column(id, primaryKey: true)
                        t.column(name, unique: true)
                        t.column(category)
                        t.column(price)
                        t.column(quantity)
                    })
                } catch let error {
                    print(error)
                }
                
                for item in itemsFromJSON {
                    do {
                        try self.addItem(nameValue: item.name, categoryValue: item.category, priceValue: item.price, quantityValue: item.quantity)
                    } catch let error {
                        print(error)
                    }
                }
                 
                UserDefaults.standard.set(true, forKey: "is_item_table_created")
            }
             
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func addItem(nameValue: String, categoryValue: String, priceValue: Int, quantityValue: Int) {
        do {
            try db?.run(items.insert(name <- nameValue, category <- categoryValue, price <- priceValue, quantity <- quantityValue))
        } catch {
            print(error)
        }
    }
    
    public func getItems() -> [Item] {
        var itemModels: [Item] = []
     
        items = items.order(id.desc)
     
        do {
            if(db != nil) {
                for item in try db!.prepare(items) {
         
                    var itemModel: Item = Item()
         
                    itemModel.id = item[id]
                    itemModel.name = item[name]
                    itemModel.category = item[category]
                    itemModel.price = item[price]
                    itemModel.quantity = item[quantity]
         
                    itemModels.append(itemModel)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return itemModels
    }
    
    public func getItem(idValue: Int) -> Item {
        var itemModel: Item = Item()
        
        do {
            if(db != nil) {
                var item: AnySequence<Row> = try db!.prepare(items.filter(id == idValue))
         
                try item.forEach({ (rowValue) in
                    itemModel.id = try rowValue.get(id)
                    itemModel.name = try rowValue.get(name)
                    itemModel.category = try rowValue.get(category)
                    itemModel.price = try rowValue.get(price)
                    itemModel.quantity = try rowValue.get(quantity)
                })
            }
        } catch {
            print(error)
        }
        
        return itemModel
    }
    
    public func updateItem(idValue: Int, nameValue: String, categoryValue: String, priceValue: Int, quantityValue: Int) {
        do {
            let item: Table = items.filter(id == idValue)
            
            try db?.run(item.update(name <- nameValue, category <- categoryValue, price <- priceValue, quantity <- quantityValue))
        } catch {
            print(error)
        }
    }
    
    public func deleteItem(idValue: Int) {
        do {
            let item: Table = items.filter(id == idValue)
             
            try db?.run(item.delete())
        } catch {
            print(error)
        }
    }
    
    public func deleteDatabase() {
        do {
            db = nil
            try fm.removeItem(atPath: "\(path)/cashier.sqlite3")
            UserDefaults.standard.set(false, forKey: "is_item_table_created")
            UserDefaults.standard.set(false, forKey: "is_transaction_table_created")
            UserDefaults.standard.set(false, forKey: "is_transaction_item_table_created")
        } catch {
            print(error)
        }
    }
}
