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
    
    private var healthStoreInstance: HealthStore?
    @State private var steps: [Step] = [Step]()
    @State private var isAlert: Bool = false
    
    init() {
        healthStoreInstance = HealthStore()
    }
    
    var body: some View {
        NavigationView {
            VStack{
                GraphView(steps: steps)
                Button(action: {
                    exportJson()
                    self.isAlert = true
                }, label: {
                    Text("Export Json File")
                }).alert(isPresented: self.$isAlert, content: {
                    Alert(title: Text("データを取得しました🙂"))
                })
            }
            .navigationTitle("歩数データの取り出し")
        }
        .onAppear {
            if let healthStore = healthStoreInstance {
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
    
    //MARK: FUNCTIONS
    func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
            
        }
    }
    
    func exportJson() {
        //MARK: Export Json File
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        do{
            let data = try encoder.encode(steps)
            let jsonstr :String = String(data: data, encoding: .utf8)!
            print(jsonstr)
            
            // MARK: Write to output.json
            let fileName = "output.json"
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
