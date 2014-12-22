# ARHomeScreenShortcuts
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/alexruperez/ARHomeScreenShortcuts?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Twitter](http://img.shields.io/badge/contact-@alexruperez-blue.svg?style=flat)](http://twitter.com/alexruperez)
[![GitHub Issues](http://img.shields.io/github/issues/alexruperez/ARHomeScreenShortcuts.svg?style=flat)](http://github.com/alexruperez/ARHomeScreenShortcuts/issues)
[![CI Status](http://img.shields.io/travis/alexruperez/ARHomeScreenShortcuts.svg?style=flat)](https://travis-ci.org/alexruperez/ARHomeScreenShortcuts)
[![Version](https://img.shields.io/cocoapods/v/ARHomeScreenShortcuts.svg?style=flat)](http://cocoadocs.org/docsets/ARHomeScreenShortcuts)
[![License](https://img.shields.io/cocoapods/l/ARHomeScreenShortcuts.svg?style=flat)](http://cocoadocs.org/docsets/ARHomeScreenShortcuts)
[![Platform](https://img.shields.io/cocoapods/p/ARHomeScreenShortcuts.svg?style=flat)](http://cocoadocs.org/docsets/ARHomeScreenShortcuts)
[![Dependency Status](https://www.versioneye.com/objective-c/arhomescreenshortcuts/0.1.0/badge.svg?style=flat)](https://www.versioneye.com/objective-c/arhomescreenshortcuts/0.1.0)
[![Analytics](https://ga-beacon.appspot.com/UA-55329295-1/ARHomeScreenShortcuts/readme?pixel)](https://github.com/igrigorik/ga-beacon)

## Overview

ARHomeScreenShortcuts installs home screen shortcuts to features of your app like [OneTap](https://itunes.apple.com/us/app/onetap/id502840938) or [Facebook Groups](https://itunes.apple.com/us/app/facebook-groups/id931735837).

![ARHomeScreenShortcuts Screenshot](https://raw.githubusercontent.com/alexruperez/ARHomeScreenShortcuts/master/screenshot.png)

## Usage

### Installation

ARHomeScreenShortcuts is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "ARHomeScreenShortcuts"

You need [define an URL Scheme](http://g.twimg.com/dev/documentation/image/scheme2_0.png) for your app.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Customization

To customize your shortcut you can use the following properties:

```objectivec
    ARHomeScreenShortcuts *shortcut = [[ARHomeScreenShortcuts alloc] init];
		
    shortcut.title = @"Shortcut Title";
		
    shortcut.icon = [UIImage imageNamed:@"ShortcutIcon"];
		
    shortcut.urlScheme = @"myapp";
		
    shortcut.action = @"open"
		
    shortcut.parameters = @{@"id" : @"my_identifier"};
		
    [shortcut.replacementDictionary setObject:@"<div>INSTALL ME</div>" forKey:@"<REPLACEMENT_EXAMPLE>"];
		
    [shortcut installShortcut];
```

To customize the installation HTML, copy [ARHomeScreenShortcuts.html](http://github.com/alexruperez/ARHomeScreenShortcuts/blob/master/Pod/Assets/ARHomeScreenShortcuts.html) file to your proyect.

# Etc.

* Contributions are very welcome.
* Attribution is appreciated (let's spread the word!), but not mandatory.

## Use it? Love/hate it?

Tweet the author [@alexruperez](http://twitter.com/alexruperez), and check out alexruperez's blog: http://alexruperez.com

## License

ARHomeScreenShortcuts is available under the MIT license. See the LICENSE file for more info.

