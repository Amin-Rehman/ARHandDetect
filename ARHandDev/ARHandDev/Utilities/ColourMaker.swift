//
//  ColourMaker.swift
//  ARHandDev
//
//  Created by Amin Rehman on 19.11.19.
//  Copyright © 2019 Stephanie. All rights reserved.
//

import UIKit
import Foundation

struct ColourMaker {
    static func makeRandomColor() -> UIColor {
      let red = CGFloat(drand48())
      let green = CGFloat(drand48())
      let blue = CGFloat(drand48())
      return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
