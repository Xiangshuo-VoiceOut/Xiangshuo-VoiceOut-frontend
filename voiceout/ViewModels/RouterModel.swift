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
    case resetPassword(UserRole)
    case forgetPassword(UserRole)
    case successRedirect(title: String)
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
        case .resetPassword(let role):
            ResetPasswordView(role)
        case .forgetPassword(let role):
            ForgetPasswordView(role)
        case .successRedirect(let title):
            FinishView(title: title)
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
