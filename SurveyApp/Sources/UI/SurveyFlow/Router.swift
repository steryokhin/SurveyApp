//
//  Router.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 11/12/2023.
//

import Combine
import SwiftUI

protocol RouterProtocol {
    associatedtype Destination: Hashable

    var navigationPath: NavigationPath { get }

    func navigate(to destination: Destination)
    func back()
    func goToRoot()
}

final class Router<Destination: Hashable>: ObservableObject, RouterProtocol {
    @Published var navigationPath = NavigationPath()
    private var service: SurveyServiceProtocol?

    init(service: SurveyServiceProtocol) {
        self.service = service
    }

    func navigate(to destination: Destination) {
        navigationPath.append(destination)
    }

    func back() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    func goToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}
