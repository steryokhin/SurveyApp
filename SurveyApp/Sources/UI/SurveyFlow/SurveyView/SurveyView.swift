//
//  RootView.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 09/12/2023.
//

import Combine
import SwiftUI

import SwiftUI

/// A view that displays the survey flow.
struct SurveyView: View {
    @StateObject private var router: SurveyRouter
    @StateObject private var viewModel: SurveyViewModel

    init() {
        let url = URL(string: "https://xm-assignment.web.app")!
        let client = APIClient(baseURL: url)
        let service = SurveyService(apiClient: client)

        let router = SurveyRouter(service: service)
        self._router = StateObject(wrappedValue: router)

        let viewModel = SurveyViewModel(router: router, service: service)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            if viewModel.isLoading {
                LoadingView()
            } else {
                WelcomeView(
                    surveyStarter: viewModel
                ).navigationDestination(for: SurveyRouter.Destination.self) { destination in
                    switch destination {
                    case .welcome:
                        WelcomeView(surveyStarter: viewModel)
                    case .loading:
                        LoadingView()
                    case .question:
                        QuestionView(
                            router: router,
                            surveyViewModel: viewModel
                        )
                    }
                }                
            }
        }
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView()
    }
}
