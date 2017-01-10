//
//  JSCollectionViewCell.m
//  JSTransition
//
//  Created by John Setting on 1/8/17.
//  Copyright © 2017 John Setting. All rights reserved.
//

#import "JSCollectionViewCell.h"

@implementation JSCollectionViewCell
+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}
@end
