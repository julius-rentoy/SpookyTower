//
//  SettingScene.mm
//  towerGame
//
//  Created by KCU on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingScene.h"
#import "TitleScene.h"
#import "BackgroundManager.h"
#import "CCSlider.h"
#import "CC3PartButton.h"
#import "SoundManager.h"
#import "AppSettings.h"
#import "ScoreManager.h"
#import "GameConfig.h"
#define kTagMusicSlider 100
#define kTagSFXSlider	101
#define __CLIPPING_SLIDERBAR   // Use clipping sliderbar
#define __TOUCH_END_SLIDERBAR  // Use touch end callback sliderbar


@implementation SettingScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SettingScene *layer = [SettingScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
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
		
		CC3PartButton* btnReset = [[CC3PartButton alloc] initWithTarget:self 
                                                               selector: @selector(resetGame:) 
                                                            textureName: @"option_btn_reset" 
                                                         selTextureName: @"option_btn_reset1"
                                                                   text: @""
                                                               position: CGPointMake(SCREEN_WIDTH/4, ipy(390))];
        
    
        
		//[self addChild: btnReset];
		
		CC3PartButton* btnMenu = [[CC3PartButton alloc] initWithTarget:self 
															  selector: @selector(actionMenu:) 
														   textureName: @"option_btn_menu" 
														selTextureName: @"option_btn_menu1"
																  text: @""
															  position: CGPointMake(ipx(125), ipy(420))];
		[self addChild: btnMenu];
		
		[self createSFXSlider];
		[self createMusicSlider];
	}
	return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex == 0)
		[[ScoreManager sharedScoreManager] resetScore];
}


- (void) resetGame: (id) sender
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:@"Are you reset game?"
												   delegate:self
										  cancelButtonTitle:@"Yes"
										  otherButtonTitles: @"No", nil];
	[alert show];	
	[alert release];
}

- (void) actionMenu: (id) sender
{
	CCScene* titleScene = [TitleScene node];
	[[CCDirector sharedDirector] replaceScene:titleScene];	
}

#pragma mark MusicSlider
- (void) musicSliderMessage : (id)sender {
	
	CCSliderThumb *thumb = (CCSliderThumb *)sender;
	CCLOG(@"%f" , thumb.value );
	[[SoundManager sharedSoundManager] setBackgroundVolume: thumb.value];
    
    CCNode *node = [self getChildByTag:kTagMusicSlider];
    CCSlider *slider = (CCSlider *)node;
    
#if defined (__CLIPPING_SLIDERBAR)
    
    float slideMultiplier   =   kIsDeviceIPAD ? 1.0f : CC_CONTENT_SCALE_FACTOR();
    [slider clippingBar:CGSizeMake(thumb.value * slider.barImage.contentSize.width,
                                   slider.barImage.contentSize.height * slideMultiplier)];
#endif
}

- (void) musicSliderTouchEnd {
    
	float fVolume = [[SoundManager sharedSoundManager] backgroundVolume];
	[AppSettings setBackgroundVolume: fVolume];
    CCLOG(@"sliderTouchEnd");
}

- (void) createMusicSlider
{
    float slideMultiplier   =   kIsDeviceIPAD ? 1.0f : CC_CONTENT_SCALE_FACTOR();
	CCSlider *slider = [CCSlider sliderWithTarget:self selector:@selector(musicSliderMessage:)];
	slider.position = ccp( SCREEN_WIDTH *2/ 4, ipy(246) );
	slider.liveDragging = YES;
	
	// You can use custom image
	/* --- This is sample code --- */
	slider.thumb.selectedImage = [CCSprite spriteWithFile:SHImageString(@"slider_red_catch1")];
	slider.thumb.normalImage   = [CCSprite spriteWithFile:SHImageString(@"slider_red_catch")];
	slider.thumb.contentSize   = slider.thumb.selectedImage.contentSize;
	slider.thumb.contentSizeInPixels =  slider.thumb.selectedImage.contentSizeInPixels;
    //;
    
	slider.barImage = [CCSprite spriteWithFile:SHImageString(@"slider_red_bar")];
	/* --- This is sample code --- */
	
	[self addChild:slider];
	slider.tag = kTagMusicSlider;
	slider.value = [AppSettings backgroundVolume];
	[self musicSliderMessage: slider];
	
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
    float slideMultiplier   =   kIsDeviceIPAD ? 1.0f : CC_CONTENT_SCALE_FACTOR();
    [slider clippingBar:CGSizeMake(thumb.value * slider.barImage.contentSize.width,
                                   slider.barImage.contentSize.height * slideMultiplier)];
#endif
}

- (void) sfxSliderTouchEnd {
    
	float fVolume = [[SoundManager sharedSoundManager] effectVolume];
	[AppSettings setEffectVolume: fVolume];
    
    CCLOG(@"sliderTouchEnd");
}

- (void) createSFXSlider
{
	CCSlider *slider = [CCSlider sliderWithTarget:self selector:@selector(sfxSliderMessage:)];
	//slider.position = ccp( ipx(160-2), ipy(222) );
    slider.position = ccp( SCREEN_WIDTH *2/ 4, ipy(146) );

	slider.liveDragging = YES;
	
	// You can use custom image
	/* --- This is sample code --- */
	slider.thumb.selectedImage = [CCSprite spriteWithFile:SHImageString(@"slider_blue_catch1")];
	slider.thumb.normalImage   = [CCSprite spriteWithFile:SHImageString(@"slider_blue_catch")];
	slider.thumb.contentSize   = slider.thumb.selectedImage.contentSize;
	slider.thumb.contentSizeInPixels = slider.thumb.selectedImage.contentSizeInPixels;
	slider.barImage = [CCSprite spriteWithFile:SHImageString(@"slider_blue_bar")];
	/* --- This is sample code --- */
	
	[self addChild:slider];
	slider.tag = kTagSFXSlider;
	[slider setValue: [AppSettings effectVolume]];
	[self sfxSliderMessage: slider];	
	
	// If you use setTouchEndSelector method, 
	// you can call specific selector when 
	// you release your finger from the slider.
#if defined (__TOUCH_END_SLIDERBAR)        
	[slider setTouchEndSelector:@selector(sfxSliderTouchEnd)];
#endif
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

- (void) drawPauseMenu
{
	[self drawSprite: @"text_setting" position: ccp(ipx(80), ipy(320))];
	//[self drawSprite: @"option_back" position: ccp(ipx(30), ipy(90))];
	
	//slider background
	[self drawSprite: @"slider_back" position: ccp(ipx(48), ipy(240))];
	[self drawSprite: @"slider_back" position: ccp(ipx(48), ipy(140))];
	
	[self drawSprite: @"text_music" position: ccp(ipx(130), ipy(285))];
	[self drawSprite: @"text_sound" position: ccp(ipx(130), ipy(240))];
	
    //	[mLabel setString: @"Settings"];
    //	[mLabel setPosition: ccp(160, 340)];
    //	[mLabel visit];
}

- (void) draw
{
    /*
	BackgroundManager* backManager = [BackgroundManager sharedBackgroundManager];
	[backManager draw];
	*/
    
    ResourceManager* resManager = [ResourceManager sharedResourceManager];
	CCSprite* sprite = [resManager getTextureWithName: @"option_back"];
	//[sprite setOpacity: 50];
	[sprite setPosition: ccp(ipx(160), ipy(240))];
	[sprite visit];	
    
	[self drawPauseMenu];
}

- (void) dealloc
{
	[super dealloc];
	[mLabel release];
	[mSmallLabel release];
}

@end
