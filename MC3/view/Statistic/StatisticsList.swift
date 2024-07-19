import SwiftUI

struct StatisticsList: View {
    @State private var showItems: [Bool] = Array(repeating: false, count: 20)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 20) {
                ForEach(0..<20, id: \.self) { index in
                    NavigationLink(destination: VideoListView()/*, tag: index, selection: $selectedDetailIndex*/)  {
                        VStack(alignment: .leading) {
                            Text("June 30, 2024")
                                .font(.custom("SF Pro Text", size: 18))
                            Text("Sunday Morning Exercise")
                                .foregroundStyle(.gray)
                                .font(.custom("SF Pro Text", size: 16))
                            HStack {
                                VStack {
                                    Text("0:10:05")
                                        .bold()
                                        .font(.custom("SF Pro Text", size: 22))
                                    Text("Time")
                                        .font(.custom("SF Pro Text", size: 12))
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Text("10")
                                        .font(.custom("SF Pro Text", size: 22))
                                    Text("Reps")
                                        .font(.custom("SF Pro Text", size: 12))
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Text("05")
                                        .font(.custom("SF Pro Text", size: 22))
                                    Text("Accuracy")
                                        .font(.custom("SF Pro Text", size: 12))
                                }
                                .padding(.vertical, 5)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .offset(x: showItems[index] ? 0 : 400)
                        .opacity(showItems[index] ? 1 : 0)
                        .animation(.easeOut.delay(Double(index) * 0.1), value: showItems[index])
                    }
                }
                .foregroundColor(.black)
            }
            .padding()
            .onAppear {
                for index in 0..<showItems.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                        withAnimation {
                            showItems[index] = true
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
