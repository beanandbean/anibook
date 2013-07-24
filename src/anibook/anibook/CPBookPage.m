//
//  CPBookPage.m
//  anibook
//
//  Created by wangsw on 7/24/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CPBookPage.h"

#import "CPBookShelf.h"

#import "CCBReader.h"

@implementation CPBookPage

- (void)pressedHome:(id)sender {
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"BookShelf.ccbi" owner:self];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:1.0 scene:scene]];
}

- (void)pressedNext:(id)sender {
    [CPBookShelf increaseCurrentPage];
    [CPBookShelf loadCurrentPage];
}

- (void)pressedPrev:(id)sender {
    [CPBookShelf decreaseCurrentPage];
    [CPBookShelf loadCurrentPage];
}

@end
