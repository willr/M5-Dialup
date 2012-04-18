//
//  IndividualContainer.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ContactBaseContainer.h"
#import "FavoritesListDelegate.h"
#import "ToggleDelegate.h"

@interface PersonContainer : ContactBaseContainer
{
    NSDictionary *_person;
}

@property (strong, nonatomic) NSDictionary *person;
@property (strong, nonatomic, readonly) NSString *name;

- (NSDictionary *)nameAndPhoneNumberAtIndex:(NSUInteger)index;

- (NSNumber *) phoneIdAtIndex:(NSUInteger)index;

- (NSString *) phoneTypeAtIndex:(NSUInteger)index;

- (NSUInteger) count;


@end
