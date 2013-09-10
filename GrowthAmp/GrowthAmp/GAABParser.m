//
//  GAABParser.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GAABParser.h"
#import "GAContact.h"
#import "GASite.h"
#import "GAPhoneNumber.h"
#import "GASocialProfile.h"
#import "GAAddress.h"

@implementation GAABParser

- (NSArray *)parseContactsFromAddressBookRef:(ABAddressBookRef)abRef error:(NSError **)error {
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    
    CFArrayRef sourcesRef = ABAddressBookCopyArrayOfAllSources(abRef);
    
    for (CFIndex sourceIndex=0, sourceCount = CFArrayGetCount(sourcesRef); sourceIndex<sourceCount; sourceIndex++) {
        ABRecordRef sourceRef = CFArrayGetValueAtIndex(sourcesRef, sourceIndex);
        CFArrayRef peopleRef = ABAddressBookCopyArrayOfAllPeopleInSource(abRef, sourceRef);
   
        
        for (CFIndex index=0, peopleCount=CFArrayGetCount(peopleRef); index<peopleCount; index++) {
            ABRecordRef recordRef = CFArrayGetValueAtIndex(peopleRef, index);
            GAContact *contact =  [self deserializeContactFromRecord:recordRef];
            
            [contacts addObject:contact];
            
            CFRelease(recordRef);
        }
        
        CFRelease(peopleRef);
    }
    
    CFRelease(sourcesRef);
    
    return contacts;
}

- (GAContact *)deserializeContactFromRecord:(ABRecordRef)record {
    GAContact *contact = [[GAContact alloc] init];
    
    ABRecordID recordId = ABRecordGetRecordID(record);
    contact.identifier = recordId;
    
    CFStringRef firstNameRef =  ABRecordCopyValue(record, kABPersonFirstNameProperty);
    if (firstNameRef) {
        contact.firstName = (__bridge_transfer NSString*)firstNameRef;
    }
    
    CFStringRef middleNameRef = ABRecordCopyValue(record, kABPersonMiddleNameProperty);
    if (middleNameRef) {
        contact.middleName = (__bridge_transfer NSString*)middleNameRef;
    }
    
    CFStringRef lastNameRef = ABRecordCopyValue(record, kABPersonLastNameProperty);
    if (lastNameRef) {
        contact.lastName = (__bridge_transfer NSString*)lastNameRef;
    }
    
    
    CFStringRef jobTitleRef = ABRecordCopyValue(record, kABPersonJobTitleProperty);
    if (jobTitleRef) {
        contact.jobTitle = (__bridge_transfer NSString*)jobTitleRef;
    }
    
    CFStringRef companyRef = ABRecordCopyValue(record, kABPersonOrganizationProperty);
    if (companyRef) {
        contact.companyName = (__bridge_transfer NSString*)companyRef;
    }
    
    CFStringRef noteRef = ABRecordCopyValue(record, kABPersonNoteProperty);
    if (noteRef) {
        contact.note = (__bridge_transfer NSString*)noteRef;
    }
    
    CFStringRef birthdayRef = ABRecordCopyValue(record, kABPersonNoteProperty);
    if (birthdayRef) {
        contact.birthday = (__bridge_transfer NSDate*)birthdayRef;
    }
    
    CFDateRef modifiedDateRef = ABRecordCopyValue(record, kABPersonModificationDateProperty);
    if (modifiedDateRef) {
        contact.dateModified = (__bridge_transfer NSDate *)modifiedDateRef;
    }
    
    CFDateRef createdDateRef = ABRecordCopyValue(record, kABPersonCreationDateProperty);
    if (createdDateRef) {
        contact.dateCreated = (__bridge_transfer NSDate *)createdDateRef;
    }
    
    NSMutableArray *emails = [self emailsFromRecord:record];
    if (emails && [emails count] > 0) {
        contact.emails = emails;
    }
    
    NSMutableArray *sites = [self sitesFromRecord:record];
    if (sites && [sites count] > 0) {
        contact.sites = sites;
    }
    
    NSMutableArray *socialProfiles = [self socialProfilesFromRecord:record];
    if (socialProfiles && [socialProfiles count] > 0) {
        contact.socialProfiles = socialProfiles;
    }
    
    NSMutableArray *phoneNumbers = [self phoneNumbersFromRecord:record];
    if (phoneNumbers && [phoneNumbers count] > 0) {
        contact.phoneNumbers = phoneNumbers;
    }
    
    NSMutableArray *addresses = [self addressesFromRecord:record];
    if (addresses && [addresses count] > 0) {
        contact.addresses = addresses;
    }
    
    if( ABPersonHasImageData(record)) {
        contact.imageData = (__bridge NSData *)(ABPersonCopyImageData(record));
    }
    
    return contact;
}

- (NSMutableArray *)emailsFromRecord:(ABRecordRef)record {
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    ABMultiValueRef emailRecordsRef = ABRecordCopyValue(record, kABPersonEmailProperty);
    int len = ABMultiValueGetCount(emailRecordsRef);
    
    for (CFIndex j=0; j<len; j++) {
        CFStringRef emailRef = ABMultiValueCopyValueAtIndex(emailRecordsRef, j);
        NSString *email = (__bridge_transfer NSString *)emailRef;
        [emails addObject:email];
    }
    
    if (emailRecordsRef != NULL) {
        CFRelease(emailRecordsRef);
    }
    
    return emails;
}

