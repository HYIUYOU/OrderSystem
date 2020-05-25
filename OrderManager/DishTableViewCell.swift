//
//  DishTableViewCell.swift
//  OrderManager
//
//  Created by 何忆源 on 2020/5/25.
//  Copyright © 2020 何忆源. All rights reserved.
//

import UIKit

class DishTableViewCell: UITableViewCell
{
    
    //输出Label显示菜品名字
    @IBOutlet weak var nameLabel: UILabel!
    //输出ImageView显示菜品图标
    @IBOutlet weak var picImageView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}


