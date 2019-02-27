//
//  FMDBTool.swift
//  Base
//
//  Created by daihz on 2018/5/2.
//  Copyright © 2018年 daihz. All rights reserved.
//

import UIKit
import FMDB

class GDBManager: NSObject {
    
    // MARK: - Once
    static let shareGDBManager  = GDBManager()
    
    func dbFilePath() -> String{
        return documentsPath + "/bluetoothInfo.sqlite"
    } 
    
    // MARK: - Action
    /// 创建数据库
    ///
    /// - Returns: 数据库对象
    func  database() -> FMDatabase {
        return FMDatabase.init(path: dbFilePath())
    }

    /// 创建表 
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - fieldKeysAndTypes: [字段:类型]
    func creatTable(tableName: String, fieldKeysAndTypes: NSDictionary) {
        let db = database()
        if db.open() {
            var sql = "CREATE TABLE IF NOT EXISTS " + tableName + "(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
            let keys = fieldKeysAndTypes.allKeys as! [String]
            for i in 0..<keys.count {
                if i != keys.count - 1 {
                    sql = sql + keys[i] + " " + (fieldKeysAndTypes[keys[i]] as! String)   + ", "
                }else{
                    sql = sql + keys[i] + " " + (fieldKeysAndTypes[keys[i]]as! String)   + ")"
                }
            }
            do {
                try db.executeUpdate(sql, values: nil)
            }catch{
                printg(db.lastErrorMessage())
            }
        }
    }

    /// 查询表是否存在
    ///
    /// - Parameter tableName: 表名
    /// - Returns: 查询结果
    func tableExists(tableName: String) -> Bool {
        let db = database()
        if db.open() {
        return db.tableExists(tableName)
        }else{
            return false
        }
    }
    
    /// 查询是表内是否包含指定字段   
    ///
    /// - Parameters:
    ///   - columnName: 字段名
    ///   - tableName: 表名
    /// - Returns: 查询结果
    func columnExists(columnName: String, tableName: String) -> Bool {
        let db = database()
        if db.open() {
        return db.columnExists(columnName, inTableWithName: tableName)
        }else{
            return false
        }
    }
    
    /// 添加数据    
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - dicFields: 需要添加的数据
    func insertDataToTable(tableName: String, dicFields: NSDictionary) {
        let db = database()
        if db.open() {
            let arFieldsKeys:[String] = dicFields.allKeys as! [String]
            let arFieldsValues:[Any] = dicFields.allValues
            var sqlUpdatefirst = "INSERT INTO '" + tableName + "' ("
            var sqlUpdateLast = " VALUES("
            for i in 0..<arFieldsKeys.count {
                if i != arFieldsKeys.count-1 {
                    sqlUpdatefirst = sqlUpdatefirst + arFieldsKeys[i] + ","
                    sqlUpdateLast = sqlUpdateLast + "?,"
                }else{
                    sqlUpdatefirst = sqlUpdatefirst + arFieldsKeys[i] + ")"
                    sqlUpdateLast = sqlUpdateLast + "?)"
                }
            }
            do{
                try db.executeUpdate(sqlUpdatefirst + sqlUpdateLast, values: arFieldsValues)                
            }catch{
                printg(db.lastErrorMessage())
            }
            
        }
    }
    
    /// 删除数据
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - FieldKey: 过滤的表字段
    ///   - FieldValue: 过滤表字段对应的值
    func deleteFromTable(tableName: String, FieldKey: String, FieldValue: [Any], append key: String? = nil) {
        let db = database()
        if db.open() {
            let  sql = "DELETE FROM '" + tableName + "' WHERE " + FieldKey + " = ?" + ((key != nil) ? key! + " = ?" : "")
            do{
                try db.executeUpdate(sql, values: FieldValue)
            }catch{
                printg(db.lastErrorMessage())
            }
        }
    }
        
    /// 删除数据并清空自增值
    ///
    /// - Parameter tableName: 表名
    func deleteAllDataFromTable(tableName: String) {
        let db = database()
        if db.open() {
            //删除表数据
            let  sql = "DELETE FROM '" + tableName + "'"
            //自增值清空
            let sql1 = "UPDATE sqlite_sequence set seq=0 where name='\(tableName)'"
            do{
                try db.executeUpdate(sql, values: nil)
                try db.executeUpdate(sql1, values: nil)
            }catch{
                printg(db.lastErrorMessage())
            }
        } 
    }
    
    /// 修改数据
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - dicFields: key为表字段，value为要修改的值
    ///   - ConditionsKey: 过滤筛选的字段
    ///   - ConditionsValue: 过滤筛选字段对应的值
    /// - Returns: 操作结果 true为成功，false为失败
    @discardableResult
    func modifyToData(tableName: String , dicFields: NSDictionary, ConditionsKey: String, ConditionsValue: Any) -> (Bool) {
        var result:Bool = false
        let arFieldsKey : [String] = dicFields.allKeys as! [String]
        var arFieldsValues:[Any] = dicFields.allValues
        arFieldsValues.append(ConditionsValue)
        var sqlUpdate  = "UPDATE " + tableName +  " SET "
        for i in 0..<dicFields.count {
            if i != arFieldsKey.count - 1 {
                sqlUpdate = sqlUpdate + arFieldsKey[i] + " = ?,"
            }else {
                sqlUpdate = sqlUpdate + arFieldsKey[i] + " = ?"
            }
        }
        sqlUpdate = sqlUpdate + " WHERE " + ConditionsKey + " = ?"
        let db = database()
        if db.open() {
            do{
                try db.executeUpdate(sqlUpdate, values: arFieldsValues)
                result = true
            }catch{
                printg(db.lastErrorMessage())
            }
        }
        return result
    }
    
    //MARK: - 查询数据
    /// 查询数据
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - arFieldsKey: 要查询获取的表字段
    /// - Returns: 返回相应数据
    func selectFromTable(tableName: String, wheres: String, arFieldsKey: NSArray) -> [NSMutableDictionary] {
        let db = database()
        var arFieldsValue = [NSMutableDictionary]()
        let sql = "SELECT * FROM " + tableName + (wheres.isEmpty == true ? "" : (" WHERE " + wheres))
        if db.open() {
            do{
                let rs = try db.executeQuery(sql, values: nil)
                while rs.next() {
                    var dicFieldsValue :NSMutableDictionary = [:]
                    if arFieldsKey.count == 0 {
                        dicFieldsValue  = rs.columnNameToIndexMap
                    }else{
                        for i in 0..<arFieldsKey.count {
                            dicFieldsValue.setObject(rs.string(forColumn: arFieldsKey[i] as! String) ?? "", forKey: arFieldsKey[i] as! NSCopying)
                        }
                    }
                    arFieldsValue.append(dicFieldsValue)
                }
            }catch{
                printg(db.lastErrorMessage())
            }
            
        }
        return arFieldsValue
    }
    
    /// 删除表
    ///
    /// - Parameter tableName: 表名
    func removeTable(tableName: String) {
        let db = database()
        if db.open() {
            let  sql = "DROP TABLE " + tableName
            do{
                try db.executeUpdate(sql, values: nil)
            }catch{
                printg(db.lastErrorMessage())
            }
        }
        
    }
    
    /// 新增加表字段
    ///
    /// - Parameter tableName: 表名
    func changeTableWay(tableName: String, addField: String, addFieldType: String) {
        let db = database()
        if db.open() {
            let sql  = "ALTER TABLE " + tableName + " ADD " + addField + " " + addFieldType
            do{
                try db.executeUpdate(sql, values: nil)
            }catch{
                printg(db.lastErrorMessage())
            }
        }
    }
    
}
