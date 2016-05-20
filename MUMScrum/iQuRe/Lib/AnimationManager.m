//
//  AnimationManager.m
//  PhotoBullet
//
//  Created by Najmul Hasan on 12/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnimationManager.h"


@implementation AnimationManager

+ (AnimationManager*)sharedInstance {
    static dispatch_once_t once;
    static AnimationManager *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[AnimationManager alloc] init]; });
    return sharedInstance;
}

-(void)doAppearViewFromTop:(UIView*)incomingView
{	
    CATransition *animation1 = [CATransition animation];
    [animation1 setType:kCATransitionPush];
    [animation1 setSubtype:kCATransitionFromBottom];
    [animation1 setDuration:0.5];
    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[incomingView layer] addAnimation:animation1 forKey:kCATransition];
	
	incomingView.hidden = NO;
}

-(void)doAppearViewFromBottom:(UIView*)incomingView
{	
    CATransition *animation1 = [CATransition animation];
    [animation1 setType:kCATransitionPush];
    [animation1 setSubtype:kCATransitionFromTop];
    [animation1 setDuration:0.5];
    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[incomingView layer] addAnimation:animation1 forKey:kCATransition];
	
	incomingView.hidden = NO;
}

-(void)doDisappearViewToTop:(UIView*)incomingView
{	
    CATransition *animation1 = [CATransition animation];
    [animation1 setType:kCATransitionPush];
    [animation1 setSubtype:kCATransitionFromTop];
    [animation1 setDuration:0.5];
    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[incomingView layer] addAnimation:animation1 forKey:kCATransition];
	
	incomingView.hidden = YES;
}

-(void)doDisappearViewToBottom:(UIView*)incomingView
{	
    CATransition *animation1 = [CATransition animation];
    [animation1 setType:kCATransitionPush];
    [animation1 setSubtype:kCATransitionFromBottom];
    [animation1 setDuration:0.5];
    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[incomingView layer] addAnimation:animation1 forKey:kCATransition];
	
	incomingView.hidden = YES;
}

-(void)doSingleLeftViewAnimation:(UIView*)incomingView
{	
    CATransition *animation1 = [CATransition animation];
    [animation1 setType:kCATransitionPush];
    [animation1 setSubtype:kCATransitionFromLeft];
    [animation1 setDuration:0.5];
    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[incomingView layer] addAnimation:animation1 forKey:kCATransition];
	
	incomingView.hidden = NO;
}

-(void)doSingleRightViewAnimation:(UIView*)incomingView
{	
    CATransition *animation1 = [CATransition animation];
	[animation1 setType:kCATransitionPush];
    [animation1 setSubtype:kCATransitionFromRight];
    [animation1 setDuration:0.5];
    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[incomingView layer] addAnimation:animation1 forKey:kCATransition];
	
	incomingView.hidden = NO;
}

-(void)doBottomViewAnimation:(UIView*)incomingView:(UIView*)outgoingView
{	
	// Set up the animation
    CATransition *animation1 = [CATransition animation];
	
    [animation1 setType:kCATransitionPush];
    [animation1 setSubtype:kCATransitionFromTop];
	
    [animation1 setDuration:0.5];
    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	CATransition *animation2 = [CATransition animation];
	
    [animation2 setType:kCATransitionPush];
    [animation2 setSubtype:kCATransitionFromBottom];
	
    [animation2 setDuration:0.5];
    [animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	
    [[incomingView layer] addAnimation:animation1 forKey:kCATransition];
	[[outgoingView layer] addAnimation:animation2 forKey:kCATransition];
	
	incomingView.hidden = NO;
	outgoingView.hidden = YES;
}

-(void)doTopViewAnimation:(UIView*)incomingView:(UIView*)outgoingView
{	
	// Set up the animation
    CATransition *animation1 = [CATransition animation];
	
    [animation1 setType:kCATransitionPush];
    [animation1 setSubtype:kCATransitionFromBottom];
	
    [animation1 setDuration:0.5];
    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	CATransition *animation2 = [CATransition animation];
	
    [animation2 setType:kCATransitionPush];
    [animation2 setSubtype:kCATransitionFromTop];
	
    [animation2 setDuration:0.5];
    [animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	
    [[incomingView layer] addAnimation:animation1 forKey:kCATransition];
	[[outgoingView layer] addAnimation:animation2 forKey:kCATransition];
	
	incomingView.hidden = NO;
	outgoingView.hidden = YES;
}

-(void)startFadeIn:(UIView*)candidate{
    
    [candidate setHidden:YES];
    [candidate setAlpha:0.f];
    [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [candidate setHidden:NO];
        [candidate setAlpha:1.f];
    } completion:nil];
}

-(void)startFadeOut:(UIView*)candidate{

    [candidate setAlpha:1.f];
    [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [candidate setAlpha:0.f];
        [candidate setHidden:YES];
    } completion:nil];
}
@end
