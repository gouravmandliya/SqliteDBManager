//
//  DBmanager2.swift
//  Sqlite Demo
//
//  Created by Gourav on 15/03/20.
//  Copyright © 2020 Gourav. All rights reserved.
//

import UIKit
import FMDB //  Install ( pod 'FMDB' ) before use


class DBManager: NSObject {

    static let shared:DBManager = DBManager()
    let dataBaseFileName = "Local.sqlite"
    var databasePath : String!
    var DB :FMDatabase!
    
    override init(){
        super.init()
        let documentDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        databasePath = documentDirectory.appending("/\(dataBaseFileName)")
        print(documentDirectory)
    }
    
    // Create Table
    func createDatabaseTable()  {
        if !FileManager.default.fileExists(atPath: databasePath) {
            DB = FMDatabase(path:databasePath!)
            if DB != nil {
                if DB.open() {
                    do{
                        try DB.executeUpdate(DBManager.SQLCreate, values: nil)
                        print("Database created")
                    }
                    catch{
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    DB.close()
                }
                else{
                    print("Could not open the database.")
                }
            }
        }
    }
    // Check database exists
    func openDataBase() -> Bool {
        if DB == nil {
            if FileManager.default.fileExists(atPath: databasePath) {
                DB = FMDatabase(path:databasePath)
            }
        }
        if DB != nil {
            if DB.open() {
                return true
            }
        }
        return false
    }
    // insert data
    func insertIntoLocalDatabase(data:[Json4Swift_Base]) {
        if openDataBase() {
            for itme in data{
                do{
                    try DB.executeUpdate(DBManager.SQLInsert, values: [itme.title ?? "",itme.url ?? "",itme.thumbnailUrl ?? ""])
                }
                catch{
                    print("Could not Insert Detail.")
                    print(error.localizedDescription)
                }
            }
        }
        DB.close()
    }
    // fetch data
    func fetchFromLocalDatabase() -> [Json4Swift_Base] {
        var sqliteData = [Json4Swift_Base]()
        if openDataBase() {
            do{
                let results = try DB.executeQuery(DBManager.SQLSelect, values: nil)
                while results.next() {
                    
                    let title = results.string(forColumnIndex: 1)
                    let url = results.string(forColumnIndex: 2)
                    let thumburl = results.string(forColumnIndex: 3)
                    let data = Json4Swift_Base(title: title ?? "", url: url ?? "", thumburl: thumburl ?? "")
                    sqliteData.append(data)
                }
            }
            catch{
                print(error.localizedDescription)
            }
            DB.close()
        }
        return sqliteData
    }
    // update data
    func updateData(with id:String,title: String, url: String, thumburl: String) {
        if openDataBase() {
            do{
                try DB.executeUpdate(DBManager.SQLUpdate, values:[title,url,thumburl,id])
            }
            catch{
                print(error.localizedDescription)
            }
            DB.close()
        }
    }
    // fetch data
    func fetchSingleRowData(withID ID:Int, completionHandler:(_ studentDetail:Json4Swift_Base?) -> Void) {
        var singleRowData: Json4Swift_Base!
        
        if openDataBase() {
            
            do{
                
                let result = try DB.executeQuery(DBManager.SQLSelectSingleRow, values: [ID])
                
                if result.next() {
                    
                    let title = result.string(forColumnIndex: 0)
                    let url = result.string(forColumnIndex: 1)
                    let thumburl = result.string(forColumnIndex: 2)
                    singleRowData = Json4Swift_Base(title: title ?? "", url: url ?? "", thumburl: thumburl ?? "")
                }
                else {
                    print(DB.lastError())
                }
            }
            catch {
                print(error.localizedDescription)
            }
            DB.close()
        }
        completionHandler(singleRowData)
    }
    // delete data
    func deleteStudent(withID ID : Int) -> Bool {
        var  deleted = false
        if openDataBase() {
            do{
                try DB.executeUpdate(DBManager.SQLDelete, values: [ID])
                deleted = true
            }
            catch {
                
                print(error.localizedDescription)
            }
            DB.close()
        }
        return deleted
    }
    
    // Query for the create table.
    private static let SQLCreate = "" +
    "CREATE TABLE IF NOT EXISTS Local (" +
      "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
      "title TEXT, " +
      "url TEXT, " +
      "thumbnailurl TEXT" +
    ");"

    /// Query for the inssert row.
    private static let SQLSelect = "" +
    "SELECT " +
      "id, title, url, thumbnailurl " +
    "FROM " +
      "Local;" +
    "ORDER BY " +
      "title;"
    
    /// Query for the inssert row.
    private static let SQLSelectSingleRow = "" +
    "SELECT " +
      "id, title, url, thumbnailurl " +
    "FROM " +
      "Local;" +
    "WHERE" +
      "id = ?;"
    
    /// Query for the inssert row.
    private static let SQLDelete = "" +
    "DELETE " +
    "FROM " +
      "Local;" +
    "WHERE" +
      "id = ?;"
    
    
    /// Query for the inssert row.
    private static let SQLInsert = "" +
    "INSERT INTO " +
      "Local (title, url, thumbnailurl) " +
    "VALUES " +
      "(?, ?, ?);"

    /// Query for the update row.
    private static let SQLUpdate = "" +
    "UPDATE " +
      "Local " +
    "SET " +
      "title = ?, url = ?, thumbnailurl = ? " +
    "WHERE " +
      "id = ?;"
}
