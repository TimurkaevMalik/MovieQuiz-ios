//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 27.12.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func showAlertPresenter()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
