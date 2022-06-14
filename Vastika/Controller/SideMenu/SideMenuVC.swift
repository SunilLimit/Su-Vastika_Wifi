//
//  SideMenuVC.swift
//  Vastika
//
//  Created by Mac on 15/09/21.
//

import UIKit

class SideMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var lblUserDetails: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var arrayList = NSMutableArray()
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDetails = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let name = userDetails?.object(forKey: "name") as? String
        let email = userDetails?.object(forKey: "email") as? String
        self.lblUserDetails.text = name! + "\n" + email!
        
        var dict = ["img" : "device","name" : "My Devices"]
        self.arrayList.add(dict)
        dict = ["img" : "userProfile","name" : "My Profile"]
        self.arrayList.add(dict)
        dict = ["img" : "feedback","name" : "Feedback"]
        self.arrayList.add(dict)
        dict = ["img" : "Changepassword","name" : "Change Password"]
        self.arrayList.add(dict)
        dict = ["img" : "signout","name" : "Logout"]
        self.arrayList.add(dict)
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.bounces = false
        self.tblView.tableFooterView = UIView();
        self.tblView.separatorStyle = .singleLine;
        self.tblView.register(UINib(nibName: "sideMenuCell", bundle: nil), forCellReuseIdentifier: "sideMenuCell")
        self.tblView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userDetails = UserDefaults.standard.object(forKey: "user") as? NSDictionary
        let name = userDetails?.object(forKey: "name") as? String
        let email = userDetails?.object(forKey: "email") as? String
        self.lblUserDetails.text = name! + "\n" + email!
        
    }
    
    func callLogout()
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: webServices.AppName, message: "Are you sure , You want to logout ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
            self.viewModel.logout(viewController: self, isLoaderRequired: true) { status, msg in
                if status == "Success"
                {
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    UserDefaults.standard.synchronize()
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.setRootNavigation()
                }
                else
                {
                    let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- UITableview Delegate and datasource method  ---------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  44
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        var cell: sideMenuCell! = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell") as? sideMenuCell
            if cell == nil {
              cell = sideMenuCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "sideMenuCell")
            }
            
        let dict = self.arrayList.object(at: indexPath.row) as? NSDictionary
        cell!.lbltitlee.text = dict?.object(forKey: "name") as? String
        cell!.selectionStyle = .none;
        cell!.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15);
        cell.imgItem.contentMode = .scaleAspectFill;
        cell.imgItem.image = UIImage(named: dict?.object(forKey: "img") as! String)
        
        return cell!;
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrayList.object(at: indexPath.row) as? NSDictionary
        let name =  dict?.object(forKey: "name") as? String
        switch name{
        case "My Devices":
            self.navigationController?.popViewController(animated: true)
            break
        case "My Profile":
            let dict = UserDefaults.standard.object(forKey: "user") as? NSDictionary//setValue(dict, forKey: "user")
            let email = dict?.object(forKey: "created") as? Int
            if email == 0
            {
                if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "UpdateProfileVC") as? UpdateProfileVC{
                    vcToPresent.isFrom = "Mob"
                    self.navigationController?.pushViewController(vcToPresent, animated: true);
                }
            }
            else
            {
                if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC{
                    self.navigationController?.pushViewController(vcToPresent, animated: true)
                }
            }
           
            break
        case "Feedback":
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "FeedbackVC") as? FeedbackVC{
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
            break
        case "Change Password":
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC{
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
            break
        default:
            self.callLogout()
            break
        }
    }
   

}
