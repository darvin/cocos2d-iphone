//
//  CCTouch.m
//  cocos2d-ios
//
//  Created by Oleg Osin on 6/12/14.
//
//

#import "cocos2d.h"
#import "CCTouch.h"
#import "CCDirector.h"

@implementation CCTouch

- (instancetype)initWithPlatformTouch:(PlatformTouch*)touch
{
    if((self = [super init]))
    {
        _uiTouch = touch;
        _view = (CCGLView*)[CCDirector sharedDirector].view;
        return self;
    }
    
    return self;
}

+ (instancetype)touchWithPlatformTouch:(PlatformTouch*)touch
{
    return [[self alloc] initWithPlatformTouch:touch];
}

- (CCTouchPhase)phase
{
#if !__CC_PLATFORM_ANDROID_COMPILE_ON_IOS_LAWLZ
    return (CCTouchPhase)_uiTouch.phase;
#else
    return 0;
#endif
}

- (NSUInteger)tapCount
{
#if !__CC_PLATFORM_ANDROID_COMPILE_ON_IOS_LAWLZ
    return _uiTouch.tapCount;
#else
    return 0;
#endif
}

- (NSTimeInterval)timestamp
{
#if !__CC_PLATFORM_ANDROID_COMPILE_ON_IOS_LAWLZ
    return _uiTouch.timestamp;
#else
    return 0;
#endif
}

- (CGPoint)locationInNode:(CCNode*) node
{
    CCDirector* dir = [CCDirector sharedDirector];
    
    CGPoint touchLocation = [self locationInView: [self view]];
	touchLocation = [dir convertToGL: touchLocation];
    return [node convertToNodeSpace:touchLocation];
}

- (CGPoint)locationInWorld
{
    CCDirector* dir = [CCDirector sharedDirector];
    
    CGPoint touchLocation = [self locationInView: [self view]];
	return [dir convertToGL: touchLocation];
}

- (CGPoint)locationInView:(CCGLView *)view
{
    return (CGPoint){0, 0};
}

- (CGPoint)previousLocationInView:(CCGLView *)view
{
    return (CGPoint){0, 0};
}

@end


