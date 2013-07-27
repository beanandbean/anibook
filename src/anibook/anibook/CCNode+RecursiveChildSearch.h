//
//  CCNode+RecursiveChildSearch.h
//  anibook
//
//  Created by wangsw on 7/27/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CCNode.h"

@interface CCNode (RecursiveChildSearch)

- (CCNode *)recursiveChildWithTag:(NSInteger)tag;

@end
