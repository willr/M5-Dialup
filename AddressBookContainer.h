//
//  AddressBookContainer.h
//  Dialer
//
//  Created by William Richardson on 2/16/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookContainer : NSObject <UITableViewDataSource>
{
    NSDictionary *_tableViewData;
    NSMutableArray *_contactList;
}

@property (strong, nonatomic) NSDictionary *tableViewData;
@property (strong, nonatomic) NSMutableArray *contactList;

- (void)collectAddressBookInfo;

- (NSDictionary *)getPersonForPath:(NSIndexPath *)indexPath;

@end
