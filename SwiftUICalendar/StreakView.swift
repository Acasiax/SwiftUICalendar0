//
//  StreakView.swift
//  SwiftCal.2
//
//  Created by 이윤지 on 2023/04/02.
//

import SwiftUI
import CoreData


struct StreakView: View {
    
    @State private var streakVaule = 0
    var body: some View {
        VStack{
            Text("\(streakVaule)")
                .font(.system(size: 200, weight: .semibold, design: .rounded))
                .foregroundColor(streakVaule > 0 ? .orange : .pink)
            Text("Current Streak")
                .font(.title2)
                .bold()
                .foregroundColor(.secondary)
            
        }
        .offset(y: -50)
    }
}

struct StreakView_Previews: PreviewProvider {
    static var previews: some View {
        StreakView()
    }
}
