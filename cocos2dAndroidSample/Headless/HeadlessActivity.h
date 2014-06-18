//
//  HeadlessActivity.h
//  Headless
//
//  Created by Philippe Hausler on 6/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <BridgeKitV3/BridgeKit.h>

BRIDGE_CLASS("android.view.Surface")
@interface AndroidViewSurface : JavaObject
@end

BRIDGE_CLASS("android.view.SurfaceHolder")
@interface AndroidViewSurfaceHolder : JavaObject
- (AndroidViewSurface*)surface;
@end

BRIDGE_CLASS("com.apportable.HeadlessActivity")
@interface HeadlessActivity : AndroidActivity

- (void)onCreated:(AndroidBundle *)bundle;

- (void)surfaceCreated:(AndroidViewSurfaceHolder*)holder;
- (void)surfaceChanged:(AndroidViewSurfaceHolder*)holder format:(int)format width:(int)width height:(int)height;
- (void)surfaceDestroyed:(AndroidViewSurfaceHolder*)holder;

@end
