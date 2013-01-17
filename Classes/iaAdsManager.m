//
//  AdsManager.m
//  Bottle Tunes
//
//  Created by Jason Pawlak on 9/2/11.
//  Copyright 2011 Paw Apps LLC. All rights reserved.
//

#import "iaAdsManager.h"
//#import "Mobclix.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include "AppSpecificValues.h"
//#define MOBCLIX_ID @"E0CC0E6A-4CE0-4893-A9D6-B05208A5510D"

@implementation iaAdsManager

@synthesize adView;
@synthesize adStarted;

static iaAdsManager *_sharedAdsManager = nil;

// Helper methods

-(UIViewController*) getRootViewController
{
	return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void) presentViewController:(UIViewController*)vc
{
	UIViewController* rootVC = [self getRootViewController];
	[rootVC presentModalViewController:vc animated:YES];
}

-(NSString *) platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

-(void) newAd:(CGPoint)loc 
{
    /*
    
    if (adView) {
        // We only want one ad at a time
        [self cancelAd];
    }
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //bool is3GDevice = [[self platform] isEqualToString:@"iPhone1,2"];
  //  adView = [adView alloc];
    if(winSize.width > 728) {
        adView = [[[UIView alloc]   initWithFrame:CGRectMake(loc.x,winSize.height - 66.0f, 768.0f, 66.0f)] autorelease];
        [InneractiveAd DisplayAd: InnerActive_IDIpad withType:IaAdType_Banner withRoot:adView withReload:15 ];
    } 
    
    else {
        
        // Optional parameters
        NSMutableDictionary *optionalParams = [[NSMutableDictionary alloc] init];
        //[optionalParams setObject:@"25" forKey:[NSNumber numberWithInt:Key_Age]];
        [optionalParams setObject:@"947" forKey:[NSNumber numberWithInt:Key_Distribution_Id]];
//        [optionalParams setObject:@"Test_EID" forKey:[NSNumber numberWithInt:Key_External_Id]];
//        [optionalParams setObject:@"m" forKey:[NSNumber numberWithInt:Key_Gender]];
//        [optionalParams setObject:@"53.542132,-2.239856" forKey:[NSNumber numberWithInt:Key_Gps_Coordinates]];
//        [optionalParams setObject:@"inneractive,test" forKey:[NSNumber numberWithInt:Key_Keywords]];
//        [optionalParams setObject:@"US,NY,NY" forKey:[NSNumber numberWithInt:Key_Location]];
//        [optionalParams setObject:@"972561234567" forKey:[NSNumber numberWithInt:Key_Msisdn]];
        //InnerActive_IDIphone
        adView = [[[UIView alloc]  initWithFrame:CGRectMake(loc.x, winSize.height - 53.0f, 320.0f, 53.0f)] autorelease];
        [InneractiveAd DisplayAd: InnerActive_IDIphone withType:IaAdType_Banner withRoot:adView withReload:15 withParams: optionalParams ];
        
    }
    //    [[[self getRootViewController] view] addSubview:adView];
    //UIView *a = [UIView alloc];
    //a= [[[UIView alloc] initWithFrame:CGRectMake(loc.x, winSize.height - loc.y - 53.0f, 320.0f, 53.0f)] autorelease];
    [[[CCDirector sharedDirector] openGLView] addSubview:adView];
    //[InneractiveAd DisplayAd: @"iOS_Test" withType:IaAdType_Banner withRoot:a withReload:60 ];
    
    
    //[self.adView resumeAdAutoRefresh];
     */
}

-(void) showAd {
    if (!adView)
        [self newAd:ccp(0,0)];
    //[self.adView resumeAdAutoRefresh];
    [self.adView setHidden:NO];
}

-(void) hideAd {
    //[self.adView pauseAdAutoRefresh];
    [self.adView setHidden:YES];
}

-(void) cancelAd {
    // Can only cancel it if it exists
    if (adView) {
        //[adView cancelAd];
        //[adView setDelegate:nil];
        [adView removeFromSuperview];
        adView = nil;
    }
}

-(void) startMobclix {
    if (!adStarted)
        adStarted = YES;
    //[Mobclix startWithApplicationId:MOBCLIX_ID];
}

+(iaAdsManager*)sharedAdsManager
{
	@synchronized([iaAdsManager class])
	{
		if (!_sharedAdsManager)
			[[self alloc] init];
        
		return _sharedAdsManager;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([iaAdsManager class])
	{
		NSAssert(_sharedAdsManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedAdsManager = [[super alloc] init];
		return _sharedAdsManager;
	}
    
	return nil;
}

-(id)autorelease {
    [self cancelAd];
    
    return self;
}

-(id)init {
    if (!adStarted)
        [self startMobclix];
	return [super init];
}

@end