//
//  MainLoad.swift
//  Vastika
//
//  Created by Mac on 20/09/21.
//

import UIKit

class MainLoad: UIView {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var viewe3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var vieew4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var lblVoolttageCount: UILabel!
    @IBOutlet weak var imgBatteery: UIImageView!
    @IBOutlet weak var lblBatteryPeerceentage: UILabel!
    @IBOutlet weak var imgGrid: UIImageView!
    @IBOutlet weak var imgSolar: UIImageView!
    @IBOutlet weak var lblChargingBothPerccentaageStatus: UILabel!
    @IBOutlet weak var lblCharingPoweerWalt: UILabel!
    @IBOutlet weak var lblModeeBoost: UILabel!
    @IBOutlet weak var imgSolarStatus: UIImageView!
    @IBOutlet weak var lblSolarStatusValue: UILabel!
    @IBOutlet weak var lblAtc: UILabel!
    @IBOutlet weak var imgatc: UIImageView!
    @IBOutlet weak var lblAtcTempraturee: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView(vw: self.view1)
        self.setUpView(vw: self.view2)
        self.setUpView(vw: self.viewe3)
        self.setUpView(vw: self.vieew4)
        self.setUpView(vw: self.view5)
        self.setUpView(vw: self.view6)
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
    }}
