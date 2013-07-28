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

#import "CCBAnimationManager+MovementFromAnimation.h"

#import "SimpleAudioEngine.h"

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

+ (void)loadCurrentPageWithForward:(BOOL)isForward {
    NSString *bookFullName = [NSString stringWithFormat:@"%@_%02d.ccbi", currentBook, currentPage];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:bookFullName ofType:@""]]) {
        CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:bookFullName owner:self];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5 scene:scene backwards:!isForward]];
    } else {
        NSAssert1(NO, @"%@ - CCBI file not found", bookFullName);
    }
}

- (void)didLoadFromCCB {
    [CCBAnimationManager cleanAnimatingNodeSet];
    if (self.backgroundVolume) {
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.6;
    } else {
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1.0;
    }
    if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying] && self.backgroundMusic && ![self.backgroundMusic isEqualToString:@""]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:self.backgroundMusic ofType:@""]]) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:self.backgroundMusic];
        } else {
            NSAssert1(NO, @"%@ - Background music file not found", self.backgroundMusic);
        }
    }
}

- (void)pressedBook:(id)sender {
    [currentBook release];
    currentBook = [((CPBookButton *)sender).bookName retain];
    currentPage = 1;
    [CPBookShelf loadCurrentPageWithForward:YES];
}

- (void)dealloc {
    [_backgroundMusic release];
    [super dealloc];
}

@end
