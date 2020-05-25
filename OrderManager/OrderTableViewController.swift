//
//  OrderTableViewController.swift
//  OrderManager
//
//  Created by 何忆源 on 2020/5/25.
//  Copyright © 2020 何忆源. All rights reserved.
//

import UIKit

//选购菜品的委托
protocol AddItemDelegate
{
    func addItem(dish_id:Int, count:Int)
}


class OrderTableViewController: UITableViewController, AddItemDelegate
{
    
    //选购的菜品
    var filterDishes:[Dish] = []
    
    
    //加载选购的菜品
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //获取所有的菜品
        let allDishes:[Dish] = OrderManagerDAL.GetAllDishes()!
        //获取选购的菜品
        for dish in allDishes
        {
            if dish.count != 0              //如果菜品的数量不等于0
            {
                filterDishes.append(dish)   //则为已选购的菜品
            }
        }
    }

    
    // MARK: - Table view data source
    //实现cell
    //返回cell数目
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filterDishes.count
    }

    
    //返回cell内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOrder", for: indexPath)

        cell.textLabel?.text = filterDishes[indexPath.row].name
        cell.detailTextLabel?.text = "数量：\(filterDishes[indexPath.row].count)"
        
        return cell
    }
    
    
    //将选购的菜品加到订单中（实际是在更新数据库菜品表dish中菜品的数量）
    func addItem(dish_id: Int, count:Int)
    {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() { return }
        
        let updateOrder = "UPDATE dish SET count=\(count) WHERE dish_id==\(dish_id)"
        if !sqlite.execNoneQuerySQL(sql: updateOrder)
        {
            sqlite.closeDB()
            return
        }
        
        sqlite.closeDB()
    }
    
    
    //每次打开订单页时进行刷新
    override func viewWillAppear(_ animated: Bool)
    {
        tableView.reloadData()
        
        //在订单页Tab Bar显示已选购菜品的数量
        navigationController?.tabBarItem.badgeValue = "\(filterDishes.count)"
    }
    
    
    //点击支付按钮
    @IBAction func payButtonPressed(_ sender: Any)
    {
        //弹窗确认支付信息
        let alertController = UIAlertController.init(title: "确认支付？", message: nil, preferredStyle: .alert)
        //点击“确认”，转场到主菜单，即餐厅页
        let confirmAction = UIAlertAction(title: "确认", style: .default,handler: {ACTION in self.performSegue(withIdentifier: "Back", sender: Any?.self)})
        //点击“取消”，返回上一级，即订单页
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    //删除选购的菜品
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let sqlite = SQLiteManager.sharedInstance
            if !sqlite.openDB() { return }
            let updateOrder = "UPDATE dish SET count=0 WHERE dish_id==\(filterDishes[indexPath.row].dish_id)"
            if !sqlite.execNoneQuerySQL(sql: updateOrder)
            {
                sqlite.closeDB()
                return
            }
            
            sqlite.closeDB()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
