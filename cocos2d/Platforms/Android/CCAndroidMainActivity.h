//
//  CCAndroidMainActivity.h
//  cocos2d-ios
//
//  Created by Oleg Osin on 5/22/14.
//
//

#import "cocos2d.h"
//#import "CCDirectorAndroid.h"

#if 0//__CC_PLATFORM_ANDROID

#import <BridgeKitV3/BridgeKit.h>

BRIDGE_CLASS("org.cocos2d.CCAndroidActivity")
@interface CCAndroidActivity : AndroidActivity

- (void)onCreate:(AndroidBundle *)bundle;
- (void)onStart;
- (void)onResume;
- (void)onPause;
- (void)onStop;

//- (void)surfaceChanged:(AndroidSurfaceHolder *)holder format:(int)format width:(int)w height:(int)h;

@end



#endif 

