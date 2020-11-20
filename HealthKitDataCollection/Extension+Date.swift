//
//  Extension+Date.swift
//  HealthKitDataCollection
//
//  Created by 神村亮佑 on 2020/11/20.
//

import Foundation

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}
