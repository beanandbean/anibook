//
//  CPControlButton.h
//  anibook
//
//  Created by wangsw on 7/26/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CCControlButton.h"

@interface CPControlButton : CCControlButton

// Page Control
@property (retain, nonatomic) NSString *controlCommand;
@property (retain, nonatomic) NSString *bookName;
@property (nonatomic) int pageNumber;

// Animation
@property (retain, nonatomic) NSString *animationName;

// Movement
@property (retain, nonatomic) NSString *movementName;
@property (retain, nonatomic) NSString *movementNodes;
@property (retain, nonatomic) NSString *movementType;

// Particle Control
@property (retain, nonatomic) NSString *toggleStateParticles;

// Button Sound
@property (retain, nonatomic) NSString *buttonSound;
@property (nonatomic) float buttonSoundVolume;

// Animation Sound
@property (retain, nonatomic) NSString *animationSound;
@property (nonatomic) float animationSoundVolume;

// Counter
@property (nonatomic) int counterValue;
@property (nonatomic) int counterMaxium;

@end
