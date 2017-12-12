# VCBoss

Present UIViewControllers modally in an easy and safe way. No more `Fatal Exception: NSInvalidArgumentException Application tried to present modally an active controller ...` errors. Easily present, dismiss, replace, and swap UIViewControllers presented modally in a parent UIViewController.

![Swift 4.0.x](https://img.shields.io/badge/Swift-4.0.x-orange.svg)

![](meta/header.jpg)

[![Version](https://img.shields.io/cocoapods/v/VCBoss.svg?style=flat)](http://cocoapods.org/pods/VCBoss)
[![License](https://img.shields.io/cocoapods/l/VCBoss.svg?style=flat)](http://cocoapods.org/pods/VCBoss)
[![Platform](https://img.shields.io/cocoapods/p/VCBoss.svg?style=flat)](http://cocoapods.org/pods/VCBoss)

# Why?

In my iOS apps, I enjoy presenting, dismissing, replacing, swapping in and out UIViewControllers modally. It's a very nice touch to present subviews in a main UI for a user to interact with.

However, managing all of those UIViewControllers is risky business. What if I am already showing a user a UIViewController and I want to display another one after that? What if I want to replace the currently shown UIViewController with a new one after the user presses the "Accept" button? There are many use cases that VCBoss can be used for. Managing all of these use cases becomes a pain very quickly.

# Features

* Present a UIViewController modally in the stack to be shown immediately if no other UIViewController is presented modally, or appended at the end to be shown eventually.
* Present a UIViewController immediately by dismissing a currently shown UIViewController if there is one. Do not worry, the UIViewController that gets dismissed, if there is one, will be presented after the forced UIViewController gets dismissed.
* Replace the currently shown UIViewController, if there is one, with a new UIViewController.
* Dismiss a UIViewController and have the next one in line automatically shown next.

All of these operations are performed with 1 line of code without running the risk of getting, `Fatal Exception: NSInvalidArgumentException Application tried to present modally an active controller ...` thrown by trying to present 2+ UIViewControllers at once.

# How?

Replace all of your `self.present()` function calls with `self.vcboss.present()` instead. Replace all of your `myPresentedViewController.dismiss()` with `myPresentingViewController.vcboss.dismiss(myPresentedViewController)`. Besides these, there are many more functions available to you for extended functionality:

```swift
func replace(with viewController: UIViewController, animated: Bool, completion: (() -> Void)?)

func presentOnlyIfNothingAlreadyShown(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)

func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?, force: Bool = false)
```

## Docs

[Check out the docs here](https://levibostian.github.io/VCBoss/).

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

VCBoss is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'VCBoss'
```

**Note:** I recommend appending the version of the cocoapod to the Podfile line entry like: `pod "VCBoss", '~> 0.1.0'` because this library at this time does *not* provide the guarantee of backwards compatibility. Be aware when using it the API can change at anytime. I don't want your code to break the next time you call `pod update` :).

The latest version at this time is: [![Version](https://img.shields.io/cocoapods/v/VCBoss.svg?style=flat)](http://cocoapods.org/pods/VCBoss)

### SwiftLint

VCBoss *does not* work if you use `self.present()` and `self.dismiss()` to present/dismiss UIViewControllers. You must use the VCBoss class to do the presenting and dismissing. We are all human. It's easy to use your habit and use `self.present()` in your app. To help, I recommend you use [SwiftLint]() to throw errors whenever you use either of these two methods. When you try and compile your code, SwiftLint will throw an XCode error not allowing you to continue  until you fix your code.

To use SwiftLint, all you need to do is:

* [Install SwiftLint]() into your iOS project (super easy)
* Add the following to your `.swiftlint.yml` file:

```
custom_rules:
  use_vcboss_present:
    included: ".*\\.swift"
    excluded: ".*Test\\.swift"
    regex: "(self\.present\()"
    message: "Use self.vcboss.present() instead."
    severity: error
  use_vcboss_dismiss:
    included: ".*\\.swift"
    excluded: ".*Test\\.swift"
    regex: "(self\.dismiss\()"
    message: "Use self.vcboss.dismiss() instead."
    severity: error
```

## Author

* Levi Bostian - [GitHub](https://github.com/levibostian), [Twitter](https://twitter.com/levibostian), [Website/blog](http://levibostian.com)

![Levi Bostian image](https://gravatar.com/avatar/22355580305146b21508c74ff6b44bc5?s=250)

## Development

### Documentation

The docs are generated and hosted by cocoapods automatically for cocoadocs.

The docs are generated via jazzy using command: `jazzy --podspec VCBoss.podspec` (assuming jazzy is installed. If not: `gem install jazzy`)

## License

VCBoss is available under the MIT license. See the LICENSE file for more info.

## Credits

* Header image: Photo by [rawpixel.com](https://unsplash.com/photos/FXN2ENfu-sg?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)

* Inspiration for some of the API from [Kingfisher](https://github.com/onevcat/Kingfisher). I tried to make the library easy to use and as backwards compatible as possible with existing UIKit code, Kingfisher's API seemed like a great with with it's use of extensions and easy to use code.
