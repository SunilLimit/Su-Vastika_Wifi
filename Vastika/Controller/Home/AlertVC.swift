//
//  AlertVC.swift
//  Vastika
//
//  Created by Mac on 22/09/21.
//

import UIKit

class AlertVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblview: UITableView!
    var viewModel = HomeViewModel()
    var deviceeId = String()
    
    var arrayList = [AlertModel]()
    
    // MARK:- View Life Cycle--------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblview.delegate = self
        self.tblview.dataSource = self
        self.tblview.bounces = false
        self.tblview.tableFooterView = UIView();
        self.tblview.separatorStyle = .singleLine;
        self.tblview.register(UINib(nibName: "alertCell", bundle: nil), forCellReuseIdentifier: "alertCell")
        self.tblview.reloadData()
        self.getAlert()
        // Do any additional setup after loading the view.
    }
    
    func getAlert()
    {
        if !Reachability.isConnectedToNetwork()
        {
            let alert = UIAlertController(title: webServices.AppName, message: "Internet connection is not availbale. Please check your intertnet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.viewModel.getDeviceAlert(deviceId : deviceeId, viewController: self, isLoaderRequired: true) { status, obj in
            if status == "Success"
            {
                // reload tabl
                self.arrayList = obj
                self.tblview.reloadData()
            }
            else
            {
                let alert = UIAlertController(title: webServices.AppName, message: "Alert not found.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK:- UIAction Method ------------
    @IBAction func tapbacl(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    // MARK:- UITableview Delegate and datasource method  ---------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  60
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        var cell: alertCell! = tableView.dequeueReusableCell(withIdentifier: "alertCell") as? alertCell
        if cell == nil {
          cell = alertCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "alertCell")
        }
            
        if indexPath.row == 0
        {
            cell.lblAlertt.text = "Alert"
            cell.lblDate.text = "Date"
            cell.lblDate.textAlignment = .left
            cell.lblAlertt.textAlignment = .left
            cell.lblDate.font = UIFont(name: "System-Bold", size: 14)
            cell.lblAlertt.font = UIFont(name: "System-Bold", size: 14)

        }
        else
        {
            cell.lblDate.textAlignment = .left
            cell.lblAlertt.textAlignment = .left
            cell.lblDate.font = UIFont(name: "System", size: 10)
            cell.lblAlertt.font = UIFont(name: "System", size: 14)
            cell.lblAlertt.text = self.arrayList[indexPath.row - 1].status_error
            cell.lblDate.text = self.arrayList[indexPath.row - 1].log_date

        }
        return cell!;
            
    }
    
 

   
}
