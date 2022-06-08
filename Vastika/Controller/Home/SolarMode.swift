//
//  OtherMode.swift
//  Vastika
//
//  Created by Mac on 20/09/21.
//

import UIKit

class SolarMode: UIView {

    @IBOutlet weak var viewSolar1: UIView!
    @IBOutlet weak var viewSolar2: UIView!
    @IBOutlet weak var viewSolar3: UIView!
    @IBOutlet weak var viewSolar4: UIView!
    @IBOutlet weak var viewSolar5: UIView!
    @IBOutlet weak var viewSolar6: UIView!
    @IBOutlet weak var lblInputVoltage: UILabel!
    @IBOutlet weak var lblBattery: UILabel!
    @IBOutlet weak var imgBattery: UIImageView!
    @IBOutlet weak var imgAtc: UIImageView!
    @IBOutlet weak var lblAtcValue: UILabel!
    @IBOutlet weak var imgSystemStatus: UIImageView!
    @IBOutlet weak var lblSystemStatus: UILabel!
    @IBOutlet weak var imgMainStatus: UIImageView!
    @IBOutlet weak var lblMainStatus: UILabel!
    @IBOutlet weak var imgSolarStatus: UIImageView!
    @IBOutlet weak var lblSolarStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView(vw: self.viewSolar1)
        self.setUpView(vw: self.viewSolar2)
        self.setUpView(vw: self.viewSolar3)
        self.setUpView(vw: self.viewSolar4)
        self.setUpView(vw: self.viewSolar5)
        self.setUpView(vw: self.viewSolar6)
    }
    
    func initializeUI() {
        layer.masksToBounds = true
        layoutIfNeeded()
    }
    
    func setUpView(vw : UIView)  {
        vw.layer.cornerRadius = 1.0
        vw.layer.borderWidth = 1.0
        vw.layer.borderColor = UIColor.black.cgColor
        vw.clipsToBounds = true
    }
    
    
    
}
