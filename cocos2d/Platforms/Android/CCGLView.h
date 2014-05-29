//
//  CCGLView.h
//  cocos2d-ios
//
//  Created by Oleg Osin on 5/22/14.
//
//

#ifdef __CC_PLATFORM_ANDROID

BRIDGE_CLASS("org.cocos2d.CCGLView")
@interface CCGLView : AndroidSurfaceView

- (id)initWithContext:(AndroidContext *)context;
- (void)setupView;
- (void)swapBuffers;

@property (nonatomic) CGFloat contentScaleFactor; // TODO
@property (nonatomic) CGRect bounds;    // TODO
@property (nonatomic) EGLDisplay display;
@property (nonatomic) EGLSurface surface;
@property (nonatomic) EGLContext context;

@end
#endif // __CC_PLATFORM_ANDROID


