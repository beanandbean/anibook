//
//  CPBookPage.m
//  anibook
//
//  Created by wangsw on 7/24/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CPBookPage.h"

#import "CPBookShelf.h"

#import "CPAnimationButton.h"

#import "CCBReader.h"
#import "CCBAnimationManager.h"
#import "SimpleAudioEngine.h"

@interface CPBookPage ()

@property (retain, nonatomic) CCBAnimationManager *animationManager;

@end

@implementation CPBookPage

- (void)didLoadFromCCB {
    self.animationManager = self.userObject;
}

- (void)pressedHome:(id)sender {
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"BookShelf.ccbi" owner:self];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:1.0 scene:scene]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"ButtonSound.caf"];
}

- (void)pressedNext:(id)sender {
    [CPBookShelf increaseCurrentPage];
    [CPBookShelf loadCurrentPage];
}

- (void)pressedPrev:(id)sender {
    [CPBookShelf decreaseCurrentPage];
    [CPBookShelf loadCurrentPage];
}

- (void)pressedAnimation:(id)sender {
    [self.animationManager runAnimationsForSequenceNamed:((CPAnimationButton *)sender).animationName];
}

@end
