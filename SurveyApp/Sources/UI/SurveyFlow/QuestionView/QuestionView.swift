//
//  QuestionView.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 09/12/2023.
//

import SwiftUI
import Combine

import SwiftUI

struct QuestionView: View {
    @ObservedObject var router: SurveyRouter
    @ObservedObject var viewModel: QuestionViewModel

    init(
        router: SurveyRouter,
        surveyViewModel: SurveyViewModel
    ) {
        self.router = router
        self.viewModel = surveyViewModel.createQuestionViewModel()
    }

    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.question.question)
                TextField(
                    "Your answer",
                    text: $viewModel.currentAnswer
                )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                Button(action: {
                    viewModel.postSurvey()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2.0)
                    } else {
                        if viewModel.question.isSynchronised {
                            Text("Already Submitted")
                        } else {
                            Text("Submit")
                        }

                    }
                }
                .disabled(
                    viewModel.currentAnswer.isEmpty || viewModel.question.isSynchronised
                )
            }

            CounterView(message: "Submitted: \(viewModel.answeredQuestions)")

            if let lastResult = viewModel.lastResult {
                if case .success = lastResult {
                    MessageView(
                        message: "Success!",
                        backgroundColor: .green,
                        buttonInfo: nil
                    )
                    .disabled(viewModel.isLoading)
                } else {
                    MessageView(
                        message: "Failure!",
                        backgroundColor: .red,
                        buttonInfo: .init(
                            title: "Retry",
                            action: viewModel.postSurvey 
                        )
                    )
                    .disabled(viewModel.isLoading)
                }
            }

        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: HStack {
                Button(action: {
                    router.goToRoot()
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text("Question \(viewModel.currentQuestionNumber)/\(viewModel.totalQuestions)")
                Spacer()
            },
            trailing: HStack {
                Button(action: {
                    viewModel.goPrevious()
                }) {
                    Text("Previous")
                }
                .disabled(viewModel.isPreviousDisabled)

                Button(action: {
                    viewModel.goNext()
                }) {
                    Text("Next")
                }
                .disabled(
                    viewModel.isNextDisabled
                )
            }
        )
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://xm-assignment.web.app")!
        let client = APIClient(baseURL: url)
        let service = SurveyService(apiClient: client)

        let router = SurveyRouter(service: service)
        let viewModel = SurveyViewModel(router: router, service: service)

        return QuestionView(
            router: router,
            surveyViewModel: viewModel
        )
    }
}

