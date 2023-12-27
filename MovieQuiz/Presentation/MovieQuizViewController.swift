import UIKit



final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Lifecycle
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var noButtonClicked: UIButton!
    @IBOutlet var yesButtonClicked: UIButton!
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    
    private enum FileManagerError: Error {
        case fileDoesntExist
    }
    
    
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion?
    
    private let presenter = MovieQuizPresenter()
    private lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    private var alertPresenter: AlertPresenter = AlertPresenter()
    private var statisticPresenter: StatisticService = StatisticServiceImplementation()
    
    
    private func resetImageBorederColor() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect == true {
            correctAnswers += 1
        }
        
        noButtonClicked.isEnabled = false
        yesButtonClicked.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            
            self.showNextQuestionOrResults()
        }
    }
    
    private func showAlertPresenter() {
        statisticPresenter.store(correct: correctAnswers, total: presenter.questionsAmount)
        
        guard let bestGame = statisticPresenter.gameRecord else {return}
        
        
        let TotalGamesString = "количество сыгранных квизов: \(statisticPresenter.gamesCount)"
        let bestGameString = "рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let accuracyOfAnswers = "Средяя точность: \(String(format: "%.2f", statisticPresenter.totalAccuracy))%"
        
        let text = "Ваш результат \(correctAnswers)/\(presenter.questionsAmount)"
        
        let someVar = AlertModel(title: "Этот раунд окончен!", message: "\(text)\n\(TotalGamesString)\n\(bestGameString)\n\(accuracyOfAnswers)", buttonText: "Сыграть ещё раз", comletion: { [weak self] in
            guard let self = self else {return}
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory.requestNextQuestion()
        })
        
        
        alertPresenter.controller = self
        alertPresenter.show(in: self, model: someVar)
        resetImageBorederColor()
    }
    
    private func showNextQuestionOrResults() {
        
        if presenter.isLastQuestion() {
            
            showAlertPresenter()
            
        } else {
            
            presenter.switchToNextQuestion()
            questionFactory.requestNextQuestion()
        }
    }
    
    
    private func string(from documentsURL: URL) throws -> String {
        
        if !FileManager.default.fileExists(atPath: documentsURL.path) {
            
            throw FileManagerError.fileDoesntExist
        }
        
        return try String(contentsOf: documentsURL)
    }
    
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробуйте ещё раз") { [weak self] in
                
                guard let self = self else {return}
                
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                
                self.showLoadingIndicator()
                self.questionFactory.loadData()
                self.questionFactory.requestNextQuestion()
            }
        
        
        alertPresenter.show(in: self, model: model)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        
        questionFactory.delegate = self
        
        showLoadingIndicator()
        resetImageBorederColor()
        
        questionFactory.loadData()
        
    }
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        noButtonClicked.isEnabled = true
        yesButtonClicked.isEnabled = true
        
        resetImageBorederColor()
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        questionFactory.requestNextQuestion()
        activityIndicator.isHidden = true
    }
    
    func didFailToLoadData(with error: Error) {
        alertPresenter.controller = self
        showNetworkError(message: error.localizedDescription)
    }
}



/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
