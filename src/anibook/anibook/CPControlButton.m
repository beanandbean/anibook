//
//  CPControlButton.m
//  anibook
//
//  Created by wangsw on 7/26/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CPControlButton.h"

#import "SimpleAudioEngine.h"

@implementation CPControlButton

- (id)initWithBackgroundSprite:(CCScale9Sprite *)sprite {
    self = [super initWithBackgroundSprite:sprite];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithLabel:(CCNode<CCLabelProtocol,CCRGBAProtocol> *)label backgroundSprite:(CCScale9Sprite *)backgroundsprite {
    self = [super initWithLabel:label backgroundSprite:backgroundsprite];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title fontName:(NSString *)fontName fontSize:(NSUInteger)fontsize {
    self = [super initWithTitle:title fontName:fontName fontSize:fontsize];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.counterValue = 0;
    [self addTarget:self action:@selector(touchDown:) forControlEvents:CCControlEventTouchDown];
    if (self.buttonSound && ![self.buttonSound isEqualToString:@""] && [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:self.buttonSound ofType:@""]]) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:self.buttonSound];
    }
    if (self.animationSound && ![self.animationSound isEqualToString:@""] && [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:self.animationSound ofType:@""]]) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:self.animationSound];
    }
}

- (void)touchDown:(id)sender {
    if (self.buttonSound && ![self.buttonSound isEqualToString:@""]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:self.buttonSound ofType:@""]]) {
            if (self.buttonSoundVolume) {
                [SimpleAudioEngine sharedEngine].effectsVolume = self.buttonSoundVolume;
            } else {
                [SimpleAudioEngine sharedEngine].effectsVolume = 1.0;
            }
            [[SimpleAudioEngine sharedEngine] playEffect:self.buttonSound];
        } else {
            NSAssert1(NO, @"%@ - Sound file not found", self.buttonSound);
        }
    }
}

- (void)dealloc {
    [_controlCommand release];
    [_bookName release];
    [_animationName release];
    [_movementName release];
    [_movementNodes release];
    [_movementType release];
    [_toggleStateParticles release];
    [_buttonSound release];
    [_animationSound release];

    [super dealloc];
}

@end
