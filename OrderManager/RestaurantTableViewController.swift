//
//  RestaurantTableViewController.swift
//  OrderManager
//
//  Created by 何忆源 on 2020/5/25.
//  Copyright © 2020 何忆源. All rights reserved.
//

import UIKit


class RestaurantTableViewController: UITableViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //初始化数据库
        OrderManagerDAL.initDB()
        //获取所有菜品
        let allDishes = OrderManagerDAL.GetAllDishes()!
        
        //将所有菜品对应的图片存到菜品表dish中
        for dish in allDishes
        {
            OrderManagerDAL.SaveImage(dish_id: dish.dish_id, img: UIImage(named: "\(dish.dish_id)"))
        }
    }

    
    // MARK: - Table view data source
    //实现cell
    //返回菜品cell数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let restaurants = OrderManagerDAL.GetRestaurant()
       return restaurants!.count
    
    }

    
    //返回cell内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurants = OrderManagerDAL.GetRestaurant()
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRestaurant", for: indexPath)
        cell.textLabel?.text = restaurants?[indexPath.row].name
        
        return cell
    }
    
    
    // MARK: - Navigation
    //为转场做准备
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dishesTableViewController = segue.destination as? DishesTableViewController
            else { return }

        //将选定的餐厅传递给菜单页
        let restaurants = OrderManagerDAL.GetRestaurant()
        let indexPath = self.tableView.indexPathForSelectedRow
        dishesTableViewController.restaurant = restaurants![indexPath!.row]
    }
    
}
