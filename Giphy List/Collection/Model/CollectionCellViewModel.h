//
//  CollectionCellViewModel.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageLoader;
@class CollectionCellViewModel;

typedef NS_ENUM(NSUInteger, CollectionCellViewModelState) {
	CollectionCellViewModelStateDefault,
	CollectionCellViewModelStateLoading,
	CollectionCellViewModelStateSuccess
};

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionCellViewModelDelegate <NSObject>

- (void)viewModelDidChangeState:(CollectionCellViewModel *)viewModel;

@end

@interface CollectionCellViewModel : NSObject

@property (nonatomic, readonly, nullable) NSData *image;
@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, readonly) NSInteger height;
@property (nonatomic, readonly) CollectionCellViewModelState state;
@property (nonatomic, weak, nullable) id<CollectionCellViewModelDelegate> delegate;

- (instancetype)initWithWidth:(NSInteger)width
					   height:(NSInteger)height
						  url:(NSString *)urlString
				  imageLoader:(ImageLoader *)imageLoader;

- (void)updateImage;

@end

NS_ASSUME_NONNULL_END
