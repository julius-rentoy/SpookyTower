//
//  ConfirmDialog.m
//  towerGame
//
//  Created by KCU on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//#import "QuickGame.h"


#import "GameOverDialog.h"
#import "ResourceManager.h"
#import "CC3PartButton.h"
#import "TitleScene.h"
#import "CCButton.h"
#import "towerGameAppDelegate.h"
#import "ReloadScene.h"
#import "GameConfig.h"
//#import "BeginScene.h"
@implementation GameOverDialog
@synthesize m_nFloor;
@synthesize m_bScoreAttack;

- (id) init
{
	if ( (self=[super init]) )
	{
        towerGameAppDelegate* del = (towerGameAppDelegate*)[UIApplication sharedApplication].delegate;
        
        prefs = [NSUserDefaults standardUserDefaults];
        if([prefs integerForKey:@"integerKey"] == 0)
        { [prefs setInteger:1 forKey:@"integerKey"]; }
        else
        { 
            int f = [prefs integerForKey:@"integerKey"] + 1;
            [prefs setInteger:f forKey:@"integerKey"];
        }
        [prefs synchronize];
    
        if([prefs integerForKey:@"integerKey"] == 3)
        { [self review]; }
        
        if([prefs floatForKey:@"floatKey"] == 0)
        { [prefs setFloat:1 forKey:@"floatKey"]; }
        else
        { 
            int f = [prefs floatForKey:@"floatKey"] + 1;
            [prefs setFloat:f forKey:@"floatKey"];
        }
        [prefs synchronize];
        
        int g = [prefs floatForKey:@"floatKey"];
        if(g%2 == 0)
        { [del gameOverRevmob]; }
        if(g%3 == 0)
        { [del gameOverChartboost]; }
        
        
		ccColor4B shadowColor = ccc4(0, 0, 255, 255);
		ccColor4B fillColor = ccc4(255, 255, 255,255);
    
        
        largeFont = [[CCLabelFX labelWithString: @"RESULTS"
										dimensions:CGSizeMake(ipx(200), ipy(50)) 
										 alignment:CCTextAlignmentCenter
										  fontName:@"Arial" 
										  fontSize:ipx(50)
									  shadowOffset:CGSizeMake(0,0) 
										shadowBlur:3.0f 
									   shadowColor:shadowColor 
										 fillColor:fillColor] retain];
        
        largeFont.position  =   ccp(ipx(166), ipy(280));
        largeFont.color =   ccWHITE;
        [self addChild:largeFont];
        
        
        
        
        
        smallFont = [[CCLabelTTF labelWithString: @"Tower Height"
												 dimensions:CGSizeMake(ipx(250), ipy(200)) 
												  alignment:CCTextAlignmentCenter
												   fontName:@"Arial" 
												   fontSize:ipx(35)] retain];
		[smallFont setColor: ccc3(0, 0, 255)];
		[smallFont setPosition: ccp(ipx(166), ipy(250))];
        smallFont.color =   ccWHITE;
        
		CC3PartButton* btnRetry = [[CC3PartButton alloc] initWithTarget:self 
																selector: @selector(againAction:) 
															 textureName: @"option_btn_playagain" 
														  selTextureName: @"option_btn_playagain1"
																	text: @""
																position: CGPointMake(ipx(168), ipy(260))];
		[self addChild: btnRetry];

		CC3PartButton* btnMenu = [[CC3PartButton alloc] initWithTarget:self 
															   selector: @selector(menuAction:) 
															textureName: @"option_btn_menu" 
														 selTextureName: @"option_btn_menu1"
																   text: @""
															   position: CGPointMake(ipx(168), ipy(290))];
        
		[self addChild: btnMenu];
        
//        if (!kIsPaidVersion) {
//            banner = [[BsButton buttonWithImage:SHImageString(@"banner")
//                                       selected:SHImageString(@"banner")
//                                         target:self
//                                       selector:@selector(bannerAction)] retain];
//            
//            [banner setPosition:ccp(ipx(252) ,ipy(50))];
//            [self addChild: banner];
//        }
        
        
        
	}
	
	return self;
}

