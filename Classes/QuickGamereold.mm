//
//  QuickGame.mm
//  towerGame
//
//  Created by KCU on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MKStoreManager.h"
#import "AppSpecificValues.h"
#import "AdsManager.h"
#import "QuickGame.h"
#import "ResourceManager.h"
#import "CrashDetectUtils.h"
#import "GameLogic.h"
#import "BackgroundManager.h"
#import "ConfirmDialog.h"
#import "GameOverDialog.h"
#import "ScoreManager.h"
#import "SoundManager.h"
#import "AppSettings.h"
//#import "../InApp/MKStoreManager.h"
#import "towerGameAppDelegate.h"
#import "BsButton.h"

#define kTagMusicSlider 100
#define kTagSFXSlider	101
#define __CLIPPING_SLIDERBAR   // Use clipping sliderbar
#define __TOUCH_END_SLIDERBAR  // Use touch end callback sliderbar
#define MAX_LIFE	3
#define MAX_TIME	46*1000
#define SCORE_PERFECT	5
#define SCORE_NORMAL	2
#define SCORE_FALL		-10

@implementation QuickGame
@synthesize m_nGameType;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	QuickGame *layer = [QuickGame node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) dealloc
{
    //[self removeAllChildrenWithCleanup:YES];
	[super dealloc];
	[mLabel release];
	[mSmallLabel release];
}

// on "init" you need to initialize your instance
-(id) init
{
    towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (mainDelegate.m_showhint == 1) {
        mainDelegate.m_showhint = 2;
    }
    
    
    //if([MKStoreManager featureAPurchased] == NO)
      //  m_maxTime = 20*1000;
    //else
        m_maxTime = 46*1000;
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) 
	{
		ccColor4B shadowColor = ccc4(0, 0, 255, 255);
		ccColor4B fillColor = ccc4(255, 255, 255,255);
		
		mLabel = [[CCLabelFX labelWithString:@"test" 
										dimensions:CGSizeMake(200, 30) 
										 alignment:CCTextAlignmentCenter
										  fontName:@"Arial" 
										  fontSize:20
									  shadowOffset:CGSizeMake(0,0) 
										shadowBlur:3.0f 
									   shadowColor:shadowColor 
										 fillColor:fillColor] retain];
		
		mLabel.position = ccp(100, 100);

		mSmallLabel = [[CCLabelFX labelWithString:@"test" 
								  dimensions:CGSizeMake(100, 30) 
								   alignment:CCTextAlignmentCenter
									fontName:@"Arial" 
									fontSize:15
								shadowOffset:CGSizeMake(0,0) 
								  shadowBlur:3.0f 
								 shadowColor:shadowColor 
								   fillColor:fillColor] retain];
		
		self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
		
		mApartment = [[NSMutableArray arrayWithCapacity: 10] retain];
		mHouse = [[House alloc] init];
		mHouse.m_houseType = HOUSETYPE_FA;
		mfAnimateBaseY = 0;
		[GameLogic setBaseLineY: 0];
		
		mPauseDialog = DIALOG_NONE;
		CCButton* btnClose = [[CCButton alloc] initWithTarget:self 
													 selector: @selector(actionPause:) 
												  textureName: @"pause" 
											   selTextureName: @"pause1"
														text : @""
											position:CGPointMake(260, 20)];
		mbtnPause = btnClose;
		[self addChild: btnClose];
		
		CC3PartButton* btnResume = [[CC3PartButton alloc] initWithTarget:self 
																selector: @selector(resumeGame:) 
															 textureName: @"option_btn_resume" 
														  selTextureName: @"option_btn_resume1"
																	text: @""
																position: CGPointMake(80, 220+60)];
		[self addChild: btnResume];
		btnResume.visible = NO;
		mbtnResume = btnResume;

		CC3PartButton* btnMenu = [[CC3PartButton alloc] initWithTarget:self 
																selector: @selector(confirmExitGame:) 
															 textureName: @"option_btn_menu" 
														  selTextureName: @"option_btn_menu1"
																	text: @""
																position: CGPointMake(80, 270+60)];
		[self addChild: btnMenu];
		btnMenu.visible = NO;
		mbtnMenu = btnMenu;
		
		[self createMusicSlider];
		[self createSFXSlider];
		mSwingTimer.SetTimer(TIMER0, 30, YES);
		m_nLifeCount = MAX_LIFE;
		m_lScore = 0;
		m_lStartTime = [self GetCurrentTime];
		[self createScoreInput];
        
        [self createAd];
        [self initPopupCounters];
	}
	
	return self;
}

