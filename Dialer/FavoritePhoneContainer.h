//
//  FavoritePhoneContainer.h
//  Dialer
//
//  Created by William Richardson on 4/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ContactBaseContainer.h"

@interface FavoritePhoneContainer : ContactBaseContainer
{
    NSMutableArray *_favorites;
    
    BOOL _favoritesModified;
}

@property (nonatomic) BOOL favoritesModified;
@property (nonatomic, strong) NSMutableArray *favorites;

- (void)removeFavorite:(NSNumber *)phoneId;

- (void)addFavorite:(NSDictionary *)person phoneId:(NSNumber *)phoneId;

- (BOOL)isFavorite:(NSNumber *) phoneId;

- (NSDictionary *)personAtIndex:(NSInteger)pos;

- (NSNumber *) phoneIdAtIndex:(NSInteger)pos;

- (NSUInteger)count;

- (NSDictionary *) nameAndPhoneNumberAtIndex:(NSInteger)pos;

@end
