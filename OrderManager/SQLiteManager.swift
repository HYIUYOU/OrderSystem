//
//  SQLiteManager.swift
//  OrderManager
//
//  Created by 何忆源 on 2020/5/25.
//  Copyright © 2020 何忆源. All rights reserved.
//

import Foundation

//数据库封装类
class SQLiteManager:NSObject
{
    
    private var dbPath:String!
    private var database:OpaquePointer? = nil
    
    
    static var sharedInstance:SQLiteManager
    {
        return SQLiteManager()
    }
    
    
    //重写构造函数
    override  init()
    {
        super.init()
        
        let dirpath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        dbPath = dirpath.appendingPathComponent("OrderManager.sqlite").path
        
    }
    
    
    //打开数据库
    func openDB() -> Bool
    {
        let result = sqlite3_open(dbPath, &database)
        
        if result != SQLITE_OK
        {
            return false
        }
        
        return true
    }
    
    
    //关闭数据库
    func closeDB()
    {
        sqlite3_close(database)
    }
    
    
    //执行数据库操作：增删改
    func execNoneQuerySQL(sql:String) -> Bool
    {
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let cSql = sql.cString(using: String.Encoding.utf8)!
       
        if sqlite3_exec(database, cSql, nil, nil, &errMsg) == SQLITE_OK
        {
            return true
        }
        let msg = String.init(cString: errMsg!)
        print(msg)
        
        return false
    }
    
    
    //执行数据库操作：查
    func execQuerySQL(sql:String) -> [[String: AnyObject]]?
    {
        let cSql = sql.cString(using: String.Encoding.utf8)!
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, cSql, -1, &statement, nil) != SQLITE_OK
        {
            sqlite3_finalize(statement)
            
            print("执行\(sql)错误\n")
            let errmsg = sqlite3_errmsg(database)
            if errmsg != nil
            {
                print(errmsg!)
            }
            
            return nil
        }
        
        var rows = [[String: AnyObject]]()
        
        while sqlite3_step(statement) == SQLITE_ROW {
            rows.append(record(stmt: statement!))
        }
        
        sqlite3_finalize(statement)
        
        return rows
    }
    
    
    
    private func record(stmt: OpaquePointer) -> [String: AnyObject]
    {
        var row = [String: AnyObject]()
        
        for col in 0 ..< sqlite3_column_count(stmt)
        {
            let cName = sqlite3_column_name(stmt, col)
            let name = String(cString: cName!, encoding: String.Encoding.utf8)
            
            var value: AnyObject?
            
            switch (sqlite3_column_type(stmt, col))
            {
            case SQLITE_FLOAT:
                value = sqlite3_column_double(stmt, col) as AnyObject
            case SQLITE_INTEGER:
                value = Int(sqlite3_column_int(stmt, col)) as AnyObject
            case SQLITE_TEXT:
                let cText = sqlite3_column_text(stmt, col)
                value = String.init(cString: cText!) as AnyObject
            case SQLITE_NULL:
                value = NSNull()
            default:
                print("")
            }
            row[name!] = value ?? NSNull()
        }
        
        return row
    }
    
    
    //存储Blob数据
    func execSaveBlob(sql:String, blob:NSData)
    {
        let csql = sql.cString(using: .utf8)!
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, csql, -1, &statement, nil) != SQLITE_OK
        {
            sqlite3_finalize(statement)
            print("Prepare error:\(sql)")
            return
        }
        
        let paramsCnt = sqlite3_bind_parameter_count(statement)
        if paramsCnt != 1
        {
            print("need only 1 parameter:\(sql)")
            sqlite3_finalize(statement)
            return
        }
        
        if sqlite3_bind_blob(statement, 1, blob.bytes, Int32(blob.length), nil) != SQLITE_OK
        {
            print("bind blob error:\(sql)")
            sqlite3_finalize(statement)
            return
        }
        
        let rslt = sqlite3_step(statement)
        if rslt != SQLITE_OK && rslt != SQLITE_DONE
        {
            print("extue blob error:\(sql)")
            sqlite3_finalize(statement)
            return
        }
        
        sqlite3_finalize(statement)
        return
        
    }
    
    
    //读取Blob数据
    func execLoadBlob(sql:String) -> Data?
    {
        let csql =  sql.cString(using: String.Encoding.utf8)!
        var statement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, csql, -1, &statement, nil) != SQLITE_OK
        {
            sqlite3_finalize(statement)
            print("执行\(sql)错误\n")
            if let errmsg = sqlite3_errmsg(database)
            {
                print(errmsg)
            }
            return nil
        }
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            if let dataBlob = sqlite3_column_blob(statement, 0)
            {
                let dataBlobLength = sqlite3_column_bytes(statement, 0)
                let data = Data(bytes: dataBlob, count: Int(dataBlobLength))
                sqlite3_finalize(statement)
                return data
            }
        }
        
        sqlite3_finalize(statement)
        return nil
    }
    
}





