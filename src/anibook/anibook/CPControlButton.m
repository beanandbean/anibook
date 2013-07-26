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
        [self addTarget:self action:@selector(touchDown:) forControlEvents:CCControlEventTouchDown];
        if (self.soundEffect && ![self.soundEffect isEqualToString:@""] && [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:self.soundEffect ofType:@""]]) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:self.soundEffect];
        }
    }
    return self;
}

- (id)initWithLabel:(CCNode<CCLabelProtocol,CCRGBAProtocol> *)label backgroundSprite:(CCScale9Sprite *)backgroundsprite {
    self = [super initWithLabel:label backgroundSprite:backgroundsprite];
    if (self) {
        [self addTarget:self action:@selector(touchDown:) forControlEvents:CCControlEventTouchDown];
        if (self.soundEffect && ![self.soundEffect isEqualToString:@""] && [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:self.soundEffect ofType:@""]]) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:self.soundEffect];
        }
    }
    return self;
}

- (id)initWithTitle:(NSString *)title fontName:(NSString *)fontName fontSize:(NSUInteger)fontsize {
    self = [super initWithTitle:title fontName:fontName fontSize:fontsize];
    if (self) {
        [self addTarget:self action:@selector(touchDown:) forControlEvents:CCControlEventTouchDown];
        if (self.soundEffect && ![self.soundEffect isEqualToString:@""] && [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:self.soundEffect ofType:@""]]) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:self.soundEffect];
        }
    }
    return self;
}

- (void)touchDown:(id)sender {
    if (self.soundEffect && ![self.soundEffect isEqualToString:@""]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:self.soundEffect ofType:@""]]) {
            [[SimpleAudioEngine sharedEngine] playEffect:self.soundEffect];
        } else {
            NSAssert1(NO, @"%@ - Sound file not found", self.soundEffect);
        }
    }
}

@end
