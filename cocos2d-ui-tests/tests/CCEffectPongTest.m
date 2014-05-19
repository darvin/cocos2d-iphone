//
//  CCEffectPongTest.m
//  cocos2d-tests-ios
//
//  Created by Oleg Osin on 5/16/14.
//  Copyright (c) 2014 Cocos2d. All rights reserved.
//

#import "TestBase.h"
#import "CCTextureCache.h"
#import "CCNodeColor.h"
#import "CCEffectNode.h"
#import "CCEffectGaussianBlur.h"

#if CC_ENABLE_EXPERIMENTAL_EFFECTS

#define PADDLE_HEIGHT 100.0f
#define PADDLE_WIDTH 20.0f
#define PADDLE_X_OFFSET 10.0f

#define BALL_HEIGHT 10.0f
#define BALL_WIDTH 10.0f

#define CEILING_HEIGHT 5.0f
#define FLOOR_HEIGHT 5.0f

typedef enum { TEST_PONG_PLAYING, TESTS_PONG_GAMEOVER } TEST_PONG_STATE;

@interface CCEffectPongTest : TestBase <CCPhysicsCollisionDelegate> @end

@implementation CCEffectPongTest {
    CCNodeColor* _playerPaddle;
    CCNodeColor* _aiPaddle;
    CCSprite* _ball;
    CGSize _designSize;
    
    CCEffectNode* _ballEffectNode;
    CCEffectGaussianBlur* _ballEffect;
    
    CCNodeColor* _ceiling;
    CCNodeColor* _floor;
    
    CCEffectNode* _pixellateEffectNode;
    CCEffectPixellate* _pixellateEffect;
    
    TEST_PONG_STATE _gameState;
}

- (BOOL)canPaddleMoveTo:(float)y
{
    return !((y + (PADDLE_HEIGHT * 0.5f) > _designSize.height - CEILING_HEIGHT) ||
            (y - (PADDLE_HEIGHT * 0.5f) < FLOOR_HEIGHT));
}

- (void)setupEffectPongTest
{
    self.userInteractionEnabled = YES;
    
    _gameState = TEST_PONG_PLAYING;
    
    CCPhysicsNode *physics = [CCPhysicsNode node];
    //physics.debugDraw = YES;
    [physics setCollisionDelegate:self];
	//[self.contentNode addChild:physics];
    
    _designSize = [[CCDirector sharedDirector] designSize];
    _designSize.height -= _headerBg.contentSize.height;

    [self setupBall];
    [physics addChild:_ballEffectNode];

    [self setupPlayerPaddle];
    [physics addChild:_playerPaddle];
    
    [self setupAIPaddle];
    [physics addChild:_aiPaddle];
    
    
    [self setupFloorAndCeiling];
    [physics addChild:_ceiling];
    [physics addChild:_floor];
    
    _pixellateEffectNode = [[CCEffectNode alloc] initWithWidth:_designSize.width height:_designSize.height];
    
    // HACK
    _pixellateEffectNode.position = ccp(_designSize.width * 0.5f, _designSize.height * 0.5f); // This should work with position 0,0. FIXME - Oleg. An effectnodes position without an actual effect handles behave different when an effect is added.
    
    _pixellateEffect = [[CCEffectPixellate alloc] initWithPixelScale:0.0001f];
    
    [_pixellateEffectNode addChild:physics];

    [self.contentNode addChild:_pixellateEffectNode];
    
    [self schedule:@selector(sceneUpdate:) interval:1.0f/60.0f];
}

- (void)setupPlayerPaddle
{
    // Left paddle (player)
    if(_playerPaddle == nil)
    {
        _playerPaddle = [CCNodeColor nodeWithColor:[CCColor redColor]];
        _playerPaddle.anchorPoint = ccp(0.0, 0.5);
        _playerPaddle.contentSize = CGSizeMake(PADDLE_WIDTH, PADDLE_HEIGHT);
        
        CGRect rect = {CGPointZero, _playerPaddle.contentSize};
        _playerPaddle.physicsBody = [CCPhysicsBody bodyWithRect:rect cornerRadius:0.0];
        _playerPaddle.physicsBody.type = CCPhysicsBodyTypeStatic;
        _playerPaddle.physicsBody.collisionType = @"playerPaddle";
    }
    
    _playerPaddle.position = ccp(PADDLE_X_OFFSET, _designSize.height * 0.5f);
}

