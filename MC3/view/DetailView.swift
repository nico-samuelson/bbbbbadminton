//
//  DetailView.swift
//  MC3
//
//  Created by Vanessa on 14/07/24.
//

import SwiftUI

struct DetailView: View {
    let card: CardData

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(card.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(card.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)

                HStack {
                    Text("by \(card.author)")
                    Spacer()
                    Text(card.date)
                    Spacer()
                    Text(card.duration)
                }
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 10)

                Image(card.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding(.bottom, 10)

                Text(card.detail)
                    .padding(.bottom, 5)
            }
            .padding()
            .navigationTitle(card.title)
        }
    }
}
