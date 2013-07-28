//
//  CCBAnimationManager+MovementFromAnimation.m
//  anibook
//
//  Created by wangsw on 7/27/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CCBAnimationManager+MovementFromAnimation.h"

#import "CCNode+RecursiveChildSearch.h"

#import "CCBSequence.h"
#import "CCBSequenceProperty.h"
#import "CCBKeyframe.h"

static NSMutableSet *animatingNode;

@implementation CCBAnimationManager (MovementFromAnimation)

+ (void)cleanAnimatingNodeSet {
    [animatingNode release];
    animatingNode = [[NSMutableSet alloc] init];
}

- (BOOL)runMovementFromAnimationNamed:(NSString *)animationName onNodes:(NSString *)nodeList movementType:(NSString *)type {
    return [self runMovementFromAnimationNamed:animationName onNodes:nodeList tweenDuration:0.0 movementType:type];
}

- (BOOL)runMovementFromAnimationNamed:(NSString *)animationName onNodes:(NSString *)nodeList tweenDuration:(float)tweenDuration movementType:(NSString *)type {
    int animationId = [self sequenceIdForSequenceNamed:animationName];
    return [self runMovementFromAnimationWithId:animationId onNodes:nodeList tweenDuration:tweenDuration movementType:type];
}

- (BOOL)runMovementFromAnimationWithId:(int)animationId onNodes:(NSString *)nodeList tweenDuration:(float)tweenDuration movementType:(NSString *)type {
    NSAssert1(animationId != -1, @"Animation id %d couldn't be found", animationId);
    
    NSMutableArray *nodeArray = [NSMutableArray array];
    
    if ([nodeList isEqualToString:@"ALL"]) {
        for (NSValue *nodePtr in nodeSequences) {
            CCNode *node = [nodePtr pointerValue];
            [nodeArray addObject:node];
        }
    } else {
        NSArray *nodeTagArray = [nodeList componentsSeparatedByString:@","];
        for (NSString *nodeTagStr in nodeTagArray) {
            NSInteger nodeTag = [nodeTagStr integerValue];
            CCNode *node = [rootNode recursiveChildWithTag:nodeTag];
            [nodeArray addObject:node];
        }
    }
    
    for (CCNode *node in nodeArray) {
        NSDictionary *seqs = [nodeSequences objectForKey:[NSValue valueWithPointer:node]];
        NSDictionary *seqNodeProps = [seqs objectForKey:[NSNumber numberWithInt:animationId]];
        if (seqNodeProps.count != 0 && [animatingNode containsObject:node]) {
            return NO;
        }
    }
    
    for (CCNode *node in nodeArray) {
        [node stopAllActions];
        
        NSDictionary *seqs = [nodeSequences objectForKey:[NSValue valueWithPointer:node]];
        NSDictionary *seqNodeProps = [seqs objectForKey:[NSNumber numberWithInt:animationId]];
        for (NSString *propName in seqNodeProps) {
            CCBSequenceProperty *seqProp = [seqNodeProps objectForKey:propName];
            
            if ([type isEqualToString:@"relative"]) {
                [self runRelativeActionsForNode:node sequenceProperty:seqProp tweenDuration:tweenDuration];
            } else if ([type isEqualToString:@"absolute"]) {
                [self setFirstFrameForNode:node sequenceProperty:seqProp tweenDuration:tweenDuration];
                [self runActionsForNode:node sequenceProperty:seqProp tweenDuration:tweenDuration];
            } else if ([type isEqualToString:@"destination"]) {
                [self runActionsForNode:node sequenceProperty:seqProp tweenDuration:tweenDuration];
            } else {
                return NO;
            }
        }
        
        CCBSequence *seq = [self sequenceFromSequenceId:animationId];
        CCAction *completeAction = [CCSequence actionOne:[CCDelayTime actionWithDuration:seq.duration + tweenDuration] two:[CCCallFuncO actionWithTarget:self selector:@selector(movementCompleted:) object:node]];
        [rootNode runAction:completeAction];
        
        [animatingNode addObject:node];
    }
    return YES;
}

