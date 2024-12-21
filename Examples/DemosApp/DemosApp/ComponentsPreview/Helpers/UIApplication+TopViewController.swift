import UIKit

extension UIApplication {
  var topViewController: UIViewController? {
    var topViewController: UIViewController?

    if #available(iOS 13, *) {
      for scene in self.connectedScenes {
        if let windowScene = scene as? UIWindowScene {
          for window in windowScene.windows {
            if window.isKeyWindow {
              topViewController = window.rootViewController
            }
          }
        }
      }
    } else {
      topViewController = self.keyWindow?.rootViewController
    }

    while true {
      if let presented = topViewController?.presentedViewController {
        topViewController = presented
      } else if let navController = topViewController as? UINavigationController {
        topViewController = navController.topViewController
      } else if let tabBarController = topViewController as? UITabBarController {
        topViewController = tabBarController.selectedViewController
      } else {
        break
      }
    }
    return topViewController
  }
}
