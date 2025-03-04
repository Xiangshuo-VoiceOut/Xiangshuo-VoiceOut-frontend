//
//  RouterModel.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/26/24.
//

import SwiftUI

enum Route: Hashable {
    case userLogin
    case userSignUp
    case therapistLogin
    case therapistSignup
    case therapistSignupSuccess
    case therapistRegister
    case resetPassword(UserRole)
    case forgetPassword(UserRole)
    case successRedirect(title: String)
    case profilePage
    case questionDetail(title: String, questionID: String, answers: [FAQAnswer])
    case profileWithReservation(date: Date, slot: Slot)
    case waitingConfirmation(date: Date, timeSlot: Slot, clinicianId: String)
}

final class RouterModel: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()

    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .userLogin:
            LoginView(.user)
        case .userSignUp:
            UserSignUpView()
        case .therapistLogin:
            LoginView(.therapist)
        case .therapistSignup:
            TherapistSignupView()
        case .therapistSignupSuccess:
            TherapistFinishView()
        case .therapistRegister:
            RegistrationFormView()
        case .resetPassword(let role):
            ResetPasswordView(role)
        case .forgetPassword(let role):
            ForgetPasswordView(role)
        case .successRedirect(let title):
            FinishView(title: title)
        case .profilePage:
            ProfilePageView()
                .environmentObject(self)
        case .questionDetail(let title, let questionID, let answers):
            BeforeFirstConsultationView(
                title: title,
                questionID: questionID,
                answers: answers
            )
        case .profileWithReservation(let date, let slot):
            ProfilePageView()
                .environmentObject(self)
                .onAppear {
                    DispatchQueue.main.async {
                    }
                }
        case .waitingConfirmation(let date, let timeSlot, let clinicianId):
            WaitingConfirmationView(selectedDate: date, selectedTimeSlot: timeSlot, consultantId: clinicianId)
                .environmentObject(self)
        }
    }

    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }

    func navigateBack() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
