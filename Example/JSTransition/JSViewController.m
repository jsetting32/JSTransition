//
//  JSViewController.m
//  JSTransition
//
//  Created by John Setting on 01/08/2017.
//  Copyright (c) 2017 John Setting. All rights reserved.
//

#import "JSViewController.h"

#import "JSCollectionViewCell.h"

#import <JSTransition/JSTransition.h>


@interface JSViewController () <JSTransitionProtocol, UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) JSTransition *transition;
@property (weak, nonatomic) JSCollectionViewCell *cell;
@end

@implementation JSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[JSCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat min = MIN(collectionView.frame.size.height, collectionView.frame.size.width);
    CGFloat width = min / 3.0f;
    return CGSizeMake(width, width);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (CGRect)transitionSourceFrame {
    NSArray <NSIndexPath *> * indexPaths = [self.collectionView indexPathsForSelectedItems];
    NSIndexPath *firstIndexPath = [indexPaths firstObject];
    JSCollectionViewCell *cell = (JSCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:firstIndexPath];
    CGRect cellFrameInSuperview = [cell.imageView convertRect:cell.imageView.frame toView:self.collectionView.superview];
    return cellFrameInSuperview;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = (JSCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
}

- (CGRect)transitionDestinationFrame {
    NSArray <NSIndexPath *> * indexPaths = [self.collectionView indexPathsForSelectedItems];
    NSIndexPath *firstIndexPath = [indexPaths firstObject];
    JSCollectionViewCell *cell = (JSCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:firstIndexPath];
    CGRect cellFrameInSuperview = [cell.imageView convertRect:cell.imageView.frame toView:self.collectionView.superview];
    return cellFrameInSuperview;
}


- (CGFloat)transitionDuration {
    return 1.0f;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    UIViewController <JSTransitionProtocol> *sourceController = (UIViewController <JSTransitionProtocol> *)source;
    UIViewController <JSTransitionProtocol> *presentingController = (UIViewController <JSTransitionProtocol> *)presented;
    if ([sourceController conformsToProtocol:@protocol(JSTransitionProtocol)] &&
        [presentingController conformsToProtocol:@protocol(JSTransitionProtocol)]) {
        JSTransition *transition = [[JSTransition alloc] init];
        transition.presenting = YES;
        transition.originFrame = [self transitionSourceFrame];
        transition.sourceController = sourceController;
        transition.destinationController = presentingController;
        return transition;
    }
    return nil;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    UIViewController <JSTransitionProtocol> *sourceController = (UIViewController <JSTransitionProtocol> *)dismissed;
    UIViewController <JSTransitionProtocol> *presentingController = self;
    if ([sourceController conformsToProtocol:@protocol(JSTransitionProtocol)] &&
        [presentingController conformsToProtocol:@protocol(JSTransitionProtocol)]) {
        JSTransition *transition = [[JSTransition alloc] init];
        transition.presenting = NO;
        transition.originFrame = [self transitionSourceFrame];
        transition.sourceController = sourceController;
        transition.destinationController = presentingController;
        return transition;
    }
    return nil;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    UIViewController *vc = segue.destinationViewController;
    vc.transitioningDelegate = self;
}

@end
