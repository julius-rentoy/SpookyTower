//
//  Button.m
//  StickWars - Siege
//
//  Created by EricH on 8/3/09.
//
 
#import "BsButton.h"
 

@implementation BsButton

+ (CCMenuItem*)createMenuItem:(NSString*)normalImage 
					 selected:(NSString*)selectedImage 
					 disabled:(NSString*)disabledImage 
					   target:(id)target
					 selector:(SEL)sel
{
	CCSprite *normalSprite   = nil;
	CCSprite *selectedSprite = nil;
	CCSprite *disabledSprite = nil;
	
	if (normalImage) {
		normalSprite = [CCSprite spriteWithFile:normalImage];
		normalSprite.anchorPoint = ccp(0,0);
	}
	
	if (selectedImage) {
		selectedSprite = [CCSprite spriteWithFile:selectedImage];
		selectedSprite.anchorPoint = ccp(0,0);
	}
	
	if (disabledImage) {
		disabledSprite = [CCSprite spriteWithFile:disabledImage];
		disabledSprite.anchorPoint = ccp(0,0);
	}
	
	assert(normalSprite);
	assert(selectedSprite);
	//	assert(disabledSprite);
	
	CCMenuItem *menuItem = [CCMenuItemSprite itemFromNormalSprite:normalSprite
												   selectedSprite:selectedSprite
												   disabledSprite:disabledSprite
														   target:target
														 selector:sel];
	
	return menuItem;
}

+ (BsButton*)buttonWithImage:(NSString*)normalImage 
					selected:(NSString*)selectedImage 
					disabled:(NSString*)disabledImage 
					  target:(id)target
					selector:(SEL)sel
{
	CCMenuItem *menuItem = [BsButton createMenuItem:normalImage
										   selected:selectedImage
										   disabled:disabledImage
											 target:target
										   selector:sel];
	
	BsButton *menu = [BsButton menuWithItems:menuItem, nil];
	return menu;
}

+ (BsButton*)buttonWithImage:(NSString*)normalImage 
					selected:(NSString*)selectedImage 
					  target:(id)target
					selector:(SEL)sel
{
	BsButton *menu = [BsButton buttonWithImage:normalImage
					 selected:selectedImage
					 disabled:nil
					   target:target
					 selector:sel];

	return menu;
}

+ (CCLabelTTF*)addLabel:(CCMenuItem*)menuItem
				  title:(NSString*)title
			   fontName:(NSString*)fontName
			   fontSize:(int)fontSize
				  color:(ccColor3B)color
{
	CCLabelTTF* label = [CCLabelTTF labelWithString:title fontName:fontName fontSize:fontSize];
	label.color = color;
	
	CGRect rtItem = [menuItem rect];
	CGSize szItem = CGSizeMake(CGRectGetWidth(rtItem), CGRectGetHeight(rtItem));
	[label setPosition: ccp(rtItem.origin.x+szItem.width, rtItem.origin.y+szItem.height)];
	[menuItem addChild:label];
	
	return label;
}

+ (BsButton*)buttonWithString:(NSString*)title
					   normal:(NSString*)normalImage 
					 selected:(NSString*)selectedImage 
					 disabled:(NSString*)disabledImage 
					   target:(id)target
					 selector:(SEL)sel 
{
	CCMenuItem *menuItem = [BsButton createMenuItem:normalImage
										   selected:selectedImage
										   disabled:disabledImage
											 target:target
										   selector:sel];
	
	[BsButton addLabel:menuItem title:title fontName:@"Arial" fontSize:48 * SCALE_SCREEN_WIDTH color:ccWHITE];
	
	BsButton *menu = [BsButton menuWithItems:menuItem, nil];
	
	return menu;
}

+ (BsButton*)buttonWithString:(NSString*)title
					   normal:(NSString*)normalImage 
					 selected:(NSString*)selectedImage 
					   target:(id)target
					 selector:(SEL)sel 
{
	return [BsButton buttonWithString:title
							   normal:normalImage 
							 selected:selectedImage 
							 disabled:nil 
							   target:target
							 selector:sel];
}

+ (BsButton*)buttonWithString:(NSString*)title
					   normal:(NSString*)normalImage 
					 selected:(NSString*)selectedImage 
					 disabled:(NSString*)disabledImage 
					   target:(id)target
					 selector:(SEL)sel 
						  tag:(int)tag
{
	CCMenuItem *menuItem = [BsButton createMenuItem:normalImage
										   selected:selectedImage
										   disabled:disabledImage
											 target:target
										   selector:sel];
	menuItem.tag = tag;
	
//	[CCMenuItemFont setFontSize:24];
//	[CCMenuItemFont setFontName: @"Courier New"];
//	CCMenuItem *labelItem = [CCMenuItemFont itemFromString: title target:target selector:sel];
//	labelItem.tag = tag;
//	BsButton *menu = [BsButton menuWithItems:menuItem, labelItem, nil];
//	menu.tag = tag;
	
	NSString*	fontName = @"Imagica";
	int			fontSize = 48 * SCALE_SCREEN_WIDTH;
	CCLabelTTF* labelShadow = [BsButton addLabel:menuItem title:title fontName:fontName fontSize:fontSize color:ccc3(0, 0, 0)];
	[BsButton addLabel:menuItem title:title fontName:fontName fontSize:fontSize color:ccc3(255, 175, 101)];
	[labelShadow setPosition:ccpAdd(labelShadow.position, ccp(4 * SCALE_SCREEN_WIDTH, -4 * SCALE_SCREEN_WIDTH))];
	[labelShadow setOpacity: 255 * 20 / 100];
	BsButton *menu = [BsButton menuWithItems:menuItem, nil];
	
	return menu;
}

+ (BsButton*)buttonWithString:(NSString*)title
					   normal:(NSString*)normalImage 
					 selected:(NSString*)selectedImage 
					   target:(id)target
					 selector:(SEL)sel 
						  tag:(int)tag
{
	return [BsButton buttonWithString:title
					  normal:normalImage 
					selected:selectedImage 
					disabled:nil 
					  target:target
					selector:sel 
						 tag:tag];
}

- (void) setEnable:(BOOL) bEnable {
	self.isTouchEnabled = bEnable;
	
	if (bEnable)
		[self setOpacity: 255];
	else 
		[self setOpacity: 80];	
}

@end