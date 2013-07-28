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

#import "CCNode+RecursiveChildSearch.h"

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
    [CCBAnimationManager cleanAnimatingNodeSet];
    self.animationManager = self.userObject;
    if (self.toggleStateParticles && ![self.toggleStateParticles isEqualToString:@""]) {
        NSArray *particleTags = [self.toggleStateParticles componentsSeparatedByString:@","];
        for (NSString *particleTagStr in particleTags) {
            NSInteger particleTag = [particleTagStr integerValue];
            CCParticleSystem *particleSys = (CCParticleSystem *)[self recursiveChildWithTag:particleTag];
            if ([particleSys active]) {
                [particleSys stopSystem];
            } else {
                [particleSys startSystem];
            }
        }
    }
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
    
    BOOL ignorePress = YES;
    NSString *animationName = [CPBookPage stringWithString:button.animationName andCounterValue:button.counterValue];
    NSString *movementName = [CPBookPage stringWithString:button.movementName andCounterValue:button.counterValue];
    NSString *movementNodes = [CPBookPage stringWithString:button.movementNodes andCounterValue:button.counterValue];
    NSString *movementType = button.movementType;
    NSString *toggleStateParticles = [CPBookPage stringWithString:button.toggleStateParticles andCounterValue:button.counterValue];
    
    if (movementName && ![movementName isEqualToString:@""]) {
        if (!movementNodes || [movementNodes isEqualToString:@""]) {
            movementNodes = @"ALL";
        }
        if (!movementType || [movementType isEqualToString:@""]) {
            movementType = @"absolute";
        }
        ignorePress = ![self.animationManager runMovementFromAnimationNamed:movementName onNodes:movementNodes movementType:movementType];
    }
    if (animationName && ![animationName isEqualToString:@""]) {
        [self.animationManager runAnimationsForSequenceNamed:animationName];
        ignorePress = NO;
    }
    if (toggleStateParticles && ![toggleStateParticles isEqualToString:@""]) {
        NSArray *particleTags = [toggleStateParticles componentsSeparatedByString:@","];
        for (NSString *particleTagStr in particleTags) {
            NSInteger particleTag = [particleTagStr integerValue];
            CCParticleSystem *particleSys = (CCParticleSystem *)[self recursiveChildWithTag:particleTag];
            if ([particleSys active]) {
                [particleSys stopSystem];
            } else {
                [particleSys startSystem];
            }
            ignorePress = NO;
        }
    }
    
    if (!ignorePress) {
        if (button.soundEffect && ![button.soundEffect isEqualToString:@""]) {
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
}

- (void)dealloc {
    [_toggleStateParticles release];
    [super dealloc];
}

@end
