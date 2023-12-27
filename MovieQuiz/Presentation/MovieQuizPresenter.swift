//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 24.12.2023.
//

import UIKit

final class MovieQuizPresenter {
    
    var questionsAmount = 10
    private var currentQuestionIndex = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func yesButtonClicked() {
        buttonClicked(givenAnswer: true)
    }
    
    func noButtonClicked() {
        buttonClicked(givenAnswer: false)
    }
    
    private func buttonClicked(givenAnswer: Bool) {
        guard let currentQuestion = currentQuestion else {return}
        
        viewController?.showAnswerResult(isCorrect: givenAnswer ==   currentQuestion.correctAnswer)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert (model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
}
