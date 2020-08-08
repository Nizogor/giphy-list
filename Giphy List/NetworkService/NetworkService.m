//
//  NetworkService.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 01.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "NetworkService.h"

@interface NetworkService ()

@property (nonnull, readonly) RequestFactory *requestFactory;
@property (nonnull, readonly) NSError *defaultError;

@end

@implementation NetworkService

- (instancetype)initWithRequestFactory:(RequestFactory *)requestFactory {
	self = [super init];
	if (self) {
		_requestFactory = requestFactory;
		_defaultError = [NSError errorWithDomain:@"com.Giphy-List.networking"
											code:-101
										userInfo:@{ NSLocalizedDescriptionKey : @"Unknown error occured" }];
	}
	return self;
}

- (void)searchWithQuery:(NSString *)query
				  limit:(NSInteger)limit
				 offset:(NSInteger)offset
				success:(void (^)(SearchResultJSONModel *result))success
				failure:(void (^)(NSError *))failure {
	NSURLRequest *request = [self.requestFactory searchRequestWithQuery:query limit:limit offset:offset];

	if (request) {
		[self searchWithRequest:request success:success failure:failure];
	} else if (failure) {
		failure(self.defaultError);
	}
}

- (void)searchWithRequest:(NSURLRequest *)request
				  success:(void (^_Nullable)(SearchResultJSONModel *result))success
				  failure:(void (^_Nullable)(NSError *))failure {
	__weak typeof(self) wself = self;
	__auto_type completionHandler = ^(NSData * _Nullable data,
									  NSURLResponse * _Nullable response,
									  NSError * _Nullable error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[wself handleResponseData:data error:error success:success failure:failure];
		});
	};

	NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
															 completionHandler:completionHandler];
	[task resume];
}

- (void)handleResponseData:(nullable NSData *)data
					 error:(nullable NSError *)error
				   success:(void (^_Nullable)(SearchResultJSONModel *result))success
				   failure:(void (^_Nullable)(NSError *))failure {
	if (!error) {
		[self handleResponseData:data success:success failure:failure];
	} else if (failure) {
		failure(error);
	}
}

- (void)handleResponseData:(NSData *)data
				   success:(void (^_Nullable)(SearchResultJSONModel *result))success
				   failure:(void (^_Nullable)(NSError *))failure {
	NSError *error;
	id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

	if (!error) {
		[self handleResponseJSON:json success:success failure:failure];
	} else if (failure) {
		failure(error);
	}
}

- (void)handleResponseJSON:(NSDictionary *)json
				   success:(void (^_Nullable)(SearchResultJSONModel *result))success
				   failure:(void (^_Nullable)(NSError *))failure {
	NSError *error;
	SearchResultJSONModel *result = [[SearchResultJSONModel alloc] initWithDictionary:json error:&error];

	if (!error) {
		if (success) {
			success(result);
		}
	} else if (failure) {
		failure(error);
	}
}

@end
