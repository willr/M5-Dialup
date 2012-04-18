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

- (void)removeFavorite:(NSNumber *)phoneId;

- (void)addFavorite:(NSNumber *)phoneId;

- (BOOL)isFavorite:(NSNumber *) phoneId;

- (NSDictionary *)personAtIndex:(NSInteger)pos;

- (NSUInteger)count;

- (NSDictionary *)findPhoneEntryForPhoneId:(NSNumber *)phoneId;

@end
