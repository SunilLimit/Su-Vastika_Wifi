//
//  NavigationHeader.swift
//  CRM
//
//  Created by Mac on 07/06/21.
//

import Foundation
import UIKit

class NavigationHeader : NSObject
{

    
        func calculateHeightOgnav()-> CGFloat
        {
        var height = CGFloat()
        switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    height = 64
                    
                case 1334:
                    height = 64
                    
                case 1920, 2208:
                    height = 64
                    
                case 2436:
                    height = 64
                    

                case 2688:
                    height = 64
                    

                case 1792:
                    height = 64
                    

                default:
                    print("Unknown")
                }

        return height
        }
}
