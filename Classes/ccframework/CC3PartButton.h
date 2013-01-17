/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */


#import "CCLayer.h"
#import "ResourceManager.h"
#import "CCLabelFX.h"

typedef enum  {
	kCC3PartButtonSelected = 0,
	kCC3PartButtonUnSelected
} tCC3PartButtonState;

/** A CCMenu
 * 
 * Features and Limitation:
 *  - You can add MenuItem objects in runtime using addChild:
 *  - But the only accecpted children are MenuItem objects
 */
@interface CC3PartButton : CCLayer <CCRGBAProtocol>
{
	NSInvocation *invocation;
#if NS_BLOCKS_AVAILABLE
	// used for menu items using a block
	void (^block_)(id sender);
#endif
	
	tCC3PartButtonState state;
	ResourceManager* resManager;
	CGRect mFrame;
	CCSprite* mSpriteHead;

	CCSprite* mSelSpriteHead;
	
	CCLabelFX *mButtonLabel;
}

- (id) initWithTarget:(id) rec 
			 selector:(SEL) cb 
		  textureName: (NSString*) textureName 
	   selTextureName: (NSString*) selTextureName 
				 text: (NSString*) text
			 position:(CGPoint) position;
@end
