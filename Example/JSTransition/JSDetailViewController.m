//
//  JSDetailViewController.m
//  JSTransition
//
//  Created by John Setting on 1/8/17.
//  Copyright © 2017 John Setting. All rights reserved.
//

#import "JSDetailViewController.h"

#import <JSTransition/JSTransition.h>

@interface JSDetailViewController () <JSTransitionProtocol>

@end

@implementation JSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self.imageView addGestureRecognizer:gesture];
}

- (void)dismiss:(UITapGestureRecognizer *)gesture {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)transitionDuration {
    return 1.0f;
}

- (CGRect)transitionDestinationFrame {
    return [self.view frame];
}

- (CGRect)transitionSourceFrame {
    return [self.view frame];
}

@end
