//
//  CPBookShelf.h
//  anibook
//
//  Created by wangsw on 7/24/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "cocos2d.h"

@interface CPBookShelf : CCLayer

@property (retain, nonatomic) NSString *backgroundMusic;
@property (nonatomic) float backgroundVolume;

+ (NSString *)currentBook;
+ (int)currentPage;
+ (void)increaseCurrentPage;
+ (void)decreaseCurrentPage;

+ (void)loadCurrentPageWithForward:(BOOL)isForward;

@end
