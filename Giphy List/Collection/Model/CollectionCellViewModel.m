//
//  CollectionCellViewModel.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "CollectionCellViewModel.h"
#import "FixedHeightImageJSONModel.h"
#import "ImageLoader.h"

@interface CollectionCellViewModel () <ImageLoaderListener>

@property (nonatomic, nullable) NSData *image;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (nonatomic) CollectionCellViewModelState state;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic) ImageLoader *imageLoader;

@end

@implementation CollectionCellViewModel

- (instancetype)initWithWidth:(NSInteger)width
					   height:(NSInteger)height
						  url:(NSString *)urlString
				  imageLoader:(ImageLoader *)imageLoader {
	self = [super init];
	if (self) {
		_width = width;
		_height = height;

		_urlString = urlString;
		_imageLoader = imageLoader;
	}
	return self;
}

- (void)setDelegate:(id<CollectionCellViewModelDelegate>)delegate {
	_delegate = delegate;

	if (!delegate) {
		[self.imageLoader removeListener:self];

		switch (self.state) {
			case CollectionCellViewModelStateLoading:
				self.state = CollectionCellViewModelStateDefault;
				break;
			default:
				break;
		}
	}
}

- (void)updateImage {
	switch (self.state) {
		case CollectionCellViewModelStateDefault:
			[self loadImage];
			break;
		default:
			break;
	}
}

- (void)loadImage {
	self.state = CollectionCellViewModelStateLoading;
	[self updateView];

	[self.imageLoader addListener:self];
	[self.imageLoader loadImageWithURL:self.urlString];
}

- (void)updateView {
	[self.delegate viewModelDidChangeState:self];
}

#pragma mark - ImageLoaderListener

- (void)imageLoader:(ImageLoader *)imageLoader didLoadImage:(NSData *)image fromURL:(NSString *)urlString {
	[self.imageLoader removeListener:self];

	self.image = image;
	self.state = CollectionCellViewModelStateSuccess;
	[self updateView];
}

- (void)imageLoader:(ImageLoader *)imageLoader didFailLoadingImageWithURL:(NSString *)urlString {
	[self.imageLoader removeListener:self];

	self.state = CollectionCellViewModelStateDefault;
	[self updateView];
}

@end
