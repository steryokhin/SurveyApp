//
//  SurveyNavigation.swift
//  SurveyApp
//
//  Created by Sergey Teryokhin on 09/12/2023.
//

import Combine
import SwiftUI

enum Destination: Hashable {
    case welcome
    case loading
    case question
}
typealias SurveyRouter = Router<Destination>
