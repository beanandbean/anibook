//
//  CPAnimationButton.m
//  anibook
//
//  Created by wangsw on 7/25/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CPAnimationButton.h"

@implementation CPAnimationButton

- (void)dealloc {
    [self.animationName release];
    [super dealloc];
}

@end
