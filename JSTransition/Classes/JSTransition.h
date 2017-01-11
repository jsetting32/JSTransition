//
//  JSTransition.h
//  Pods
//
//  Created by John Setting on 1/8/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JSTransition;

@protocol JSTransitionProtocol <NSObject>
- (CGRect)transitionSourceFrame;
- (CGRect)transitionDestinationFrame;
- (CGFloat)transitionDuration;
@end

@interface JSTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) BOOL presenting;
@property (weak, nonatomic, nullable) UIViewController <JSTransitionProtocol> *sourceController;
@property (weak, nonatomic, nullable) UIViewController <JSTransitionProtocol> *destinationController;
@end