- (void)setupAIPaddle
{
    if(_aiPaddle == nil)
    {
        _aiPaddle = [CCNodeColor nodeWithColor:[CCColor redColor]];
        _aiPaddle.anchorPoint = ccp(0.0, 0.5);
        _aiPaddle.contentSize = CGSizeMake(PADDLE_WIDTH, PADDLE_HEIGHT);
        
        CGRect rect = {CGPointZero, _aiPaddle.contentSize};
        _aiPaddle.physicsBody = [CCPhysicsBody bodyWithRect:rect cornerRadius:0.0];
        _aiPaddle.physicsBody.type = CCPhysicsBodyTypeStatic;
        _aiPaddle.physicsBody.collisionType = @"aiPaddle";
    }
    
    _aiPaddle.position = ccp(_designSize.width - PADDLE_WIDTH - PADDLE_X_OFFSET, _designSize.height * 0.5f);
}

- (void)setupBall
{
    if(_ball == nil)
    {
        _ball = [CCSprite spriteWithImageNamed:@"sphere-23.png"];
        _ball.anchorPoint = ccp(0.0, 0.0); // We shouldn't have to set this here. FIXME - Oleg
        
        CGSize size = {_ball.contentSize.width + 20, _ball.contentSize.height + 20};
        _ballEffectNode = [[CCEffectNode alloc] init];
        _ballEffectNode.contentSize = size;
        _ballEffectNode.anchorPoint = ccp(0.5, 0.5);
        
        CGRect rect = {CGPointZero, size};
        _ballEffectNode.physicsBody = [CCPhysicsBody bodyWithRect:rect cornerRadius:0.0];
        _ballEffectNode.physicsBody.collisionType = @"ball";
        
        _ballEffectNode.scale = 0.1f;
        [_ballEffectNode addChild:_ball];
        
        _ballEffect = [CCEffectGaussianBlur effectWithBlurStrength:0.01f direction:GLKVector2Make(0.0, 0.0)];
        [_ballEffectNode addEffect:_ballEffect];
    }
    
    _ballEffectNode.physicsBody.velocity = ccp(-160, 0);
    _ballEffectNode.physicsBody.angularVelocity = 0.1;
    _ballEffectNode.position = ccp(_designSize.width * 0.5f, _designSize.height * 0.5f);
}

- (void)setupFloorAndCeiling
{
    _ceiling = [CCNodeColor nodeWithColor:[CCColor greenColor]];
    _ceiling.anchorPoint = ccp(0.5, 1.0);
    _ceiling.contentSize = CGSizeMake(_designSize.width, CEILING_HEIGHT);
    
    CGRect rect = {CGPointZero, _ceiling.contentSize};
    _ceiling.physicsBody = [CCPhysicsBody bodyWithRect:rect cornerRadius:0.0];
    _ceiling.physicsBody.type = CCPhysicsBodyTypeStatic;
    _ceiling.physicsBody.collisionType = @"ceiling";
    
    _ceiling.position = ccp(_designSize.width * 0.5f, _designSize.height);
    
    _floor = [CCNodeColor nodeWithColor:[CCColor greenColor]];
    _floor.anchorPoint = ccp(0.5f, 0.0f);
    _floor.contentSize = CGSizeMake(_designSize.width, FLOOR_HEIGHT);
    
    rect.size = _floor.contentSize;
    _floor.physicsBody = [CCPhysicsBody bodyWithRect:rect cornerRadius:0.0];
    _floor.physicsBody.type = CCPhysicsBodyTypeStatic;
    _floor.physicsBody.collisionType = @"floor";
    
    _floor.position = ccp(_designSize.width * 0.5f, 0.0f);
}