- (void) createScoreInput
{
	changePlayerAlert = [UIAlertView new];
	changePlayerAlert.title = @"Enter your name";
	changePlayerAlert.message = @"\n\n";
	changePlayerAlert.delegate = self;
	[changePlayerAlert addButtonWithTitle:@"Save"];
	[changePlayerAlert addButtonWithTitle:@"Cancel"];
	
	CGRect frame = changePlayerAlert.frame;
	frame.origin.y -= 100.0f;
	changePlayerAlert.frame = frame;
	
	changePlayerTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, 245, 27)];
	
	changePlayerTextField.borderStyle = UITextBorderStyleRoundedRect;
	[changePlayerAlert addSubview:changePlayerTextField];
	//	changePlayerTextField.placeholder = @"Enter your name";
	//changePlayerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	changePlayerTextField.keyboardType = UIKeyboardTypeNamePhonePad;
	changePlayerTextField.returnKeyType = UIReturnKeyDone;
	changePlayerTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	changePlayerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	changePlayerTextField.delegate = self;
}

- (void) submitMyScore
{
	[changePlayerAlert show];
	[changePlayerTextField becomeFirstResponder];
}

- (void) changePlayerDone 
{
	NSString* currentPlayer = [changePlayerTextField.text retain];
	if (currentPlayer == nil || [currentPlayer length] == 0)
	{
		currentPlayer = @"NoName";
	}
	else
	{	
		if ([currentPlayer length] > 10)
		{
			currentPlayer = [currentPlayer substringToIndex: 10];
		}
	}
	
	if (m_nGameType == GAMETYPE_SCOREATTACK)
	{
		[[ScoreManager sharedScoreManager] submitScore: currentPlayer score: m_lScore];	
	}
	else
	{		
		int floor = [mApartment count] - m_nFallFloorCount;
		if (m_nGameType == GAMETYPE_QUICK)
		{
			[[ScoreManager sharedScoreManager] submitQuickScore: currentPlayer score: floor];	
		}
		else
		{
			[[ScoreManager sharedScoreManager] submitTimeScore: currentPlayer score: floor];	
		}
	}
	
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(buttonIndex == 0 && alertView.tag != 10) 
	{
		[self changePlayerDone];
	}
    
    if (buttonIndex == 1 && alertView.tag == 10)
	{// rate app
        
        [self buyFullApp];
        
	}
    if (buttonIndex == 0 && alertView.tag == 10)
	{// rate app
        
        //[self buyFullApp];
        
	}
    
    if (buttonIndex == 1 && alertView.tag == 20)
	{// rate app
        
        [self rateApp];
        
	}
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField 
{
	[changePlayerAlert dismissWithClickedButtonIndex:0 animated:YES];
	[self changePlayerDone];
	return YES;
}

#pragma mark MusicSlider
- (void) musicSliderMessage : (id)sender {
	
	CCSliderThumb *thumb = (CCSliderThumb *)sender;
	CCLOG(@"%f" , thumb.value );
	[[SoundManager sharedSoundManager] setBackgroundVolume: thumb.value];
    CCNode *node = [self getChildByTag:kTagMusicSlider];
    CCSlider *slider = (CCSlider *)node;
    
#if defined (__CLIPPING_SLIDERBAR)
    [slider clippingBar:CGSizeMake(thumb.value * slider.barImage.contentSize.width,
                                   slider.barImage.contentSize.height)];
#endif
}

- (void) musicSliderTouchEnd {
    
    CCLOG(@"sliderTouchEnd");
	float fVolume = [[SoundManager sharedSoundManager] backgroundVolume];
	[AppSettings setBackgroundVolume: fVolume];
}

- (void) createMusicSlider
{
	CCSlider *slider = [CCSlider sliderWithTarget:self selector:@selector(musicSliderMessage:)];
	slider.position = ccp( 160-2, 272 );
	slider.liveDragging = YES;
	
	// You can use custom image
	/* --- This is sample code --- */
	slider.thumb.selectedImage = [CCSprite spriteWithFile:@"slider_red_catch1.png"];
	slider.thumb.normalImage   = [CCSprite spriteWithFile:@"slider_red_catch.png"];
	slider.thumb.contentSize   = slider.thumb.selectedImage.contentSize;
	slider.thumb.contentSizeInPixels = slider.thumb.selectedImage.contentSizeInPixels;
	slider.barImage = [CCSprite spriteWithFile:@"slider_red_bar.png"];
	/* --- This is sample code --- */
	
	[self addChild:slider];
	slider.tag = kTagMusicSlider;
	slider.value = [AppSettings backgroundVolume];
	[self musicSliderMessage: slider];
	slider.visible = NO;
	
	// If you use setTouchEndSelector method, 
	// you can call specific selector when 
	// you release your finger from the slider.
#if defined (__TOUCH_END_SLIDERBAR)        
	[slider setTouchEndSelector:@selector(musicSliderTouchEnd)];
#endif
}

#pragma mark MusicSlider
- (void) sfxSliderMessage : (id)sender {
	
	CCSliderThumb *thumb = (CCSliderThumb *)sender;
	CCLOG(@"%f" , thumb.value );
	[[SoundManager sharedSoundManager] setEffectVolume: thumb.value];

    CCNode *node = [self getChildByTag:kTagSFXSlider];
    CCSlider *slider = (CCSlider *)node;
    
#if defined (__CLIPPING_SLIDERBAR)
    [slider clippingBar:CGSizeMake(thumb.value * slider.barImage.contentSize.width,
                                   slider.barImage.contentSize.height)];
#endif
}

- (void) sfxSliderTouchEnd {
    
    CCLOG(@"sliderTouchEnd");
	float fVolume = [[SoundManager sharedSoundManager] effectVolume];
	[AppSettings setEffectVolume: fVolume];
}

- (void) createSFXSlider
{
	CCSlider *slider = [CCSlider sliderWithTarget:self selector:@selector(sfxSliderMessage:)];
	slider.position = ccp( 160-2, 222 );
	slider.liveDragging = YES;
	
	// You can use custom image
	/* --- This is sample code --- */
	slider.thumb.selectedImage = [CCSprite spriteWithFile:@"slider_blue_catch1.png"];
	slider.thumb.normalImage   = [CCSprite spriteWithFile:@"slider_blue_catch.png"];
	slider.thumb.contentSize   = slider.thumb.selectedImage.contentSize;
	slider.thumb.contentSizeInPixels = slider.thumb.selectedImage.contentSizeInPixels;
	slider.barImage = [CCSprite spriteWithFile:@"slider_blue_bar.png"];
	/* --- This is sample code --- */
	
	[self addChild:slider];
	slider.tag = kTagSFXSlider;
	[slider setValue: [AppSettings effectVolume]];
	[self sfxSliderMessage: slider];	
	slider.visible = NO;
	
	// If you use setTouchEndSelector method, 
	// you can call specific selector when 
	// you release your finger from the slider.
#if defined (__TOUCH_END_SLIDERBAR)        
	[slider setTouchEndSelector:@selector(sfxSliderTouchEnd)];
#endif
}

- (void) resumeGame: (id) sender
{
	m_lStartTime = [self GetCurrentTime] - m_lPastTime;
	mPauseDialog = DIALOG_NONE;	
	mbtnPause.visible = YES;
	mbtnResume.visible = NO;
	mbtnMenu.visible = NO;
	
	CCNode *node = [self getChildByTag:kTagSFXSlider];	
	node.visible = NO;
	node = [self getChildByTag:kTagMusicSlider];	
	node.visible = NO;
}

- (unsigned long) GetCurrentTime
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	unsigned long ms = tv.tv_sec * 1000L + tv.tv_usec / 1000L;
	return ms;
}

