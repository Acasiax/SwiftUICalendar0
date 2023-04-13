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
    
    @State private var safeAreaInsets = EdgeInsets()

    var body: some View {
        NavigationView {
            VStack {
                // title 앞뒤에 버튼이 추가된 NavigationView 입니다.
                // .navigationTitle("") // title을 빈 값으로 설정
                
                // HStack에 이전 월, 다음 월 버튼을 추가합니다.
                HStack {
                    Button(action: {
                        // 이전 월로 이동하는 코드
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    })
                    Spacer()
                    Text(Date().formatted(.dateTime.month(.wide)))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(25)
                    
                    Spacer()
                    Button(action: {
                        // 다음 월로 이동하는 코드
                    }, label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                    })
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // 나머지 내용은 그대로 유지합니다.
                HStack(spacing: 0) {
                    ForEach(dayOfWeek, id: \.self) { dayOfWeek in
                        Text(dayOfWeek)
                            .fontWeight(.black)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 10)
                .padding(.top, -10) // 요일 배열이 월 아래에 위치하도록 top padding을 추가
                Spacer()
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
                .navigationBarTitleDisplayMode(.inline)
            
            }
            .edgesIgnoringSafeArea(.bottom)
            // title 앞뒤에 버튼이 추가된 NavigationView 입니다.
            // .navigationTitle("") // title을 빈 값으로 설정
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    HStack {
//                        Button(action: {
//                            // 이전 월로 이동하는 코드
//                        }, label: {
//                            Image(systemName: "chevron.left")
//                                .font(.title2)
//                        })
//
//                        Text(Date().formatted(.dateTime.month(.wide)))
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                            .padding(10)
//
//                        Button(action: {
//                            // 다음 월로 이동하는 코드
//                        }, label: {
//                            Image(systemName: "chevron.right")
//                                .font(.title2)
//                        })
//                    }
//                }
//            }
        }
    }
        
        
        func creatMonthDays(for date: Date){
            
            for dayOffset in 0..<date.numberOfDaysInMonth{
                let newDay = Day(context: viewContext)
                newDay.date = Calendar.current.date(byAdding: .day, value: dayOffset, to: date.startOfMonth)
                
                newDay.didStudy = false
            }
            
        }
        
    
    
    
    
    
    
    struct ContentView_Previewss: PreviewProvider {
        static var previews: some View {
            CalendarView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

