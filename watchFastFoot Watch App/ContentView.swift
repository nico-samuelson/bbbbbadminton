//
//  ContentView.swift
//  watchFastFoot Watch App
//
//  Created by Vanessa on 16/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("pause")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
         
        }
    }
}

#Preview {
    ContentView()
}
