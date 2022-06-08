//
//  SolarMode.swift
//  Vastika
//
//  Created by Mac on 20/09/21.
//

import UIKit

class UPSMode: UIView {

    @IBOutlet weak var viewUPS1: UIView!
    @IBOutlet weak var viewUPS2: UIView!
    @IBOutlet weak var viewUPS3: UIView!
    @IBOutlet weak var vieewUPS4: UIView!
    @IBOutlet weak var viewUPS5: UIView!
    @IBOutlet weak var viewUPS6: UIView!
    @IBOutlet weak var imgSwitchONOFF: UIImageView!
    @IBOutlet weak var lblSwitch: UILabel!
    @IBOutlet weak var imgATC: UIImageView!
    @IBOutlet weak var lblATCValue: UILabel!
    @IBOutlet weak var imgSystemStaus: UIImageView!
    @IBOutlet weak var lblSystemStatus: UILabel!
    @IBOutlet weak var imgSolarSystem: UIImageView!
    @IBOutlet weak var lblSolarSystem: UILabel!
    @IBOutlet weak var imgBatteruy: UIImageView!
    @IBOutlet weak var lblBattery: UILabel!
    @IBOutlet weak var imgLoadWattaeg: UIImageView!
    @IBOutlet weak var lblLoadWattege: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView(vw: self.viewUPS1)
        self.setUpView(vw: self.viewUPS2)
        self.setUpView(vw: self.viewUPS3)
        self.setUpView(vw: self.vieewUPS4)
        self.setUpView(vw: self.viewUPS5)
        self.setUpView(vw: self.viewUPS6)
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
