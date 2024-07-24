//
//  ContentView.swift
//  MC3
//
//  Created by Vanessa on 11/07/24.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var cardViewModel = CardViewModel()
    @ObservedObject var statisticsViewModel = StatisticsViewModel()
//    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink(destination: ProfileView()) {
                        Image("profile")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(.top, 40.0)
                            .padding(.leading, 16.0)
                    }
                                   
                                   Spacer()
                               }
                HStack {
                    Text("Train My Footwork")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                     
                        .padding([.leading], 16.0)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("Tips and Tricks")
                        .font(.system(size: 13))
                        .padding([.leading, .top], 16.0)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(cardViewModel.cardData) { card in
                                CardView(card: card)
                            }
                        }
                        .padding([.leading, .bottom])
                    }
                }
                
                // Statistics Detail
                VStack() {
                    HStack{
                        Text("Statistics Detail")
                            .font(.system(size: 13))
                            .padding(.top, -5.0)
                        Spacer()
                        //                        NavigationLink(destination: StatisticDetail()) {
                        Text("Show More")
                            .font(.system(size: 13))
                            .underline()
                            .padding(.top, -5.0)
                        //                        }
                        
                    }
                    Spacer()
                    HStack{
                        
                        VStack(alignment: .leading) {
                            Text("5:45:10")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Time")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("300")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Reps")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 32.0)
                        
                        
                        VStack(alignment: .leading) {
                            Text("280")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Accuracy")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 32.0)
                        Spacer()
                    }
                    .padding(.leading)
                    
                    GeometryReader { geometry in
                        let data = statisticsViewModel.statistics.map { $0.value }
                        let months = statisticsViewModel.statistics.map { $0.month }
                        
                        let width = geometry.size.width
                        let height = geometry.size.height
                        
                        let maxData = data.max() ?? 1
                        let minData = data.min() ?? 0
                        
                        let barWidth = width / CGFloat(data.count * 2)
                        let yScale = height / CGFloat(maxData - minData)
                        
                        ZStack {
                            // Sumbu Y
                            Path { path in
                                path.move(to: CGPoint(x: 30, y: height))
                                path.addLine(to: CGPoint(x: 30, y: 0))
                                
                                path.move(to: CGPoint(x: 30, y: height))
                                path.addLine(to: CGPoint(x: width, y: height))
                            }
                            .stroke(Color.gray, lineWidth: 1)
                            
                            // Garis data
                            ForEach(0..<data.count, id: \.self) { index in
                                let xPosition = CGFloat(index) * (barWidth * 2) + 40
                                let barHeight = CGFloat(data[index] - minData) * yScale
                                
                                Path { path in
                                    path.addRect(CGRect(x: xPosition, y: height - barHeight, width: barWidth, height: barHeight))
                                }
                                .fill(Color.hex("#930F0D"))
                            }
                            
                            // Label sumbu X
                            ForEach(0..<data.count, id: \.self) { index in
                                Text(months[index])
                                    .font(.caption)
                                    .position(x: CGFloat(index) * (barWidth * 2) + barWidth / 2 + 40, y: height + 10)
                            }
                            
                            // Label sumbu Y
                            ForEach(Array(stride(from: minData, through: maxData, by: 10)), id: \.self) { value in
                                Text("\(Int(value))")
                                    .font(.caption)
                                    .position(x: 15, y: height - CGFloat(value - minData) * yScale)
                            }
                        }
                        
                    }
                    .frame(height: 150)
                    .padding([.top, .bottom, .trailing], 20.0)
                }
                .padding(.horizontal)
                
                
                // Navigasi ke TrainView
                NavigationLink(destination: trainView()) {
                    Text("Start")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 118, height: 118)
                        .background(Color.hex("#930F0D"))
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .padding(.bottom, 10.0)
                        .padding(.top, 10.0)
                }
                
                
            }
            .background(Color.hex("#FAF9F6"))
            .navigationBarHidden(true)
        }
//        .modelContext(modelContext)
    }
}

struct CardView: View {
    let card: CardData
    
    var body: some View {
        NavigationLink(destination: DetailView(card: card)) {
            HStack(alignment: .center) {
                Image(card.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 81, height: 81)
                    .cornerRadius(10)
                    .clipped()
                
                VStack(alignment: .leading) {
                    Text(card.subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text(card.title)
                        .font(.system(size: 17))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .truncationMode(.tail)
                    
                    HStack {
                        //                        Label(card.rating, systemImage: "star.fill")
                        //                            .foregroundColor(.gray)
                        Label(card.duration, systemImage: "clock")
                            .foregroundColor(.gray)
                    }
                    .font(.caption)
                }
                .padding(.vertical, 10)
            }
            .padding()
            .background(Color.hex("#FEFEFE"))
            .cornerRadius(15)
            .shadow(radius: 5)
            .frame(width: 270)
            .padding(.vertical, 10)
        }
    }
}

extension Color {
    static func hex(_ hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        return Color(red: red, green: green, blue: blue)
    }
}

#Preview {
    ContentView()
}
