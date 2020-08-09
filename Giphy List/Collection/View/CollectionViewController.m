//
//  CollectionViewController.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewLayout.h"
#import "CollectionViewCell.h"

@interface CollectionViewController ()

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readonly) id<CollectionPresenterProtocol> presenter;

@end

@implementation CollectionViewController

static NSString * const kImageCellReuseIdentifier = @"CollectionViewCell";
static NSString * const kLoadingCellReuseIdentifier = @"CollectionViewLoadCell";

- (instancetype)initWithPresenter:(id<CollectionPresenterProtocol>)presenter {
	CollectionViewLayout *layout = [[CollectionViewLayout alloc] initWithPresenter:presenter];
	self = [super initWithCollectionViewLayout:layout];
	if (self) {
		_presenter = presenter;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kImageCellReuseIdentifier];
	[self.collectionView registerClass:[UICollectionViewCell class]
			forCellWithReuseIdentifier:kLoadingCellReuseIdentifier];
	[self setupNavigationItem];
	[self.presenter load];
}

- (void)setupNavigationItem {
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
	self.navigationItem.title = @"Giphy List";
}

#pragma mark <CollectionPresenterDelegate>

- (void)updateList {
	[self.collectionViewLayout invalidateLayout];
	[self.collectionView reloadData];
}

- (void)updateIsLoading {
	if (self.presenter.isLoading) {
		[self.activityIndicator startAnimating];
	} else {
		[self.activityIndicator stopAnimating];
	}
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	switch (section) {
		case CollectionViewControllerImagesSection:
			return self.presenter.viewModels.count;
		case CollectionViewControllerLoadMoreSection:
			return 1;
		default:
			return 0;
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case CollectionViewControllerImagesSection:
			return [self collectionView:collectionView imageCellForItemAtIndexPath:indexPath];
		case CollectionViewControllerLoadMoreSection:
			return [self collectionView:collectionView loadingCellForItemAtIndexPath:indexPath];
		default:
			return nil;
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			 imageCellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kImageCellReuseIdentifier forIndexPath:indexPath];
	cell.viewModel = self.presenter.viewModels[indexPath.row];

    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
		   loadingCellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLoadingCellReuseIdentifier
																		   forIndexPath:indexPath];
	cell.backgroundColor = UIColor.whiteColor;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case CollectionViewControllerImagesSection: {
			CollectionCellViewModel *viewModel = self.presenter.viewModels[indexPath.row];
			[viewModel updateImage];
			break;
		}
		case CollectionViewControllerLoadMoreSection:
			[self.presenter load];
			break;
		default:
			break;
	}
}

- (void)collectionView:(UICollectionView *)collectionView
	   willDisplayCell:(UICollectionViewCell *)cell
	forItemAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case CollectionViewControllerLoadMoreSection:
			[self.presenter load];
			break;
		default:
			break;
	}
}

@end
