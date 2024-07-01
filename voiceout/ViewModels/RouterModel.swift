//
//  RouterModel.swift
//  voiceout
//
//  Created by Xiaoyu Zhu on 5/26/24.
//

import SwiftUI

final class RouterModel: ObservableObject {
    enum Route: Hashable {
        case userLogin
        case therapistLogin
    }
    
    @Published var path: NavigationPath = NavigationPath()
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .userLogin:
            LoginView(.user)
        case .therapistLogin:
            LoginView(.therapist)
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
