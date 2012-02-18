//
//  FavoritesListDelegate.h
//  Dialer
//
//  Created by William Richardson on 2/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FavoritesListDelegate <NSObject>

- (void)removeFavorite:(NSNumber *)index;

- (void)addFavorite:(NSDictionary *)personPhone;

- (BOOL)isFavorite:(NSNumber *) phoneId;

@optional

@end
