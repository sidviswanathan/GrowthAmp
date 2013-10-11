//
//  GASampleDataImport.m
//  GrowthAmp
//
//  Created by DON SHEFER on 10/8/13.
//  Copyright (c) 2013 GrowthAmp. All rights reserved.
//

#import "GASampleDataImport.h"
#import "GAContact.h"
#import "GAPhoneNumber.h"
#import "GAConfigManager.h"

#import <UIKit/UIKit.h>

// Random number generation
#define ARC4RANDOM_MAX 0x100000000
#define RND_RANGE(__X__,__Y__) ((float)arc4random() / ARC4RANDOM_MAX) * (__Y__ - __X__) + __X__

@implementation GASampleDataImport

+ (void)contactsWithCompletion:(void(^)(NSArray *, NSError*))completion {
    
    NSArray *names = [GASampleDataImport sampleNames];
    NSArray *images = [GASampleDataImport sampleImages];
    
    int numContacts = [[GAConfigManager sharedInstance] maxNumberOfContacts];
    int imagesIndexMale = 0;
    int imagesIndexFemale = 0;
    
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    
    for (int i=1; i<=numContacts; i++) {
        
        int nameIndex = RND_RANGE(0,(names.count-1));
        
        int imageIndex;
        
        if (nameIndex < (names.count/2)) {
        
            imageIndex = imagesIndexMale+10;
            imagesIndexMale += 1;
            imagesIndexMale = (imagesIndexMale > 9) ? 0 : imagesIndexMale;
            
        } else {
            
            imageIndex = imagesIndexFemale;
            imagesIndexFemale += 1;
            imagesIndexFemale = (imagesIndexFemale > 9) ? 0 : imagesIndexFemale;
        }
        
        int phoneArea = RND_RANGE(101, 999);
        int phoneSeed = RND_RANGE(0, 99);
        
        NSArray *nameArr = [names[nameIndex] componentsSeparatedByString:@" "];
        GAContact *newContact = [self createSampleContactWithFirstName:nameArr[0]
                                                              lastName:nameArr[1]
                                                           phoneNumber:[NSString stringWithFormat:@"(%3d) 555-01%02d",phoneArea,phoneSeed]
                                                                 image:images[imageIndex]];
        [contacts addObject:newContact];
        
    }
    
    
    completion(contacts, nil);
}


+(GAContact*)createSampleContactWithFirstName:(NSString*)firstName
                                     lastName:(NSString*)lastName
                                  phoneNumber:(NSString*)phoneNumber
                                        image:(UIImage*)image {
    
    GAContact *newContact = [[GAContact alloc] init];
    
    newContact.identifier = arc4random_uniform(100000000);
    newContact.firstName = firstName;
    newContact.lastName = lastName;
    
    GAPhoneNumber *phoneNumberObj = [[GAPhoneNumber alloc] init];
    phoneNumberObj.number = phoneNumber;
    newContact.phoneNumbers = [NSArray arrayWithObject:phoneNumberObj];
    
    newContact.imageData = UIImagePNGRepresentation(image);
    
    return newContact;
}

+(NSArray*)sampleNames {
    
    NSString* fileContents = [NSString stringWithContentsOfFile:[[GAFrameworkUtils frameworkBundle] pathForResource:@"names" ofType:@"txt"]
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    NSArray *names = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    return names;
}

+(NSArray*)sampleImages {
    
    int numImages = 20;
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:numImages];
    
    for (int i=1; i<=numImages; i++) {
    
        NSString *imageName = [NSString stringWithFormat:@"%d",i];
        UIImage *image = GAImage(imageName);
        [images addObject:image];
    }
    
    return images;
}

@end
