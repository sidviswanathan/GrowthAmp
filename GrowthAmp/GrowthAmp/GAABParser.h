//
//  GAABParser.h
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface GAABParser : NSObject

- (NSArray *)parseContactsFromAddressBookRef:(ABAddressBookRef)abRef error:(NSError **)error;

@end
