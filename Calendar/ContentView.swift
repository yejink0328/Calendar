//
//  ContentView.swift
//  Calendar
//
//  Created by MAX on 2023/07/14.
//

import SwiftUI

struct ContentView: View {
    
    @State var month: Date
    @State var offset: CGSize = CGSize()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)

    var body: some View {
        VStack{
            headerView
            calendarGridView
        }
        .padding(20)
        .gesture(
        DragGesture()
            .onChanged{ gesture in self.offset = gesture.translation
            }
            .onEnded { gesture in
                if gesture.translation.width < 10 {
                    changeMonth(by: 1)
                } else if gesture.translation.width > 10 {
                    changeMonth(by: -1)
                }
                self.offset = CGSize()
            }
        )
    }
    
    private var headerView: some View {
        VStack{
            Text("요소 :\(firstWeekdayOfMonth(in: month))")
            Text(month, formatter: Self.dateFormatter)
                .font(.title)
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { index in
                    ZStack{
                        Text(Self.weekdaySymbols[index])
                            .frame(width: 50, height: 50)
                    }
                }
            }
        }
    }
    
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        
        return VStack{
            LazyVGrid(columns: columns, spacing: 2) {
//                ForEach(1 ..< firstWeekday + daysInMonth, id: \.self) { index in
//                    if (index < firstWeekday) {
//                        Text("\(firstWeekday)-")
//                            .frame(width: 50, height: 50)
//                    } else {
//                            let day = firstWeekday
//                            cellView(day: day)
//                        }
//                }
                
                ForEach(0 ..< firstWeekday, id: \.self) { _ in
                    Text("")
                        .frame(width: 50, height: 50)
                }
                
                ForEach(1 ..< daysInMonth + 1, id: \.self) { day in
                    cellView(day: day)
                }
            }
        }
    }
}

struct cellView: View {
    
    @State private var isClick: Bool = false
    @State private var day: Int
    
    init(day: Int) {
        self.day = day
    }
    
    var body: some View {
        ZStack{
            if isClick {
                Color(.orange)
            }
            Text("\(day)")
                .frame(width: 50, height: 50)
        }
        .onTapGesture {
            self.isClick.toggle()
        }
        .sheet(isPresented: $isClick) {
            resultSheetView(day: $day)
        }
    }
}

struct resultSheetView: View {
    @Binding var day: Int
    
    var body: some View {
        Text("\(day)일 결과시트")
    }
}

private extension ContentView {
    private func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
    }
    
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }
}

extension ContentView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter
    }()
    
    static let weekdaySymbols: [String] = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.shortWeekdaySymbols
        }()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(month: Date())
    }
}
