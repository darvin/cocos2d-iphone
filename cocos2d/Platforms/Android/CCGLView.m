//
//  CCGLView.m
//  cocos2d-ios
//
//  Created by Oleg Osin on 5/22/14.
//
//
#ifdef __CC_PLATFORM_ANDROID
#import "CCGLView.h"

// Sample BridgeKit syntax
//@interface CCGLSurfaceView : AndroidSurfaceView
//
//- (id)initWithContext:(AndroidContext)ctx;
//
//@end
//
//@implementation CCGLSurfaceView
//
//@bridge initWithContext: = <init>
//
//@end

@implementation CCGLView

- (id)initWithContext:(AndroidContext *)context
{
    if((self = [super context]))
    {
        return self;
    }
    
    return self;
}

- (BOOL)setupView
{
    ANativeWindow* window = ANativeWindow_fromSurface(bridge_getJava(holder.surface));
    
    const EGLint attribs[] = {
        EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
        EGL_BLUE_SIZE, 8,
        EGL_GREEN_SIZE, 8,
        EGL_RED_SIZE, 8,
        EGL_NONE
    };
    EGLConfig config;
    EGLint numConfigs;
    EGLint format;
    EGLint width;
    EGLint height;
    GLfloat ratio;
    
    LOG_INFO("Initializing context");
    
    if((_display = eglGetDisplay(EGL_DEFAULT_DISPLAY)) == EGL_NO_DISPLAY)
    {
        //LOG_ERROR("eglGetDisplay() returned error %d", eglGetError());
        return NO;
    }
    
    if(!eglInitialize(_display, 0, 0))
    {
        //LOG_ERROR("eglInitialize() returned error %d", eglGetError());
        return NO;
    }
    
    if(!eglChooseConfig(_display, attribs, &config, 1, &numConfigs))
    {
        //LOG_ERROR("eglChooseConfig() returned error %d", eglGetError());
        return NO
    }
    
    if(!eglGetConfigAttrib(_display, config, EGL_NATIVE_VISUAL_ID, &format))
    {
        //LOG_ERROR("eglGetConfigAttrib() returned error %d", eglGetError());
        return NO;
    }
    
    ANativeWindow_setBuffersGeometry(window, 0, 0, format);
    
    if(!(_surface = eglCreateWindowSurface(_display, config, window, 0)))
    {
        //LOG_ERROR("eglCreateWindowSurface() returned error %d", eglGetError());
        return NO;
    }
    
    if(!(_context = eglCreateContext(_display, config, 0, 0)))
    {
        //LOG_ERROR("eglCreateContext() returned error %d", eglGetError());
        return NO;
    }
    
    if(!eglMakeCurrent(_display, _surface, _surface, _context))
    {
        //LOG_ERROR("eglMakeCurrent() returned error %d", eglGetError());
        return NO;
    }
    
    if(!eglQuerySurface(display, surface, EGL_WIDTH, &width) ||
        !eglQuerySurface(display, surface, EGL_HEIGHT, &height))
    {
        //LOG_ERROR("eglQuerySurface() returned error %d", eglGetError());
        return NO;
    }
    
    
//    glDisable(GL_DITHER);
//    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);
//    glClearColor(0, 0, 0, 0);
//    glEnable(GL_CULL_FACE);
//    glShadeModel(GL_SMOOTH);
//    glEnable(GL_DEPTH_TEST);
//    
//    glViewport(0, 0, width, height);
//    
//    ratio = (GLfloat) width / height;
//    glMatrixMode(GL_PROJECTION);
//    glLoadIdentity();
//    glFrustumf(-ratio, ratio, -1, 1, 1, 10);
    
    return YES;
}

- (void)swapBuffers
{
    eglSwapBuffers(_display, _surface);
}

@end
#endif // __CC_PLATFORM_ANDROID



