//
//  ARHomeScreenShortcuts.m
//  ARHomeScreenShortcuts
//
//  Created by alexruperez on 11/19/2014.
//  Copyright (c) 2014 alexruperez. All rights reserved.
//

#import "ARHomeScreenShortcuts.h"

#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>

#if TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
NSUInteger const ARDefaultPort = 80;
#else
NSUInteger const ARDefaultPort = 8080;
#endif

NSString * const ARHeadTitleKey = @"<ARHSS_HEAD_TITLE>";
NSString * const ARBase64IconKey = @"<ARHSS_B64_ICON>";
NSString * const ARFullSchemeKey = @"<ARHSS_FULL_SCHEME>";
NSString * const ARURLSchemeKey = @"<ARHSS_URL_SCHEME>";
NSString * const ARTimeIntervalKey = @"<ARHSS_TIME_INTERVAL>";

@interface ARHomeScreenShortcuts ()

@property (strong, nonatomic) GCDWebServer *webServer;

@end

@implementation ARHomeScreenShortcuts

+ (void)load
{
    [GCDWebServer setLogLevel:5];
}

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        self.replacementDictionary = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopWebServer) name:UIApplicationWillEnterForegroundNotification object:nil];
    }

    return self;
}

- (NSString *)title
{
    if (!_title)
    {
        _title = self.defaultTitle;
    }
    
    return _title;
}

- (UIImage *)icon
{
    if (!_icon)
    {
        _icon = self.defaultIcon;
    }
    
    return _icon;
}

- (NSString *)action
{
    if (!_action)
    {
        _action = self.defaultAction;
    }
    
    return _action;
}

- (NSString *)urlScheme
{
    if (!_urlScheme)
    {
        _urlScheme = self.defaultURLScheme;
    }
    
    return _urlScheme;
}

- (NSString *)timeInterval
{
    return self.defaultTimeInterval;
}

- (NSString *)fullURLScheme
{
    if (!self.urlScheme)
    {
        return @"";
    }
    
    NSString *fullURLScheme = self.urlScheme;
    
    fullURLScheme = [self processString:fullURLScheme byAppendingIfNotFound:@":"];
    fullURLScheme = [self processString:fullURLScheme byAppendingIfNotFound:@"//"];
    
    if (self.action)
    {
        fullURLScheme = [fullURLScheme stringByAppendingString:self.action];
    }
    
    if (self.parameters.count)
    {
        fullURLScheme = [fullURLScheme stringByAppendingString:@"?"];
        
        for (NSString *key in self.parameters.allKeys)
        {
            fullURLScheme = [fullURLScheme stringByAppendingFormat:@"%@=%@&", key, self.parameters[key]];
        }

        fullURLScheme = [fullURLScheme substringToIndex:[fullURLScheme length] - 1];
    }
    
    return fullURLScheme;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (NSString *)installShortcut
{
    return [self openURLString:self.urlString] ? self.fullURLScheme : nil;
}

- (NSString *)urlString
{
    return [NSString stringWithFormat:@"data:text/html;charset=UTF-8;base64,%@", self.htmlBase64String];
}

- (NSString *)htmlBase64String
{
    return [self stringToBase64String:self.processedHTMLString];
}

- (NSString *)processedHTMLString
{
    [self.replacementDictionary addEntriesFromDictionary:@{ARHeadTitleKey : self.title, ARBase64IconKey : [self imageToBase64String:self.icon], ARURLSchemeKey : self.urlScheme, ARFullSchemeKey : self.fullURLScheme, ARTimeIntervalKey : self.timeInterval}];
    
    return [self processHTML:self.htmlString withDictionary:self.replacementDictionary];
}

- (NSString *)htmlString
{
    NSError *htmlError = nil;
    NSString *htmlString = [NSString stringWithContentsOfFile:self.htmlResourcePath encoding:NSUTF8StringEncoding error:&htmlError];
    if (htmlString && !htmlError)
    {
        return htmlString;
    }

    NSLog(@"%@ Error: %@", self.classString, htmlError);
    return nil;
}

#pragma mark - WebServer

- (BOOL)openURLString:(NSString *)urlString
{
    if (urlString)
    {
        self.webServer = [[GCDWebServer alloc] init];
        
        [self.webServer addDefaultHandlerForMethod:@"GET" requestClass:GCDWebServerRequest.class processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
            return [GCDWebServerDataResponse responseWithHTML:[NSString stringWithFormat:@"<head><meta http-equiv=\"refresh\" content=\"0; URL=%@\"></head>", urlString]];
        }];
        
        NSURL *localWebServerURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%lu/", (unsigned long)ARDefaultPort]];
        
        if ([self.webServer startWithOptions:@{GCDWebServerOption_AutomaticallySuspendInBackground : @NO, GCDWebServerOption_Port : @(ARDefaultPort)} error:nil] && [[UIApplication sharedApplication] canOpenURL:localWebServerURL])
        {
            return [[UIApplication sharedApplication] openURL:localWebServerURL];
        }
    }
    
    return NO;
}

