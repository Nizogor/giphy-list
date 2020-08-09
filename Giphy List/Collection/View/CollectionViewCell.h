//
//  CollectionViewCell.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell <CollectionCellViewModelDelegate>

- (void)setupWithViewModel:(CollectionCellViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
