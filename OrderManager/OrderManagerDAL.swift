//
//  OrderManagerDAL.swift
//  OrderManager
//
//  Created by 何忆源 on 2020/5/25.
//  Copyright © 2020 何忆源. All rights reserved.
//

import Foundation

import UIKit

//数据库实现类
class OrderManagerDAL
{
    
    //初始化数据库
    static func initDB()
    {
        let sqlite = SQLiteManager.sharedInstance
        
        if !sqlite.openDB() { return }
        
        //创建餐厅表restaurant
        let createsqlForRestaurant = "CREATE TABLE IF NOT EXISTS restaurant('id'  INTERGER NOT NULL PRIMARY KEY, 'name' TEXT);"
        //创建菜品表dish
        let createsqlForDish = "CREATE TABLE IF NOT EXISTS dish('dish_id' INTERGER  NOT NULL PRIMARY KEY, 'restaurant_id' INTERGER, 'name' TEXT, 'price' REAL, 'pic' BLOB, 'info' TEXT, 'count' INTERGER, FOREIGN KEY(restaurant_id) REFERENCES restaurant(id));"
        if !sqlite.execNoneQuerySQL(sql: createsqlForRestaurant)
        {
            sqlite.closeDB()
            return
        }
        if !sqlite.execNoneQuerySQL(sql: createsqlForDish)
        {
            sqlite.closeDB()
            return
        }
        
        
        //在餐厅表restaurant中插入快餐店、甜品店、饮品店
        let fastFoodRestaurant = "INSERT OR REPLACE INTO restaurant(id, name) VALUES(1,'KFC');"
        let dessertRestaurant = "INSERT OR REPLACE INTO restaurant(id, name) VALUES(2,'马先生甜品');"
        let drinkRestaurant = "INSERT OR REPLACE INTO restaurant(id, name) VALUES(3,'一点点');"
        if !sqlite.execNoneQuerySQL(sql: fastFoodRestaurant)
        {
            sqlite.closeDB()
            return
        }
        if !sqlite.execNoneQuerySQL(sql: dessertRestaurant)
        {
            sqlite.closeDB()
            return
        }
        if !sqlite.execNoneQuerySQL(sql: drinkRestaurant)
        {
            sqlite.closeDB()
            return
        }
        
    
        //在菜品表dish中插入KFC菜品
        let hamburger = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(1,1,'鸡腿堡',8.8,'选用超大无骨鸡腿肉烤制，鲜嫩多汁，甜中带辣。',0);"
        let chickenLeg = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(2,1,'吮指原味鸡',2.99,'香辣多汁，口感鲜美',0);"
        let pizza = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(3,1,'鸡米花',9.9,'将鸡腿肉加工成小巧造型，用经典的香辣腌料，手工裹上优质面粉，炸至金黄喷香。',0);"
        let frenchFries = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(4,1,'薯条',3.8,'优质土豆，外表黄金诱人',0);"
        let soup = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(5,1,'蔬菜汤',10.0,'奶油蘑菇汤是搭配披萨的好伴侣，汤味醇厚，适口易饮，舌舔唇边回味无穷。',0);"
        if !sqlite.execNoneQuerySQL(sql: hamburger)
        {
                   sqlite.closeDB()
                   return
        }
        if !sqlite.execNoneQuerySQL(sql: chickenLeg)
        {
                   sqlite.closeDB()
                   return
        }
        if !sqlite.execNoneQuerySQL(sql: pizza)
        {
                   sqlite.closeDB()
                   return
        }
        if !sqlite.execNoneQuerySQL(sql: frenchFries)
        {
                   sqlite.closeDB()
                   return
        }
        if !sqlite.execNoneQuerySQL(sql: soup)
        {
                   sqlite.closeDB()
                   return
        }
        
        
        //在菜品表dish中插入甜品店菜品
        let iceCream = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(6,2,'圣代',4.9,'日本白桃冰淇淋，北美蓝莓果酱',0);"
        let smoothies = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(7,2,'水果捞',16.0,'一碗刚刚好，每天一碗补充维生素～',0);"
        let cake = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(8,2,'雪媚娘',8.8,'进口安佳动物奶油',0);"
        if !sqlite.execNoneQuerySQL(sql: iceCream)
        {
            sqlite.closeDB()
            return
        }
        if !sqlite.execNoneQuerySQL(sql: smoothies)
        {
            sqlite.closeDB()
            return
        }
        if !sqlite.execNoneQuerySQL(sql: cake)
        {
            sqlite.closeDB()
            return
        }
        
        
        //在菜品表dish中插入饮品店菜品
        let tea = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(9,3,'抹茶',10.0,'口感清新，回味浓郁。',0);"
        let juice = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(10,3,'蜂蜜绿',8.8,'茉莉绿茶与蜂蜜完美搭配，喝在口，甜在心！',0);"
        let redWine = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(11,3,'养乐多',6.6,'养乐多绿限制作冷饮，以保存养乐多活性乳酸菌',0);"
        let cocktail = "INSERT OR REPLACE INTO dish(dish_id, restaurant_id, name, price, info, count) VALUES(12,3,'百香绿',8.8,'茉莉绿茶搭配特制百香风味果汁，清新怡人。',0);"
        if !sqlite.execNoneQuerySQL(sql: tea)
        {
            sqlite.closeDB()
            return
        }
        if !sqlite.execNoneQuerySQL(sql: juice)
        {
            sqlite.closeDB()
            return
        }
        if !sqlite.execNoneQuerySQL(sql: redWine)
        {
            sqlite.closeDB()
            return
        }
        if !sqlite.execNoneQuerySQL(sql: cocktail)
        {
            sqlite.closeDB()
            return
        }
        
        sqlite.closeDB()
    }
    
    
    //获取餐厅表restaurant中所有的餐厅
    static func GetRestaurant() ->[Restaurant]?
    {
        let sqlite = SQLiteManager.sharedInstance

        if !sqlite.openDB() { return nil }
        
        let queryResult = sqlite.execQuerySQL(sql: "SELECT * FROM restaurant")
        var restaurants:[Restaurant] = []
        for row in queryResult!
        {
            let id = row["id"] as! Int
            let name = row["name"] as! String
            let result = Restaurant.init(id: id, name: name)
            restaurants.append(result)
        }
        
        sqlite.closeDB()
        return restaurants
    }
    
    
    //获取菜品表dish中所有菜品
    static func GetAllDishes() -> [Dish]?
    {
        let sqlite = SQLiteManager.sharedInstance
        
        if !sqlite.openDB() { return nil }
        
        let queryResult = sqlite.execQuerySQL(sql: "SELECT * FROM dish")
        var dishes:[Dish] = []
        for row in queryResult!
        {
            let dish_id = row["dish_id"] as! Int
            let restaurant_id = row["restaurant_id"] as! Int
            let name = row["name"] as! String
            let price = row["price"] as! Double
            let info = row["info"] as! String
            let count = row["count"] as! Int
            let dish = Dish.init(dish_id: dish_id, restaurant_id: restaurant_id, name: name, price: price, pic: UIImage.init(named: "appicon")!, info: info, count: count)
            dishes.append(dish)
        }
        
        sqlite.closeDB()
        return dishes
    }
    
    
    //从菜品表dish中获取指定餐厅内的所有菜品
    static func GetDish(restaurant_id:Int) -> [Dish]?
    {
        let sqlite = SQLiteManager.sharedInstance
        
        if !sqlite.openDB() { return nil }
        
        let queryResult =  sqlite.execQuerySQL(sql: "SELECT * FROM dish WHERE restaurant_id == \(restaurant_id)")
        var dishes:[Dish] = []
        for row in queryResult!
        {
            let dish_id = row["dish_id"] as! Int
            let restaurant_id = row["restaurant_id"] as! Int
            let name = row["name"] as! String
            let price = row["price"] as! Double
            let info = row["info"] as! String
            let count = row["count"] as! Int
            let dish = Dish.init(dish_id: dish_id, restaurant_id: restaurant_id, name: name, price: price, pic: UIImage.init(named: "appicon")!, info: info, count: count)
            dishes.append(dish)
        }
        
        sqlite.closeDB()
        return dishes
    }
    
    
    //将对应菜品的图片存到菜品表dish中
    static func SaveImage(dish_id:Int, img:UIImage?)
    {
        if img == nil { return }
        
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() { return }
        
        let sql = "UPDATE dish SET pic = ? WHERE dish_id = \(dish_id)"
        let data = img!.jpegData(compressionQuality: 1.0) as NSData?
        sqlite.execSaveBlob(sql: sql, blob: data!)
        
        sqlite.closeDB()
    }
    
    
    //将对应菜品的图片从菜品表dish中取出来
    static func LoadImage(dish_id:Int) -> UIImage
    {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() { return UIImage(named:"appicon")! }
        
        let sql = "SELECT pic FROM dish WHERE dish_id = \(dish_id)"
        let data = sqlite.execLoadBlob(sql: sql)
        sqlite.closeDB()
        
        if data != nil
        {
            return UIImage(data: data!)!
        }
        else
        {
            return UIImage(named: "appicon")!
        }
    }
    
}
