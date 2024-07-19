//
//  Achievements.swift
//  MC3
//
//  Created by samuel on 17/07/24.
//

import SwiftUI

struct Achievements: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                HStack{
                    
                    Text("Latest Achievements")
                        .bold()
                        .font(.system(size: 17))
                         .foregroundColor(Color.black)
                    Spacer()
                }
                .padding()
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 20) {
                        ForEach(0..<10) { index in
                            VStack {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(Color.red)
//                                    .foregroundColor(Color(UIColor(hex: "930F0D")))
                                Text("Item \(index + 1)")
                                    .font(.headline)
                            }
                            .frame(width: 150, height: 200)
                            .background(RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.red)
//                                .stroke(Color(UIColor(hex: "930F0D")), lineWidth: 2))
                            .background(RoundedRectangle(cornerRadius: 24).fill(Color.white))
                            .clipShape(RoundedRectangle(cornerRadius: 24)))
                        }
                    }
                    .padding()
                    
                }
                
                HStack{
                    
                    Text("Personal Records")
                        .bold()
                        .font(.system(size: 17))
                         .foregroundColor(Color.black)
                    Spacer()
                }
                .padding()
                ScrollView(.vertical, showsIndicators: true) {
                          LazyVGrid(columns: columns, spacing: 20) {
                              ForEach(0..<20) { index in
                                  VStack {
                                      Image(systemName: "star.fill")
                                          .resizable()
                                          .frame(width: 80, height: 80)
                                          .foregroundColor(.red)
                                      Text("Item \(index + 1)")
                                          .font(.headline)
                                  }
                                  .frame(width: 100, height: 150)
                                  .background(Color.gray.opacity(0.2))
                                  .cornerRadius(12)
                                  .shadow(radius: 5)
                              }
                          }
                          .padding()
                      }            }
        }
    }
}

#Preview {
    Achievements()
}