- (void) confirmExitGame:(id) sender
{
	ConfirmDialog *dialog = [[ConfirmDialog alloc] init];
	[self addChild: dialog];
}

- (void) actionPause: (id) sender
{
	mPauseDialog = DIALOG_PAUSE;
	mbtnPause.visible = NO;
	mbtnResume.visible = YES;
	mbtnMenu.visible = YES;

	CCNode *node = [self getChildByTag:kTagSFXSlider];	
	node.visible = YES;
	node = [self getChildByTag:kTagMusicSlider];	
	node.visible = YES;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (mPauseDialog != DIALOG_NONE)
		return;
	
	UITouch *touch = [touches anyObject];
	if ([touch tapCount] > 1)
		return;

	if (mHouse.hidden == YES)
		return;
    
    //if([MKStoreManager featureAPurchased] == NO)
    //    return;
	[mHouse setFocus: YES];
	[mHouse fallHouse: YES];
	
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (mPauseDialog != DIALOG_NONE)
		return;

	UITouch *touch = [touches anyObject];
	if ([touch tapCount] > 1)
		return;
	[mHouse setFocus: NO];
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (mPauseDialog != DIALOG_NONE)
		return;

	UITouch *touch = [touches anyObject];
	if ([touch tapCount] > 1)
		return;
	[mHouse setFocus: NO];
}

