//
//  CollectionViewCell.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "CollectionViewCell.h"
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface CollectionViewCell ()

@property (nonatomic) FLAnimatedImageView *imageView;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIImageView *refreshImageView;
@property (nonatomic, weak, nullable) CollectionCellViewModel *viewModel;
@property (nonatomic, getter=isSetup) BOOL setup;

@end

@implementation CollectionViewCell

- (void)prepareForReuse {
	[super prepareForReuse];

	self.viewModel.delegate = nil;
	self.viewModel = nil;
	self.imageView.image = nil;
	[self.activityIndicator stopAnimating];
}

- (void)setupWithViewModel:(CollectionCellViewModel *)viewModel {
	self.viewModel = viewModel;
	viewModel.delegate = self;

	[self setupCell];
	[self updateState];

	[viewModel updateImage];
}

- (void)updateState {
	switch (self.viewModel.state) {
		case CollectionCellViewModelStateDefault:
			self.imageView.animatedImage = nil;
			self.refreshImageView.hidden = NO;
			[self.activityIndicator stopAnimating];
			break;
		case CollectionCellViewModelStateLoading:
			self.imageView.animatedImage = nil;
			self.refreshImageView.hidden = YES;
			[self.activityIndicator startAnimating];
			break;
		case CollectionCellViewModelStateSuccess:
			self.imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.viewModel.image];
			self.refreshImageView.hidden = YES;
			[self.activityIndicator stopAnimating];
			break;
	}
}

- (void)setupCell {
	if (self.isSetup) {
		return;
	}

	self.contentView.backgroundColor = UIColor.whiteColor;
	self.clipsToBounds = YES;

	[self setupImageView];
	[self setupActivityIndicator];
	[self setupRefreshImageView];

	self.setup = YES;
}

- (void)setupImageView {
	self.imageView = [[FLAnimatedImageView alloc] init];
	self.imageView.layer.borderWidth = 1;
	self.imageView.layer.borderColor = UIColor.lightGrayColor.CGColor;
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.imageView];

	NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.imageView
																	 attribute:NSLayoutAttributeTop
																	 relatedBy:NSLayoutRelationEqual
																		toItem:self
																	 attribute:NSLayoutAttributeTop
																	multiplier:1
																	  constant:0];
	NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.imageView
																	  attribute:NSLayoutAttributeLeft
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:self
																	  attribute:NSLayoutAttributeLeft
																	 multiplier:1
																	   constant:0];
	NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView
																	   attribute:NSLayoutAttributeRight
																	   relatedBy:NSLayoutRelationEqual
																		  toItem:self
																	   attribute:NSLayoutAttributeRight
																	  multiplier:1
																		constant:0];
	NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.imageView
																		attribute:NSLayoutAttributeBottom
																		relatedBy:NSLayoutRelationEqual
																		   toItem:self
																		attribute:NSLayoutAttributeBottom
																	   multiplier:1
																		 constant:0];
	__auto_type constraints = @[topConstraint, leftConstraint, rightConstraint, bottomConstraint];
	[NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupActivityIndicator {
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
	self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.activityIndicator];

	NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:self.activityIndicator
																   attribute:NSLayoutAttributeCenterX
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self
																   attribute:NSLayoutAttributeCenterX
																  multiplier:1
																	constant:0];

	NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:self.activityIndicator
																   attribute:NSLayoutAttributeCenterY
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self
																   attribute:NSLayoutAttributeCenterY
																  multiplier:1
																	constant:0];
	__auto_type constraints = @[xConstraint, yConstraint];
	[NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupRefreshImageView {
	self.refreshImageView = [[UIImageView alloc] init];
	self.refreshImageView.image = [UIImage imageNamed:@"refresh"];
	self.refreshImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.refreshImageView];

	NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:self.refreshImageView
																   attribute:NSLayoutAttributeCenterX
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self
																   attribute:NSLayoutAttributeCenterX
																  multiplier:1
																	constant:0];

	NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:self.refreshImageView
																   attribute:NSLayoutAttributeCenterY
																   relatedBy:NSLayoutRelationEqual
																	  toItem:self
																   attribute:NSLayoutAttributeCenterY
																  multiplier:1
																	constant:0];
	__auto_type constraints = @[xConstraint, yConstraint];
	[NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - CollectionViewModelDelegate

- (void)viewModelDidChangeState:(CollectionCellViewModel *)viewModel {
	[self updateState];
}

@end
