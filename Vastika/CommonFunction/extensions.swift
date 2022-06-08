//
//  extensions.swift
//  VMConsumer
//
//  Created by Developer on 21/12/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField


extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
        func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
            let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
            return boundingBox.height
        }
}


class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIButton {
    private func actionHandleBlock(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
    
    @objc private func triggerActionHandleBlock() {
        self.actionHandleBlock()
    }
    
    func actionHandle(controlEvents control :UIControl.Event, ForAction action:@escaping () -> Void) {
        self.actionHandleBlock(action: action)
        self.addTarget(self, action: #selector(UIButton.triggerActionHandleBlock), for: control)
    }
}



extension UIViewController{
    
    func setBackBtn(){
        let backImage = UIImage(named: "newBackBtn")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popnav))
    }
    
    
    @objc func popnav() {
        
        if(self.navigationController == nil){
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
            self.view.endEditing(true)
        }
    }
    
    @objc func hideAlert(){
        print("ok btn pressed");
        let view = self.view.viewWithTag(1331)
        view?.removeFromSuperview();
    }
    
    func hideBottomBar(){
        self.tabBarController?.tabBar.isHidden = true
        if let view = UIApplication.shared.keyWindow?.viewWithTag(777) as? UIButton{
            view.isHidden = true
        }
        
    }
    
    func showBottomBar(){
        self.tabBarController?.tabBar.isHidden = false
        if let view = UIApplication.shared.keyWindow?.viewWithTag(777) as? UIButton{
            view.isHidden = false
        }
    }
}

extension UITableView {
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }
        
        return lastIndexPath == indexPath
    }
}

extension Sequence {
    
    func groupBy<G: Hashable>(closure: (Iterator.Element)->G) -> [G: [Iterator.Element]] {
        var results = [G: Array<Iterator.Element>]()
        
        forEach {
            let key = closure($0)
            
            if var array = results[key] {
                array.append($0)
                results[key] = array
            }
            else {
                results[key] = [$0]
            }
        }
        
        return results
    }
}


extension NSURL {
    
    var allQueryItems: [NSURLQueryItem] {
        get {
            let components = NSURLComponents(url: self as URL, resolvingAgainstBaseURL: false)!
            // print(components)
            let allQueryItems = components.queryItems!
            return allQueryItems as [NSURLQueryItem]
        }
    }
    
    func queryItemForKey(key: String) -> NSURLQueryItem? {
        
        let predicate = NSPredicate(format: "name=%@", key)
        return (allQueryItems as NSArray).filtered(using: predicate).first as? NSURLQueryItem
        
    }
}


extension UILabel{
    
    func addBottomLayer(){
        let lineView = UIView(frame: CGRect(x: 0, y: self.frame.height + 3, width: self.frame.width, height: 0.5))
        lineView.backgroundColor = color.line_backgroundColor;
        self.addSubview(lineView)
    }
}



extension UIView{
    
    func addBottomLayerToView(height:CGFloat){
        let lineView = UIView(frame: CGRect(x: 0, y: self.frame.height + 3, width: self.frame.width, height: height)
        )
        lineView.backgroundColor = color.line_backgroundColor;
        self.addSubview(lineView)
    }
    
    func addTopLayerToView(height:CGFloat){
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: height)
        )
        lineView.backgroundColor = color.line_backgroundColor;
        self.addSubview(lineView)
    }
}



extension String {
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = ":-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return  addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
    
    
}


extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.maximumFractionDigits = AppUtils.decimalDigits;
        numberFormatter.positiveFormat = "#,##0.00";
        
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}


extension SkyFloatingLabelTextField{
@IBInspectable var changeSelectedTitleFormat: Bool{
get{
return self.changeSelectedTitleFormat
}
set (isChange) {
if isChange{
fix(textField: self)
}
}
}

  func fix(textField: SkyFloatingLabelTextField) {
    textField.titleFormatter = { $0 }
}
}



extension String{
    
    func strikeThroughString()->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string:self)
        // Swift 4.2 and above
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        
        return attributedString

    }
    
    func removeStrikeThroughString()->NSMutableAttributedString{
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughColor, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
}
