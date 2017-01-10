//
//  JSTransition.m
//  Pods
//
//  Created by John Setting on 1/8/17.
//
//

#import "JSTransition.h"

//#define link

@interface JSTransition()
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) CGFloat time;
@property (assign, nonatomic) BOOL animating;
@property (strong, nonatomic) id <UIViewControllerContextTransitioning> transitionContext;

@property (assign, nonatomic) CGRect initialFrame;
@property (assign, nonatomic) CGRect finalFrame;
@property (assign, nonatomic) CFTimeInterval lastStep;
@property (assign, nonatomic) CFTimeInterval timeOffset;
@property (assign, nonatomic) CGAffineTransform scaleTransform;
@end

@implementation JSTransition

static CGFloat const transitionDurationDefault = 0.5f;
//static CGFloat const framesPerSecond = 60.0f;


- (instancetype)init {
    self = [super init];
    if (self) {
        _presenting = YES;
        _originFrame = CGRectZero;
        _time = 0.0f;
        _animating = NO;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.sourceController && [self.sourceController respondsToSelector:@selector(transitionDuration)]) {
        return [self.sourceController transitionDuration];
    }
    return transitionDurationDefault;
}

- (void)animate:(CADisplayLink *)displayLink {
    //calculate time delta
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
//    CFTimeInterval stepDuration = 1 / framesPerSecond;
    self.lastStep = thisStep;

    //update time offset
    CGFloat duration = [self.sourceController transitionDuration];
    self.timeOffset = MIN(self.timeOffset + stepDuration, duration);
    
    //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / duration;
    
    //apply easing
    //time = bounceEaseOut(time);

    CGPoint initialMid = CGPointMake(CGRectGetMidX(self.initialFrame), CGRectGetMidY(self.initialFrame));
    CGPoint destinationMid = CGPointMake(CGRectGetMidX(self.finalFrame), CGRectGetMidY(self.finalFrame));
    CGPoint center = [self interpolatePoint:initialMid to:destinationMid time:time];

    if (self.presenting) {
        //interpolate position
        UIViewController *toVC = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC.view.center = center;
        //toVC.view.transform = [self interpolateTransform:toVC.view.transform to:CGAffineTransformIdentity time:time];
    } else {
        UIViewController *fromVC = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        fromVC.view.center = center;
        //fromVC.view.transform = [self interpolateTransform:fromVC.view.transform to:self.scaleTransform time:time];
    }
    
    //stop the timer if we've reached the end of the animation
    if (self.timeOffset >= duration) {
        [self.transitionContext completeTransition:!self.transitionContext.transitionWasCancelled];
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIView *containerView = [transitionContext containerView];
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    
    self.initialFrame = [self.sourceController transitionSourceFrame];
    self.finalFrame = [self.destinationController transitionDestinationFrame];
    
    CGFloat xScaleFactor = self.initialFrame.size.width / self.finalFrame.size.width;
    CGFloat yScaleFactor = self.initialFrame.size.height / self.finalFrame.size.height;
    self.scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor);
    
    if (self.presenting) {
        toVC.view.transform = self.scaleTransform;
        toVC.view.center = CGPointMake(CGRectGetMidX(self.initialFrame), CGRectGetMidY(self.initialFrame));
        toVC.view.clipsToBounds = YES;
        [containerView addSubview:toVC.view];
    } else {
        CGFloat xScaleFactor = self.finalFrame.size.width / self.initialFrame.size.width;
        CGFloat yScaleFactor = self.finalFrame.size.height / self.initialFrame.size.height;
        self.scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor);
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    }
    
#ifdef link
    if (!self.animating) {
        self.animating = YES;
        self.transitionContext = transitionContext;
        self.lastStep = CACurrentMediaTime();
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animate:)];
        [self.displayLink setPreferredFramesPerSecond:framesPerSecond];
        [fromVC beginAppearanceTransition:NO animated:YES];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        return;
    }
#else
    [fromVC beginAppearanceTransition:NO animated:YES];
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        if (self.presenting) {
            //[toVC.view setTransform:CGAffineTransformIdentity];
            toVC.view.center = CGPointMake(CGRectGetMidX(self.finalFrame), CGRectGetMidY(self.finalFrame));
        } else {
            //[fromVC.view setTransform:self.scaleTransform];
            fromVC.view.center = CGPointMake(CGRectGetMidX(self.finalFrame), CGRectGetMidY(self.finalFrame));
        }
    } completion:^(BOOL finished) {
        if (self.presenting) {
            [fromVC endAppearanceTransition];
        } else {
            [toVC endAppearanceTransition];
        }
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
#endif
}

float bounceEaseOut(float t) {
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    } else {
        return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
    }
}

double_t interpolate(double_t from, double_t to, double_t time) {
    return (to - from) * time + from;
}

- (CGPoint)interpolatePoint:(CGPoint)from to:(CGPoint)to time:(CGFloat)time {
    return CGPointMake(interpolate(from.x, to.x, time),
                       interpolate(from.y, to.y, time));
}

- (CGAffineTransform)interpolateTransform:(CGAffineTransform)from to:(CGAffineTransform)to time:(CGFloat)time {
    return CGAffineTransformMake(interpolate(from.a, to.a, time),
                                 interpolate(from.b, to.b, time),
                                 interpolate(from.c, to.c, time),
                                 interpolate(from.d, to.d, time),
                                 interpolate(from.tx, to.tx, time),
                                 interpolate(from.ty, to.ty, time));
}


@end
