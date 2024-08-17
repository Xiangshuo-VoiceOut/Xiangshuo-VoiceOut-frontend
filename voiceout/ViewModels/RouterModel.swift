//
//  RouterModel.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/26/24.
//

import SwiftUI

enum Route: Hashable {
    case userLogin
    case therapistLogin
    case therapistSignup
    case userSignUp
    case resetPassword(UserRole)
    indirect case finish(finishText: String, navigateToText: String, destination: Route)
}

final class RouterModel: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .userLogin:
            LoginView(.user)
        case .therapistLogin:
            LoginView(.therapist)
        case .therapistSignup:
            TherapistSignupView()
        case .userSignUp:
            UserSignUpView()
        case .resetPassword(let role):
            ResetPasswordView(role)
        case .finish(let finishText, let navigateToText, let destination):
            FinishView(finishText: finishText, navigateToText: navigateToText, destination: destination)
        }
    }
    
    func navigateToFinish(finishText: String, navigateToText: String, destination: Route) {
            path.append(Route.finish(finishText: finishText, navigateToText: navigateToText, destination: destination))
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
