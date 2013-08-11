//
//  CPBookShelf.h
//  anibook
//
//  Created by wangsw on 7/24/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "cocos2d.h"
#import "CPBookPage.h"

@interface CPBookShelf : CPBookPage

@property (retain, nonatomic) NSString *backgroundMusic;
@property (nonatomic) float backgroundVolume;

+ (NSString *)currentBook;
+ (void)setCurrentBook:(NSString *)book;

+ (int)currentPage;
+ (void)increaseCurrentPage;
+ (void)decreaseCurrentPage;
+ (void)setCurrentPage:(int)page;

+ (void)loadCurrentPageWithForward:(BOOL)isForward;

@end
