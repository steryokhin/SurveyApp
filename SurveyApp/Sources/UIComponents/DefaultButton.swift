//
//  DefaultButton.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 09/12/2023.
//

import SwiftUI

public struct DefaultButton: View {
    var title: String
    var action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(title, action: action)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
