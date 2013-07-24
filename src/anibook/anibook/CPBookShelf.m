//
//  CPBookShelf.m
//  anibook
//
//  Created by wangsw on 7/24/13.
//  Copyright (c) 2013 codingpotato. All rights reserved.
//

#import "CPBookShelf.h"

#import "CPBookButton.h"

#import "CCBReader.h"

static NSString *currentBook;
static int currentPage;

@implementation CPBookShelf

+ (NSString *)currentBook {
    return currentBook;
}

+ (int)currentPage {
    return currentPage;
}

+ (void)increaseCurrentPage {
    currentPage++;
}

+ (void)decreaseCurrentPage {
    currentPage--;
}

+ (void)loadCurrentPage {
    NSString *bookFullName = [NSString stringWithFormat:@"%@_%02d.ccbi", currentBook, currentPage];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:bookFullName ofType:@""]]) {
        CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:bookFullName owner:self];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:1.0 scene:scene]];
    } else {
        NSAssert1(NO, @"%@ - CCBI file not found", bookFullName);
    }
}

- (void)pressedBook:(id)sender {
    [currentBook release];
    currentBook = [((CPBookButton *)sender).bookName retain];
    currentPage = 1;
    [CPBookShelf loadCurrentPage];
}

@end
