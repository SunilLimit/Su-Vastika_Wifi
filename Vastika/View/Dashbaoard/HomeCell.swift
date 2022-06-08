//
//  HomeCell.swift
//  Vastika
//
//  Created by Mac on 15/09/21.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnDelegte: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
