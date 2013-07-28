//
//  CPAnimationButton.h
//  anibook
//
//  Created by wangsw on 7/25/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CPControlButton.h"

@interface CPAnimationButton : CCControlButton

@property (retain, nonatomic) NSString *soundEffect;
@property (nonatomic) float soundVolume;

@property (retain, nonatomic) NSString *animationName;

@property (retain, nonatomic) NSString *movementName;
@property (retain, nonatomic) NSString *movementNodes;
@property (retain, nonatomic) NSString *movementType;

@property (retain, nonatomic) NSString *toggleStateParticles;

@property (nonatomic) int counterValue;
@property (nonatomic) int counterMaxium;

@end
