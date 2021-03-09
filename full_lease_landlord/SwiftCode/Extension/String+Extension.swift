//
//  String+Extension.swift
//  full_lease_landlord
//
//  Created by apple on 2021/1/29.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

public extension String {
    @discardableResult
    func correctPrecision() -> String {
        let conversionValue: Double = Double(self) ?? 0
        let doubleString = String.init(format: "%lf", conversionValue)
        let decNumber = Decimal.init(string: doubleString)
        return decNumber!.description
    }
    
}
