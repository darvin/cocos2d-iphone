//
//  CCAndroidMainActivity.m
//  cocos2d-ios
//
//  Created by Oleg Osin on 5/22/14.
//
//

#if __CC_PLATFORM_ANDROID
#import "CCAndroidMainActivity.h"
#import "CCGLView.h"

@implementation CCAndroidActivity {
    BOOL _initalized;
}

@bridge (callback) onCreate: = onCreate;
@bridge (callback) onStart = onStart;
@bridge (callback) onResume = onResume;
@bridge (callback) onPause = onPause;
@bridge (callback) surfaceChanged:format:width:height: = surfaceChanged;

- (void)onCreate:(AndroidBundle *)bundle
{
    _initalized = NO;
    [super onCreate:bundle];
    surface = [[CCGLView alloc] initWithContext:self];
    [self setContentView:surface];
    [surface.holder addCallback:self];
    
    CCDirectorAndroid* director = (CCDirectorAndroid*) [CCDirector sharedDirector];
    [director setView:surface];
}

- (void)initalize
{
    if(_initalized == YES)
        return;
    
    CCDirectorAndroid* director = (CCDirectorAndroid*) [CCDirector sharedDirector];
    [director.view setupView];
    
    // TODO: figure out how to pass the config through
    
    // set FPS at 60
	NSTimeInterval animationInterval = [(config[CCSetupAnimationInterval] ?: @(1.0/60.0)) doubleValue];
    [director setAnimationInterval:animationInterval];
	
	director.fixedUpdateInterval = [(config[CCSetupFixedUpdateInterval] ?: @(1.0/60.0)) doubleValue];
    
    if([config[CCSetupScreenMode] isEqual:CCScreenModeFixed]){
		CGSize size = [CCDirector sharedDirector].viewSizeInPixels;
		CGSize fixed = FIXED_SIZE;
		
		if([config[CCSetupScreenOrientation] isEqualToString:CCScreenOrientationPortrait]){
			CC_SWAP(fixed.width, fixed.height);
		}
		
		// Find the minimal power-of-two scale that covers both the width and height.
		CGFloat scaleFactor = MIN(FindPOTScale(size.width, fixed.width), FindPOTScale(size.height, fixed.height));
		
		director.contentScaleFactor = scaleFactor;
		director.UIScaleFactor = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 1.0 : 0.5);
		
		// Let CCFileUtils know that "-ipad" textures should be treated as having a contentScale of 2.0.
		[[CCFileUtils sharedFileUtils] setiPadContentScaleFactor: 2.0];
		
		director.designSize = fixed;
		[director setProjection:CCDirectorProjectionCustom];
	} else {
		// Setup tablet scaling if it was requested.
		if(
           UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
           [config[CCSetupTabletScale2X] boolValue]
           ){
			// Set the director to use 2 points per pixel.
			director.contentScaleFactor *= 2.0;
			
			// Set the UI scale factor to show things at "native" size.
			director.UIScaleFactor = 0.5;
			
			// Let CCFileUtils know that "-ipad" textures should be treated as having a contentScale of 2.0.
			[[CCFileUtils sharedFileUtils] setiPadContentScaleFactor:2.0];
		}
		
		[director setProjection:CCDirectorProjection2D];
	}
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change this setting at any time.
	[CCTexture setDefaultAlphaPixelFormat:CCTexturePixelFormat_RGBA8888];
    
    // Initialise OpenAL
    [OALSimpleAudio sharedInstance];
    
	// Android equivalent?
	// Create a Navigation Controller with the Director
    //	navController_ = [[CCNavigationController alloc] initWithRootViewController:director];
    //	navController_.navigationBarHidden = YES;
    //	navController_.appDelegate = self;
    //	navController_.screenOrientation = (config[CCSetupScreenOrientation] ?: CCScreenOrientationLandscape);
    
	// for rotation and other messages
	//[director setDelegate:navController_];
	
	// set the Navigation Controller as the root view controller
	//[window_ setRootViewController:navController_];
	
	// make main window visible
	//[window_ makeKeyAndVisible];

}

- (void)surfaceChanged:(AndroidSurfaceHolder *)holder format:(int)format width:(int)w height:(int)h
{
    // Will be called when a view is first created or the viewport changes size
    
    [self initalize];
    
    CCDirectorAndroid* director = (CCDirectorAndroid* )[CCDirector sharedDirector];
	[director reshapeProjection:CGSizeMake(w, h)];
}

- (void)onStart
{
    [[CCDirector sharedDirector] startAnimation];
}

- (void)onResume
{
    [[CCDirector sharedDirector] resume];
//    [[CCDirector sharedDirector] startAnimation]; ?
}

- (void)onPause
{
    [[CCDirector sharedDirector] pause];
//    [[CCDirector sharedDirector] stopAnimation]; ?
}

- (void)onStop
{
    // do a bunch of clean up here
    [[CCDirector sharedDirector] end];
}


@end
#endif

