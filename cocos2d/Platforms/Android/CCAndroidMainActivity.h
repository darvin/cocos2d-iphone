//
//  CCAndroidMainActivity.h
//  cocos2d-ios
//
//  Created by Oleg Osin on 5/22/14.
//
//

#if __CC_PLATFORM_ANDROID
#import "CCDirectorAndroid.h"

BRIDGE_CLASS("org.cocos2d.CCAndroidActivity")
@interface CCAndroidActivity : AndroidActivity

- (void)onCreate:(AndroidBundle *)bundle;
- (void)onStart;
- (void)onResume;
- (void)onPause;
- (void)onStop;

- (void)surfaceChanged:(AndroidSurfaceHolder *)holder format:(int)format width:(int)w height:(int)h;

@end

#endif 
