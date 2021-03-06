//
//  CCBAnimationManager+MovementFromAnimation.h
//  anibook
//
//  Created by wangsw on 7/27/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CCBAnimationManager.h"

@interface CCBAnimationManager (MovementFromAnimation)

+ (void)cleanAnimatingNodeSet;

- (BOOL)runMovementFromAnimationNamed:(NSString *)animationName onNodes:(NSString *)nodeList movementType:(NSString *)type;

@end
