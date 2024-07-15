//
//  cardViewModel.swift
//  MC3
//
//  Created by Vanessa on 14/07/24.
//

import SwiftUI


class CardViewModel: ObservableObject {
    @Published var cardData: [CardData] = [
        CardData(title: "How to Improve Your Badminton Footwork: The Complete Guide", subtitle: "Footwork", imageName: "exampleimage", rating: "4.9", duration: "3m", detail: "Footwork Steps\n\nThere are dozens of step variations in badminton, and they often use combinations of jumps, shuffles, and lunges. Learning all of them can take some time, so it’s helpful to get the basics down first.\n\nHere are four basic footwork steps to get familiar with:\n\n-Split step: This is a short hop-like technique that you’ll use to widen your stance and generate power before making your next move.\n-Running step: This is the basic running motion you’ll use to reach many of your opponent’s shots.\n-Chasse step: This is an effective way to close a short distance on the court. Check out this excellent video tutorial to see how it works.\n-Recovery step: This is the step (or “hop”) you’ll take to move back to your base position after swinging your racket. Here’s a helpful video on the recovery step.\n\nBase Position\nThe base position is the point from which you can most easily reach your opponents’ shots — no matter which direction they send them flying.\nFor singles, the base position will be the center of the court. For doubles, it will be the centermost point of the side that you’re covering.\n\nReady Stance\nThe ready stance is the position that allows you to jump into action quickly and accurately. If you aren’t confident in your ready stance or haven’t had a lot of time to practice, be sure to check out this guide.", author: "Justin Ma", date: "2024"),
        CardData(title: "Yoga Instructor", subtitle: "Wellness", imageName: "exampleimage", rating: "4.8", duration: "3h 15m", detail: "Yoga is a holistic practice that improves both physical and mental well-being. A yoga instructor can guide you through personalized sessions to enhance flexibility, strength, and mindfulness.", author: "Dhammiko", date: "2024"),

    ]
}
