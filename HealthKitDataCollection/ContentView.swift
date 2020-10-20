//
//  ContentView.swift
//  HealthKit_Tutorial
//
//  Created by 神村亮佑 on 2020/08/15.
//  Copyright © 2020 神村亮佑. All rights reserved.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    
    @State private var steps: [Step] = [Step]()
    
    private var healthStore: HealthStore?
    
    init() {
        healthStore = HealthStore()
    }
    
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate){ (statistics, stop) in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            self.steps.append(step)
        }
    }
    
    var body: some View {
        
        NavigationView{
            List(steps, id: \.id) { step in
                VStack{
                    
                    Text("\(step.count)")
                    Text("\(step.date)")
                        .opacity(0.5)
                }
            }
        .navigationBarTitle("Just Stepping")
        }
        
            .onAppear{
                if let healthStore = self.healthStore {
                    healthStore.requestAuthorization{ success in
                        if success {
                            healthStore.calculateSteps { statisticsCollection in
                                if let statisticsCollection = statisticsCollection {
                                    //Updata UI
                                    self.updateUIFromStatistics(statisticsCollection)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