- (CGPoint) calcLB: (CGPoint) ptLB sprite:(CCSprite*) sprite
{
	CGSize size = [sprite contentSize];
	ptLB.x += size.width/2.0f;
	ptLB.y += size.height/2.0f;
	return ptLB;
}

- (void) drawSprite: (NSString*) strSprite position: (CGPoint) position
{
	ResourceManager* resManager = [ResourceManager sharedResourceManager];
	CCSprite* sprite = [resManager getTextureWithName: strSprite];
	[sprite setPosition: [self calcLB:position sprite: sprite]];
	[sprite visit];	
}

- (void) drawScaleXSprite: (NSString*) strSprite position: (CGPoint) position fScale: (float) fScale
{
	ResourceManager* resManager = [ResourceManager sharedResourceManager];
	CCSprite* sprite = [resManager getTextureWithName: strSprite];
	[sprite setScaleX: fScale];
	[sprite setPosition: [self calcLB:position sprite: sprite]];
	[sprite visit];	
}

- (void) drawSpriteToCenter: (NSString*) strSprite position: (CGPoint) position
{
	ResourceManager* resManager = [ResourceManager sharedResourceManager];
	CCSprite* sprite = [resManager getTextureWithName: strSprite];
	[sprite setPosition: position];
	[sprite visit];	
}

- (CGSize) calcSpriteSize: (NSString*) strSprite
{
	ResourceManager* resManager = [ResourceManager sharedResourceManager];
	CCSprite* sprite = [resManager getTextureWithName: strSprite];
	return [sprite contentSize];
}

- (void) drawRope
{
	static float fAlpha = 0.0;
	if (mSwingTimer.CallTimerFunc())
		fAlpha += 0.10f;
	
	float x = 160;
	float y = 100;
	
	float fBaseY = 300;
	if ([mApartment count] == 1)
	{
		fBaseY = 370;
	}
	else if ([mApartment count] == 2)
	{
		fBaseY = 420;	
	}
	else if ([mApartment count] >= 3)
	{
		fBaseY = 440;
	}
		
	x = 160+cos(fAlpha) * 50;
	y = fBaseY + sin(fAlpha)*20;
	[mHouse draw:x y:y fAlpha:fAlpha];

	glLineWidth(1);
	glColor4ub(0xBF, 0x8F, 0x80, 0xFF);	
	ccDrawLine(ccp(x-1, y), ccp(160-2, 600));

	glLineWidth(2);
	glColor4ub(0x80, 0x50, 0x20,0xFF);	
	ccDrawLine(ccp(x, y), ccp(160, 600));
	
	glLineWidth(1);
	glColor4ub(0xBF, 0x8F, 0x80, 0xFF);	
	ccDrawLine(ccp(x+1, y), ccp(160+2, 600));
	
	glLineWidth(1);
	glColor4ub(0xFF, 0xFF, 0xFF, 0xFF);	

	[self drawSpriteToCenter: @"b16" position: ccp(x, y)];
	
	if ([mHouse m_bFall] == YES || mHouse.hidden)
		[self drawSpriteToCenter: @"b74" position: ccp(x+1, y-18)];
	
	//Shader Draw
	if ([mApartment count] == 0)
		[self drawSpriteToCenter: @"c25" position: ccp(x, 480-430)];
	
}

- (void) drawApartment
{
	int nCount = [mApartment count];
	
	for (int i = 0; i < nCount; i ++)
	{
		House* house = [mApartment objectAtIndex: i];
		if ([house visibleInViewport])
			[house drawFloor: i];
	}
}

- (void) drawStatus
{
	[self drawSprite: @"c16" position: CGPointMake(4, 430)];

	[mLabel setString: [NSString stringWithFormat: @"%d", [mApartment count]]];
	[mLabel setPosition:ccp(35, 442)];
	[mLabel visit];

	if (m_nGameType == GAMETYPE_TIMEATTACK)
		return;
	
	float fOffsetY = 410;
	float fDiff = 20;
	for (int i = 0; i < m_nLifeCount; i ++)
	{
		[self drawSprite: @"b80" position: CGPointMake(28, fOffsetY-fDiff*i)];
	}
}

