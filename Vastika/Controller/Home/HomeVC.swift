//
//  HomeVC.swift
//  Vastika
//
//  Created by Mac on 15/09/21.
//

import UIKit

class HomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    var arrayList = [HomeModel]()
    @IBOutlet weak var btnAddNew: UIButton!
    var viewModel = HomeViewModel()
    
    // MARK:- View Life cycle -------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setStatusBar(backgroundColor: Device.common_header_Color)
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.bounces = false
        self.tblView.tableFooterView = UIView();
        self.tblView.separatorStyle = .singleLine;
        self.tblView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        self.tblView.reloadData()
        self.btnAddNew.layer.cornerRadius = self.btnAddNew.frame.size.height/2
        self.btnAddNew.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getList()
    }
    
    // MARK:- Get Data List
    
    func getList()  {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.arrayList.removeAll()
        self.viewModel.getProductList(page: "1", viewController: self, isLoaderRequired: true) { status, obj in
            if status == "Success"
            {
                self.arrayList = obj
                self.tblView.reloadData()
            }
            else
            {
                if status == "Token Expire and app going to logout."
                {
                    // loogout
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    UserDefaults.standard.synchronize()
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.setRootNavigation()
                }
                else
                {
                    let alert = UIAlertController(title: webServices.AppName, message: "Unable to connect to the server.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.getList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
               
            }
        }
    }
    
    // MAARK:- UIAction Method -------
    @IBAction func tapSideMenu(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuVC{
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    @IBAction func tapAddNew(_ sender: Any) {
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "AddDeviceVC") as? AddDeviceVC{
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    // MARK:- UITableview Delegate and datasource method  ---------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        var cell: HomeCell! = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as? HomeCell
            if cell == nil {
              cell = HomeCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "HomeCell")
            }
            
        cell!.lblTitle.text = self.arrayList[indexPath.row].device_name
        cell!.selectionStyle = .none;
        cell!.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15);
        cell.btnView.addTarget(self, action: #selector(tapViewDetails(button:)), for: .touchUpInside)
        cell.btnDelegte.addTarget(self, action: #selector(tapDeleteDetails(button:)), for: .touchUpInside)

        
        let img = self.arrayList[indexPath.row].image_path
        if img == nil
        {

        }
        else if img != "" || img != " " || img != nil
        {
            if let imgPath = img!.replacingOccurrences(of: "'\'", with: "").stringByAddingPercentEncodingForRFC3986(){

                cell.imgProduct.kf.setImage(with: URL(string: imgPath ),placeholder: UIImage(named: "placeholderImage"),options: nil, completionHandler: {
                    result in
                    switch result {
                    case .success(_):
                        cell.imgProduct.contentMode = .scaleAspectFill;
                    case .failure(_):
                        cell.imgProduct.contentMode = .scaleAspectFill;
                        let image = UIImage(named: "user");
                        cell.imgProduct.image = image;
                    }
                })
            }
        }
        
        return cell!;
            
    }
    
    func getIndexPathFor(view: UIView, tableView: UITableView) -> IndexPath? {

        let point = tableView.convert(view.bounds.origin, from: view)
        let indexPath = tableView.indexPathForRow(at: point)
        return indexPath
       }
    
    @objc func tapViewDetails(button : UIButton)
    {
        let indexPath = self.getIndexPathFor(view: button, tableView: self.tblView)
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DemoVC") as? DemoVC{
            vcToPresent.deviceid = String(self.arrayList[indexPath!.row].device_id)
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    @objc func tapDeleteDetails(button : UIButton)
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not available. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let indexPath = self.getIndexPathFor(view: button, tableView: self.tblView)
        let deviceID = String(self.arrayList[indexPath!.row].device_id)
        let alert = UIAlertController(title: webServices.AppName, message: "Are you sure ? You want to delete this device? ", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes, Delete It!", style: .default, handler: { (action) in
            self.viewModel.deleteDevice(deviceId: deviceID, viewController: self, isLoaderRequired: true) { status, msg in
                if status == "Success"
                {
                    let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.getList()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    let alert = UIAlertController(title: webServices.AppName, message: msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "NewDeviceDetailsVC") as? NewDeviceDetailsVC{
//            vcToPresent.deviceId = String(self.arrayList[indexPath.row].device_id)
//            self.navigationController?.pushViewController(vcToPresent, animated: true)
//        }
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DemoVC") as? DemoVC{
            vcToPresent.deviceid = String(self.arrayList[indexPath.row].device_id)
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
       
    }
}
