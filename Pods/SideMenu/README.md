# SideMenu
[![Version](https://img.shields.io/cocoapods/v/SideMenu.svg?style=flat)](http://cocoapods.org/pods/SideMenu)
[![License](https://img.shields.io/cocoapods/l/SideMenu.svg?style=flat)](http://cocoapods.org/pods/SideMenu)
[![Platform](https://img.shields.io/cocoapods/p/SideMenu.svg?style=flat)](http://cocoapods.org/pods/SideMenu)

SideMenu is a simple and versatile side menu control written in Swift. The are three standard animation styles to choose from along with several other options for further customization if desired. It's highly customizable without needing to write tons of custom code, and **can be implemented in storyboard without a single line of code**. Check out the example project to see it in action.

PS: It makes me happy when you ★ this repo.

![](etc/Preview.gif)

## Requirements
* Xcode 7 or higher
* iOS 8 or higher
* ARC

## Installation

SideMenu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SideMenu"
```

## Usage
### Storyboard Implementation
1. Create a Navigation Controller for a side menu. Set the custom class of the Navigation Controller to be `UISideMenuNavigationController` in the **Identity Inspector**. Create a Root View Controller for the Navigation Controller (shown as a UITableViewController below). Set up any Triggered Segues you want in that View Controller.
![](etc/Screenshot1.png)

2. Set the `Left Side` property of the `UISideMenuNavigationController` to On if you want it to appear from the left side of the screen, or Off/Default if you want it to appear from the right side.
![](etc/Screenshot2.png)

3. Add a UIButton or UIBarButton to a View Controller that you want to display the menu from. Set that button's Triggered Segues action to modally present the Navigation Controller from step 1.
![](etc/Screenshot3.png)

That's it. *Note: you can only enable gestures in code.*
### Code Implementation
In your View Controller's `viewDidLoad` event, do something like this:
``` swift
// Define the menus
let leftMenuNavigationController = UIMenuNavigationController()
leftMenuNavigationController.leftSide = true
// UIMenuNavigationController is a subclass of UINavigationController, so do any additional configuration of it here like setting it's viewControllers.
SideMenuManager.menuLeftNavigationController = leftMenuNavigationController
let rightMenuNavigationController = UIMenuNavigationController()
// UIMenuNavigationController is a subclass of UINavigationController, so do any additional configuration of it here like setting it's viewControllers.
SideMenuManager.menuRightNavigationController = rightMenuNavigationController

// Enable gestures. The left and/or right menus must be set up above for these to work.
// Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
```
Then from a button, do something like this:
``` swift
presentViewController(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
```
That's it.
### Customization
Just type `SideMenuManager.menu...` and code completion will show you everything you can customize (defaults are shown below for reference):
``` swift
menuPresentMode:MenuPresentMode = .ViewSlideOut
menuAllowPushOfSameClassTwice = true
menuAllowPopIfPossible = false
menuWidth: CGFloat = max(round(min(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height) * 0.75), 240)
menuAnimationPresentDuration = 0.35
menuAnimationDismissDuration = 0.35
menuAnimationFadeStrength: CGFloat = 0
menuAnimationShrinkStrength: CGFloat = 1
menuAnimationBackgroundColor: UIColor? = nil
menuShadowOpacity: Float = 0.5
menuShadowColor = UIColor.blackColor()
menuShadowRadius: CGFloat = 5
menuLeftSwipeToDismissGesture: UIPanGestureRecognizer?
menuRightSwipeToDismissGesture: UIPanGestureRecognizer?
menuParallaxStrength: Int = 0
menuFadeStatusBar = true
menuBlurEffectStyle: UIBlurEffectStyle? = nil // Note: if you want cells in a UITableViewController menu to look good, make them a subclass of UITableViewVibrantCell!
menuLeftNavigationController: UILeftMenuNavigationController? = nil
menuRightNavigationController: UIRightMenuNavigationController? = nil
menuAddScreenEdgePanGesturesToPresent(toView toView: UIView, forMenu:UIRectEdge? = nil) -> [UIScreenEdgePanGestureRecognizer]
menuAddPanGestureToPresent(toView toView: UIView) -> UIPanGestureRecognizer
```

## Known Issues
Don't try to change the status bar appearance when presenting a menu. When used with quick gestures/animations, it causes the presentation animation to not complete properly and locks the UI. See [radar 21961293](http://www.openradar.me/21961293) for more information.

## License

SideMenu is available under the MIT license. See the LICENSE file for more info.
