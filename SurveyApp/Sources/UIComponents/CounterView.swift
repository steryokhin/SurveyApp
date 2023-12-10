//
//  CounterView.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 11/12/2023.
//

import SwiftUI

struct CounterView: View {
    let message: String

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(message)
                    .frame(height: 40)
                    .foregroundColor(.black)

                Spacer()
            }
            .background(.gray)
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    CounterView(message: "Questions submitted: 1")
}
