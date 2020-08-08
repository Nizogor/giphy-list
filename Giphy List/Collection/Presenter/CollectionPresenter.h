//
//  CollectionPresenter.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "CollectionCellViewModel.h"

@protocol NetworkServiceProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionPresenterProtocol <NSObject>

@property (nonatomic, readonly) BOOL isLoading;
@property (nonatomic, readonly) NSArray<CollectionCellViewModel *> *viewModels;

- (void)load;

@end

@protocol CollectionPresenterDelegate <NSObject>

- (void)update;

@end

@interface CollectionPresenter : NSObject <CollectionPresenterProtocol>

@property (nonatomic, weak, nullable) id<CollectionPresenterDelegate> delegate;

- (instancetype)initWithNetworkService:(id<NetworkServiceProtocol>)networkService;

@end

NS_ASSUME_NONNULL_END
