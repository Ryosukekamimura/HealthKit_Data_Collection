//
//  HealthStore.swift
//  HealthKitDataCollection
//
//  Created by 神村亮佑 on 2020/10/19.
//

import Foundation
import HealthKit


extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

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
    
    // Execute Statistics Queries
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let startDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        
        let anchorDay = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDay, intervalComponents: daily)
        
        query!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
            
        }
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
        
    }
    
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        guard let healthStore = self.healthStore else {
            return completion(false)
        }
        healthStore.requestAuthorization(toShare: [], read: [stepType]){(success, error) in
            completion(success)
        }
    }
}
