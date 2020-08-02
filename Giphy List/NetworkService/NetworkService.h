//
//  NetworkService.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 01.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "SearchResultJSONModel.h"

@class RequestFactory;

NS_ASSUME_NONNULL_BEGIN

@interface NetworkService : NSObject

- (instancetype)initWithRequestFactory:(RequestFactory *)requestFactory;

- (void)searchWithQuery:(NSString *)query
				  limit:(NSInteger)limit
				 offset:(NSInteger)offset
				success:(void (^)(SearchResultJSONModel *result))success
				failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
