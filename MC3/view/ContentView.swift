//
//  ContentView.swift
//  MC3
//
//  Created by Vanessa on 11/07/24.
//
import SwiftUI

struct ContentView: View {
    @ObservedObject var cardViewModel = CardViewModel()
    @ObservedObject var statisticsViewModel = StatisticsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("Train My Footwork")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.top, .leading], 16.0)
                    Spacer()
                }
                
                ScrollView {
                    // Tips and Tricks
                    VStack(alignment: .leading) {
                        Text("Tips and Tricks")
                            .font(.system(size: 18))
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
                    VStack(alignment: .leading) {
                        Text("Statistics Detail")
                            .font(.system(size: 18))
                            .padding([.top, .leading], 16.0)
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
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("300")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("Reps")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("280")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("Accuracy")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding([.leading, .trailing, .bottom])
                        
                        GeometryReader { geometry in
                            let data = statisticsViewModel.statistics.map { $0.value }
                            let months = statisticsViewModel.statistics.map { $0.month }
                            
                            let width = geometry.size.width
                            let height = geometry.size.height
                            
                            let maxData = data.max() ?? 1
                            let minData = data.min() ?? 0
                            
                            let xStep = width / CGFloat(data.count - 1)
                            let yScale = height / CGFloat(maxData - minData)
                            
                            ZStack {
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: height))
                                    path.addLine(to: CGPoint(x: 0, y: 0))
                                    
                                    path.move(to: CGPoint(x: 0, y: height))
                                    path.addLine(to: CGPoint(x: width, y: height))
                                }
                                .stroke(Color.gray, lineWidth: 1)
                                
                                // Garis data
                                Path { path in
                                    guard data.count > 1 else { return }
                                    
                                    path.move(to: CGPoint(x: 0, y: height - CGFloat(data[0] - minData) * yScale))
                                    
                                    for index in 1..<data.count {
                                        let xPosition = CGFloat(index) * xStep
                                        let yPosition = height - CGFloat(data[index] - minData) * yScale
                                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                                    }
                                }
                                .stroke(Color.hex("#930F0D"), lineWidth: 2)
                                
                                // Label sumbu X
                                ForEach(0..<data.count, id: \.self) { index in
                                    Text(months[index])
                                        .font(.caption)
                                        .position(x: CGFloat(index) * xStep, y: height + 10)
                                }
                                
                                // Label sumbu Y
                                ForEach(0..<Int(maxData - minData) + 1, id: \.self) { index in
                                    Text("\(Int(minData) + index)")
                                        .font(.caption)
                                        .position(x: -20, y: height - CGFloat(index) * yScale)
                                }
                            }
                            .padding()
                        }
                        .frame(height: 220)
                        .padding(.bottom, 40)
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
                    }
                    .padding(.bottom, 59.0)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CardView: View {
    let card: CardData

    var body: some View {
        NavigationLink(destination: DetailView(card: card)) {
            HStack(alignment: .center, spacing: 10) {
                Image(card.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 90)
                    .cornerRadius(10)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(card.subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text(card.title)
                        .font(.system(size: 17))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
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
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            .frame(width: 270)
            .padding(.trailing, 10)
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
