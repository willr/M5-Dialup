//
//  ToggleImageControl.m
//  Dialer
//
//  Created by William Richardson on 2/17/12.
//  Copyright (c) 2012 CodeSpan Technologies. All rights reserved.
//

#import "ToggleImageControl.h"
#import "Constants.h"

@implementation ToggleImageControl

@synthesize selectedState = _selected, toggleDelegate = _toggleDelegate, activated = _activated;

- (id)initWithFrame:(CGRect)frame 
{
    // create the imageView which is the basis of the control
    // set the images to load based on the selected not-selected states 
    if ( self = [super initWithFrame: frame] ){
        _normalImage = [UIImage imageNamed: EmptyBoxImageTitle];
        _selectedImage = [UIImage imageNamed: BoxWithCheckmarkImageTitle];
        // created smallish box, slight off the left side for looks
        CGRect frame = CGRectMake(5.0, 0.0, 35.0, 35.0);
        _imageView = [[UIImageView alloc] initWithImage: _normalImage];
        _imageView.frame = frame;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // set imageView we just created as a subview, we do everything with the imageView, the control is just a container
        [self addSubview: _imageView];
        
        // add the target below
        [self addTarget: self action: @selector(toggleImage) forControlEvents: UIControlEventTouchDown];
    }
    
    return self;
}

- (void) toggleImage
{
    // based on current state we set the image to be loaded
    _selected = !_selected;
    _imageView.image = (_selected ? _selectedImage : _normalImage); 
    
    // Use NSNotification or other method to notify data model about state change.
    // Notification example:
    // NSDictionary *dict = [NSDictionary dictionaryWithObject: [NSNumber numberWithInt: self.tag] forKey: @"CellCheckToggled"];
    // [[NSNotificationCenter defaultCenter] postNotificationName: @"CellCheckToggled" object: self userInfo: dict];
    
    // we are currently just using delegates, cause it is easy and we only have a one to one relationship,
    // this could be expanded sometime to use notificationCenter, not sure if needed.
    
    // activated allows control to be setup to a know state prior to delegate being fired on each toggle
    if (_activated) {
        [self.toggleDelegate toggled:self];
    }
}
                          
@end
