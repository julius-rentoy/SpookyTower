//
//  ConfirmDialog.h
//  towerGame
//
//  Created by KCU on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BsButton.h"

@class CCLabelFX;
@interface GameOverDialog : CCLayer {

	NSInvocation *invocation;
#if NS_BLOCKS_AVAILABLE
	// used for menu items using a block
	void (^block_)(id sender);
#endif

	CCLabelFX *largeFont;
	CCLabelTTF* smallFont;
    
	NSInteger	m_nFloor;
	BOOL		m_bScoreAttack;
    
    NSUserDefaults * prefs;
    BsButton * banner;
}

@property (nonatomic) NSInteger m_nFloor;
@property (nonatomic) BOOL m_bScoreAttack;

- (id) init;
- (void) setTarget:(id) rec selector:(SEL) cb;

@end
