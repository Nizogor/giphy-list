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
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic, readonly) id<CollectionPresenterProtocol> presenter;
@property (nonatomic) NSLayoutConstraint *keyboardConstraint;

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
	self.view.backgroundColor = UIColor.whiteColor;
	[self setupNavigationItem];
	[self setupCollecitonView];
	[self.presenter load];
	[self setupSearchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)setupNavigationItem {
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
	self.navigationItem.title = @"Giphy List";
}

- (void)setupCollecitonView {
	[self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kImageCellReuseIdentifier];
	[self.collectionView registerClass:[UICollectionViewCell class]
			forCellWithReuseIdentifier:kLoadingCellReuseIdentifier];
	self.collectionView.backgroundColor = UIColor.whiteColor;
	self.collectionView.keyboardDismissMode = YES;
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
	[self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
	[self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
	[self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

- (void)setupSearchBar {
	UIView *expanderView = [[UIView alloc] init];
	expanderView.backgroundColor = UIColor.whiteColor;
	expanderView.translatesAutoresizingMaskIntoConstraints = NO;

	[self.view addSubview:expanderView];
	[expanderView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
	[expanderView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
	[expanderView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;

	self.searchBar = [[UISearchBar alloc] init];
	self.searchBar.layer.borderWidth = 0;
	self.searchBar.backgroundImage = [[UIImage alloc] init];
	self.searchBar.backgroundColor = UIColor.whiteColor;
	self.searchBar.placeholder = @"Search";
	self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;

	[self.view addSubview:self.searchBar];
	[self.searchBar.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
	[self.searchBar.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
	self.keyboardConstraint = [self.searchBar.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor];
	self.keyboardConstraint.active = YES;

	[expanderView.topAnchor constraintEqualToAnchor:self.searchBar.topAnchor].active = YES;
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
	CGRect endFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

	[UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
		self.keyboardConstraint.constant = -CGRectGetHeight(endFrame) + self.view.safeAreaInsets.bottom;
		[self.view layoutIfNeeded];
	} completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

	[UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
		self.keyboardConstraint.constant = 0;
		[self.view layoutIfNeeded];
	} completion:nil];
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
