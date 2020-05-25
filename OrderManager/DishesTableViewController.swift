//
//  DishesTableViewController.swift
//  OrderManager
//
//  Created by 何忆源 on 2020/5/25.
//  Copyright © 2020 何忆源. All rights reserved.
//

import UIKit

class DishesTableViewController: UITableViewController
{
    
    //在餐厅页选定的餐厅
    var restaurant:Restaurant?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //注册加载自定义cell
        let xib = UINib(nibName: "DishTableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "CellDish")
        tableView.rowHeight = 100
    }

    
    // MARK: - Table view data source
    //实现cell
    //返回cell数目
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let restaurant = self.restaurant
        let dishes = OrderManagerDAL.GetDish(restaurant_id: restaurant!.id)
       return dishes!.count
    }
    
    
    //返回cell内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDish", for: indexPath) as! DishTableViewCell

        let restaurant = self.restaurant
        let dishes = OrderManagerDAL.GetDish(restaurant_id: restaurant!.id)
        
        //输出菜品名
        cell.nameLabel?.text = dishes?[indexPath.row].name
        //输出菜品的小图标
        cell.imageView?.image = OrderManagerDAL.LoadImage(dish_id: dishes![indexPath.row].dish_id)
        
        return cell
    }

    
    //在选定cell时实现转场，转到菜品详情页
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "Modally", sender: Any?.self)
    }

    
    // MARK: - Navigation
    //为转场做准备
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        guard let dishDetailViewController = segue.destination as? DishDetailViewController
        else { return }
        
        //将选定的菜品传递给菜品详情页
        if segue.identifier == "Modally"
        {
        let restaurant = self.restaurant
        let dishes = OrderManagerDAL.GetDish(restaurant_id: restaurant!.id)
        let indexPath = self.tableView.indexPathForSelectedRow
            dishDetailViewController.filterDish = dishes![indexPath!.row]
        }
    }
    
}
