//
//  AppSetting.h
//  fruitGame
//
//  Created by KCU on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppSettings : NSObject 
{

}

+ (void) defineUserDefaults;

+ (void) setBackgroundVolume: (float) fVolume;
+ (void) setEffectVolume: (float) fVolume;
+ (float) backgroundVolume;
+ (float) effectVolume;

@end
