//
//  startTutorialView.swift
//  MC3
//
//  Created by Vanessa on 15/07/24.
//

import SwiftUI

struct startTutorialView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                NavigationLink(destination: tutorialView()) {
                    Text("Start Tutorial")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 220, height: 55)
                        .background(Color.hex("#930F0D"))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}
#Preview {
    startTutorialView()
}
