# VCBoss

Present UIViewControllers modally in an easy and safe way. No more `Fatal Exception: NSInvalidArgumentException Application tried to present modally an active controller ...` errors. Easily present, dismiss, replace, and swap UIViewControllers presented modally in a presenting UIViewController.

![Swift 4.0.x](https://img.shields.io/badge/Swift-4.0.x-orange.svg)

![](meta/header.jpg)

[![Version](https://img.shields.io/cocoapods/v/VCBoss.svg?style=flat)](http://cocoapods.org/pods/VCBoss)
[![License](https://img.shields.io/cocoapods/l/VCBoss.svg?style=flat)](http://cocoapods.org/pods/VCBoss)
[![Platform](https://img.shields.io/cocoapods/p/VCBoss.svg?style=flat)](http://cocoapods.org/pods/VCBoss)

# Why?

In my iOS apps, I enjoy presenting, dismissing, replacing, swapping in and out UIViewControllers modally. It's a nice way to present subviews in a main UI for a user to interact with.

However, managing all of those presented UIViewControllers is risky business. What if I am already showing a user a UIViewController and I want to display another one after that? What if I want to replace the currently shown UIViewController with a new one after the user presses an "Accept" button? There are many use cases that VCBoss can be used for. Managing all of these use cases manually in a presenting UIViewController becomes a pain very quickly.

# Features

VCBoss comes with the basic functionality you're already used to:

* Present a UIViewController modally.
* Dismiss a UIViewController that was presented modally.

Pretty simple, right? However, here is where VCBoss makes me happy 😄:

* Present a UIViewController modally immediately (if the presenting UIViewController is not presenting a UIViewController already) or add to the end of the stack to be presented in the future.
* Present a UIViewController forcefully by dismissing a currently shown UIViewController if there is one and then show the new UIViewController. Do not worry, the UIViewController that gets dismissed, if there is one, will be presented after the forced UIViewController gets dismissed. It's like someone cuts to the front of the line.
* Replace the currently shown UIViewController, if there is one, with a new UIViewController.
* Dismiss a UIViewController and have the next one in line automatically shown next.
* Dismiss all UIViewControllers currently in the stack of UIViewControllers shown and to be shown.

All of these operations are performed with 1 line of code without running the risk of getting, `Fatal Exception: NSInvalidArgumentException Application tried to present modally an active controller ...` thrown by trying to present 2+ UIViewControllers at once.

# How?

VCBoss uses a very familiar API.

* To present a new UIViewController modally immediately (if the presenting UIViewController is not presenting a UIViewController already) or add to the end of the stack to be presented in the future after previous UIViewControllers are dismissed by VCBoss:

```
self.vcboss.present(newViewController, animated: true, completion: nil)
```

* To dismiss a UIViewController:

```
presentedViewController.vcboss.dismiss(animated: true, completion: nil)
```

or

```
presentingViewController.vcboss.dismiss(presentedViewController, animated: true, completion: nil)
```

These are the 2 functions you are already used to using in your code. To start using VCBoss, all you need to do is replace all of your instances of `self.present()` with `self.vcboss.present()` and all instances of `viewController.dismiss()` with `viweController.vcboss.dismiss()`. Just add the extension and you're done.

To make life easier, check out the section on [how to determine where you're using `self.present()`` and `viewController.dismiss()` already in your app to replace with VCBoss](#swiftlint).

---

Below are added functionality that UIKit does not give you that VCBoss does.

* To replace the currently shown UIViewController with a new UIViewController:

```
self.vcboss.replace(with: newViewController, animated: true, completion: nil)
```

* Present a new UIViewController immediately, dismissing a UIViewController if there is one already shown and bring it back after this new UIViewController gets dismissed:

```
self.vcboss.present(newViewController, animated: true, completion: nil, force: true)
```

* Present a new UIViewController only if there is not one already presented:

```
self.vcboss.presentOnlyIfNothingAlreadyShown(newViewController, animated: true, completion: nil)
```

* Dismiss the currently shown UIViewController and do *not* show anymore that may have been added before. Clear the stack to start over.

```
self.vcboss.dismissAll(animated: true, completion: nil)
```

* If you need to get the number of UIViewControllers currently presented + UIViewControllers in stack to be shown in future after currently presented UIViewController gets dismissed:

```
self.vcboss.numViewControllersPresenting
```

[Full documentation here](https://levibostian.github.io/VCBoss/).

## Docs

[Check out the docs here](https://levibostian.github.io/VCBoss/). If something is confusing, please, [open an issue](https://github.com/levibostian/VCBoss/issues/new).

## Example

To run the example iOS app:

* Clone the repo.
* Run `pod install` from the `Example/` directory.
* Run app from XCode by opening `VCBoss` workspace.

## Installation

VCBoss is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'VCBoss'
```

**Note:** I recommend appending the version of the cocoapod to the Podfile line entry like: `pod "VCBoss", '~> 0.1.0'` because this library at this time does *not* provide the guarantee of backwards compatibility. Be aware when using it the API can change at anytime. I don't want your code to break the next time you call `pod update` :).

The latest version at this time is: [![Version](https://img.shields.io/cocoapods/v/VCBoss.svg?style=flat)](http://cocoapods.org/pods/VCBoss)

# SwiftLint

VCBoss *does not* work well (it tries it's best, but cannot guarantee anything) if you use `self.present()` and `self.dismiss()` to present/dismiss UIViewControllers. You must use the VCBoss class to do all of the presenting and dismissing.

But, we are all human. It's easy to use your habits and use `self.present()` in your app. To help, I recommend you use [SwiftLint](https://github.com/realm/SwiftLint) to throw errors whenever you use either of these two methods. When you try and compile your code, SwiftLint will throw an XCode error not allowing you to continue until you fix your code.

To use SwiftLint, all you need to do is:

* [Install SwiftLint](https://github.com/realm/SwiftLint#installation) into your iOS project (super easy. I use [this method](https://github.com/realm/SwiftLint#using-cocoapods)).
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
