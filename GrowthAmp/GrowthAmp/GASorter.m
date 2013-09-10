//
//  GASorter.m
//  GrowthAmp
//
//  Created by Kirollos Risk on 7/14/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GASorter.h"
#import "GAContact.h"
#import <AddressBook/AddressBook.h>

#define SCORE_IMAGE         0.2
#define SCORE_FACEBOOK      0.4
#define SCORE_NUM_FIELDS    0.3

@interface GASorter ()

@property (nonatomic, strong) NSMutableDictionary *scores;

@end

@implementation GASorter

- (id)init {
    self = [super init];
    if (self) {
        self.scores = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (dispatch_queue_t)queue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.growthamp.sort.queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

- (void)sortContacts:(NSArray *)contacts completion:(void(^)(NSArray *, NSError *))completion {
    dispatch_async([[self class] queue], ^{
        NSArray *sortedContacts = [contacts sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            float scoreA = [self scoreForContact:(GAContact*)a];
            float scoreB = [self scoreForContact:(GAContact*)b];
            
            if (scoreA > scoreB) {
                return NSOrderedAscending;
            } else if (scoreA < scoreB) {
                return NSOrderedDescending;
            }  else {
                return NSOrderedSame;
            }
        }];
        
        completion(sortedContacts, nil);
    });
}

- (float)scoreForContact:(GAContact *)contact {
    float score = 0.0;
    
    // Only consider contacts with phone numbers
    if (!contact.phoneNumbers.count) {
        return score;
    }
    
    // If it's cached, retrieve it
    if (self.scores[@(contact.identifier)]) {
        return [self.scores[@(contact.identifier)] floatValue];
    }
    
    NSString *facebook = (__bridge_transfer NSString *)kABPersonSocialProfileServiceFacebook;
    
    if (contact.imageData) {
        score += SCORE_IMAGE * 1;
    }
    
    if ([contact.socialProfiles containsObject:facebook]) {
        score += SCORE_FACEBOOK * 1;
    }
    
    int numFields = 0;
    if (contact.jobTitle) {
        numFields++;
    }
    if (contact.companyName) {
        numFields++;
    }
    if (contact.note) {
        numFields++;
    }
    if (contact.birthday){
        numFields++;
    }
    if (contact.sites){
        numFields++;
    }
    if (contact.emails){
        numFields++;
    }
    if (contact.addresses){
        numFields++;
    }
    if (contact.socialProfiles){
        numFields++;
    }
    
    score += SCORE_NUM_FIELDS * numFields;
    
    // cache it
    self.scores[@(contact.identifier)] = @(score);
    
    return score;
}


@end
