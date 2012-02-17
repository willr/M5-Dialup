//
//  IndividualContainer.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddressBookContainer.h"


@interface PersonContainer : AddressBookContainer <UITableViewDataSource>
{
    NSDictionary *_person;
}

@property (strong, nonatomic) NSDictionary *person;
@property (strong, nonatomic, readonly) NSString *name;


@end
