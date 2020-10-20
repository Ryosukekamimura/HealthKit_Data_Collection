//
//  Step.swift
//  HealthKitDataCollection
//
//  Created by 神村亮佑 on 2020/10/20.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}
