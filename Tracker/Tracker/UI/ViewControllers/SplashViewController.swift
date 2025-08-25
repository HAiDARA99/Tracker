import UIKit

final class SplashViewController: UIViewController {
    private lazy var splashLogoView = {
        let splash = UIImageView()
        splash.image = UIImage(named: "splash_screen_logo")
        splash.contentMode = .scaleAspectFit
        splash.translatesAutoresizingMaskIntoConstraints = false
        return splash
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "colorBlue")
        view.addSubview(splashLogoView)
        
        NSLayoutConstraint.activate([
            splashLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashLogoView.widthAnchor.constraint(equalToConstant: 71),
            splashLogoView.heightAnchor.constraint(equalToConstant: 74)
        ])
    }
}
