//
//  DishDetailViewController.swift
//  OrderManager
//
//  Created by 何忆源 on 2020/5/25.
//  Copyright © 2020 何忆源. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController
{
    
    //在菜单页选定的菜品
    var filterDish:Dish?
    //增加菜品到订单页的委托实例
    var addItemDelegate : AddItemDelegate?
    
    
    //菜品的图片
    @IBOutlet weak var detailImageView: UIImageView!
    //菜品选购的数量
    @IBOutlet weak var countLabel: UILabel!
    //菜品的名字
    @IBOutlet weak var nameLabel: UILabel!
    //菜品的价格
    @IBOutlet weak var priceLabel: UILabel!
    //菜品的详情信息
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //实例化一个订单页，从而实现选购菜品的功能
        let orderTableViewController = OrderTableViewController()
        addItemDelegate = orderTableViewController

        //输出菜品的信息
        if let dish = filterDish
        {
            countLabel.text = "\(dish.count)"
            nameLabel.text = dish.name
            priceLabel.text = "$\(dish.price)"
            infoLabel.text = dish.info
            detailImageView.image = OrderManagerDAL.LoadImage(dish_id: dish.dish_id)
        }
    }
    
    
    //点击返回菜单按钮，回到菜单页
     @IBAction func closedButtonPressed(_ sender: Any)
     {
           dismiss(animated: true, completion: nil)
        
    }
       
    
    //点击➕按钮，增加菜品的选购数量
     @IBAction func addButtonPressed(_ sender: Any)
     {
        if let dish = filterDish
        {
            dish.count += 1
            countLabel.text = "\(dish.count)"
            addItemDelegate!.addItem(dish_id: dish.dish_id, count: dish.count)
        }
    }
       
    
    //点击➖按钮，减少菜品的选购数量
     @IBAction func subButtonPressed(_ sender: Any)
     {
          if let dish = filterDish
          {
            if dish.count > 0      //当菜品选购数量大于0时减少菜品的数量
            {
                dish.count -= 1
                countLabel.text = "\(dish.count)"
                addItemDelegate!.addItem(dish_id: dish.dish_id, count: dish.count)
            }
          }
      }
    
}
