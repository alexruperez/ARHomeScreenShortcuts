//
//  ARViewController.m
//  ARHomeScreenShortcuts
//
//  Created by alexruperez on 11/19/2014.
//  Copyright (c) 2014 alexruperez. All rights reserved.
//

#import "ARViewController.h"

#import <ARHomeScreenShortcuts/ARHomeScreenShortcuts.h>


@interface ARViewController () <ABPeoplePickerNavigationControllerDelegate>

@end

@implementation ARViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.peoplePickerDelegate = self;

    [[NSNotificationCenter defaultCenter] addObserverForName:@"openURL" object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {

        NSString *personID = [self getURLParameters:note.object][@"id"];

        if (personID)
        {
            ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];

            personViewController.displayedPerson = ABAddressBookGetPersonWithRecordID(self.addressBook, [personID intValue]);
            personViewController.allowsEditing = NO;
            personViewController.navigationItem.title = (__bridge NSString *)(ABRecordCopyValue(personViewController.displayedPerson, kABPersonFirstNameProperty));
            personViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissViewController)];

            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:personViewController] animated:YES completion:nil];
        }
    }];

}

- (NSDictionary *)getURLParameters:(NSURL *)url
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    NSString *parametersString = [url.absoluteString componentsSeparatedByString:@"?"][1];

    for (NSString *parameterString in [parametersString componentsSeparatedByString:@"&"])
    {
        NSArray *keyValue = [parameterString componentsSeparatedByString:@"="];
        if (keyValue.count > 1)
        {
            [dictionary setObject:keyValue[1] forKey:keyValue[0]];
        }
    }

    return dictionary;
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ARHomeScreenShortcuts *homeScreenShortcuts = [[ARHomeScreenShortcuts alloc] init];

    homeScreenShortcuts.title = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));

    if (ABPersonHasImageData(person))
    {
        homeScreenShortcuts.icon = [UIImage imageWithData:(__bridge NSData *)(ABPersonCopyImageData(person))];
    }

    homeScreenShortcuts.parameters = @{@"id" : @(ABRecordGetRecordID(person))};

    [homeScreenShortcuts.replacementDictionary setObject:@"<div style=\"position:absolute; bottom:0; width:100%; text-align:center;\">INSTALL ME</div>" forKey:@"<REPLACEMENT_EXAMPLE>"];

    [homeScreenShortcuts installShortcut];
}

@end
