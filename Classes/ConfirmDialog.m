//
//  ConfirmDialog.m
//  towerGame
//
//  Created by KCU on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfirmDialog.h"
#import "ResourceManager.h"
#import "TitleScene.h"
#import "CCButton.h"
@implementation ConfirmDialog

- (id) init
{
	if ( (self=[super init]) )
	{
		CCButton* yesButton = [[CCButton alloc] initWithTarget:self		
													  selector: @selector(yesAction:)	
												   textureName: @"dialog_btn_yes"	
												selTextureName: @"dialog_btn_yes1"	
														  text: @""	
													  position: CGPointMake(ipx(70), ipy(300))];
		[self addChild: yesButton];

		CCButton* noButton = [[CCButton alloc] initWithTarget:self		
													  selector: @selector(noAction:)	
												   textureName: @"dialog_btn_no"	
												selTextureName: @"dialog_btn_no1"	
														  text: @""	
													  position: CGPointMake(ipx(190), ipy(300))];
		[self addChild: noButton];
		
		ccColor4B shadowColor = ccc4(0, 0, 255, 255);
		ccColor4B fillColor = ccc4(255, 255, 255,255);
		
        CCLabelFX* labelTitle = [CCLabelFX labelWithString: @"Please confirm"
										dimensions:CGSizeMake(ipx(200), ipy(50)) 
										 alignment:CCTextAlignmentCenter
										  fontName:@"Arial" 
										  fontSize:25
									  shadowOffset:CGSizeMake(0,0) 
										shadowBlur:3.0f 
									   shadowColor:shadowColor 
										 fillColor:fillColor];
		[labelTitle setPosition: ccp(ipx(160), ipy(340))];
		[self addChild: labelTitle];

        CCLabelTTF* labelMsg = [CCLabelTTF labelWithString: @"Do you really want to exit your\ncurrent game and return to the\n main menu?"
												 dimensions:CGSizeMake(250, 200) 
												  alignment:CCTextAlignmentCenter
												   fontName:@"Arial" 
												   fontSize:15];
		[labelMsg setColor: ccc3(255, 255, 255)];
		[labelMsg setPosition: ccp(ipx(160), ipy(180))];
        
        
//        if (CC_CONTENT_SCALE_FACTOR() == 2 &&
//            UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//            //labelMsg.pos
//        }
        
        
		[self addChild: labelMsg];		
	}
	
	return self;
}

- (void) yesAction: (id) sender
{
	[[CCDirector sharedDirector] replaceScene:[TitleScene node]];			
}

- (void) noAction: (id) sender
{
	[self removeFromParentAndCleanup: YES];
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
    
    BOOL isRetina   =   CC_CONTENT_SCALE_FACTOR()  ==  2;
    BOOL isIPHONE   =   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    float multiplier    =   (isRetina && isIPHONE) ? 2 : 1;
    
    
	ccDrawFilledRect(CGPointMake(0, 0), CGPointMake(ipx(320 * multiplier), ipy(480 * multiplier)));
    

    
	ResourceManager* resManager = [ResourceManager sharedResourceManager];
	CCSprite* sprite = [resManager getTextureWithName: @"back"];
	[sprite setOpacity: 50];
	[sprite setPosition: ccp(ipx(160), ipy(240))];
	[sprite visit];	

	sprite = [resManager getTextureWithName: @"dialog_back"];
	[sprite setPosition: ccp(ipx(160), ipy(240))];
	[sprite visit];	
}

@end
