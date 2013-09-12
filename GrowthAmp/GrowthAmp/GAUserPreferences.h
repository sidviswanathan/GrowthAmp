//
//  DSUserPreferences.h
//
//
//  Created by Don Shefer on 9/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GAUserPreferences : NSObject

+(id)getObjectOfTypeKey:(NSString*)key;
+(void)setObjectOfTypeKey:(NSString*)key object:(id)object;

+(void)clearAllUserSettings;

@end