- (void) setSwingWidth
{
	NSInteger count = [mApartment count];
	float fSwingWidth = 0;
	
	//fSwingWidth = 30*sin(count);
	for (int i = 1; i < count; i ++)
	{
		House* house = [mApartment objectAtIndex: i];
		[house setSwingData: fSwingWidth fAngle:0];
	}
}

- (BOOL) addFloor: (int) nFloor fLapWidth: (float) fLapWidth
{
	House *house = [[[House alloc] init] autorelease];
	house.m_fX = mHouse.m_fX;
	house.m_fY = 60 + 58*nFloor;
	house.m_bFall = YES;
	house.m_houseType = mHouse.m_houseType;
	house.m_fFallAngle = fLapWidth/4.0f;
	
	House* lastHouse = [mApartment lastObject];
	[mApartment addObject: house];
	[self setSwingWidth];

	NSLog(@"fLapWidth = %f", fLapWidth);
	m_nFallFloorCount = 0;
	if (fabs(fLapWidth) < 15.0f)
	{
		BOOL bEffect = NO;
		if ([mApartment count] > 1 && fabs(fLapWidth) < 5)
		{
			bEffect = YES;
			[[SoundManager sharedSoundManager] playEffect: kEPerfect bForce: YES];
            
            //if([MKStoreManager featureAPurchased] == YES)
                m_lStartTime += 2000;
		}
		else
		{
			[[SoundManager sharedSoundManager] playEffect: kENormal bForce: YES];
		}
		[house startCrashAnimation: fLapWidth/4.0f bEffect: bEffect];
		if (bEffect)
			m_lScore += SCORE_PERFECT;
		else
			m_lScore += SCORE_NORMAL;
	}
	else
	{
		[[SoundManager sharedSoundManager] playEffect: kECrash bForce: YES];

		if ([mApartment count] > 2)
		{
			[lastHouse startDestroyAnimation2];
			m_nFallFloorCount ++;

			BOOL bInc = NO;
			for (unsigned int i = nFloor; i < [mApartment count]-2; i ++)
			{
				House* removeHouse = [mApartment objectAtIndex: i];
				[removeHouse startDestroyAnimation2];
				m_nFallFloorCount ++;
				bInc = YES;
			}
			
//			if (bInc)
//			{
//				if (m_nFallFloorCount >= 2)
//					m_nFallFloorCount --;
//				else
//					m_nFallFloorCount = m_nFallFloorCount - 2;
//			}
		}
		[house startDestroyAnimation: fLapWidth/4.0f];
		m_nFallFloorCount ++;
		m_lScore += SCORE_FALL;
		if (m_lScore < 0)
			m_lScore = 0;
		return NO;
	}
	
	return YES;
}

- (void) removeDestroyedFloor
{
	for (unsigned int i = 0; i < [mApartment count]; i ++)
	{
		House* house = [mApartment objectAtIndex: i];
		if ([house canDestroyFloor])
		{
			[mApartment removeObjectAtIndex: i];
			mHouse.hidden = NO;
			i = 0;
		}
	}
}

- (void) procGameOver
{
    
    [self shouldReviewApp];
	mPauseDialog = DIALOG_OVER;
	mfAnimateBaseY = 0;
	mbtnPause.visible = NO;
	GameOverDialog* dialog = [[GameOverDialog alloc] init];
	[dialog setTarget: self selector: @selector(actionGameAgain:)];	
	if (m_nGameType == GAMETYPE_SCOREATTACK)
	{
		dialog.m_bScoreAttack = YES;
		dialog.m_nFloor = m_lScore;
		
		if ([[ScoreManager sharedScoreManager] isTop5ForScore:m_lScore])				
			[self submitMyScore];
	}
	else
	{
		dialog.m_bScoreAttack = NO;
		dialog.m_nFloor = [mApartment count] - m_nFallFloorCount;

		if ([[ScoreManager sharedScoreManager] isTop5ForScore:[mApartment count] - m_nFallFloorCount])				
			[self submitMyScore];
	}
	
	[self addChild: dialog];
}

