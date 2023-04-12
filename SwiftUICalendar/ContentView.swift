//
//  ContentView.swift
//  SwiftUICalendar
//
//  Created by 이윤지 on 2023/04/12.
//

import SwiftUI
import CoreData

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private var calendar: Calendar
    private var today: Date
    private var startOfMonth: Date

    init() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        self.calendar = calendar
        
        let now = Date()
        let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: now)!
        self.today = startOfDay
        
        let components = DateComponents(year: calendar.component(.year, from: today), month: calendar.component(.month, from: today))
        guard let startOfMonth = calendar.date(from: components) else { fatalError("Failed to get start of month") }
        self.startOfMonth = startOfMonth
        
        calendar.firstWeekday = 2
        var date = startOfMonth
        while calendar.component(.weekday, from: date) != calendar.firstWeekday {
            date = calendar.date(byAdding: .day, value: -1, to: date)!
        }
        self.startOfMonth = date
    }



    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)",
                               //⭐️
                               Date().startOfCalendarWithPrefixDays as CVarArg,
                              // Date().startOfMonth as CVarArg,
                               Date().endOfMonth as CVarArg))
    private var days: FetchedResults<Day>


    private func fetchRequest() -> NSFetchRequest<Day> {
        let request = NSFetchRequest<Day>(entityName: "Day")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Day.date, ascending: true)]
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", Date().startOfMonth as CVarArg, Date().endOfMonth as CVarArg)
        return request
    }



    
    let dayOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
       private let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "d"
           formatter.locale = Locale(identifier: "ko_KR")
           formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
           return formatter
       }()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(Date().formatted(.dateTime.month(.wide)))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    ForEach(dayOfWeek, id: \.self) { dayOfWeek in
                        Text(dayOfWeek)
                            .fontWeight(.black)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                    }
                }
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                        ForEach(days){ day in
                            if day.date!.monthInt != Date().monthInt {
                                Text(" ")
                            } else {
                                Text(day.date!, formatter: dateFormatter)
                                    .fontWeight(.bold)
                                    .foregroundColor(day.didStudy ? .orange : .secondary)
                                    .frame(maxWidth: .infinity, minHeight: 40)
                                    .background(
                                        Circle()
                                            .foregroundColor(.orange.opacity(day.didStudy ? 0.3 : 0.0))
                                    )
                                    .onTapGesture {
                                        if day.date!.dayInt <= Date().dayInt{
                                            day.didStudy.toggle()
                                            do {
                                                try viewContext.save()
                                                print("✅ \(day.date!.dayInt) 일 날에 공부했어요.")
                                            } catch {
                                                print("내용을 저장하는데 실패하였습니다.")
                                            }
                                        } else {
                                            print("미리 공부했다고 표시 할 수는 없어요!!")
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
            .navigationTitle(Date().formatted(.dateTime.month(.wide)))
            .padding()
            .onAppear {
                if days.isEmpty {
                    creatMonthDays(for: .now.startOfPreviousMonth)
                    creatMonthDays(for: .now)
                } else if days.count < 10 {
                    creatMonthDays(for: .now)
                }
            }
        }
    }

    
    func creatMonthDays(for date: Date){
        
        for dayOffset in 0..<date.numberOfDaysInMonth{
            let newDay = Day(context: viewContext)
            newDay.date = Calendar.current.date(byAdding: .day, value: dayOffset, to: date.startOfMonth)
            
            newDay.didStudy = false
        }
    
    }
    
}
    




struct ContentView_Previewss: PreviewProvider {
    static var previews: some View {
        CalendarView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

