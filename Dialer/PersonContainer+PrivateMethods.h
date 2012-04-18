//
//  NSObject_PersonContainer_PrivateMethods_h.h
//  Dialer
//
//  Created by William Richardson on 4/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonContainer (PrivateMethods)

- (void)toggled:(id)sender;

- (NSMutableDictionary *)phoneEntryAtIndex:(NSUInteger)entryPos;

@end
