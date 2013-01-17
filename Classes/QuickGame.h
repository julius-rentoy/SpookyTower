//
//  QuickGame.h
//  towerGame
//
//  Created by KCU on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLabelFX.h"
#include "House.h"
#import "CCButton.h"
#import "CC3PartButton.h"
#import "CCSlider.h"
#import "BBTimer.h"
#import "BsButton.h"

typedef enum 
{
	DIALOG_NONE = 0,
	DIALOG_PAUSE,
	DIALOG_OVER
}DIALOG;

typedef enum
{
    GAMETYPE_QUICK = 0,
	GAMETYPE_SCOREATTACK,
	GAMETYPE_TIMEATTACK,
	GAMETYPE_COUNT
}GAMETYPE;


@interface QuickGame : CCLayer <UITextFieldDelegate>
{
        BsButton*			m_btnMenuAd;
	CCLabelFX* mLabel;
	CCLabelFX* mSmallLabel;
	House* mHouse;
	NSMutableArray* mApartment;
	float mfAnimateBaseY;
	
	DIALOG mPauseDialog;
	CCButton* mbtnPause;
	CC3PartButton* mbtnResume;
	CC3PartButton* mbtnMenu;
	CCSlider*	mMusicSlider;
	CCSlider*	mSFXSlider;
	
	BBTimer		mSwingTimer;
	int			m_nFallFloorCount;
	GAMETYPE	m_nGameType;
	int			m_nLifeCount;
	
	long m_lScore;
	long m_lPastTime;	
	long m_lStartTime;
    
    long m_maxTime;
	
	UIAlertView *changePlayerAlert;
	UITextField *changePlayerTextField;	
}

@property (nonatomic) GAMETYPE m_nGameType;

- (void) createMusicSlider;
- (void) createSFXSlider;
- (unsigned long) GetCurrentTime;
- (void) createScoreInput;
@end
