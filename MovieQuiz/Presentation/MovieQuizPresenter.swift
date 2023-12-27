//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 24.12.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var correctAnswers = 0
    private var questionsAmount = 10
    private var currentQuestionIndex = 0
    private var statisticPresenter: StatisticService = StatisticServiceImplementation()
    
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - Simmple Functions
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func yesButtonClicked() {
        buttonClicked(givenAnswer: true)
    }
    
    func noButtonClicked() {
        buttonClicked(givenAnswer: false)
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // MARK: - More Coplicated Functions
    private func buttonClicked(givenAnswer: Bool) {
        guard let currentQuestion = currentQuestion else {return}
        
        viewController?.showAnswerResult(isCorrect: givenAnswer ==   currentQuestion.correctAnswer)
    }
    
    private func convert (model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            
            viewController?.showAlertPresenter()
            
        } else {
            
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    
    func statisticAlertStrings() -> String {
        
        statisticPresenter.store(correct: correctAnswers, total: questionsAmount)
        
        guard let bestGame = statisticPresenter.gameRecord else {return "nil"}
        
        let text = "Ваш результат \(correctAnswers)/\(questionsAmount)"
        let totalGamesString = "количество сыгранных квизов: \(statisticPresenter.gamesCount)"
        let bestGameString = "рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let accuracyOfAnswers = "Средяя точность: \(String(format: "%.2f", statisticPresenter.totalAccuracy))%"
        
        let statisticAlert = [text, totalGamesString, bestGameString, accuracyOfAnswers].joined(separator: "\n")
        
        return statisticAlert
    }
    
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        
        viewController?.noButtonClicked.isEnabled = true
        viewController?.yesButtonClicked.isEnabled = true
        viewController?.unshowImageBorederColor()
        
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
        viewController?.activityIndicator.isHidden = true
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.alertPresenter.controller = viewController
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}
