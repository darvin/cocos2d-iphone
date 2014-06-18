//
//  HeadlessActivity.h
//  Headless
//
//  Created by Philippe Hausler on 6/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <BridgeKitV3/BridgeKit.h>

BRIDGE_CLASS("com.apportable.HeadlessActivity")
@interface HeadlessActivity : AndroidActivity

- (void)onCreated:(AndroidBundle *)bundle;

@end