- (void) actionGameAgain: (id) sender
{
	mfAnimateBaseY = 0;
	[GameLogic setBaseLineY: 0];
	mPauseDialog = DIALOG_NONE;
	mbtnPause.visible = YES;
	m_nLifeCount = MAX_LIFE;
	[mApartment removeAllObjects];
	
	m_lPastTime = 0;
	m_lStartTime = [self GetCurrentTime];
	m_lScore = 0;
}

- (void) crashDetect
{
	if (mPauseDialog != DIALOG_NONE)
		return;
	
	if (m_nGameType == GAMETYPE_TIMEATTACK)
	{
		m_lPastTime = ([self GetCurrentTime] - m_lStartTime);
		if ((m_maxTime-m_lPastTime) <= 0)
			[self procGameOver];
	}
	
	if ([mHouse m_bFall] == NO)
		return;
	
	int nCount = [mApartment count];
	if (nCount <= 0)
	{
		if ([mHouse m_fY] <= 60)
		{
			[self addFloor: 0 fLapWidth: 0];
			[mHouse fallHouse: NO];
			mHouse.m_houseType = HOUSETYPE_ONE;
		}
		
		return;			
	}
	
	for (int i = 0; i < nCount; i ++)
	{
		House* house = [mApartment objectAtIndex: nCount-i-1];
		CGRect rtTopHouse = [house getAbsoluteFrame];
		CGRect rtNewHouse = [mHouse getFrame];
		float fLapWidth = 0;
		fLapWidth = CrashDetectUtils::CalcLapRectAndRect(rtNewHouse, rtTopHouse);
		if (fLapWidth != 1000)
		{
			NSLog(@"lap = %f", fLapWidth);
			BOOL bSuccess = [self addFloor: nCount-i fLapWidth: fLapWidth];
			[mHouse fallHouse: NO];	
			mHouse.m_houseType = HOUSETYPE_ONE;
		
			if (bSuccess == YES)	//If success adding Floor.
			{			
				if (nCount > 1)
					mfAnimateBaseY -= 58;
				if (((nCount+1)%10) == 0)
					mHouse.m_houseType = HOUSETYPE_VE;
                if (nCount <= 125)
                    mSwingTimer.SetInterval(30-nCount/5);
			}
			else	//If failed add floor.
			{
				if (nCount > 1 && [GameLogic getBaseLineY] < 0)
					mfAnimateBaseY += 58*(m_nFallFloorCount-1);
				mHouse.hidden = YES;

				if (m_nGameType != GAMETYPE_TIMEATTACK)
				{
					m_nLifeCount --;
					if (m_nLifeCount < 1)
					{
						m_nLifeCount = 0;
						[self procGameOver];
					}
				}
			}
			return;
		}
	}
	
	if (mHouse.m_fY < 50)
	{
		[mHouse fallHouse: NO];
		mHouse.m_houseType = HOUSETYPE_ONE;
		if (m_nGameType != GAMETYPE_TIMEATTACK)
		{
			m_nLifeCount --;
			if (m_nLifeCount < 1)
			{
				m_nLifeCount = 0;
				[self procGameOver];
			}
		}
	}
}

- (void) drawPauseMenu
{
	if (mPauseDialog != DIALOG_PAUSE)
		return;
	
	glColor4ub(0x0, 0x0, 0x0, 255);
	ccDrawFilledRect(CGPointMake(0, 0), CGPointMake(320, 480));

	ResourceManager* resManager = [ResourceManager sharedResourceManager];
	CCSprite* sprite = [resManager getTextureWithName: @"back"];
	[sprite setOpacity: 50];
	[sprite setPosition: ccp(160, 240)];
	[sprite visit];	
	
	[self drawSprite: @"text_pause" position: ccp(80, 320)];
	[self drawSprite: @"option_back" position: ccp(30, 90)];
	
	//slider background
	[self drawSprite: @"slider_back" position: ccp(48, 267)];
	[self drawSprite: @"slider_back" position: ccp(48, 217)];
	
	[self drawSprite: @"text_music" position: ccp(130, 285)];
	[self drawSprite: @"text_sound" position: ccp(130, 240)];
}

static NSString* rNumImage[10] = {
	@"brnum0",
	@"brnum1",
	@"brnum2",
	@"brnum3",
	@"brnum4",
	@"brnum5",
	@"brnum6",
	@"brnum7",
	@"brnum8",
	@"brnum9",
};


