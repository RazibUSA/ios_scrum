//
//  AnimationManager.h
//  PhotoBullet
//
//  Created by Najmul Hasan on 12/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AnimationManager : NSObject {
    
}

+ (AnimationManager*)sharedInstance;

-(void)doAppearViewFromTop:(UIView*)incomingView;
-(void)doAppearViewFromBottom:(UIView*)incomingView;

-(void)doDisappearViewToTop:(UIView*)incomingView;
-(void)doDisappearViewToBottom:(UIView*)incomingView;

-(void)doSingleLeftViewAnimation:(UIView*)incomingView;
-(void)doSingleRightViewAnimation:(UIView*)incomingView;

-(void)startFadeIn:(UIView*)candidate;
-(void)startFadeOut:(UIView*)candidate;

@end
