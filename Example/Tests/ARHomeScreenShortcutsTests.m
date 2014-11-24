//
//  ARHomeScreenShortcutsTests.m
//  ARHomeScreenShortcutsTests
//
//  Created by alexruperez on 11/19/2014.
//  Copyright (c) 2014 alexruperez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <ARHomeScreenShortcuts/ARHomeScreenShortcuts.h>

@interface ARHomeScreenShortcutsTests : XCTestCase

@property (strong, nonatomic) ARHomeScreenShortcuts *shortcut;

@end

@implementation ARHomeScreenShortcutsTests

- (void)setUp
{
    [super setUp];

    self.shortcut = [[ARHomeScreenShortcuts alloc] init];
}

- (void)testHomeScreenShortcutsDefaultTitle
{
    XCTAssertTrue([self.shortcut.title isEqualToString:@"ARShortcuts"], @"");
}

- (void)testHomeScreenShortcutsCustomTitle
{
    self.shortcut.title = @"Title";

    XCTAssertTrue([self.shortcut.title isEqualToString:@"Title"], @"");
}

- (void)testHomeScreenShortcutsDefaultURLScheme
{
    XCTAssertTrue([self.shortcut.urlScheme isEqualToString:@"arshortcuts"], @"");
}

- (void)testHomeScreenShortcutsCustomURLScheme
{
    self.shortcut.urlScheme = @"test";

    XCTAssertTrue([self.shortcut.urlScheme isEqualToString:@"test"], @"");
}

- (void)testHomeScreenShortcutsDefaultAction
{
    XCTAssertTrue([self.shortcut.action isEqualToString:@"launch"], @"");
}

- (void)testHomeScreenShortcutsCustomAction
{
    self.shortcut.action = @"test";

    XCTAssertTrue([self.shortcut.action isEqualToString:@"test"], @"");
}

- (void)testHomeScreenShortcutsDefaultParameters
{
    XCTAssertFalse(self.shortcut.parameters.count, @"");
}

- (void)testHomeScreenShortcutsReplacementDictionary
{
    XCTAssertFalse(self.shortcut.replacementDictionary.count, @"");
}

- (void)testHomeScreenShortcutsInstallCustomShortcut
{
    self.shortcut.urlScheme = @"test";
    self.shortcut.action = @"open";

    NSString *resultURL = [self.shortcut installShortcut];
    XCTAssertTrue([resultURL isEqualToString:@"test://open"], @"%@", resultURL);
}

- (void)tearDown
{
    self.shortcut = nil;

    [super tearDown];
}

@end
