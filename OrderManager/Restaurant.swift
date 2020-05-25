//
//  Restaurant.swift
//  OrderManager
//
//  Created by 何忆源 on 2020/5/25.
//  Copyright © 2020 何忆源. All rights reserved.
//




import Foundation

//餐厅模型类
class Restaurant: NSObject
{
    
    let id:Int         //id
    let name:String    //名字
    
    
    //构造函数
    init(id:Int, name:String )
    {
        self.id = id
        self.name = name
    }
    
}