- (void) drawTime
{
	if (m_nGameType != GAMETYPE_TIMEATTACK)
		return;
	float fBaseX = 120;
	long lRemain = m_maxTime-m_lPastTime;
	if (lRemain < 0)
		lRemain = 0;
	
	int nTime = (int)(lRemain / 10000);
	ResourceManager* resManager = [ResourceManager sharedResourceManager];
	CCSprite* sprite = [resManager getTextureWithName: rNumImage[nTime]];
	[sprite setPosition: ccp(fBaseX, 430)];
	[sprite visit];

	nTime = (lRemain / 1000) % 10;
	sprite = [resManager getTextureWithName: rNumImage[nTime]];
	[sprite setPosition: ccp(fBaseX+20, 430)];
	[sprite visit];

	sprite = [resManager getTextureWithName: @"bcomma"];
	[sprite setPosition: ccp(fBaseX+40, 430)];
	[sprite visit];
	
	nTime = (lRemain / 100) % 10;
	sprite = [resManager getTextureWithName: rNumImage[nTime]];
	[sprite setPosition: ccp(fBaseX+60, 430)];
	[sprite visit];

	nTime = (lRemain / 10) % 10;
	sprite = [resManager getTextureWithName: rNumImage[nTime]];
	[sprite setPosition: ccp(fBaseX+80, 430)];
	[sprite visit];
}

- (void) drawScore
{
	if (m_nGameType != GAMETYPE_SCOREATTACK)
		return;

	float fBaseX = 110;
	long lScore = m_lScore;
	if (lScore < 0)
		lScore = 0;
	
	int nScore = (int)(lScore / 100000);
	ResourceManager* resManager = [ResourceManager sharedResourceManager];
	CCSprite* sprite = [resManager getTextureWithName: rNumImage[nScore]];
	[sprite setPosition: ccp(fBaseX, 430)];
	[sprite visit];
	
	nScore = (lScore / 10000) % 10;
	sprite = [resManager getTextureWithName: rNumImage[nScore]];
	[sprite setPosition: ccp(fBaseX+20, 430)];
	[sprite visit];
	
	nScore = (lScore / 1000) % 10;
	sprite = [resManager getTextureWithName: rNumImage[nScore]];
	[sprite setPosition: ccp(fBaseX+40, 430)];
	[sprite visit];
	
	nScore = (lScore / 100) % 10;
	sprite = [resManager getTextureWithName: rNumImage[nScore]];
	[sprite setPosition: ccp(fBaseX+60, 430)];
	[sprite visit];

	nScore = (lScore / 10) % 10;
	sprite = [resManager getTextureWithName: rNumImage[nScore]];
	[sprite setPosition: ccp(fBaseX+80, 430)];
	[sprite visit];

	nScore = lScore % 10;
	sprite = [resManager getTextureWithName: rNumImage[nScore]];
	[sprite setPosition: ccp(fBaseX+100, 430)];
	[sprite visit];
}

- (void) draw
{	
	[[GameLogic sharedGameLogic] draw];
	[self drawStatus];
	[self drawRope];
	[self drawApartment];
	[self drawTime];
	[self drawScore];
	[self crashDetect];
	[self removeDestroyedFloor];
	[self drawPauseMenu];

	float fBaseY = [GameLogic getBaseLineY];
	if (mfAnimateBaseY >= 0)
		mfAnimateBaseY = 0;
	if (mfAnimateBaseY > fBaseY)
	{
		fBaseY += 2;
	}
	else if (mfAnimateBaseY < fBaseY)
	{
		fBaseY -= 2;
	}
	
	[GameLogic setBaseLineY: fBaseY];
}


////Init Counts for iap and rate popups
//-(void) initPopupCounters {
//    towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
//    [[AdsManager  sharedAdsManager] newAd:ccp(0, 0)];
//    
//    //...
//    // Show the ad
//    [[AdsManager sharedAdsManager] hideAd ];
//    m_btnMenuAd.visible = NO;
//#ifdef FreeApp
//	//if(mainDelegate.m_no_ads = YES;) {
//    if([MKStoreManager isFeaturePurchased: featureAIdVar] == NO) {    
//        
//        
//        mainDelegate.m_no_ads = YES;
//        // Create ad but don't show it yet
//        //[[AdsManager sharedAdsManager] startMobclix]; 
//        
//        [[AdsManager sharedAdsManager] showAd];
//        
//        
//        CCSprite* sprite1 = [[CCSprite spriteWithFile:SHImageString(@"x_no", @"png")] retain];
//        
//        
//        m_btnMenuAd = [[BsButton buttonWithImage:SHImageString(@"x_no", @"png")  
//                                        selected:SHImageString(@"x_on", @"png") 
//                                          target:self
//                                        selector:@selector(showIAPNOADS:)] retain];
//        [m_btnMenuAd setPosition:ccp( SCREEN_WIDTH-sprite1.contentSize.width ,sprite1.contentSize.height *2.2)];
//        // [m_btnMenuAd setPosition:ccp(sprite.contentSize.width/2+10*SCALE_SCREEN_WIDTH, SCREEN_HEIGHT - sprite.contentSize.height/2-10*SCALE_SCREEN_HEIGHT)];
//        [self addChild: m_btnMenuAd];
//        [sprite1 release];
//        //[self initPopupCounters];
//        [[AdsManager sharedAdsManager] showAd ];
//        
//    }
//#endif
//     
//}

