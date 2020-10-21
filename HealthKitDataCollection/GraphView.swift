//
//  GraphViewSwift.swift
//  HealthKitDataCollection
//
//  Created by 神村亮佑 on 2020/10/21.
//

import SwiftUI

struct GraphView: View {
    
    
    static let dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
        
    }()
    
    let steps: [Step]
    
    var totalSteps: Int {
        steps.map { $0.count }.reduce(0,+)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                
                ForEach(steps, id: \.id) { step in
                    
                    let yValue = Swift.min(step.count/20, 300)
                    
                    VStack {
                        Text("\(step.count)")
                            .font(.caption)
                            .foregroundColor(Color.black)
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 20, height: CGFloat(yValue))
                        Text("\(step.date,formatter: Self.dateFormatter)")
                            .font(.caption)
                            .foregroundColor(Color.black)
                    }
                }
                
            }
            
            Text("Total Steps: \(totalSteps)").padding(.top, 100)
                .foregroundColor(Color.white)
                .opacity(0.5)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        .cornerRadius(10)
        .padding(10)
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        
        let steps = [
                   Step(count: 3452, date: Date()),
                   Step(count: 123, date: Date()),
                   Step(count: 1223, date: Date()),
                   Step(count: 5223, date: Date()),
                   Step(count: 12023, date: Date())
               ]
        
        GraphView(steps: steps)
    }
}