- (void) setTarget:(id) rec selector:(SEL) cb
{
	NSMethodSignature * sig = nil;
	
	if( rec && cb ) {
		sig = [[rec class] instanceMethodSignatureForSelector:cb];
		
		invocation = nil;
		invocation = [NSInvocation invocationWithMethodSignature:sig];
		[invocation setTarget:rec];
		[invocation setSelector:cb];
#if NS_BLOCKS_AVAILABLE
		if ([sig numberOfArguments] == 3) 
#endif
			[invocation setArgument:&self atIndex:2];
		
		[invocation retain];
	}
}

- (void) againAction: (id) sender
{   //[ self dealloc];
	[self removeFromParentAndCleanup: YES];
	//[invocation invoke];
    
    //CCScene *a = [ReloadScene node];
    //[[CCDirector sharedDirector] replaceScene:[ReloadScene node]];
    //[[CCDirector sharedDirector] replaceScene:[TitleScene node]];
    //[[CCDirector sharedDirector] pushScene:[QuickGame node]];
    
    //[[CCDirector sharedDirector] replaceScene:[ReloadScene node]];
   
    CCScene* quickScene = [ReloadScene node];
	//((ReloadScene*)quickScene).gametype = 1;
	[[CCDirector sharedDirector] replaceScene:quickScene];	
   
}

- (void) menuAction: (id) sender
    {//towerGameAppDelegate *mainDelegate = (towerGameAppDelegate *)[[UIApplication sharedApplication]delegate];
         
    //mainDelegate.m_showhint = 2;
	[[CCDirector sharedDirector] replaceScene:[TitleScene node]];			
}

- (void) drawSpriteToCenter: (NSString*) strSprite position: (CGPoint) position
{
	ResourceManager* resManager = [ResourceManager sharedResourceManager];
	CCSprite* sprite = [resManager getTextureWithName: strSprite];
	[sprite setPosition: position];
	[sprite visit];	
}

- (void) draw
{
	glColor4ub(0x0, 0x0, 0x0, 255);
	ccDrawFilledRect(CGPointMake(0, 0), CGPointMake(ipx(320), ipy(480)));
	
	ResourceManager* resManager = [ResourceManager sharedResourceManager];
	CCSprite* sprite = [resManager getTextureWithName: @"back"];
	//[sprite setOpacity: 50];
	[sprite setPosition: ccp(ipx(160), ipy(240))];
	[sprite visit];	
	
	//[self drawSpriteToCenter: @"option_back" position: ccp(ipx(160), ipy(240))];
	
//	[largeFont setString: @"RESULTS"];
//	[largeFont setPosition: ccp(ipx(168), ipy(320))];
//	[largeFont visit];

	[largeFont setString: [NSString stringWithFormat: @"%d", m_nFloor]];
	//[largeFont setPosition: ccp(ipx(160), ipy(250))];
	[largeFont visit];
	
	if (m_bScoreAttack)
	{
		[smallFont setString: @"Score"];
	}
	[smallFont visit];
}

- (void) dealloc
{
	
    
    [super dealloc];
	[invocation release];
	[largeFont release];
	[smallFont release];
}

- (void) actionRateApp
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Thanks for playing Spooky Tower! Please review this great game!" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = 20;
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark - ALERTVIEW DELEGATE

- (void) review
{
    /*
    if([prefs floatForKey:@"floatKey"] != 3.0)
    { 
        [prefs setFloat:0.0 forKey:@"floatKey"];
        [prefs synchronize];
        CCLOG(@"%f",f);
    }
    */
    
    UIAlertView *alert  =   [[[UIAlertView alloc] initWithTitle:@"Spooky Tower"
                                                        message:@"Thanks for playing Spooky Tower! Please review this great game!"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil] autorelease];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [prefs setInteger:4 forKey:@"integerKey"];
        [prefs synchronize];
        
      
        NSString *urlString   =   @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APPID&onlyLatestVersion=false&type=Purple+Software";
        NSString *rateURL   =   [urlString stringByReplacingOccurrencesOfString:@"APPID" withString:kRateAppID];
        NSURL *url  =   [NSURL URLWithString:rateURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        CCLOG(@"NO!!!");
        [prefs setInteger:0 forKey:@"integerKey"];
        [prefs synchronize];
    }
}

- (void) bannerAction
{
    [(towerGameAppDelegate*)[[UIApplication sharedApplication] delegate] freeGameChartboost];
}

@end
