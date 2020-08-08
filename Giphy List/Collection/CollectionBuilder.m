//
//  CollectionBuilder.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "CollectionBuilder.h"
#import "CollectionViewController.h"
#import "NetworkService.h"

@implementation CollectionBuilder

- (UIViewController *)buildModule {
	RequestFactory *requestFactory = [[RequestFactory alloc] init];
	NetworkService *networkService = [[NetworkService alloc] initWithRequestFactory:requestFactory];
	CollectionPresenter *presenter = [[CollectionPresenter alloc] initWithNetworkService:networkService];

	CollectionViewController *viewController = [[CollectionViewController alloc] initWithPresenter:presenter];
	presenter.delegate = viewController;

	return viewController;
}

@end
