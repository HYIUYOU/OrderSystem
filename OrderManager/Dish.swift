//
//  Dish.swift
//  OrderManager
//
//  Created by 何忆源 on 2020/5/25.
//  Copyright © 2020 何忆源. All rights reserved.
//

import Foundation

import UIKit

//菜品模型类
class Dish:NSObject
{
    
    let dish_id:Int          //id
    let restaurant_id:Int    //所属餐厅id
    let name:String          //名字
    let price:Double         //价格
    let pic:UIImage          //图片
    let info:String          //详细信息
    var count:Int            //数量
    
    
    //构造函数
    init(dish_id:Int, restaurant_id:Int, name:String, price:Double, pic:UIImage, info:String, count:Int)
    {
        self.dish_id = dish_id
        self.restaurant_id = restaurant_id
        self.name = name
        self.price = price
        self.pic = pic
        self.info = info
        self.count = count
    }
    
}




