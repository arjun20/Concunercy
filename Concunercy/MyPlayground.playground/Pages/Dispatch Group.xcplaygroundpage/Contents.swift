import UIKit
import Combine
class SplashViewController: UIViewController {
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var cancellables = Set<AnyCancellable>()
    var launchDataDispatchGroup: DispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async { [weak self] in
            self?.getAppLaunchData()
        }
    }
    
    func getAppLaunchData() {
        launchDataDispatchGroup.enter()
        NetworkManager.shared.getData(endpoint: .userPreferences, type: UserPreference.self)
            .sink { [weak self] completion in
                self?.launchDataDispatchGroup.leave()
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { userPreferences in
                print("Watchlists -> \(userPreferences.watchlist?.first ?? "")")
            }
            .store(in: &self.cancellables)
        launchDataDispatchGroup.enter()
        NetworkManager.shared.getData(endpoint: .appConfig, type: AppConfig.self)
            .sink { [weak self] completion in
                self?.launchDataDispatchGroup.leave()
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { config in
                print("Base URL -> \(config.baseURL ?? "")")
            }
            .store(in: &self.cancellables)
        let waitResult: DispatchTimeoutResult = launchDataDispatchGroup.wait(timeout: .now() + .seconds(3))
        DispatchQueue.main.async { [weak self] in
            switch waitResult {
            case .success:
                print("API calls completed before timeout")
            case .timedOut:
                print("APIs timed out")
            }
            self?.activityIndicator.stopAnimating()
            self?.navigateToSignupVC()
        }
        //        launchDataDispatchGroup.notify(queue: .main) { [weak self] in
        //            print("Launch calls complete, navigate to next screen")
        //            self?.activityIndicator.stopAnimating()
        //            self?.navigateToSignupVC()
        //        }
    }
    
    func navigateToSignupVC() {
        guard let signupVC: SignupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController else { return }
        UIApplication.shared.windows.first?.rootViewController = signupVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
