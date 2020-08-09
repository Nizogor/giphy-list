//
//  CollectionPresenter.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "CollectionPresenter.h"
#import "NetworkService.h"
#import "ImageLoader.h"

NSInteger const kLimit = 100;

@interface CollectionPresenter ()

@property (nonatomic) BOOL isLoading;
@property (nonatomic) NSMutableArray<CollectionCellViewModel *> *viewModels;
@property (nonatomic, nullable) PaginationJSONModel *pagination;

@property (nonatomic) id<NetworkServiceProtocol> networkService;

@end

@implementation CollectionPresenter

- (instancetype)initWithNetworkService:(id<NetworkServiceProtocol>)networkService {
	self = [super init];
	if (self) {
		_viewModels = @[].mutableCopy;
		_networkService = networkService;
	}
	return self;
}

- (void)load {
	if (self.isLoading && self.viewModels.count < self.pagination.count) {
		return;
	}

	self.isLoading = YES;
	[self.delegate updateIsLoading];

	__weak typeof(self) wself = self;

	[self.networkService searchWithQuery:@"test" limit:kLimit offset:self.viewModels.count success:^(SearchResultJSONModel * _Nonnull result) {
		NSMutableArray<CollectionCellViewModel *> *newViewModels = @[].mutableCopy;

		for (GIFJSONModel *model in result.data) {
			NSInteger width = model.images.fixedHeightSmall.width.integerValue;
			NSInteger height = model.images.fixedHeightSmall.height.integerValue;
			NSString *url = model.images.fixedHeightSmall.url;
			ImageLoader *imageLoader = [[ImageLoader alloc] init];
			CollectionCellViewModel *viewModel = [[CollectionCellViewModel alloc] initWithWidth:width
																						 height:height
																							url:url
																					imageLoader:imageLoader];
			[newViewModels addObject:viewModel];
		}

		wself.isLoading = NO;
		[wself.viewModels addObjectsFromArray:newViewModels];
		[wself.delegate updateIsLoading];
		[wself.delegate updateList];
	} failure:^(NSError * _Nonnull error) {
		wself.isLoading = NO;
		[wself.delegate updateIsLoading];
	}];
}

@end
