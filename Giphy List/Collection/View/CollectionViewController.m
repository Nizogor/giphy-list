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

static NSString * const reuseIdentifier = @"CollectionViewCell";

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
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	[self setupNavigationItem];
	[self.presenter load];
}

- (void)setupNavigationItem {
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
	self.navigationItem.title = @"Giphy List";
}

#pragma mark <CollectionPresenterDelegate>

- (void)update {
	if (self.presenter.isLoading) {
		[self.activityIndicator startAnimating];
	} else {
		[self.activityIndicator stopAnimating];
	}

	[self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.presenter.viewModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
																							   forIndexPath:indexPath];
	cell.viewModel = self.presenter.viewModels[indexPath.row];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	CollectionCellViewModel *viewModel = self.presenter.viewModels[indexPath.row];
	[viewModel updateImage];
}

@end
