//
//  UserDefaultsContainer.h
//  Dialer
//
//  Created by William Richardson on 4/27/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsContainer : NSObject
{
    NSMutableDictionary *_appDefaults;
    
    BOOL                _defaultsModified;
}

@property (nonatomic, retain)   NSMutableDictionary *appDefaults;
@property (nonatomic)           BOOL                defaultsModified;

+ (id)current;

- (void) registerDefaults;

- (void) updateDefault:(NSString *)key value:(NSString *)value;

- (NSString *) getValueForKey:(NSString *)key;

@end
