//
//  NetworkService.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 01.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "SearchResultJSONModel.h"
#import "RequestFactory.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NetworkServiceProtocol <NSObject>

- (void)searchWithQuery:(NSString *)query
				  limit:(NSInteger)limit
				 offset:(NSInteger)offset
				success:(void (^)(SearchResultJSONModel *result))success
				failure:(void (^)(NSError *error))failure;

@end

@interface NetworkService : NSObject <NetworkServiceProtocol>

- (instancetype)initWithRequestFactory:(RequestFactory *)requestFactory;

@end

NS_ASSUME_NONNULL_END
