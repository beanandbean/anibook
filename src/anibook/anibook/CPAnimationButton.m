//
//  CPAnimationButton.m
//  anibook
//
//  Created by wangsw on 7/25/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CPAnimationButton.h"

#import "SimpleAudioEngine.h"

@implementation CPAnimationButton

- (id)initWithBackgroundSprite:(CCScale9Sprite *)sprite {
    self = [super initWithBackgroundSprite:sprite];
    if (self) {
        self.counterValue = 0;
        if (self.soundEffect && ![self.soundEffect isEqualToString:@""] && [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:self.soundEffect ofType:@""]]) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:self.soundEffect];
        }
    }
    return self;
}

- (id)initWithLabel:(CCNode<CCLabelProtocol,CCRGBAProtocol> *)label backgroundSprite:(CCScale9Sprite *)backgroundsprite {
    self = [super initWithLabel:label backgroundSprite:backgroundsprite];
    if (self) {
        self.counterValue = 0;
        if (self.soundEffect && ![self.soundEffect isEqualToString:@""] && [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:self.soundEffect ofType:@""]]) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:self.soundEffect];
        }
    }
    return self;
}

- (id)initWithTitle:(NSString *)title fontName:(NSString *)fontName fontSize:(NSUInteger)fontsize {
    self = [super initWithTitle:title fontName:fontName fontSize:fontsize];
    if (self) {
        self.counterValue = 0;
        if (self.soundEffect && ![self.soundEffect isEqualToString:@""] && [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:self.soundEffect ofType:@""]]) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:self.soundEffect];
        }
    }
    return self;
}

- (void)dealloc {
    [_animationName release];
    [_movementName release];
    [_movementNodes release];
    [super dealloc];
}

@end
