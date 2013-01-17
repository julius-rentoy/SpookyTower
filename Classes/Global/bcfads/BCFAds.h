#import <Foundation/Foundation.h>
#import "BCFAdsDelegate.h"
#import <UIKit/UIKit.h>

@interface BCFAds : NSObject

/* This SDK is available for iOS publishers and advertisers. You can choose to call only publisher methods, only advertiser methods, or both. */

#pragma mark PUBLISHER METHODS
// Below you'll find methods to be called if you want to monetize your apps with BCFAds.

+ (void)showPopupWithAppID:(NSString *)appID withDelegate:(NSObject<BCFAdsDelegate> *)delegate;

/* This will show a popup ad unit. This popup will ask the user to install an app. There are no incentives, so your app is safe -- Tapjoy and Flurry apps were banned by Apple in the past because of incentivized downloads, but we chose not to do this, so you'll be safe with us. The text may vary from language to language and from app to app. You're paid by the install, not by the click nor by the impression. The more you call this method, the more money you'll make, but the more annoyed your users will be. Our network has artificial intelligence so you may not receive requests when: (1) the device has already received several requests (2) two consecutive requests happening in a 60-second window (3) our system believes the user is not interested in the app.
 
 (NSString *)appID => You can collect your App ID at http://bcfads.com by looking up your apps. If you haven't registered the apps yet, simply add an app in your BCFAds account. Example of NSString *appID:@"4f342dc09dcb890003003a7a".
 
 (NSObject<BCFAdsDelegate> *)delegate => Optional assignment of a delegate, otherwise simply return nil. Default is nil.
 
 You can call this on: Delegate, UIViewController or any other type of object.
 Performance: You will be paid primarily by the number of installs your app generates and sometimes by the number of clicks on the popups. Impressions shouldn't provide revenue.
 Deactivation: Not necessary.
 When: Best to show when app opens, but can be shown whenever you want.
 
 Example:
 
 *** in a Delegate, if you have multi-tasking in your app
 - (void)applicationDidBecomeActive:(UIApplication *)application {
 [BCFAds showPopupWithAppID:@"4f342dc09dcb890003003a7a" withDelegate:nil];
 }
 
 *** in a UIViewController
 - (void)viewDidLoad {
 [BCFAds showPopupWithAppID:@"4f342dc09dcb890003003a7a" withDelegate:nil];
 
 // The remaining part of your code goes here
 
 [super viewDidLoad];
 }
 
 *** any other object or method will work
 */
 
#pragma mark ADVERTISER METHODS
// Below you'll find methods to be called if you want to advertise your apps with BCFAds.

 + (void)registerInstallWithAppID:(NSString *)appID withDelegate:(NSObject<BCFAdsDelegate> *)delegate;

 /* This will enable your app to be advertised in our network, should you want to do it in the future. If you ever plan to advertise with us in the future, you should call this method. This method only works in the background, which means the user won't be notified and nothing should change in your app's interface if you call this method.
 
 (NSString *)appID => You can collect your App ID at http://bcfads.com by looking up your apps. If you haven't registered the apps yet, simply add an app in your BCFAds account. Example of NSString *appID:@"4f342dc09dcb890003003a7a".
 
 (NSObject<BCFAdsDelegate> *)delegate => Optional assignment of a delegate, otherwise simply return nil. Default is nil.
 
 You can call this on: Delegate, UIViewController or any other type of object.
 Performance: To increase the volume we'll deliver for your campaign, you can optimize the following conditions.
  - the higher your bid, the higher the volume.
  - the higher your install/click rate, the higher the volume.
  - the higher your click/impression rate, the higher the volume.
 Deactivation: Not necessary.
 When: When app opens.
 
*/

@end
