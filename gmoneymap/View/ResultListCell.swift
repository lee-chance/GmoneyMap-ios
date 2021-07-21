//
//  ResultListCell.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/07/21.
//

import UIKit

class ResultListCell: UITableViewCell {

    @IBOutlet var shopName: DynamicUILabel!
    @IBOutlet var category: DynamicUILabel!
    @IBOutlet var address: DynamicUILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