- (void)runRelativeActionsForNode:(CCNode*)node sequenceProperty:(CCBSequenceProperty*)seqProp tweenDuration:(float)tweenDuration {
    NSArray* keyframes = [seqProp keyframes];
    int numKeyframes = (int)keyframes.count;
    
    if (numKeyframes > 1) {
        // Make an animation!
        NSMutableArray* actions = [NSMutableArray array];
        
        CCBKeyframe* keyframeFirst = [keyframes objectAtIndex:0];
        float timeFirst = keyframeFirst.time + tweenDuration;
        
        if (timeFirst > 0) {
            [actions addObject:[CCDelayTime actionWithDuration:timeFirst]];
        }
        
        for (int i = 0; i < numKeyframes - 1; i++) {
            CCBKeyframe* kf0 = [keyframes objectAtIndex:i];
            CCBKeyframe* kf1 = [keyframes objectAtIndex:i+1];
            
            CCActionInterval* action = [self relativeActionFromKeyframe0:kf0 andKeyframe1:kf1 propertyName:seqProp.name node:node];
            if (action) {
                // Apply easing
                action = [self easeAction:action easingType:kf0.easingType easingOpt:kf0.easingOpt];
                
                [actions addObject:action];
            }
        }
        
        CCSequence* seq = [CCSequence actionWithArray:actions];
        [node runAction:seq];
    }    
}

- (CCActionInterval*) relativeActionFromKeyframe0:(CCBKeyframe*)kf0 andKeyframe1:(CCBKeyframe*)kf1 propertyName:(NSString*)name node:(CCNode*)node {
    float duration = kf1.time - kf0.time;
    
    if ([name isEqualToString:@"rotation"])
    {
        return [CCRotateBy actionWithDuration:duration angle:[kf1.value floatValue] - [kf0.value floatValue]];
    }
    else if ([name isEqualToString:@"opacity"])
    {
        return [CCFadeTo actionWithDuration:duration opacity:[kf1.value intValue] - [kf0.value intValue] + [(id<CCRGBAProtocol>)node opacity]];
    }
    else if ([name isEqualToString:@"color"])
    {
        ccColor3B c1, c0;
        [kf1.value getValue:&c1];
        [kf0.value getValue:&c0];
        
        return [CCTintBy actionWithDuration:duration red:c1.r - c0.r green:c1.g - c0.g blue:c1.b - c0.g];
    }
    else if ([name isEqualToString:@"visible"])
    {
        if ([kf1.value boolValue] != [kf0.value boolValue]) {
            if (node.visible)
            {
                return [CCSequence actionOne:[CCDelayTime actionWithDuration:duration] two:[CCHide action]];
            }
            else
            {
                return [CCSequence actionOne:[CCDelayTime actionWithDuration:duration] two:[CCShow action]];
            }
        } else {
            return [CCDelayTime actionWithDuration:duration];
        }
    }
    else if ([name isEqualToString:@"displayFrame"])
    {
        return [CCSequence actionOne:[CCDelayTime actionWithDuration:duration] two:[CCBSetSpriteFrame actionWithSpriteFrame:kf1.value]];
    }
    else if ([name isEqualToString:@"position"])
    {
        id value0 = kf0.value;
        id value1 = kf1.value;
        
        // Get relative position
        float x0 = [[value0 objectAtIndex:0] floatValue];
        float y0 = [[value0 objectAtIndex:1] floatValue];
        float x1 = [[value1 objectAtIndex:0] floatValue];
        float y1 = [[value1 objectAtIndex:1] floatValue];
        
        return [CCMoveBy actionWithDuration:duration position:CGPointMake(x1 - x0, y1 - y0)];
    }
    else if ([name isEqualToString:@"scale"])
    {
        id value0 = kf0.value;
        id value1 = kf1.value;
        
        // Get relative scale
        float x0 = [[value0 objectAtIndex:0] floatValue];
        float y0 = [[value0 objectAtIndex:1] floatValue];
        float x1 = [[value1 objectAtIndex:0] floatValue];
        float y1 = [[value1 objectAtIndex:1] floatValue];
        
        return [CCScaleBy actionWithDuration:duration scaleX:x1 / x0 scaleY:y1 / y0];
    }
    else
    {
        NSLog(@"CCBReader: Failed to create animation for property: %@", name);
    }
    return NULL;
}

- (void)movementCompleted:(CCNode *)node {
    if ([animatingNode containsObject:node]) {
        [animatingNode removeObject:node];
    }
}

@end
