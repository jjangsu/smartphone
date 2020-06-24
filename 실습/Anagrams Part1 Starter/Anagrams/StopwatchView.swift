//
//  StopwatchView.swift
//  Anagrams
//
//  Created by kpugame on 2020/05/28.
//  Copyright © 2020 Caroline. All rights reserved.
//

import Foundation
import UIKit

class StopWatchView: UILabel
{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(fram: )")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.font = FontHUDBig
    }
    
    func setSeconds(_ seconds: Int)
    {
        self.text = String(format: " %02i : %02i", seconds / 60, seconds % 60)
    }
}
