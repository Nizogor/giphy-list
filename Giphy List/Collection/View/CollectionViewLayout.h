//
//  CollectionViewLayout.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionPresenter.h"

typedef NS_ENUM(NSUInteger, CollectionViewControllerSection) {
	CollectionViewControllerImagesSection,
	CollectionViewControllerLoadMoreSection
};

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewLayout : UICollectionViewLayout

- (instancetype)initWithPresenter:(id<CollectionPresenterProtocol>)presenter;

@end

NS_ASSUME_NONNULL_END
