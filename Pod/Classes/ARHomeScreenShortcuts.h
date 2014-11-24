//
//  ARHomeScreenShortcuts.h
//  ARHomeScreenShortcuts
//
//  Created by alexruperez on 11/19/2014.
//  Copyright (c) 2014 alexruperez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARHomeScreenShortcuts : NSObject

/// Shortcut title, defaults to the app title.
@property (strong, nonatomic) NSString *title;

/// Shortcut icon, defaults to the app icon.
@property (strong, nonatomic) UIImage *icon;

/// Shortcut URL Scheme, defaults to the first URL Scheme defined.
@property (strong, nonatomic) NSString *urlScheme;

/// Shortcut action, defaults to @"launch".
@property (strong, nonatomic) NSString *action;

/// Optional parameters for perform the action.
@property (strong, nonatomic) NSDictionary *parameters;

/// Everything here will be replaced in the HTML.
@property (strong, nonatomic) NSMutableDictionary *replacementDictionary;

/**
 * Redirects the user to Safari to install the shortcut.
 * @return Shortcut's final URL scheme if everything goes right, nil in other case.
**/
- (NSString *)installShortcut;

@end
