//
//  GATrackingManager.h
//  GrowthAmp
//
//  Created by Don Shefer on 9/17/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GATrackingManager : NSObject

+ (id)sharedManager;

-(void)reportUserActionWithName:(NSString*)name
                           type:(NSString*)type
                           info:(NSDictionary*)info;

-(void)sendTrackingDataToServer;

@end

// Tracking Type Keys
#define kTrackingKeyTypeFull    @"full"
#define kTrackingKeyTypeAction  @"action"

// Full Page Keys
#define kTrackingKeyPageSplash   @"splash"                          // Splash screen
#define kTrackingKeyPageContacts @"contacts-list"                   // List of contacts screen
#define kTrackingKeyPageSMS      @"sms"                             // SMS compose screen
#define kTrackingKeyPageEnable   @"contact-list-enable-permissions" // Re-enable contacts permissions screen

//Action Page Keys

#define kTrackingKeyActionSplashX @"splash-x"                                     // User taps ‘X’ in top-left of splash screen
#define kTrackingKeyActionSplashContinue @"splash-continue"                       // User taps on ‘Continue’ button on splash screen’
#define kTrackingKeyActionContactsX @"contacts-list-x"                            // User taps ‘X’ button in top-left of contacts list
#define kTrackingKeyActionContactsNext @"contacts-list-next"                      // User taps ‘Next’ button in top-left of contacts list
#define kTrackingKeyActionContactsUnselectAll @"contacts-list-unselect-all"       // User ‘Unselect All’ button in contacts list
#define kTrackingKeyActionContactsSelectAll @"contacts-list-select-all"           // User taps ‘Select All’ in contacts list
#define kTrackingKeyActionContactsSelect @"contacts-list-select"                  // User selects a contact by tapping on unselected contact
#define kTrackingKeyActionContactsUnselect @"contacts-list-unselect"              // User unselects a contact by tapping on selected contact
#define kTrackingKeyActionContactsScroll @"contacts-list-scroll"                  // User scrolls on the contacts list view
#define kTrackingKeyActionContactsSearch @"contacts-list-search "                 // User taps into search field at the top of contacts list
#define kTrackingKeyActionContactsSearchCancel @"contacts-list-search-cancel"     // User taps ‘Cancel’ to exit out of search
#define kTrackingKeyActionContactsSearchX @"contacts-list-search-x"               // User taps ‘x’ button in search field to clear out search
#define kTrackingKeyActionContactsSeachSelect @"contacts-list-search-select"      // User taps on a contacts to select it from search
#define kTrackingKeyActionContactsSearchUnselect @"contacts-list-search-unselect" // User taps on a contact to unselect it from search
#define kTrackingKeyActionContactsSearchDone @"contacts-list-search-done"         // User taps on ‘Done’ button after selecting contact
#define kTrackingKeyActionSMSSend @"sms-send"                                     // User taps ‘Send’ button from SMS compose screen
#define kTrackingKeyActionSMSCancel @"sms-cancel"                                 // User taps ‘Cancel’ from SMS compose screen’

