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
#import "CCBAnimationManager+MovementFromAnimation.h"

#import "SimpleAudioEngine.h"

@interface CPBookPage ()

@property (retain, nonatomic) CCBAnimationManager *animationManager;

+ (NSString *)stringWithString:(NSString *)string andCounterValue:(int)counterValue;

@end

@implementation CPBookPage

+ (NSString *)stringWithString:(NSString *)string andCounterValue:(int)counterValue {
    NSString *output = [string stringByReplacingOccurrencesOfString:@"%%" withString:[NSString stringWithFormat:@"%02d", counterValue]];
    output = [output stringByReplacingOccurrencesOfString:@"%" withString:[NSString stringWithFormat:@"%d", counterValue]];
    return output;
}

- (void)didLoadFromCCB {
    self.animationManager = self.userObject;
    
}

- (void)pressedHome:(id)sender {
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"BookShelf.ccbi" owner:self];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5 scene:scene backwards:YES]];
}

- (void)pressedNext:(id)sender {
    [CPBookShelf increaseCurrentPage];
    [CPBookShelf loadCurrentPageWithForward:YES];
}

- (void)pressedPrev:(id)sender {
    [CPBookShelf decreaseCurrentPage];
    [CPBookShelf loadCurrentPageWithForward:NO];
}

- (void)pressedAnimation:(id)sender {
    CPAnimationButton *button = (CPAnimationButton *)sender;

    BOOL needSoundEffect = YES;
    NSString *animationName = [CPBookPage stringWithString:button.animationName andCounterValue:button.counterValue];
    NSString *movementName = [CPBookPage stringWithString:button.movementName andCounterValue:button.counterValue];
    NSString *movementNodes = [CPBookPage stringWithString:button.movementNodes andCounterValue:button.counterValue];
    if (animationName) {
        [self.animationManager runAnimationsForSequenceNamed:animationName];
    }
    if (movementName) {
        if (!movementNodes || [movementNodes isEqualToString:@""]) {
            movementNodes = @"ALL";
        }
        needSoundEffect = [self.animationManager runMovementFromAnimationNamed:movementName onNodes:movementNodes];
    }
    
    if (needSoundEffect && button.soundEffect && ![button.soundEffect isEqualToString:@""]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:button.soundEffect ofType:@""]]) {
            if (button.soundVolume) {
                [SimpleAudioEngine sharedEngine].effectsVolume = button.soundVolume;
            } else {
                [SimpleAudioEngine sharedEngine].effectsVolume = 1.0;
            }
            [[SimpleAudioEngine sharedEngine] playEffect:button.soundEffect];
        } else {
            NSAssert1(NO, @"%@ - Sound file not found", button.soundEffect);
        }
    }
    
    button.counterValue++;
    if (button.counterValue > button.counterMaxium) {
        button.counterValue = 0;
    }
}

@end
