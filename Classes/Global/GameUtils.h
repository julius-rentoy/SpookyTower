//
//  GameUtils.h
//  MonkeyTime
//
//  Created by OCH on 11/01/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface GameUtils : NSObject {
	BOOL	m_bSound;
	int		m_possibleLevel;
	int		m_selectLevel;
	int		m_highScore;
	float	m_animationInterval;
	int		m_Rating[15];
	
	SimpleAudioEngine*		m_SoundEngine;
}

@property (nonatomic,readonly,assign) BOOL		sound;
@property (nonatomic,readwrite,assign) int		possibleLevel;
@property (nonatomic,readwrite,assign) int		selectLevel;
@property (nonatomic,readwrite,assign) int		highScore;
@property (nonatomic,readwrite,assign) float	animationInterval;

-(void) InitGameInfo;
-(void) SaveGameInfo;

-(BOOL) canGotoNextLevel;
-(void) LevelUp;

-(void) setSound:(BOOL)sound;
-(void) playBackgroundMusic:(NSString*)str;
-(void) playSoundEffect:(NSString*)str;
-(void) stopBackgroundMusic;

-(BOOL)	isIPhone;

-(NSString*) ImageString:(NSString*)str ext:(NSString*)ext;
-(int) getRating:(int)level;
-(BOOL) setRating:(int)level rating:(int)rating;
	
@end

extern GameUtils*	g_GameUtils;