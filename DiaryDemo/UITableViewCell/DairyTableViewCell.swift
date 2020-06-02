//
//  DairyTableViewCell.swift
//  MY DAIRY
//
//  Created by Cp on 29/05/20.
//  Copyright © 2020 Cp. All rights reserved.
//

import UIKit

class DairyTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDayName: UILabel!
    @IBOutlet weak var ImgTime: UIImageView!
    @IBOutlet weak var BtnClose: UIButton!
    @IBOutlet weak var btnedit: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var containtView: UIView!
    @IBOutlet weak var timeImageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
