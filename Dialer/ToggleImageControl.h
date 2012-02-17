//
//  ToggleImageControl.h
//  Dialer
//
//  Created by William Richardson on 2/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToggleImageControl : UIControl
{
    BOOL _selected;
    UIImageView *_imageView;
    UIImage *_normalImage;
    UIImage *_selectedImage;
}


@end
