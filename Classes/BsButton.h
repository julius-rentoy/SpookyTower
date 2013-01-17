//
//  Button.h
//  StickWars - Siege
//
//  Created by EricH on 8/3/09.
//
 
#import "cocos2d.h"

@interface BsButton: CCMenu {
	
}

+ (BsButton*)buttonWithImage:(NSString*)normalImage 
					selected:(NSString*)selectedImage 
					disabled:(NSString*)disabledImage 
					  target:(id)target
					selector:(SEL)sel;

+ (BsButton*)buttonWithImage:(NSString*)normalImage 
					selected:(NSString*)selectedImage 
					  target:(id)target
					selector:(SEL)sel;


+ (BsButton*)buttonWithString:(NSString*)title
					   normal:(NSString*)normalImage 
					 selected:(NSString*)selectedImage 
					 disabled:(NSString*)disabledImage 
					   target:(id)target
					 selector:(SEL)sel;

+ (BsButton*)buttonWithString:(NSString*)title
					   normal:(NSString*)normalImage 
					 selected:(NSString*)selectedImage 
					   target:(id)target
					 selector:(SEL)sel;



+ (BsButton*)buttonWithString:(NSString*)title
					   normal:(NSString*)normalImage 
					 selected:(NSString*)selectedImage 
					 disabled:(NSString*)disabledImage 
					   target:(id)target
					 selector:(SEL)sel 
						  tag:(int)tag;

+ (BsButton*)buttonWithString:(NSString*)title
					   normal:(NSString*)normalImage 
					 selected:(NSString*)selectedImage 
					   target:(id)target
					 selector:(SEL)sel 
						  tag:(int)tag;

- (void)setEnable:(BOOL)bEnable;

@end
 
