//
//  CustomNavigationView.swift
//  ListPage
//
//  Created by Athul Raj on 10/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit

class CustomNavigationView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBehavior()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func addBehavior() {
        print("Add all the behavior here")
    }
}
