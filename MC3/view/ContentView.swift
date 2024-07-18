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
                    Text("Train My Foot")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                
                ScrollView {
                    // Tips and Tricks
                    VStack(alignment: .leading) {
                        Text("Tips and Tricks")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding([.leading, .top])
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
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding([.leading, .top])
                        HStack {
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
                                // Garis sumbu X dan Y
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
                                .stroke(Color.red, lineWidth: 2)
                                
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
                            .frame(width: 100, height: 100)
                            .background(Color.red)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.bottom)
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
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(card.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(card.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .lineLimit(1)  // Batasi satu baris
                        .truncationMode(.tail)  // Tambahkan titik tiga jika terpotong

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


#Preview {
    ContentView()
}
