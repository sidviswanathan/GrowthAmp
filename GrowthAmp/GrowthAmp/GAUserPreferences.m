//
//  DSUserPreferences.h
//
//
//  Created by Don Shefer on 9/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "GAUserPreferences.h"

@implementation GAUserPreferences 

+(id)getObjectOfTypeKey:(NSString*)key {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id object = [userDefaults objectForKey:key];
    
    return object;
    
}

+(void)setObjectOfTypeKey:(NSString*)key object:(id)object {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object
                     forKey:key];
    [userDefaults synchronize];    
}

#pragma mark - Clear All Settings

+(void)clearAllUserSettings {
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];

}



@end
