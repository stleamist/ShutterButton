import UIKit
import ShutterButton

class ViewController: UIViewController {
    
    private let shutterButton = ShutterButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        self.view.addSubview(shutterButton)
        shutterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shutterButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