- (void)stopWebServer
{
    if (self.webServer)
    {
        [self.webServer stop];
        self.webServer = nil;
    }
}

#pragma mark - Defaults

- (NSString *)classString
{
    return NSStringFromClass(self.class);
}

- (NSBundle *)mainBundle
{
    return [NSBundle mainBundle];
}

- (NSBundle *)defaultBundle
{
    return [NSBundle bundleWithPath:[self.mainBundle pathForResource:self.classString ofType:@"bundle"]];
}

- (NSString *)htmlResourcePathForBundle:(NSBundle *)bundle
{
    return [bundle pathForResource:self.classString ofType:@"html"];
}

- (NSString *)htmlResourcePath
{
    NSString *path = [self htmlResourcePathForBundle:self.mainBundle];
    
    if (path)
    {
        return path;
    }
    
    path = [self htmlResourcePathForBundle:self.defaultBundle];
    
    if (path)
    {
        return path;
    }
    
    return nil;
}

- (NSString *)defaultTitle
{
    NSString *title = [[NSBundle mainBundle] localizedInfoDictionary][@"CFBundleDisplayName"];
    
    if (title)
    {
        return title;
    }
    
    title = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    
    if (title)
    {
        return title;
    }
    
    return @"";
}

- (UIImage *)plainIcon
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)defaultIcon
{
    UIImage *icon = [UIImage imageNamed:@"AppIcon"];
    
    if (icon)
    {
        return icon;
    }

    icon = [UIImage imageNamed:[[NSBundle mainBundle] infoDictionary][@"CFBundleIconFiles"][0]];

    if (icon)
    {
        return icon;
    }
    
    return self.plainIcon;
}

- (NSString *)defaultAction
{
    return @"launch";
}

- (NSString *)defaultURLScheme
{
    NSString *urlScheme = [[NSBundle mainBundle] infoDictionary][@"CFBundleURLTypes"][0][@"CFBundleURLSchemes"][0];
    
    if (urlScheme)
    {
        return urlScheme;
    }
    
    return @"";
}

- (NSString *)defaultTimeInterval
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

#pragma mark - Processors

- (NSString *)processString:(NSString *)string byAppendingIfNotFound:(NSString *)replacement
{
    if ([string rangeOfString:replacement].location == NSNotFound)
    {
        string = [string stringByAppendingString:replacement];
    }
    
    return string;
}

- (NSString *)processHTML:(NSString *)htmlString withDictionary:(NSDictionary *)replacementDictionary
{
    for (NSString *key in replacementDictionary.allKeys)
    {
        htmlString = [htmlString stringByReplacingOccurrencesOfString:key withString:replacementDictionary[key]];
    }
    
    return htmlString;
}

#pragma mark - Base64 Helpers

- (NSString *)stringToBase64String:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data)
    {
        return [data base64EncodedStringWithOptions:kNilOptions];
    }
    
    return nil;
}

- (NSString *)imageToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
