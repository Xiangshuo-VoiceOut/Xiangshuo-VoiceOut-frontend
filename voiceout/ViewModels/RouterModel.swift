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
    case consultationReservation
    case waitingConfirmation
    case questionDetail(title: String, questionID: String, answers: [FAQAnswer])
    case singleChoice(question: Question, surveyId: String, surveyResultId: String)
    case rating(question: Question, surveyId: String, surveyResultId: String)
    case multipleChoice(question: Question, surveyId: String, surveyResultId: String, nextQuestion: Question?)
    case multipleChoiceEditable(question: Question, surveyId: String, surveyResultId: String)
    case resultView(surveyResultId: String)
    case matchingLoading
    case matchingTherapistView
}

final class RouterModel: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    @Published var currentView: Route?

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
        case .consultationReservation:
            ConsultationReservationView()
                .environmentObject(self)
        case .waitingConfirmation:
            WaitingConfirmationView()
                .environmentObject(self)
        case .questionDetail(let title, let questionID, let answers):
            BeforeFirstConsultationView(
                title: title,
                questionID: questionID,
                answers: answers
            )
        case .singleChoice(let question, let surveyId, let surveyResultId):
            SingleChoiceQuestionView(question: question, surveyId: surveyId, surveyResultId: surveyResultId)
                .environmentObject(self)
        case .rating(let question, let surveyId, let surveyResultId):
            RatingQuestionView(question: question, surveyId: surveyId, surveyResultId: surveyResultId)
                .environmentObject(self)
        case .multipleChoice(let question, let surveyId, let surveyResultId, let nextQuestion):
            MultipleChoiceQuestionView(question: question, surveyId: surveyId, nextQuestion: nextQuestion, surveyResultId: surveyResultId)
                .environmentObject(self)
        case .multipleChoiceEditable(let question, let surveyId, let surveyResultId):
            MultipleChoiceWithEditingView(question: question, surveyId: surveyId, surveyResultId: surveyResultId)
                .environmentObject(self)
        case .resultView(let surveyResultId):
            MatchingConsultantResultView(surveyResultId: surveyResultId)
                .environmentObject(self)
        case .matchingLoading:
            MatchingLoadingView()
                .environmentObject(self)
        case .matchingTherapistView:
            MatchingTherapistView()
                .environmentObject(self)
        }
    }

    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
        DispatchQueue.main.async {
            if self.currentView != appRoute {  
                self.currentView = appRoute
            }
        }
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
