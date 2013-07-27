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

static NSMutableSet *animatingNode;

@implementation CCBAnimationManager (MovementFromAnimation)

- (void)runMovementFromAnimationNamed:(NSString *)animationName onNodes:(NSString *)nodeList {
    [self runMovementFromAnimationNamed:animationName onNodes:nodeList tweenDuration:0.0];
}

- (void)runMovementFromAnimationNamed:(NSString *)animationName onNodes:(NSString *)nodeList tweenDuration:(float)tweenDuration {
    int animationId = [self sequenceIdForSequenceNamed:animationName];
    [self runMovementFromAnimationWithId:animationId onNodes:nodeList tweenDuration:tweenDuration];
}

- (BOOL)runMovementFromAnimationWithId:(int)animationId onNodes:(NSString *)nodeList tweenDuration:(float)tweenDuration {
    NSAssert1(animationId != -1, @"Animation id %d couldn't be found", animationId);
    
    if (!animatingNode) {
        animatingNode = [[NSMutableSet alloc] init];
    }
    
    NSMutableArray *nodeArray = [NSMutableArray array];
    
    if ([nodeList isEqualToString:@"ALL"]) {
        for (NSValue *nodePtr in nodeSequences) {
            CCNode *node = [nodePtr pointerValue];
            [nodeArray addObject:node];
        }
    } else {
        NSArray *nodeTagArray = [nodeList componentsSeparatedByString:@","];
        for (NSString *nodeTagStr in nodeTagArray) {
            int nodeTag = [nodeTagStr intValue];
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
                
            [self setFirstFrameForNode:node sequenceProperty:seqProp tweenDuration:tweenDuration];
            [self runActionsForNode:node sequenceProperty:seqProp tweenDuration:tweenDuration];
        }
        
        CCBSequence *seq = [self sequenceFromSequenceId:animationId];
        CCAction *completeAction = [CCSequence actionOne:[CCDelayTime actionWithDuration:seq.duration + tweenDuration] two:[CCCallFuncO actionWithTarget:self selector:@selector(movementCompleted:) object:node]];
        [rootNode runAction:completeAction];
        
        [animatingNode addObject:node];
    }
    return YES;
}

- (void)movementCompleted:(CCNode *)node {
    if ([animatingNode containsObject:node]) {
        [animatingNode removeObject:node];
    }
}

@end
