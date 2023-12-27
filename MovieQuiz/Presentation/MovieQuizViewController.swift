import UIKit



final class MovieQuizViewController: UIViewController {
    
    // MARK: - Lifecycle
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var noButtonClicked: UIButton!
    @IBOutlet var yesButtonClicked: UIButton!
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    
    private var presenter: MovieQuizPresenter!
    var alertPresenter: AlertPresenter = AlertPresenter()
    
    
    // MARK: - Simmple Functions
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func unshowImageBorederColor() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    
    // MARK: - More Coplicated Functions
    func showAnswerResult(isCorrect: Bool) {
        noButtonClicked.isEnabled = false
        yesButtonClicked.isEnabled = false
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    
    // MARK: - Alerts
    func showAlertPresenter() {
        
        
        let text: [String] = presenter.statisticAlertStrings().components(separatedBy: "\n")
        
        let someVar = AlertModel(title: "Этот раунд окончен!", message: "\(text[0])\n\(text[1])\n\(text[2])\n\(text[3])", buttonText: "Сыграть ещё раз", comletion: { [weak self] in
            guard let self = self else {return}
            
            self.presenter.restartGame()
        })
        alertPresenter.controller = self
        alertPresenter.show(in: self, model: someVar)
        unshowImageBorederColor()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробуйте ещё раз") { [weak self] in
                
                guard let self = self else {return}
                
                self.presenter.restartGame()
                
                self.showLoadingIndicator()
                self.viewDidLoad()
            }
        alertPresenter.show(in: self, model: model)
    }
    
    
    //MARK: - Override Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        presenter = MovieQuizPresenter(viewController: self)
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
