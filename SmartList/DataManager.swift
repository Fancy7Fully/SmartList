//
//  DataManager.swift
//  SmartList
//
//  Created by Zhiyuan Zhou on 10/15/23.
//

import Foundation
import SQLite

class DataManager {
    static let shared = DataManager()
    
    private let handlingQueue = DispatchQueue(label: "data.serial.queue")
    private var db: Connection?
    private let itemsTable = Table("Items")
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let status = Expression<Int64>("status")
    private let notes = Expression<String?>("notes")
    private let creationTime = Expression<Double>("creationTime")
    private let subItems = Expression<String?>("subItems")
    
    init() {
        
    }
    
    func readFromTable() {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        do {
            db = try Connection("\(path)/itemsDb.sqlite3")
            
            try db?.run(itemsTable.create(ifNotExists:true) { t in     // CREATE TABLE "Items" (
                t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(name)                 //     "name" TEXT
                t.column(status)
                t.column(notes)
                t.column(creationTime)
                t.column(subItems)
            })
            
            let exists = try db?.scalar(itemsTable.exists) ?? false
//            if !exists {
                insertFromMockData()
//            }
            
            if let items = try db?.prepare(itemsTable) {
                for item in items {
                    print("id: \(item[id]), email: \(item[creationTime]), name: \(item[name])")
                }
            }
            
//            try db?.run(itemsTable.drop())
//
//            if let items = try db?.prepare(itemsTable) {
//                for item in items {
//                    print("id: \(item[id]), email: \(item[creationTime]), name: \(item[name])")
//                }
//            }
        } catch {
            print(error)
        }
    }
    
    func insertFromMockData() {
        let mockData = MockModel()
        mockData.items.forEach { item in
            try? db?.run(itemsTable.insert(name <- item.name, status <- 0, creationTime <- NSDate().timeIntervalSince1970))
        }
    }
    
    func modelFromDatabase() -> Model {
        do {
            if let items = try db?.prepare(itemsTable) {
                return Model(items: items.map({ item in
                    return Item(id: Int(item[id]), name: item[name], state: Item.State(rawValue: Int(item[status])) ?? .unchecked)
                }))
            }
        } catch {
            print(error)
        }
        return Model(items: [])
    }
    
    func updateRow(itemId: Int, item: Item) {
        handlingQueue.async {[weak self] in
            guard let self = self else { return }
            do {
                let row = self.itemsTable.filter(self.id == Int64(itemId))
                try db?.run(row.update(self.name <- item.name, self.status <- Int64(item.state.rawValue)))
            } catch {
                print(error)
            }
        }
    }
}

struct MockModel {
    var items: [Item] = [
        Item(name: "HamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburgerHamburger"),
        Item(name: "Brocolli"),
        Item(name: "Cheese"),
        Item(name: "Iron"),
        Item(name: "Hamburger"),
        Item(name: "Brocolli"),
        Item(name: "Cheese"),
        Item(name: "Iron"),
        Item(name: "Hamburger"),
        Item(name: "Brocolli"),
        Item(name: "Cheese"),
        Item(name: "Iron"),
        Item(name: "Hamburger"),
        Item(name: "Brocolli"),
        Item(name: "Cheese"),
        Item(name: "Iron"),
        Item(name: "Hamburger"),
        Item(name: "Brocolli"),
        Item(name: "Cheese"),
        Item(name: "Iron"),
        Item(name: "Hamburger"),
        Item(name: "Brocolli"),
        Item(name: "Cheese"),
        Item(name: "Iron")
    ]
}
