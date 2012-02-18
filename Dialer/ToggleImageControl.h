//
//  ToggleImageControl.h
//  Dialer
//
//  Created by William Richardson on 2/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToggleDelegate.h"

@interface ToggleImageControl : UIControl
{
    BOOL _selected;
    BOOL _activated;
    UIImageView *_imageView;
    UIImage *_normalImage;
    UIImage *_selectedImage;
}

@property (strong, nonatomic) id<ToggleDelegate> toggleDelegate;
@property (nonatomic) BOOL selectedState;
@property (nonatomic) BOOL activated;

- (void) toggleImage;

@end