- (void)sceneUpdate:(CCTime)interval
{
    if(_gameState == TEST_PONG_PLAYING)
    {
        [self updateAI];
        [self handleOutOfBounds];
    }
}

#pragma mark game logic

- (void)updateAI
{
    if(_ballEffectNode.position.x + _ballEffectNode.contentSize.width * 0.5f > _designSize.width * 0.5f)
    {
        if([self canPaddleMoveTo:_ballEffectNode.position.y])
            _aiPaddle.position = ccp(_aiPaddle.position.x, _ballEffectNode.position.y);
    }
}

- (void)handleOutOfBounds
{
    if([self ballOutOfBounds])
    {
        _gameState = TESTS_PONG_GAMEOVER;
        
        // HACK
        _pixellateEffectNode.position = ccp(0.0f, 0.0f); // FIXME - Oleg. An effectnodes position without an actual effect handles behave different when an effect is added.
        [_pixellateEffectNode addEffect:_pixellateEffect];
        
        [self schedule:@selector(increasePixellate:) interval:1.0f/60.0f repeat:10 delay:0.0f];
        [self schedule:@selector(decreasePixellate:) interval:1.0f/60.0f repeat:10 delay:0.1f];
        [self scheduleOnce:@selector(resetGame:) delay:0.5f];
    }
}

- (void)resetGame:(CCTimer*)interval
{
    [self setupPlayerPaddle];
    [self setupAIPaddle];
    [self setupBall];

    // FIXME - make sure effect node reverts back to acting as empty node after all effects have been removed
    [_pixellateEffectNode removeEffect:_pixellateEffect];
    
    _gameState = TEST_PONG_PLAYING;
}

- (BOOL)ballOutOfBounds
{
    CGRect box = {CGPointZero, _designSize};
    CGPoint loc = _ballEffectNode.position;
    return !CGRectContainsPoint(box, loc);
}

#pragma mark touch

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInNode:self];
    if(location.x < _designSize.width * 0.5f)
    {
        if([self canPaddleMoveTo:location.y])
            _playerPaddle.position = ccp(_playerPaddle.position.x, location.y);
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInNode:self];
    if(location.x < _designSize.width * 0.5f)
    {
        if([self canPaddleMoveTo:location.y])
            _playerPaddle.position = ccp(_playerPaddle.position.x, location.y);
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

#pragma mark collision - Player

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair playerPaddle:(CCNode *)playerPaddle ball:(CCNode *)ball
{
    [ball.physicsBody applyImpulse:ccp(10, 0.0)];
}

- (void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair playerPaddle:(CCNode *)playerPaddle ball:(CCNode *)ball
{
    [ball.physicsBody applyImpulse:ccp(100, 0.0)];
    
    [self schedule:@selector(increaseBallBlur:) interval:1.0f/60.0f repeat:10 delay:0.0f];
    [self schedule:@selector(decreaseBallBlur:) interval:1.0f/60.0f repeat:10 delay:0.1f];
}

#pragma mark collision - AI

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair aiPaddle:(CCNode *)aiPaddle ball:(CCNode *)ball
{
    [ball.physicsBody applyImpulse:ccp(-10, 0.0)];
}

- (void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair aiPaddle:(CCNode *)aiPaddle ball:(CCNode *)ball
{
    [ball.physicsBody applyImpulse:ccp(-100, 0.0)];
    
    [self schedule:@selector(increaseBallBlur:) interval:1.0f/60.0f repeat:10 delay:0.0f];
    [self schedule:@selector(decreaseBallBlur:) interval:1.0f/60.0f repeat:10 delay:0.1f];
}

#pragma mark effect updates

- (void)increaseBallBlur:(CCTime)interval
{
    _ballEffect.blurStrength += 0.01;
}

- (void)decreaseBallBlur:(CCTime)interval
{
    _ballEffect.blurStrength -= 0.01f;
}

- (void)increasePixellate:(CCTime)interval
{
    _pixellateEffect.pixelScale += 0.001f;
}

- (void)decreasePixellate:(CCTime)interval
{
    _pixellateEffect.pixelScale -= 0.001f;
}

@end

#endif



