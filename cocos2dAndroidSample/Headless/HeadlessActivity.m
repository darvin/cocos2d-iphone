//
//  HeadlessActivity.m
//  Headless
//
//  Created by Philippe Hausler on 6/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HeadlessActivity.h"
#import <BridgeKit/AndroidSurfaceView.h>
#import <android/native_window.h>
#import <bridge/runtime.h>

BRIDGE_CLASS("android.view.Surface")
@interface AndroidViewSurface : JavaObject
@end
@implementation AndroidViewSurfacer
@end

BRIDGE_CLASS("android.view.SurfaceHolder")
@interface AndroidViewSurfaceHolder : JavaObject
- (AndroidViewSurface*)surface;
@end
@implementation AndroidViewSurfaceHolder
@bridge (instance, method) surface = getSurface;
@end


@interface HeadlessActivity ()

- (void)surfaceCreated:(AndroidViewSurfaceHolder*)holder;
- (void)surfaceChanged:(AndroidViewSurfaceHolder*)holder format:(int)format width:(int)width height:(int)height;
- (void)surfaceDestroyed:(AndroidViewSurfaceHolder*)holder;

@end

@implementation HeadlessActivity

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
        ANativeWindow* window = ANativeWindow_fromSurface(bridge_getJava(holder.surface));
    // setupView
    
    
}

- (void)surfaceDestroyed:(AndroidViewSurfaceHolder*)holder
{
    
}

@end
