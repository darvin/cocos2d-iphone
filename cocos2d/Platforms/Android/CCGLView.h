//
//  CCGLView.h
//  cocos2d-ios
//
//  Created by Oleg Osin on 5/22/14.
//
//

#if __CC_PLATFORM_ANDROID

#if __CC_PLATFORM_ANDROID_COMPILE_ON_IOS_LAWLZ

@interface SurfaceView : NSObject
@end

@interface AndroidContext : NSObject
@end

@interface EGLDisplay : NSObject
@end

@interface EGLSurface : NSObject
@end

@interface EGLContext : NSObject
@end

#else
BRIDGE_CLASS("org.cocos2d.CCGLView")
#endif

@interface CCGLView : SurfaceView

- (id)initWithContext:(AndroidContext *)context;
- (void)setupView;
- (void)swapBuffers;

@property (nonatomic) CGFloat contentScaleFactor; // TODO
@property (nonatomic) CGRect bounds;    // TODO
@property (nonatomic) EGLDisplay* display;
@property (nonatomic) EGLSurface* surface;
@property (nonatomic) EGLContext* context;

@end
#endif // __CC_PLATFORM_ANDROID