- (void) showIAPNOADS :(id)sender {
	//if([MKStoreManager isFeaturePurchased: featureAIdVar] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Do you want to upgrade to the full version of the app with no banner adds?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = 10;
        [alert show];
        [alert release];
    //} 
}



//Rate Apps redirection
- (void) buyFullApp {
    //towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
    //mainDelegate.m_rateapp = NO;
#ifdef FreeApp
    //NSString *str = buyFullAppURL;
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    [[MKStoreManager sharedManager] buyFeature: featureAIdVar
                                    onComplete:^(NSString* purchasedFeature)
     {
         
         towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
         
         mainDelegate.m_no_ads = NO;
         [self initPopupCounters];
         
         NSLog(@"Purchased: %@", purchasedFeature);
         
         //[self actionResume];
         //[m_spFire setVisible:NO];
         //[self gotoGameOverView];
         
         
         
         
         // remembering this purchase is taken care of by MKStoreKit.
     }
                                   onCancelled:^
     {
         NSLog(@"Something went wrong");
         // User cancels the transaction, you can log this using any analytics software like Flurry.
     }];  

    
    
#endif
    
}

//Rate Apps redirection
- (void) rateApp {
    towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
    mainDelegate.m_rateapp = NO;
    
    NSString *str = rateURL;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    
}

- (void) actionRateApp
{
    towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if(mainDelegate.m_rateapp == YES) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please review this great app! " delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = 20;
        [alert show];
        [alert release];
    } 
}

-(void) shouldReviewApp{
    towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if(mainDelegate.m_popup_rate_count >= 3 && mainDelegate.m_rateapp == YES) {
        [self actionRateApp];
        mainDelegate.m_popup_rate_count = 0;
        //[self initPopupCounters] ;
    }
    mainDelegate.m_popup_rate_count ++;
}

- (void) createAd {
    
    [[AdsManager  sharedAdsManager] newAd:ccp(0, 0)];
    CCSprite* sprite1 = [[CCSprite spriteWithFile:SHImageString(@"x_no")] retain];
    m_btnMenuAd = [[BsButton buttonWithImage:SHImageString(@"x_no")  
                                    selected:SHImageString(@"x_on") 
                                      target:self
                                    selector:@selector(showIAPNOADS:)] retain];
    [m_btnMenuAd setPosition:ccp( SCREEN_WIDTH-sprite1.contentSize.width ,sprite1.contentSize.height *2.2)];

    // [m_btnMenuAd setPosition:ccp(sprite.contentSize.width/2+10*SCALE_SCREEN_WIDTH, SCREEN_HEIGHT - sprite.contentSize.height/2-10*SCALE_SCREEN_HEIGHT)];
    [self addChild: m_btnMenuAd];
    [sprite1 release];
    
    //...
    // Show the ad
    [[AdsManager sharedAdsManager] hideAd ];
    m_btnMenuAd.visible = NO;
}

//Init Counts for iap and rate popups
-(void) initPopupCounters {
    
    //...
    // Show the ad
    [[AdsManager sharedAdsManager] hideAd ];
    m_btnMenuAd.visible = FALSE;
#ifdef FreeApp
    if([MKStoreManager isFeaturePurchased: featureAIdVar] == NO ) {
        
        towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        mainDelegate.m_no_ads = YES;
        // Create ad but don't show it yet
        //[[AdsManager sharedAdsManager] startMobclix]; 
        
        [[AdsManager sharedAdsManager] showAd];
        
        m_btnMenuAd.visible = TRUE;
        
    }
#endif
    
    
    
    
}

@end
