//
//  NoticeListCell.swift
//  gmoneymap
//
//  Created by HelloDigital on 2021/07/14.
//

import UIKit

class NoticeListCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var expandableIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showIcon() {
        expandableIcon.isHidden = false
        expandableIcon.image = isSelected ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
    }
    
    func hideIcon() {
        expandableIcon.isHidden = true
    }
    
}
