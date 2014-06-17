//
//  HeadlessActivity.m
//  Headless
//
//  Created by Philippe Hausler on 6/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HeadlessActivity.h"

@implementation HeadlessActivity

@bridge (callback) onCreated: = onCreated;

- (void)onCreated:(AndroidBundle *)bundle
{
    NSLog(@"Got to here!");
    [[AndroidLooper currentLooper] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
}

@end
