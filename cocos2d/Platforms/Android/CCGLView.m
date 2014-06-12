//
//  CCGLView.m
//  cocos2d-ios
//
//  Created by Oleg Osin on 5/22/14.
//
//
#if __CC_PLATFORM_ANDROID
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

#pragma mark CCGLView - Touch Delegate

//- (void)touchesBegan:(NSSet *)touches withEvent:(CCTouchEvent *)event
//{
//    // dispatch touch to responder manager
//    [[CCDirector sharedDirector].responderManager touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(CCTouchEvent *)event
//{
//    // dispatch touch to responder manager
//    [[CCDirector sharedDirector].responderManager touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(CCTouchEvent *)event
//{
//    // dispatch touch to responder manager
//    [[CCDirector sharedDirector].responderManager touchesEnded:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(CCTouchEvent *)event
//{
//    // dispatch touch to responder manager
//    [[CCDirector sharedDirector].responderManager touchesCancelled:touches withEvent:event];
//}


- (void)onTouchEvent:(id/*MotionEvent*/)event
{
    
}

- (void)handleTouchEvent:(id)event
{
//    switch ([event getAction]) {
//        case /*MotionEvent.ACTION_POINTER_DOWN*/:
//        {
//            int indexPointer = [event getPointerId];
//            int idPointer = [event getPointerId:indexPointer];
//            float xPointer = [event getX:indexPointer];
//            float yPointer = [event getY:indexPointer];
//            
//        }
//        break;
//            
//        default:
//            break;
//    }
    
    
    /*
     switch (event.getAction() & MotionEvent.ACTION_MASK) {
     case MotionEvent.ACTION_POINTER_DOWN: {
     final int indexPointer = event.getActionIndex();
     final int idPointer = event.getPointerId(indexPointer);
     final float xPointer = event.getX(indexPointer);
     final float yPointer = event.getY(indexPointer);
     nativeTouchesBegin(idPointer, xPointer, yPointer, event.getEventTime());
     break;
     }
     case MotionEvent.ACTION_DOWN: {
     // there are only one finger on the screen
     final int idDown = event.getPointerId(0);
     final float xDown = event.getX();
     final float yDown = event.getY();
     nativeTouchesBegin(idDown, xDown, yDown, event.getEventTime());
     break;
     }
     case MotionEvent.ACTION_MOVE: {
     final int pointerNumber = event.getPointerCount();
     final int[] ids = new int[pointerNumber];
     final float[] xs = new float[pointerNumber];
     final float[] ys = new float[pointerNumber];
     
     for (int i = 0; i < pointerNumber; i++) {
     ids[i] = event.getPointerId(i);
     xs[i] = event.getX(i);
     ys[i] = event.getY(i);
     }
     nativeTouchesMove(ids, xs, ys, event.getEventTime());
     break;
     }
     case MotionEvent.ACTION_POINTER_UP: {
     final int indexPointer = event.getActionIndex();
     final int idPointer = event.getPointerId(indexPointer);
     final float xPointer = event.getX(indexPointer);
     final float yPointer = event.getY(indexPointer);
     nativeTouchesEnd(idPointer, xPointer, yPointer, event.getEventTime());
     break;
     }
     case MotionEvent.ACTION_UP: {
     // there are only one finger on the screen
     final int idUp = event.getPointerId(0);
     final float xUp = event.getX();
     final float yUp = event.getY();
     nativeTouchesEnd(idUp, xUp, yUp, event.getEventTime());
     break;
     }
     case MotionEvent.ACTION_CANCEL: {
     final int pointerNumber = event.getPointerCount();
     final int[] ids = new int[pointerNumber];
     final float[] xs = new float[pointerNumber];
     final float[] ys = new float[pointerNumber];
     
     for (int i = 0; i < pointerNumber; i++) {
     ids[i] = event.getPointerId(i);
     xs[i] = event.getX(i);
     ys[i] = event.getY(i);
     }
     nativeTouchesCancel(ids, xs, ys, event.getEventTime());
     break;
     }
     default: {
     Log.d("MotionEvent", "Other:" + event.getAction());
     }
     }
     */
}

@end
#endif // __CC_PLATFORM_ANDROID



