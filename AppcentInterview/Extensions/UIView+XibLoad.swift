//
//  UIView+XibLoad.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 2.10.2021.
//

import Foundation
import UIKit

extension UIView{
    
    static func loadFromNib<T : UIView>(owner : Any? , options : [UINib.OptionsKey : Any]?) -> T{
        
        let nib = UINib(nibName: "\(self)", bundle: Bundle.main)
        
        guard let view = nib.instantiate(withOwner: owner, options: options).first as? T else{
            fatalError("View loading error")
        }
        
        return view
    }
    
}
