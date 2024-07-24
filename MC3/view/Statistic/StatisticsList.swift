import SwiftUI
import SwiftData

struct StatisticsList: View {
    @Environment(\.modelContext) var modelContext
    @Query private var exercises: [Exercise]
    @State private var currentIndex: Int = 0
    
    func formatDate(date: Date, format: String = "MMMM dd, yyyy", locale: String = "en_US") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: locale)
        
        return dateFormatter.string(from: date)
    }
    
    func setWorkoutTitle(date: Date) -> String {
        let day = formatDate(date: date, format: "EEEE")
        
        let hour = Int(formatDate(date: date, format: "HH", locale: "ID")) ?? 0
        var time = "Morning"
        
        if hour >= 12 && hour < 15 {
            time = "Noon"
        }
        else if hour >= 15 && hour < 18 {
            time = "Afternoon"
        }
        else if hour >= 18 && hour < 24 {
            time = "Night"
        }
        
        return "\(day) \(time) Exercise"
    }
    
    func formatDuration(_ seconds: Int) -> String {
        let hour = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        
        return "\(hour):\(minutes):\(seconds)"
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 20) {
                ForEach(Array(exercises.enumerated()), id: \.element) { index, exercise in
                    NavigationLink(destination: VideoListView(exercise: exercise))  {
                        VStack(alignment: .leading) {
                            Text(formatDate(date: exercise.date))
                                .font(.custom("SF Pro Text", size: 18))
                            Text(setWorkoutTitle(date: exercise.date))
                                .foregroundStyle(.gray)
                                .font(.custom("SF Pro Text", size: 16))
                            HStack {
                                VStack {
                                    Text(formatDuration(Int(exercise.duration)))
                                        .bold()
                                        .font(.custom("SF Pro Text", size: 22))
                                    Text("Time")
                                        .font(.custom("SF Pro Text", size: 12))
                                }
                                
                                Spacer()
                                
//                                VStack {
//                                    Text("10")
//                                        .font(.custom("SF Pro Text", size: 22))
//                                    Text("Reps")
//                                        .font(.custom("SF Pro Text", size: 12))
//                                }
                                
//                                Spacer()
                                
                                VStack {
                                    Text("\(Int(exercise.accuracy))%")
                                        .font(.custom("SF Pro Text", size: 22))
                                    Text("Accuracy")
                                        .font(.custom("SF Pro Text", size: 12))
                                }
                                .padding(.vertical, 5)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .padding()
                        .background(Color("Text").opacity(0.1))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .offset(x: index <= currentIndex ? 0 : 400)
                        .opacity(index <= currentIndex ? 1 : 0)
                        .animation(.easeOut.delay(Double(index) * 0.1), value: index <= currentIndex)
                    }
                }
                .foregroundColor(Color("Text"))
            }
            .padding()
            .onAppear {
                print("Exercise count: \(exercises.count)")
                for index in 0..<exercises.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                        withAnimation {
                            currentIndex += 1
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Statistic List", displayMode: .inline)
    }
}

#Preview {
    StatisticsList()
}
