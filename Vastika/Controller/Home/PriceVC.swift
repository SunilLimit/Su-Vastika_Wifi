//
//  PriceVC.swift
//  Vastika
//
//  Created by Sanjeev on 17/08/22.
//

import UIKit

class PriceVC: UIViewController {

    
    @IBOutlet weak var lblSavingInMonth: UILabel!
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secView: UIView!
    @IBOutlet weak var lblThisWeek: UILabel!
    @IBOutlet weak var lblSecWeek: UILabel!
    @IBOutlet weak var lblThrdWeek: UILabel!
    @IBOutlet weak var lblFourthWeek: UILabel!
    
    @IBOutlet weak var lblTitleFourthWeek: UILabel!
    @IBOutlet weak var lblTitleThirdWeek: UILabel!
    @IBOutlet weak var lblTitleThisWeek: UILabel!
    @IBOutlet weak var lblTitleSecWeek: UILabel!
    var deviceId = String()
    @IBOutlet weak var lblTitle: UILabel!
    var viewModel = DeviceDetailsViewModel()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDeviceDeetails()
        self.makeCurve(lbl: self.lblThisWeek)
        self.makeCurve(lbl: self.lblSecWeek)
        self.makeCurve(lbl: self.lblThrdWeek)
        self.makeCurve(lbl: self.lblFourthWeek)
        self.makeShadowBorder(yourView: self.monthlyView)
        self.makeShadowBorder(yourView: self.firstView)
        self.makeShadowBorder(yourView: self.secView)


    }
    
    func makeCurve(lbl : UILabel)
    {
        lbl.layer.cornerRadius = 10
        lbl.clipsToBounds = true
    }
   
    func makeShadowBorder(yourView : UIView)
    {
        yourView.layer.masksToBounds = false
        yourView.layer.shadowColor = UIColor.lightGray.cgColor
        yourView.layer.shadowOffset =  CGSize.zero
        yourView.layer.shadowOpacity = 0.5
        yourView.layer.shadowRadius = 4
        yourView.layer.cornerRadius = 10

    }
        


    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getDeviceDeetails()
    {
        
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.viewModel.deviceDetails(deviceId: self.deviceId, viewController: self, isLoaderRequired: true) { [self] status, obj in
            if status == "Success"
            {
                self.setupDetails(obj: obj)
                self.lblTitle.text = "Saving From " + obj.device_function_type
            }
        }
    }
    
    func setupDetails(obj : DeviceDetailsModel)
    {
        self.lblSavingInMonth.text = obj.solar_electricity_savings.days30_kwg + "\n" + obj.solar_electricity_savings.days30_saving

        let wek1 =  obj.solar_electricity_savings.week1_kwg + "\n" + obj.solar_electricity_savings.week1_saving
        let wek2 = obj.solar_electricity_savings.week2_kwg + "\n" + obj.solar_electricity_savings.week2_saving
        let wek3 =  obj.solar_electricity_savings.week3_kwg + "\n" +  obj.solar_electricity_savings.week3_saving
        let wek4 =  obj.solar_electricity_savings.week4_kwg + "\n" +  obj.solar_electricity_savings.week4_saving
        self.lblThisWeek.text = wek1
        self.lblSecWeek.text = wek2
        self.lblThrdWeek.text = wek3
        self.lblFourthWeek.text = wek4
        

        
        // attributes text for uilable
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor : UIColor.darkGray]

        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10.0), NSAttributedString.Key.foregroundColor : UIColor.darkGray]

        let attributedString1 = NSMutableAttributedString(string:"This Week \n\n", attributes:attrs1 as [NSAttributedString.Key : Any])

        
        let strThisWeek = obj.solar_electricity_savings.week1_start + " to " +  obj.solar_electricity_savings.week1_end
        
        let attributedString2 = NSMutableAttributedString(string:strThisWeek, attributes:attrs2 as [NSAttributedString.Key : Any])

        attributedString1.append(attributedString2)
        self.lblTitleThisWeek.attributedText = attributedString1
        
        
        let attributedString11 = NSMutableAttributedString(string:"Week - 2 \n\n", attributes:attrs1 as [NSAttributedString.Key : Any])

        
        let strThisWeek2 =  obj.solar_electricity_savings.week2_start + " to " +  obj.solar_electricity_savings.week2_end
        
        let attributedString22 = NSMutableAttributedString(string:strThisWeek2, attributes:attrs2 as [NSAttributedString.Key : Any])

        attributedString11.append(attributedString22)
        self.lblTitleSecWeek.attributedText = attributedString11
        
        
        let attributedString111 = NSMutableAttributedString(string:"Week - 3 \n\n", attributes:attrs1 as [NSAttributedString.Key : Any])

        
        let strThisWeek3 = obj.solar_electricity_savings.week3_start + " to " +  obj.solar_electricity_savings.week3_end
        
        let attributedString222 = NSMutableAttributedString(string:strThisWeek3, attributes:attrs2 as [NSAttributedString.Key : Any])

        attributedString111.append(attributedString222)
        self.lblTitleThirdWeek.attributedText = attributedString111
        
        
        let attributedString1111 = NSMutableAttributedString(string:"Week - 4 \n\n", attributes:attrs1 as [NSAttributedString.Key : Any])

        
        let strThisWeek4 = obj.solar_electricity_savings.week4_start + " to " +  obj.solar_electricity_savings.week4_end
        
        let attributedString2222 = NSMutableAttributedString(string:strThisWeek4, attributes:attrs2 as [NSAttributedString.Key : Any])

        attributedString1111.append(attributedString2222)
        self.lblTitleFourthWeek.attributedText = attributedString1111
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
