//
//  statisticViewModel.swift
//  MC3
//
//  Created by Vanessa on 14/07/24.
//


import SwiftUI

class StatisticsViewModel: ObservableObject {
    @Published var statistics: [Statistic] = [
        Statistic(month: "Jan", value: 10),
        Statistic(month: "Feb", value: 20),
        Statistic(month: "Mar", value: 15),
        Statistic(month: "Apr", value: 30),
        Statistic(month: "May", value: 25),
        Statistic(month: "Jun", value: 40),
        Statistic(month: "Jul", value: 35)
    ]
}

