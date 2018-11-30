//
//  ButtonsDesign.swift
//  Dots
//
//  Created by Leon Vladimirov on 9/9/18.
//  Copyright © 2018 Leon Vladimirov. All rights reserved.
//

import Foundation
import UIKit

class ButtonDesign: UIButton {
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 10
        
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor.darkGray
    }

    
}