- (NSMutableArray *)sitesFromRecord:(ABRecordRef)record {
    NSMutableArray *sites = [[NSMutableArray alloc] init];
    
    ABMultiValueRef urlsRef = ABRecordCopyValue(record, kABPersonURLProperty);
    int urlsCount = ABMultiValueGetCount(urlsRef);
    
    for (CFIndex j = 0; j<urlsCount; j++) {
        NSMutableDictionary *userSite;
        userSite = [[NSMutableDictionary alloc] init];
        CFStringRef urlRef = ABMultiValueCopyValueAtIndex(urlsRef, j);
        CFStringRef urlLabelRef = ABMultiValueCopyLabelAtIndex(urlsRef, j);
        
        NSString *label = (__bridge_transfer NSString*)ABAddressBookCopyLocalizedLabel(urlLabelRef);
        NSString *url = (__bridge_transfer NSString *)urlRef;
        
        if (url){
            GASite *site = [[GASite alloc] init];
            site.url = url;
            if (label) {
                site.label = label;
            }
            [sites addObject:userSite];
        }
    }
    
    if (urlsRef) {
        CFRelease(urlsRef);
    }
    
    return sites;
}

- (NSMutableArray *)socialProfilesFromRecord:(ABRecordRef)record {
    NSMutableArray *socialProfiles = [[NSMutableArray alloc] init];
    
    ABMultiValueRef socialProfilesRef = ABRecordCopyValue(record, kABPersonSocialProfileProperty);
    CFIndex socialProfileCount = ABMultiValueGetCount(socialProfilesRef);
    
    for (CFIndex j = 0; j < socialProfileCount; j++) {
        CFDictionaryRef socialValueRef = ABMultiValueCopyValueAtIndex(socialProfilesRef, j);
        
        // Just in case we encounter a NULL ref, skip it
        if (!socialValueRef) {
            continue;
        }
        
        NSString *service = (__bridge_transfer NSString *)CFDictionaryGetValue(socialValueRef, kABPersonSocialProfileServiceKey);
        NSString *socialProfileUrl = (__bridge_transfer NSString *)CFDictionaryGetValue(socialValueRef, kABPersonSocialProfileURLKey);
        
        if (socialProfileUrl && [socialProfileUrl length] > 0) {
            GASocialProfile *profile = [[GASocialProfile alloc] init];
            profile.service = service;
            profile.url = socialProfileUrl;
            [socialProfiles addObject:socialProfileUrl];
        }
    }
    
    if (socialProfilesRef)
    {
        CFRelease(socialProfilesRef);
    }
    
    return socialProfiles;
}

- (NSMutableArray *)phoneNumbersFromRecord:(ABRecordRef)record {
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    ABMultiValueRef phonesRef = ABRecordCopyValue(record, kABPersonPhoneProperty);
    
    for (CFIndex j=0; j< ABMultiValueGetCount(phonesRef); j++) {
        
        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phonesRef, j);
        CFStringRef locLabelRef = ABMultiValueCopyLabelAtIndex(phonesRef, j);
        
        NSString *label = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel(locLabelRef);
        NSString *number = (__bridge_transfer NSString *)phoneNumberRef;
        
        if (number) {
            
            GAPhoneNumber *phoneNumber = [[GAPhoneNumber alloc] init];
            phoneNumber.number = number;
            if (label) {
                phoneNumber.label = label;
            }
            [phoneNumbers addObject:phoneNumber];
        }
    }
    
    CFRelease(phonesRef);
    
    return phoneNumbers;
}

- (NSMutableArray *)addressesFromRecord:(ABRecordRef)record {
    NSMutableArray *addresses = [[NSMutableArray alloc] init];
    ABMultiValueRef addressPropertyRef = ABRecordCopyValue(record, kABPersonAddressProperty);
    
    for (CFIndex i = 0; i < ABMultiValueGetCount(addressPropertyRef); i++) {
        GAAddress *address = [[GAAddress alloc] init];
        
        CFDictionaryRef dictRef = ABMultiValueCopyValueAtIndex(addressPropertyRef, i);
        
        CFDictionaryRef streetRef = CFDictionaryGetValue(dictRef, kABPersonAddressStreetKey);
        
        if (streetRef) {
            NSString *street = (__bridge_transfer NSString *)streetRef;
            if (street) {
                address.street = street;
            }
        }
        
        CFStringRef cityRef = CFDictionaryGetValue(dictRef, kABPersonAddressCityKey);
        if (cityRef) {
            address.city = (__bridge_transfer NSString *)cityRef;
        }
        
        CFStringRef stateRef = CFDictionaryGetValue(dictRef, kABPersonAddressStateKey);
        if (stateRef) {
            address.state = (__bridge_transfer NSString *)stateRef;
        }
        
        CFStringRef zipRef = CFDictionaryGetValue(dictRef, kABPersonAddressZIPKey);
        if (zipRef) {
            address.zip = (__bridge_transfer NSString *)zipRef;
        }
        
        CFStringRef countryRef = CFDictionaryGetValue(dictRef, kABPersonAddressCountryKey);
        if (countryRef) {
            address.country = (__bridge_transfer NSString *)countryRef;
        }
        
        CFStringRef typeTmpRef = ABMultiValueCopyLabelAtIndex(addressPropertyRef, i);
        CFStringRef typeRef = ABAddressBookCopyLocalizedLabel(typeTmpRef);
        if (typeRef) {
            address.type = (__bridge_transfer NSString *)typeRef;
        }
        
        [addresses addObject:address];
    }
    
    CFRelease(addressPropertyRef);
    
    return addresses;
}

@end
