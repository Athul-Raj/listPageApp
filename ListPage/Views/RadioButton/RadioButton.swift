//
//  RadioButton.swift
//  ListPage
//
//  Created by Athul Raj on 12/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit

class RadioButton: UIButton {
    var alternateButton:Array<RadioButton>?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func unselectAlternateButtons(){
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:RadioButton in alternateButton! {
                aButton.isSelected = false
            }
        }else{
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton(){
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                //self.titleLabel?.textColor = Utilities.uicolorFromHex(rgbValue: UInt32(ColorHex.pinkColor))
                //self.backgroundColor = UIColor.white
                self.layer.borderColor = Utilities.uicolorFromHex(rgbValue: UInt32(ColorHex.pinkColor)).cgColor
            } else {
                //self.titleLabel?.textColor = UIColor.darkGray
                //self.backgroundColor = UIColor.white
                self.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
}
