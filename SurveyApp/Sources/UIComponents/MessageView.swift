//
//  MessageView.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 10/12/2023.
//

import SwiftUI

struct MessageView: View {
    struct ButtonInfo {
        let title: String
        let action: () -> Void
    }

    let message: String
    let backgroundColor: Color
    let buttonInfo: ButtonInfo?

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(message)
                    .frame(height: 80)
                    .padding(.leading)
                    .foregroundColor(.black)
                Spacer()
                if let buttonInfo {
                    Button(buttonInfo.title) {
                        buttonInfo.action()
                    }
                    .padding(.trailing)
                }
                Spacer()
            }
            .background(backgroundColor)
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    MessageView(
        message: "Hello",
        backgroundColor: .green,
        buttonInfo: .init(title: "Retry", action: { } )
    )
}
