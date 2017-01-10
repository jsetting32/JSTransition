//
//  JSCollectionViewCell.h
//  JSTransition
//
//  Created by John Setting on 1/8/17.
//  Copyright © 2017 John Setting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
+ (NSString *)reuseIdentifier;
@end
