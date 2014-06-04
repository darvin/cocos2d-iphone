//
//  SimpleScene.m
//  cocos2d-tests-ios
//
//  Created by Oleg Osin on 6/3/14.
//  Copyright (c) 2014 Cocos2d. All rights reserved.
//

#import "SimpleScene.h"
#import "CCNodeColor.h"
#import "CCSprite.h"

@implementation SimpleScene

- (id)init
{
    if((self = [super init]))
    {

        return self;
    }
    
    return self;
}

- (void)onEnter {
    [super onEnter];
    
    CCNodeColor* node1 = [CCNodeColor nodeWithColor:[CCColor redColor]];
    node1.contentSize = CGSizeMake(20, 20);
    [self addChild:node1];
    
    CCNodeColor* node2 = [CCNodeColor nodeWithColor:[CCColor blueColor]];
    node2.contentSize = CGSizeMake(20, 20);
    node2.position = ccp(30, 0);
    [self addChild:node2];
    
    CCSprite* spr = [CCSprite spriteWithImageNamed:@"sample_hollow_circle.png"];
    spr.position = ccp(100, 0);
    [self addChild:spr];
}

@end
