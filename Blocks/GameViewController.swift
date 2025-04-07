import UIKit
import SpriteKit
import Combine

class GameViewController: UIViewController {
    
    let model = Model()
    
    lazy var scene = GameScene(model: model)
    
    let scoreLabel = UILabel()
    
    let colorView = UIView()
        
    let skView = SKView()
    
    let gameOverLabel = UILabel()
    
    lazy var playAgainButton = UIButton(
        primaryAction: UIAction(title: "PLAY AGAIN") { [model] action in
            model.play()
        }
    )
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupScoreLabel()
        setupCurrentColorRectangle()
        setupSKView()
        setupGameOverLabel()
        setupPlayAgainButton()

        setupObservers()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scene.size = CGSize(width: skView.frame.size.width, height: skView.frame.size.height)
        skView.presentScene(scene)
    }
    
    private func setupScoreLabel() {
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        scoreLabel.textColor = .white
        scoreLabel.text = "0"
        scoreLabel.accessibilityIdentifier = "score"
    }
    
    private func setupCurrentColorRectangle() {
        view.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: 25),
            colorView.widthAnchor.constraint(equalToConstant: 25),
            colorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
        ])
    }
    
    private func setupSKView() {
        view.addSubview(skView)
        skView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skView.topAnchor.constraint(equalToSystemSpacingBelow: scoreLabel.bottomAnchor, multiplier: 1),
            skView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            skView.leftAnchor.constraint(equalTo: view.leftAnchor),
            skView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
       
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.showsPhysics = true
    }
    
    private func setupGameOverLabel() {
        view.addSubview(gameOverLabel)
        gameOverLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameOverLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameOverLabel.bottomAnchor.constraint(equalTo: skView.centerYAnchor, constant: -10),
        ])
        
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        gameOverLabel.textColor = .white
        gameOverLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func setupPlayAgainButton() {
        view.addSubview(playAgainButton)
        playAgainButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playAgainButton.topAnchor.constraint(equalTo: skView.centerYAnchor, constant: 10),
        ])

        playAgainButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        playAgainButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    private func setupObservers() {
        model.$score.sink { [unowned self] count in
            scoreLabel.text = "\(count)"
        }
        .store(in: &cancellables)
        
        model.$color.sink { [unowned self] color in
            colorView.backgroundColor = color
        }
        .store(in: &cancellables)
        
        model.$isPlaying.sink { [unowned self] isPlaying in
            switch isPlaying {
                case false:
                    skView.isUserInteractionEnabled = false
                    gameOverLabel.isHidden = false
                    playAgainButton.isHidden = false
                case true:
                    skView.isUserInteractionEnabled = true
                    gameOverLabel.isHidden = true
                    playAgainButton.isHidden = true
                    
            }
        }
        .store(in: &cancellables)
    }

}

#Preview {
    GameViewController()
}


