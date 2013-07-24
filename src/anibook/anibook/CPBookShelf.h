//
//  CPBookShelf.h
//  anibook
//
//  Created by wangsw on 7/24/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "cocos2d.h"

@interface CPBookShelf : CCLayer

+ (NSString *)currentBook;
+ (int)currentPage;
+ (void)increaseCurrentPage;
+ (void)decreaseCurrentPage;

+ (void)loadCurrentPage;

@end
