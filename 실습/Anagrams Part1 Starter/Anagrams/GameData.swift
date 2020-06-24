//
//  GameData.swift
//  Anagrams
//
//  Created by kpugame on 2020/05/28.
//  Copyright © 2020 Caroline. All rights reserved.
//

import Foundation

class GameData
{
    var points: Int = 0 {
        didSet {
            points = max(points, 0)
        }
    }
}
