//
//  ContentView.swift
//  HealthKitDataCollection
//
//  Created by 神村亮佑 on 2020/10/19.
//

import SwiftUI

struct ContentView: View {
    
    let healthStore = HealthStore()
    
    var body: some View {
        Button(action: {
            healthStore.isAvailable()
        }, label: {
            Text("Is HealthKit available?")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
