//
//  HeadlessActivity.m
//  Headless
//
//  Created by Philippe Hausler on 6/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HeadlessActivity.h"
#import <android/native_window.h>
#import <bridge/runtime.h>

#import "cocos2d.h"

@implementation AndroidViewSurface
@end


@implementation AndroidViewSurfaceHolder
@bridge (instance, method) surface = getSurface;
@end


@implementation HeadlessActivity {
    CCGLView* _glView;
}

@bridge (callback) onCreated: = onCreated;
@bridge (callback) surfaceCreated: = surfaceCreated;
@bridge (callback) surfaceDestroyed: = surfaceDestroyed;
@bridge (callback) surfaceChanged:format:width:height: = surfaceChanged;

- (void)onCreated:(AndroidBundle *)bundle
{
    NSLog(@"Got to here!");
    [[AndroidLooper currentLooper] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
}

- (void)surfaceCreated:(AndroidViewSurfaceHolder*)holder
{
    
}

- (void)surfaceChanged:(AndroidViewSurfaceHolder*)holder format:(int)format width:(int)width height:(int)height
{
    if(_glView != nil)
        return;

    // Note: temp hack, this all needs be abstracted into cocos2d (the same way it works on iOS)
    ANativeWindow* window = ANativeWindow_fromSurface(bridge_getJava(holder.surface));
    
    _glView = [[CCGLView alloc] init];
    [_glView setupView:window];

    CCDirectorAndroid* director = (CCDirectorAndroid*) [CCDirector sharedDirector];
    [director setView:_glView];
    
    
    // set FPS at 60
//	NSTimeInterval animationInterval = [(config[CCSetupAnimationInterval] ?: @(1.0/60.0)) doubleValue];
//    [director setAnimationInterval:animationInterval];
//	director.fixedUpdateInterval = [(config[CCSetupFixedUpdateInterval] ?: @(1.0/60.0)) doubleValue];

    [director setProjection:CCDirectorProjection2D];
    [CCTexture setDefaultAlphaPixelFormat:CCTexturePixelFormat_RGBA8888];
    
    [director reshapeProjection:CGSizeMake(width, height)];
    
    [[CCDirector sharedDirector] startAnimation];
    
}

- (void)surfaceDestroyed:(AndroidViewSurfaceHolder*)holder
{
    
}

@end
