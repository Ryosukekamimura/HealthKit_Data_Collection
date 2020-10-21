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
    
    private var healthStore: HealthStore?
    @State private var steps: [Step] = [Step]()
    
    init() {
        healthStore = HealthStore()
    }
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
            
        }
        
        // Write to Json
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        do{
            let data = try encoder.encode(steps)
            let jsonstr :String = String(data: data, encoding: .utf8)!
            print(jsonstr)
            
            // output.jsonに書き込み
            let fileName = "output.json"
//            if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last{
//                let targetTextFilePath = documentDirectoryFileURL.appendingPathComponent(fileName)
//                print(targetTextFilePath)
//                do{
//                    try jsonstr.write(to: targetTextFilePath, atomically: true, encoding: String.Encoding.utf8)
//                }catch let error as NSError{
//                    print("failed to write : \(error)")
//                }
//            }
            
            do{
                let fileManager = FileManager.default
                let docs = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let path = docs.appendingPathComponent(fileName)
                print(path)
                let data = jsonstr.data(using: .utf8)!
                
                fileManager.createFile(atPath: path.path, contents: data, attributes: nil)
            }catch{
                print(error)
            }
            
            
        }catch{
            print(error.localizedDescription)
        }
        
        
    }
    
    var body: some View {
        
        NavigationView {
        
            VStack{
                GraphView(steps: steps)
                Button(action: {
                    
                }, label: {
                    Text("Export Json File")
                })
            }

            
            
        .navigationTitle("Just Walking")
        }
       
        
            .onAppear {
                if let healthStore = healthStore {
                    healthStore.requestAuthorization { success in
                        if success {
                            healthStore.calculateSteps { statisticsCollection in
                                if let statisticsCollection = statisticsCollection {
                                    // update the UI
                                    updateUIFromStatistics(statisticsCollection)
                                    
                                    
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
