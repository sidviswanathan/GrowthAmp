//
//  GAABImport.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAABImport.h"
#import <AddressBook/AddressBook.h>
#import "UIAlertView+GABlock.h"
#import <UIKit/UIKit.h>
#import "GAABParser.h"

@implementation GAABImport

+ (dispatch_queue_t)importQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.growthamp.import.queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

+ (void)contactsWithCompletion:(void(^)(NSArray *, NSError *))completion {
    // Only available in iOS6+
    if (ABAddressBookCreateWithOptions) {
        // Simply here so that the next lines of code look cleaner
        typedef void (^ABAddressBookRefCompletion)(ABAddressBookRef);
        
        // Creates an address book reference in the dedicated `importQueue`.
        // From Apple's doc: "You must ensure that an instance of ABAddressBookRef is used by only one thread."
        void (^AddressBookRefCreateWithCompletion)(ABAddressBookRefCompletion) = ^(ABAddressBookRefCompletion handler){
            dispatch_async([[self class] importQueue], ^{
                CFErrorRef errorRef = nil;
                ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(nil, &errorRef);
                
                if (errorRef) {
                    CFBridgingRelease(addressBookRef);
                    NSError *error = CFBridgingRelease(errorRef);
                    completion(nil, error);
                } else {
                    handler(addressBookRef);
                }
            });
        };
        
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        
        // There's no authorization status set.  This will prompt the user for access.  If access is given, then
        // the we proceed to uploading the contacts via `LCABImportManager`
        if (status == kABAuthorizationStatusNotDetermined) {
            
            AddressBookRefCreateWithCompletion(^(ABAddressBookRef addressBookRef) {
                ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef errorRef) {
                    // First time access has been granted
                    if (granted) {
                        GAABParser *parser = [[GAABParser alloc] init];
                        
                        NSError *error;
                        NSArray *contacts = [parser parseContactsFromAddressBookRef:addressBookRef error:&error];
                        completion(contacts, error);
                    } else {
                        completion(nil, [NSError errorWithDomain:@"" code:1 userInfo:nil]);
                    }
                });
            });
        }
        // The user has previously given access, therefore proceed to uploading contacts
        else if (status == kABAuthorizationStatusAuthorized) {
            AddressBookRefCreateWithCompletion(^(ABAddressBookRef addressBookRef){
                GAABParser *parser = [[GAABParser alloc] init];
                
                NSError *error;
                NSArray *contacts = [parser parseContactsFromAddressBookRef:addressBookRef error:&error];
                completion(contacts, error);
            });
        }
        // Otherwise, the user has denied access. Therefore, prompt the user to change his privacy settings
        else {
             completion(nil, [NSError errorWithDomain:@"" code:1 userInfo:nil]);
            /*
            dispatch_async(dispatch_get_main_queue(), ^{
                // The user has previously denied access - tell user to change privacy setting
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"alert_change_privacy_setting", nil)
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                
                [alert showAlerViewWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                }];
            });
            */
        }
    }
}

@end
