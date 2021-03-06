//
//  UserDefaultsContainer.m
//  Dialer
//
//  Created by William Richardson on 4/27/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "UserDefaultsContainer.h"
#import "UserDefaultsContainer+PrivateMethods.h"
#import "Constants.h"

static UserDefaultsContainer *userDefaultsContainer = nil;

@implementation UserDefaultsContainer

@synthesize appDefaults         = _appDefaults;
@synthesize defaultsModified    = _defaultsModified;

- (id)init
{
    self = [super init];
    if (self != nil) {
        // Custom initialization
        
        // default modifed to false
        _defaultsModified = true;
        _appDefaults = [[NSMutableDictionary alloc] init];
        
        [self setupUserDefaults];
        
    }
    return self;
}

- (void)dealloc 
{
    // should never be called but added for clarity
    [super dealloc];
}

- (void) updateDefault:(NSString *)key value:(NSString *)value
{
    [self.appDefaults setObject:value forKey:key];
    
    self.defaultsModified = true;
}

- (NSString *) getValueForKey:(NSString *)key
{
    return [self.appDefaults objectForKey:key];
}

- (void) registerDefaults
{
    if (self.defaultsModified) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:self.appDefaults];
        
        self.defaultsModified = false;
    }
}

- (void) setupUserDefaults
{
    /*
     NSString * const M5DialCmd = @"M5DialCmd";
     NSString * const M5AnswerCmd = @"M5AnswerCmd";
     NSString * const M5IgnoreCmd = @"M5IgnoreCmd";
     NSString * const M5ReleaseCmd = @"M5ReleaseCmd";
     NSString * const M5HoldCmd = @"M5HoldCmd";
     NSString * const M5ListCallsCmd = @"M5ListCallsCmd";
     NSString * const M5ResumeCmd = @"M5ResumeCmd";
     */
    
    // [self.appDefaults setValue:dialCmd forKey:M5DialCmd];
}

#pragma mark -
#pragma mark Singleton Methods

+ (UserDefaultsContainer *)current
{
    @synchronized(self) {
        if(userDefaultsContainer == nil) {
            userDefaultsContainer = [[super allocWithZone:NULL] init];
        }
    }
    return userDefaultsContainer;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self current] retain];
}

- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

- (id)retain 
{
    return self;
}

- (unsigned)retainCount 
{
    return UINT_MAX; // denotes an object that cannot be released
}

- (oneway void)release 
{
    // never release
}

- (id)autorelease 
{
    return self;
}

@end








//
