//
//  CCTouchAndroid.m
//  cocos2d-ios
//
//  Created by Oleg Osin on 6/13/14.
//
//
#if __CC_PLATFORM_ANDROID

#import "CCTouchAndroid.h"

@implementation CCTouchAndroid

- (CGPoint)locationInView:(CCGLView *)view
{
    // TODO
    return [super locationInView:view];
}

- (CGPoint)previousLocationInView:(CCGLView *)view
{
    // TODO
    return [super previousLocationInView:view];
}

@end

#endif
