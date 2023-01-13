//
//  HomeVC.swift
//  Vastika
//
//  Created by Mac on 15/09/21.
//

import UIKit
import CoreBluetooth


class HomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    var arrayList = [HomeModel]()
    @IBOutlet weak var btnAddNew: UIButton!
    var viewModel = HomeViewModel()
    var simpleBluetoothIO: SimpleBluetoothIO!
    var peripherals:[CBPeripheral] = []
    var centralManager: CBCentralManager!
    let cellReuseIdentifier = "cell"
    let heartRateServiceCBUUID = CBUUID(string: "0x180D")
    var reciveData = NSMutableArray()
    var index : Int = -1
    
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
        self.tblView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tblView.reloadData()
        self.btnAddNew.layer.cornerRadius = self.btnAddNew.frame.size.height/2
        self.btnAddNew.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.peripherals.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isFrom == "BLE"
        {
            // set ble
            loaderManager.sharedInstance.startLoading();
            self.centralManager = CBCentralManager(delegate: self, queue: .main)
            let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber(value: false)]
            self.centralManager?.scanForPeripherals(withServices: nil, options: options)
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                self.centralManager.stopScan()
                loaderManager.sharedInstance.stopLoading();
                print("Scanning stop")
                var tempPeripherals:[CBPeripheral] = []

                if self.peripherals.count > 0
                {
                    for device in self.peripherals
                    {
                        if device.name?.count != 0 && device.name != nil
                        {
                            if device.name!.contains("BLE")
                            {
                                tempPeripherals.append(device)
                            }
                        }
                    }
                    self.peripherals = tempPeripherals
                    self.tblView.reloadData()
                }
            }
        }
        else
        {
            self.getList()
        }
       
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
        
        simpleBluetoothIO.writeValue(value:"hello")

//        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "AddDeviceVC") as? AddDeviceVC{
//            self.navigationController?.pushViewController(vcToPresent, animated: true)
//        }
    }
    
    
    func getString()
    {
        for str in self.reciveData
        {
            print(str)
        }
        
        if self.reciveData.lastObject as! String == "#MEND"
        {
            var str = String()
            self.reciveData.removeObject(at: 0)
            self.reciveData.removeLastObject()
            for item in self.reciveData
            {
                str = str + String(item as! String)
            }
            let convertedDict = self.convertStringToDictionary(text: str)
            let newDict = convertedDict as? NSDictionary
            print("converted json : ", "\(convertedDict)")
            self.index = self.index + 1
            if self.index == 0
            {
                let statusUPS = newDict!.object(forKey: "status_ups") as? String
                let statusMains = newDict!.object(forKey: "status_mains") as? String
                
                let pvw = newDict!.object(forKey: "pvw") as? String
                let bw = newDict!.object(forKey: "bw") as? String
                
                if statusUPS == "1" && statusMains == "0"
                {
                    if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceBLEVC") as? DeviceBLEVC{
                        vcToPresent.dicrDta = newDict!
                        self.navigationController?.pushViewController(vcToPresent, animated: true)
                    }
                }
                else if statusUPS == "0" && statusMains == "1"
                {
                    if pvw == "0.0" && bw == "0.0"
                    {
                        //Solar Mode
                    }
                    else
                    {
                        // Mains Mode
                        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DeviceMainSVC") as? DeviceMainSVC{
                            vcToPresent.dicrDta = newDict!
                            self.navigationController?.pushViewController(vcToPresent, animated: true)
                        }
                    }
                }
                
                
                
            }
            
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               self.reciveData.removeAllObjects()
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
    
    func getReciveData(msg : String)
    {
        if msg == "#MEND"
        {
            self.reciveData.add(msg)
            self.getString()
        }else
        {
            self.reciveData.add(msg)
        }
    }
    
    // MARK:- UITableview Delegate and datasource method  ---------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isFrom == "BLE"
        {
            return self.peripherals.count
        }
        else
        {
            return self.arrayList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isFrom == "BLE"
        {
            return 44
        }
        else
        {
            return  80
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isFrom == "BLE"
        {
            let cell:UITableViewCell = (self.tblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
            cell.textLabel?.text = self.peripherals[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        else
        {
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
    }
    
    func getIndexPathFor(view: UIView, tableView: UITableView) -> IndexPath? {

        let point = tableView.convert(view.bounds.origin, from: view)
        let indexPath = tableView.indexPathForRow(at: point)
        return indexPath
       }
    
    @objc func tapViewDetails(button : UIButton)
    {
        let indexPath = self.getIndexPathFor(view: button, tableView: self.tblView)
        
        if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "AddDeviceVC") as? AddDeviceVC{
            vcToPresent.isFrom = "Edit"
            vcToPresent.homeMoel = self.arrayList[indexPath!.row]
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isFrom == "BLE"
        {
            let udid = self.peripherals[indexPath.row].identifier.uuidString
            self.centralManager.connect(self.peripherals[indexPath.row])
           // simpleBluetoothIO = SimpleBluetoothIO(serviceUUID: self.peripherals[indexPath.row].identifier.uuidString, delegate: self)

        }
        else
        {
            if let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "DemoVC") as? DemoVC{
                vcToPresent.deviceid = String(self.arrayList[indexPath.row].device_id)
                self.navigationController?.pushViewController(vcToPresent, animated: true)
            }
        }
       
    }
}
extension HomeVC : CBPeripheralDelegate, CBCentralManagerDelegate{
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripherals.append(peripheral)
        let name = advertisementData["CBAdvertisementDataLocalNameKey"] as? String
        print(name)
        print(peripheral.name)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected to " +  peripheral.name!)
        print(peripheral.state.rawValue)
        simpleBluetoothIO = SimpleBluetoothIO(serviceUUID: peripheral.identifier.uuidString, delegate: self)
    }
    
    func centralManagerDidUpdateState( _ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        @unknown default:
            fatalError()
            
        }
        
    }


    private func centralManager( central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
        
    }
    
}

extension HomeVC: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: String) {
        print(value)
        self.getReciveData(msg: value)
    }
}


