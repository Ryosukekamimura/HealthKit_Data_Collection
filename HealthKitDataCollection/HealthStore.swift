//
//  HealthStore.swift
//  HealthKitDataCollection
//
//  Created by 神村亮佑 on 2020/10/19.
//

import Foundation
import HealthKit


class HealthStore{
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    // Only StepCount Type
    let alltypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)])
    
    init() {
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
        }
    }
    
    // Is HealthKit Available
    func isAvailable() {
        if HKHealthStore.isHealthDataAvailable(){
            print("HealthKit Available")
        }else{
            print("Unavailable")
        }
    }
}
