//
//  CPBookButton.m
//  anibook
//
//  Created by wangsw on 7/24/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CPBookButton.h"

@implementation CPBookButton

- (void)dealloc {
    [_bookName release];
    
    [super dealloc];
}

@end
