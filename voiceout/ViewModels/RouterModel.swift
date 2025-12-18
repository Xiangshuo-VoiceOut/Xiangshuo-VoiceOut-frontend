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
    case moodManagerLoading
    case moodDiary(selectedImage: String)
    case moodCalendar
    case textJournalView(diaries: [DiaryEntry])
    case textJournalDetail(entry: DiaryEntry)
    case moodHomepageLauncher
    case mainHomepage
    case cloudGardenOnboarding(startIndex: Int, showSkip: Bool)
    case cloudAudioOnboarding(startIndex: Int, showSkip: Bool)
    case angrySingleQuestion(id: Int)
    case envySingleQuestion(id: Int)
    case scareSingleQuestion(id: Int)
    case sadSingleQuestion(id: Int)
    case anxietySingleQuestion(id: Int)
    case guiltSingleQuestion(id: Int)
    case stressReliefEntry
    case moodManagerLoading2
    case moodCalendarWithMood(String)
    case moodTreatmentHappyHomepage
    case moodTreatmentSadHomepage
    case moodTreatmentAngryHomepage
    case moodTreatmentEnvyHomepage
    case moodTreatmentGuiltHomepage
    case moodTreatmentScareHomepage
    case moodTreatmentAnxietyHomepage
    case playRelaxVideo(name: String, ext: String = "mov")
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
        case .moodManagerLoading:
            MoodManagerLoadingView()
                .environmentObject(self)
        case .moodDiary(let selectedImage):
            MoodDiaryView(selectedImage: selectedImage)
                .environmentObject(self)
        case .moodCalendar:
            MoodCalendarView(incomingMood: nil)
                .environmentObject(self)
        case .textJournalView(let diaries):
            TextJournalView(diaries: diaries, onBack: { self.navigateBack() })
                .environmentObject(self)
        case .textJournalDetail(let entry):
            TextJournalDetailView(diary: entry)
                .environmentObject(self)
        case .moodHomepageLauncher:
            MoodTreatmentLauncherView()
                .environmentObject(self)
        case .mainHomepage:
            MainHomepageView()
                .environmentObject(self)
        case .cloudGardenOnboarding(let start, let skip):
            CloudGardenOnboardingView(startIndex: start)
                .environmentObject(self)
        case .cloudAudioOnboarding(let start, let skip):
            CloudAudioOnboardingView(startIndex: start, showSkip: skip)
                .environmentObject(self)
        case .angrySingleQuestion(let id):
            AngryQuestionPageView(questionId: id)
                .environmentObject(self)
        case .envySingleQuestion(let id):
            EnvyQuestionPageView(questionId: id)
                .environmentObject(self)
        case .scareSingleQuestion(let id):
            ScareQuestionPageView(questionId: id)
                .environmentObject(self)
        case .sadSingleQuestion(let id):
            SadQuestionPageView(questionId: id)
                .environmentObject(self)
        case .anxietySingleQuestion(let id):
            AnxietyQuestionPageView(questionId: id)
                .environmentObject(self)
        case .guiltSingleQuestion(let id):
            GuiltQuestionPageView(questionId: id)
                .environmentObject(self)
        case .stressReliefEntry:
            StressReliefEntryView()
                .environmentObject(self)
        case .moodManagerLoading2:
            MoodManagerLoadingView2()
                .environmentObject(self)
        case .moodCalendarWithMood(let mood):
            MoodCalendarView(incomingMood: mood)
                .environmentObject(self)
        case .moodTreatmentHappyHomepage:
            MoodTreatmentHappyHomepageView()
                .environmentObject(self)
        case .moodTreatmentSadHomepage:
            MoodTreatmentSadHomepageView()
                .environmentObject(self)
        case .moodTreatmentAngryHomepage:
            MoodTreatmentAngryHomepageView()
                .environmentObject(self)
        case .moodTreatmentEnvyHomepage:
            MoodTreatmentEnvyHomepageView()
                .environmentObject(self)
        case .moodTreatmentGuiltHomepage:
            MoodTreatmentGuiltHomepageView()
                .environmentObject(self)
        case .moodTreatmentScareHomepage:
            MoodTreatmentScareHomepageView()
                .environmentObject(self)
        case .moodTreatmentAnxietyHomepage:
            MoodTreatmentAnxietyHomepageView()
                .environmentObject(self)
        case .playRelaxVideo(let name, let ext):
            RelaxationVideoView(source: .bundle(name: name, ext: ext))
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
