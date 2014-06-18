//
//  CCGLView.h
//  cocos2d-ios
//
//  Created by Oleg Osin on 5/22/14.
//
//

#import "ccMacros.h"

#if __CC_PLATFORM_ANDROID

#import <BridgeKitV3/BridgeKit.h>

@interface CCGLView : NSObject

- (void)setupView:(ANativeWindow*)window;
- (void)swapBuffers;
- (void)onTouchEvent:(id/*MotionEvent*/)event;

@property (nonatomic) CGFloat contentScaleFactor; // TODO
@property (nonatomic) CGRect bounds;    // TODO
@property (nonatomic) EGLDisplay* display;
@property (nonatomic) EGLSurface* surface;
@property (nonatomic) EGLContext* context;

@end
#endif // __CC_PLATFORM_ANDROID


