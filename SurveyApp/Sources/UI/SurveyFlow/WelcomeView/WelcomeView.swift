//
//  ContentView.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 09/12/2023.
//

import SwiftUI

/// A view that displays the welcome screen for the survey flow.
struct WelcomeView: View {
    var surveyStarter: SurveyStarter

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DefaultButton("Start Survey") {
                        surveyStarter.startSurvey()
                    }
                    Spacer()
                }
                Spacer()
                Spacer()
            }
            .padding()
            .navigationBarTitle(
                "Welcome",
                displayMode: .inline
            )
        }
    }
}
