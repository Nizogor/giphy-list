//
//  RequestFactory.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 01.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "RequestFactory.h"

NSString *const kAPIKey = @"vEYCeVKXIKox4NAaK50VWeg8YQ9cdmEq";
NSString *const kBaseURLString = @"https://api.giphy.com/v1/gifs/search";

@implementation RequestFactory

- (nullable NSURLRequest *)searchRequestWithQuery:(NSString *)query limit:(NSInteger)limit offset:(NSInteger)offset {
	NSURLComponents *components = [[NSURLComponents alloc] init];
	components.queryItems = [self queryItemsWithQuery:query limit:limit offset:offset];
	NSString *queryString = components.query ?: @"";

	NSString *urlString = [NSString stringWithFormat:@"%@?%@", kBaseURLString, queryString];
	NSURL *url = [NSURL URLWithString:urlString];
	if (url) {
		NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
		urlRequest.timeoutInterval = 10;

		return urlRequest;
	} else {
		return nil;
	}
}

- (NSArray<NSURLQueryItem *> *)queryItemsWithQuery:(NSString *)query limit:(NSInteger)limit offset:(NSInteger)offset {
	NSString *limitString = [NSString stringWithFormat:@"%ld", limit];
	NSString *offsetString = [NSString stringWithFormat:@"%ld", offset];

	NSURLQueryItem *apiKeyItem = [NSURLQueryItem queryItemWithName:@"api_key" value:kAPIKey];
	NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:@"q" value:query];
	NSURLQueryItem *limitItem = [NSURLQueryItem queryItemWithName:@"limit" value:limitString];
	NSURLQueryItem *offsetItem = [NSURLQueryItem queryItemWithName:@"offset" value:offsetString];

	return @[apiKeyItem, queryItem, limitItem, offsetItem];
}

@end
