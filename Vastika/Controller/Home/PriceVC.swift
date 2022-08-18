//
//  PriceVC.swift
//  Vastika
//
//  Created by Sanjeev on 17/08/22.
//

import UIKit

class PriceVC: UIViewController {

    
    @IBOutlet weak var lblSavingInMonth: UILabel!
  
    var deviceId = String()
    @IBOutlet weak var lblTitle: UILabel!
    var viewModel = DeviceDetailsViewModel()
    private let numEntry = 4
    
    @IBOutlet weak var barChartView: BasicBarChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDeviceDeetails()
        
        let dataEntries = generateEmptyDataEntries()
        self.barChartView.updateDataEntries(dataEntries: dataEntries, animated: false)
        // Do any additional setup after loading the view.
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
        let arrayOftext = ["This Week","Week-2","Week-3","Week-4"]
        let arrayOfValue = NSMutableArray()
        let wek1 =  obj.solar_electricity_savings.week1_kwg + "\n" + obj.solar_electricity_savings.week1_saving
        let wek2 = obj.solar_electricity_savings.week2_kwg + "\n" + obj.solar_electricity_savings.week2_saving
        let wek3 =  obj.solar_electricity_savings.week3_kwg + "\n" +  obj.solar_electricity_savings.week3_saving
        let wek4 =  obj.solar_electricity_savings.week4_kwg + "\n" +  obj.solar_electricity_savings.week4_saving

        var dict = ["name" : wek1,"value" : obj.solar_electricity_savings.week1_saving]
        arrayOfValue.add(dict)
        dict = ["name" : wek2,"value" : obj.solar_electricity_savings.week2_saving]
        arrayOfValue.add(dict)
        dict = ["name" : wek3,"value" : obj.solar_electricity_savings.week3_saving]
        arrayOfValue.add(dict)
        dict = ["name" : wek4,"value" : obj.solar_electricity_savings.week4_saving]
        arrayOfValue.add(dict)
        
        let dataEntries = self.generateRandomDataEntries(obj: obj,arrayValue: arrayOfValue,arrayText: arrayOftext as NSArray)
        for data in dataEntries
        {
            print(data.height)
            print(data.textValue)
            print(data.title)
            print(data.color)
        }
        self.barChartView.updateDataEntries(dataEntries: dataEntries, animated: true)
    }

    func generateEmptyDataEntries() -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<numEntry).forEach {_ in
            result.append(DataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }
    
    func generateRandomDataEntries(obj : DeviceDetailsModel,arrayValue : NSMutableArray,arrayText : NSArray) -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<numEntry {
            let strText = arrayText[i] as? String
            let dict = arrayValue[i] as? NSDictionary
            let valuePrint = dict?.object(forKey: "name") as? String
            let valueActual = dict?.object(forKey: "value") as? String
            let height: Float = Float(valueActual!.floatValue) / obj.solar_electricity_savings.days30_saving.floatValue
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(String(describing: valuePrint!))", title: strText!))
        }
        return result
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
