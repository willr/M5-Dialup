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
    NSMutableArray      *_favorites;
    NSMutableDictionary *_contactRef;
    
    BOOL _favoritesModified;
}

@property (nonatomic)         BOOL                  favoritesModified;
@property (nonatomic, retain) NSMutableArray        *favorites;
@property (nonatomic, retain) NSMutableDictionary   *contactRef;

- (void)removeFavorite:(NSNumber *)phoneId;

- (void)addFavorite:(NSDictionary *)person phoneId:(NSNumber *)phoneId;

- (BOOL)isFavorite:(NSNumber *) phoneId;

- (NSDictionary *)personAtIndex:(NSInteger)pos;

- (NSNumber *) phoneIdAtIndex:(NSInteger)pos;

- (NSUInteger)count;

- (NSDictionary *)nameAndPhoneNumberAtIndex:(NSUInteger)index;

- (BOOL) validateFavorite:(NSDictionary *)favorite asContact:(NSDictionary *)contact;

- (void) loadSavedFavorites:(NSDictionary *)contactLookup;

- (void) saveFavorites;

@end
