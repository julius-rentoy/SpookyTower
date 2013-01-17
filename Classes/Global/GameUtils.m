//
//  GameUtils.m
//  MonkeyTime
//
//  Created by OCH on 11/01/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameUtils.h"

GameUtils*		g_GameUtils = nil;

@implementation GameUtils

@synthesize sound			= m_bSound;
@synthesize possibleLevel	= m_possibleLevel;
@synthesize selectLevel		= m_selectLevel;
@synthesize highScore		= m_highScore;
@synthesize animationInterval = m_animationInterval;


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
		m_bSound			= YES;
		m_possibleLevel		= 0;
		m_selectLevel		= 0;
		m_highScore			= 0;
		m_animationInterval	= 60.0;
		
		m_SoundEngine = [SimpleAudioEngine sharedEngine];
	}
	return self;
}

-(void) InitGameInfo {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL bInstalled = [defaults boolForKey:@"Launch Application"];
	
	if( !bInstalled ) {
		[self setSound:YES];
		m_Rating[0] = 0;
		
		[defaults setBool:YES forKey:@"Launch Application"];
		[defaults setInteger:m_Rating[0] forKey:@"Rating 0"];
	}
	else {
		m_bSound = [defaults boolForKey:@"Sound Setting"];
	}
	m_selectLevel   = [defaults integerForKey:@"Select Level"];
	m_possibleLevel = [defaults integerForKey:@"Possible Level"];
	
	m_Rating[0]     = [defaults integerForKey:@"Rating 0"];
	m_Rating[1]     = [defaults integerForKey:@"Rating 1"];
	m_Rating[2]     = [defaults integerForKey:@"Rating 2"];
	m_Rating[3]     = [defaults integerForKey:@"Rating 3"];
	m_Rating[4]     = [defaults integerForKey:@"Rating 4"];
	m_Rating[5]     = [defaults integerForKey:@"Rating 5"];
	m_Rating[6]     = [defaults integerForKey:@"Rating 6"];
	m_Rating[7]     = [defaults integerForKey:@"Rating 7"];
	m_Rating[8]     = [defaults integerForKey:@"Rating 8"];
	m_Rating[9]     = [defaults integerForKey:@"Rating 9"];
	m_Rating[10]    = [defaults integerForKey:@"Rating 10"];
	m_Rating[11]    = [defaults integerForKey:@"Rating 11"];
	m_Rating[12]    = [defaults integerForKey:@"Rating 12"];
	m_Rating[13]    = [defaults integerForKey:@"Rating 13"];
	m_Rating[14]    = [defaults integerForKey:@"Rating 14"];
    
    m_highScore     = [defaults integerForKey:@"hiscore"];
}

-(void) SaveGameInfo {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setBool:m_bSound forKey:@"Sound Setting"];
	
	[defaults setInteger:m_selectLevel   forKey:@"Select Level"];
	[defaults setInteger:m_possibleLevel forKey:@"Possible Level"];

	[defaults setInteger:m_Rating[0] forKey:@"Rating 0"];
	[defaults setInteger:m_Rating[1] forKey:@"Rating 1"];
	[defaults setInteger:m_Rating[2] forKey:@"Rating 2"];
	[defaults setInteger:m_Rating[3] forKey:@"Rating 3"];
	[defaults setInteger:m_Rating[4] forKey:@"Rating 4"];
	[defaults setInteger:m_Rating[5] forKey:@"Rating 5"];
	[defaults setInteger:m_Rating[6] forKey:@"Rating 6"];
	[defaults setInteger:m_Rating[7] forKey:@"Rating 7"];
	[defaults setInteger:m_Rating[8] forKey:@"Rating 8"];
	[defaults setInteger:m_Rating[9] forKey:@"Rating 9"];
	[defaults setInteger:m_Rating[10] forKey:@"Rating 10"];
	[defaults setInteger:m_Rating[11] forKey:@"Rating 11"];
	[defaults setInteger:m_Rating[12] forKey:@"Rating 12"];
	[defaults setInteger:m_Rating[13] forKey:@"Rating 13"];
	[defaults setInteger:m_Rating[14] forKey:@"Rating 14"];

	[defaults setInteger:m_highScore forKey:@"hiscore"];
}

// 게임의 레벨수
-(int) getLevelCount {
	return 15;
}

// 게임의 최대레벨
-(int) getMaxLevel {
	return [self getLevelCount] - 1;
}

// 놀수 있는 최대레벨
-(int) getPossibleLevel {
	return m_possibleLevel;
}

// 놀수 있는 레벨을 갱신할수 있는가?
-(BOOL) canLevelUp {
	int	nMaxLevel = [self getMaxLevel];
	
	if ( m_possibleLevel < nMaxLevel ) {
		return YES;
	} else {
		return NO;
	}
}

// 현재 선택한 레벨이 놀수 있는 레벨보다 작은가?
-(BOOL) canGotoNextLevel {
	if ( m_selectLevel < m_possibleLevel ) {
		return YES;
	} else {
		return NO;
	}
}

// 플레이 할수 있는 레벨인가?
-(BOOL) isAvalibleLevel:(int)level {
	int	nMaxLevel = [self getMaxLevel];
	
	if (level < 0)
		return NO;
	if (level > nMaxLevel)
		return NO;
	
	if (m_Rating[level] < 0)
		return NO;
	if (m_Rating[level] > 3)
		return NO;
	
	return YES;
}

// 현재 레벨의 레이팅값을 얻는다.
-(int) getRating:(int)level {
	if ([self isAvalibleLevel:level] == NO)
		return -1;
	
	return m_Rating[level];
}

// 현재 레벨에 레이팅값을 설정한다.
-(BOOL) setRating:(int)level rating:(int)rating {
	if ([self isAvalibleLevel:level] == NO)
		return NO;
	
	if (rating < 0 || rating > 3)
		return NO;
	
	m_Rating[level] = rating;
	return YES;
}

// 플레이할수 있는 레벨을 증가시킨다.
-(void) LevelUp {
	if ( [self canGotoNextLevel] == YES )
		return;

	if ( [self canLevelUp] == YES ) {
		m_possibleLevel ++;
		[self setRating:m_possibleLevel rating:0];
	}
}




-(void) playBackgroundMusic:(NSString*)str
{
	[m_SoundEngine playBackgroundMusic:str];
	[m_SoundEngine setMute:!m_bSound];
}

-(void) stopBackgroundMusic
{
	[m_SoundEngine stopBackgroundMusic];
}

-(void) playSoundEffect:(NSString*)str
{
	if (m_bSound)
		[m_SoundEngine playEffect:str];
}

-(BOOL) sound
{
	return m_bSound;
}

-(void) setSound:(BOOL)sound
{
	if (m_bSound == sound)
		return;
	m_bSound = sound;
	if (sound) {
		[m_SoundEngine setMute:NO];
	}
	else {
		[m_SoundEngine setMute:YES];
	}
}

-(BOOL)	isIPhone
{
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

-(NSString*) ImageString:(NSString*)str ext:(NSString*)ext
{
	NSString*	strImage = nil;
	
	if ([self isIPhone] == YES) {
		strImage = [NSString stringWithFormat:@"%@.%@", str, ext];
	} else {
		strImage = [NSString stringWithFormat:@"%@@3x.%@", str, ext];
	}

	return strImage;
}

@end
