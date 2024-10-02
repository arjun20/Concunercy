import UIKit
import Combine

class SignupViewController: UIViewController {
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var cancellables = Set<AnyCancellable>()
    var usernameAvailabilityWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        signupLabel.font = UIFont(name: "Palatino-Bold", size: 32)
        errorLabel.isHidden = true
        usernameTextField.delegate = self
    }
    
    func checkUsernameAvailability(username: String) {
        usernameAvailabilityWorkItem?.cancel()
        let workItem: DispatchWorkItem = DispatchWorkItem {
            NetworkManager.shared.checkUsernameAvailability(username: username)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { [weak self] isUsernameAvailable in
                    DispatchQueue.main.async {
                        self?.errorLabel.isHidden = isUsernameAvailable
                    }
                })
                .store(in: &self.cancellables)
        }
        usernameAvailabilityWorkItem = workItem
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
    }
    
    @IBAction func didClickOnSignUpButton(_ sender: Any) {
        let signUpWorkItem: DispatchWorkItem = DispatchWorkItem { [weak self] in
            guard let self: SignupViewController = self else { return }
            NetworkManager.shared.getData(endpoint: .signUp, type: Signup.self)
                .sink { _ in
                } receiveValue: { signupResponse in
                    print("Subscription Status \(signupResponse.subscriptionStatus)")
                }
                .store(in: &self.cancellables)
        }
        let rewardsWorkItem: DispatchWorkItem = DispatchWorkItem { [weak self] in
            guard let self: SignupViewController = self else { return }
            NetworkManager.shared.getData(endpoint: .rewards, type: Rewards.self)
                .sink { _ in
                } receiveValue: { rewardsResponse in
                    print("Reward points \(rewardsResponse.points)")
                    self.navigateToHomeScreen()
                }
                .store(in: &self.cancellables)
        }
        signUpWorkItem.notify(queue: .global()) {
            rewardsWorkItem.perform()
        }
        DispatchQueue.global().async(execute: signUpWorkItem)
    }
    
    func navigateToHomeScreen() {
        guard let homeVC: HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        UIApplication.shared.windows.first?.rootViewController = homeVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorLabel.isHidden = true
        if textField == usernameTextField {
            checkUsernameAvailability(username: textField.text?.appending(string) ?? "")
        }
        return true
    }
}
