//
//  JSViewController.h
//  JSTransition
//
//  Created by John Setting on 01/08/2017.
//  Copyright (c) 2017 John Setting. All rights reserved.
//

@import UIKit;

@interface JSViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
