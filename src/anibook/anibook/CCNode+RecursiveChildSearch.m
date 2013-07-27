//
//  CCNode+RecursiveChildSearch.m
//  anibook
//
//  Created by wangsw on 7/27/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CCNode+RecursiveChildSearch.h"

@implementation CCNode (RecursiveChildSearch)

- (CCNode *)recursiveChildWithTag:(NSInteger)tag {
    for (CCNode *child in self.children) {
        if (child.tag == tag) {
            return child;
        }
        CCNode *recursiveChild = [child recursiveChildWithTag:tag];
        if (recursiveChild) {
            return recursiveChild;
        }
    }
    return nil;
}

@end
