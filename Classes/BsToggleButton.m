//
//  BsToggleButton.m
//  StickWars - Siege
//
//  Created by EricH on 8/3/09.
//
 
#import "BsToggleButton.h"

@implementation BsToggleButton

+ (BsToggleButton*)buttonWithImage:(NSString*)imageOn 
					selected:(NSString*)imageOff 
					  target:(id)target
					selector:(SEL)sel
{
	CCMenuItem *itemOn  = nil;
	CCMenuItem *itemOff = nil;
	{
		CCSprite *onSprite  = [CCSprite spriteWithFile:imageOn];
		CCSprite *offSprite = [CCSprite spriteWithFile:imageOff];
		
		onSprite.anchorPoint  = ccp(0,0);
		offSprite.anchorPoint = ccp(0,0);
		
		assert(onSprite);
		assert(offSprite);
		
		itemOn = [CCMenuItemSprite itemFromNormalSprite:onSprite
										 selectedSprite:offSprite
												 target:nil
											   selector:nil];
	}
	
	{
		CCSprite *onSprite  = [CCSprite spriteWithFile:imageOn];
		CCSprite *offSprite = [CCSprite spriteWithFile:imageOff];
		
		onSprite.anchorPoint  = ccp(0,0);
		offSprite.anchorPoint = ccp(0,0);
		
		assert(onSprite);
		assert(offSprite);
		
		itemOff = [CCMenuItemSprite itemFromNormalSprite:offSprite
										  selectedSprite:onSprite
												  target:nil
												selector:nil];
	}
	
	CCMenuItemToggle* menuItem = [CCMenuItemToggle itemWithTarget:target
														 selector:sel
															items: itemOn, itemOff, nil];
	
	BsToggleButton *menu = [BsToggleButton menuWithItems:menuItem, nil];
	return menu;
}

- (void)setEnable:(BOOL) bEnable {
	self.isTouchEnabled = bEnable;
	
	if (bEnable)
		[self setOpacity: 255];
	else 
		[self setOpacity: 80];	
}

- (void)setState:(BOOL)bState
{
	CCMenuItemToggle* item = [children_ objectAtIndex:0];
	if ( [item visible] && [item isEnabled] ) {
		if(bState)
			item.selectedIndex = 0;
		else
			item.selectedIndex = 1;
	}
}

- (BOOL)state
{
	CCMenuItemToggle* item = [children_ objectAtIndex:0];
	if(item.selectedIndex == 0)
		return YES;
	return NO;
}

@end