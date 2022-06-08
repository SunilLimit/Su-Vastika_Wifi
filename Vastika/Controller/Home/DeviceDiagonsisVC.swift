//
//  DeviceDiagonsisVC.swift
//  Vastika
//
//  Created by Mac on 22/09/21.
//

import UIKit

class DeviceDiagonsisVC: UIViewController {

    
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var lblCr1: UILabel!
    @IBOutlet weak var lblCr2: UILabel!
    @IBOutlet weak var lblCr3: UILabel!
    @IBOutlet weak var lblCr4: UILabel!
    @IBOutlet weak var lblCr5: UILabel!
    @IBOutlet weak var viewHeight1: NSLayoutConstraint!
    @IBOutlet weak var viewHeight5: NSLayoutConstraint!
    @IBOutlet weak var viewHeight4: NSLayoutConstraint!
    @IBOutlet weak var viewHeight3: NSLayoutConstraint!
    @IBOutlet weak var viewHeight2: NSLayoutConstraint!
    @IBOutlet weak var lblOk1: UILabel!
    @IBOutlet weak var lblOk2: UILabel!
    @IBOutlet weak var lblOk3: UILabel!
    @IBOutlet weak var lblOk4: UILabel!
    @IBOutlet weak var lblOk5: UILabel!
    var actiVityIndicator = UIActivityIndicatorView()
    
    // MARK:- View Life Cycle --------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCricle(vew: self.lblCr1)
        self.setCricle(vew: self.lblCr2)
        self.setCricle(vew: self.lblCr3)
        self.setCricle(vew: self.lblCr4)
        self.setCricle(vew: self.lblCr5)
        self.startSpinning()
        // Do any additional setup after loading the view.
    }
    

    func setCricle(vew : UIView)
    {
        vew.layer.cornerRadius = vew.frame.size.height/2
        vew.clipsToBounds = true
    }
    
    @IBAction func tapBacck(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func startSpinning()
    {
        self.actiVityIndicator.frame = CGRect(x: self.view1.frame.origin.x - 3, y: 40, width: 30, height: 30)
        self.actiVityIndicator.startAnimating()
        self.view1.addSubview(self.actiVityIndicator)
        self.actiVityIndicator.color = UIColor.blue
        self.viewHeight1.constant = 71
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // your code here
            self.actiVityIndicator.removeFromSuperview()
            self.actiVityIndicator.frame = CGRect(x: self.view2.frame.origin.x - 3, y: 40, width: 30, height: 30)
            self.actiVityIndicator.startAnimating()
            self.view2.addSubview(self.actiVityIndicator)
            self.actiVityIndicator.color = UIColor.blue
            self.viewHeight2.constant = 71
            self.lblOk1.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            // your code here
            self.actiVityIndicator.removeFromSuperview()
            self.actiVityIndicator.frame = CGRect(x: self.view3.frame.origin.x - 3, y: 40, width: 30, height: 30)
            self.actiVityIndicator.startAnimating()
            self.view3.addSubview(self.actiVityIndicator)
            self.actiVityIndicator.color = UIColor.blue
            self.viewHeight3.constant = 71
            self.lblOk2.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
            // your code here
            self.actiVityIndicator.removeFromSuperview()
            self.actiVityIndicator.frame = CGRect(x: self.view4.frame.origin.x - 3, y: 40, width: 30, height: 30)
            self.actiVityIndicator.startAnimating()
            self.view4.addSubview(self.actiVityIndicator)
            self.actiVityIndicator.color = UIColor.blue
            self.viewHeight4.constant = 71
            self.lblOk3.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            // your code here
            self.actiVityIndicator.removeFromSuperview()
            self.actiVityIndicator.frame = CGRect(x: self.view5.frame.origin.x - 3, y: 40, width: 30, height: 30)
            self.actiVityIndicator.startAnimating()
            self.view5.addSubview(self.actiVityIndicator)
            self.actiVityIndicator.color = UIColor.blue
            self.viewHeight5.constant = 71
            self.lblOk4.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            self.actiVityIndicator.removeFromSuperview()
            self.lblOk5.isHidden = false
        }
        
    }
    

}
