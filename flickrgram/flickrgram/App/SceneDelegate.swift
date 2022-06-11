import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let factory = SearchResultsFactory()
        let navigationController = UINavigationController()
        let searchResultsViewController = factory.create(withNavigationController: navigationController)
        navigationController.viewControllers = [searchResultsViewController]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
