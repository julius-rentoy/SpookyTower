//
//  ResourceManager.m
//  glideGame
//
//  Created by KCU on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResourceManager.h"
#include <mach/mach.h>
#include <mach/machine.h>
@implementation ResourceManager
@synthesize font;
@synthesize font30;

#define isRetina    (CC_CONTENT_SCALE_FACTOR() == 2)

static ResourceManager *_sharedResource = nil;

+ (ResourceManager*) sharedResourceManager 
{
	if (!_sharedResource) 
	{
		_sharedResource = [[ResourceManager alloc] init];
	}
	
	return _sharedResource;
}

+ (void) releaseResourceManager 
{
	if (_sharedResource) 
	{
		[_sharedResource release];
		_sharedResource = nil;
	}
}

- (id) init
{
	if ( (self=[super init]) )
	{
	}
	
	return self;
}

- (void) loadLoadingData 
{
    BOOL isDeviceIPAD   =   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    NSString *extension;
    if (isDeviceIPAD) {
         extension  =   @"loading@3x.png";
    }
    else
    {
        extension   =   isRetina ? @"loading-hd.png" : @"loading.png";
        extension   =   @"loading.png";
    }
    
    
//    NSString *str   =   isDeviceIPAD ? SHImageString(@"loading") : @"loading.png";
//
    
    
	textures[kLoading] = [[CCSprite spriteWithFile:extension] retain];
    
    
    
    
    
}

- (void) print_memory_size { 
	mach_port_t host_port; 
	mach_msg_type_number_t host_size; 
	vm_size_t pagesize; 
    
	host_port = mach_host_self(); 
	host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t); 
	host_page_size(host_port, &pagesize);         
	
	vm_statistics_data_t vm_stat; 
	
	if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) 
		NSLog(@"Failed to fetch vm statistics"); 
	
	/* Stats in bytes */ 
	natural_t mem_used = (vm_stat.active_count + 
						  vm_stat.inactive_count + 
						  vm_stat.wire_count) * pagesize; 
	natural_t mem_free = vm_stat.free_count * pagesize; 
	natural_t mem_total = mem_used + mem_free; 
	NSLog(@"used: %d free: %d total: %d", mem_used, mem_free, mem_total); 
} 

- (void) loadData 
{	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) 
    {
        
//        if(isRetina)
//        {
//            CCLOG(@"retina!!");
//            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"main-hd.plist"];
//            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"game-hd.plist"];
//            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"option-hd.plist"];
//        }
//        else
        
        {
           /// CCLOG(@"non - retina!!");
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"main.plist"];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"game.plist"];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"option.plist"];
        }
    } 
    else 
    {
        CCLOG(@"ipad!!");
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"main@3x.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"game@3x.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"option@3x.plist"];
    }

	//	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tex1.plist"];
//	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tex3.plist"];
//	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tex10.plist"];
//	font = [[CCLabelBMFont alloc] initWithString:@"Now" fntFile:@"ShowcardGothic.fnt"];
//	font33 = [[CCLabelBMFont alloc] initWithString:@"Now" fntFile:@"kidfont33.fnt"];
	
	NSLog(@"Resource Manager completed loading");
	[self print_memory_size];
	
	font30 = [[CCLabelBMFont alloc] initWithString:@"Now" fntFile:@"gothic15.fnt"];
}

- (CCSprite*) getTextureWithId: (int) textureId 
{
	return textures[textureId];
}

- (CCSprite*) getTextureWithName: (NSString*) textureName
{
	return [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png", textureName]];
}

- (void) dealloc 
{
	[super dealloc];
	[font release];
	[font30 release];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	
	for (int i = 0; i < TEXTURE_COUNT; i ++)
	{
		[textures[i] release];
	}
}

@end
