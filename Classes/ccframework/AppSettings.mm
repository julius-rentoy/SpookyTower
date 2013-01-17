//
//  AppSetting.m
//  fruitGame
//
//  Created by KCU on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppSettings.h"


@implementation AppSettings

+ (void) defineUserDefaults
{
	NSString* userDefaultsValuesPath;
	NSDictionary* userDefaultsValuesDict;
	
	// load the default values for the user defaults
	userDefaultsValuesPath = [[NSBundle mainBundle] pathForResource:@"setting" ofType:@"plist"];
	userDefaultsValuesDict = [NSDictionary dictionaryWithContentsOfFile: userDefaultsValuesPath];
	[[NSUserDefaults standardUserDefaults] registerDefaults: userDefaultsValuesDict];
}

+ (void) setBackgroundVolume: (float) fVolume
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aVolume  =	[[NSNumber alloc] initWithFloat: fVolume];	
	[defaults setObject:aVolume forKey:@"music"];	
	[NSUserDefaults resetStandardUserDefaults];	
}

+ (float) backgroundVolume
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	return [defaults floatForKey:@"music"];
	
}

+ (void) setEffectVolume: (float) fVolume
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aVolume  =	[[NSNumber alloc] initWithFloat: fVolume];	
	[defaults setObject:aVolume forKey:@"effect"];	
	[NSUserDefaults resetStandardUserDefaults];	
}

+ (float) effectVolume
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	return [defaults floatForKey:@"effect"];
	
}


@end
