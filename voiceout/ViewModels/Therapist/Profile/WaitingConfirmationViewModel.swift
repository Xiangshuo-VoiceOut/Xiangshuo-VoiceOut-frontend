//
//  WaitingConfirmationViewModel.swift
//  voiceout
//
//  Created by Yujia Yang on 2/3/25.
//

import Foundation

class WaitingConfirmationViewModel: ObservableObject {
    @Published var order: Order?
    @Published var isLoading = false

    func fetchOrderDetails(orderId: String) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.order = Order(
                id: orderId,
                consultantName: "董丽华",
                consultationTime: "2024年9月9日 16:00-16:50 PM",
                price: "$200.00",
                status: "待支付",
                message: "请准时参加会议"
            )
            self.isLoading = false
        }
    }
}

