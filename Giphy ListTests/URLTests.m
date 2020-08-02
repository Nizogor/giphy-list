//
//  URLTests.m
//  Giphy ListTests
//
//  Created by Nikita Teplyakov on 01.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetworkService.h"
#import "RequestFactory.h"

@interface URLTests : XCTestCase

@property (nonatomic) NetworkService *networkService;

@end

@implementation URLTests

- (void)setUp {
	RequestFactory *requestFactory = [[RequestFactory alloc] init];
	self.networkService = [[NetworkService alloc] initWithRequestFactory:requestFactory];
}

- (void)testSearchRequest {
	XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

	[self.networkService searchWithQuery:@"test" limit:10 offset:0 success:^(SearchResultJSONModel * _Nonnull result) {
		XCTAssertTrue([result.data.firstObject.images.fixedHeight.height isEqualToString:@"200"]);
		[expectation fulfill];
	} failure:^(NSError * _Nonnull error) {
		XCTFail();
		[expectation fulfill];
	}];

	XCTWaiter *waiter = [[XCTWaiter alloc] init];
	[waiter waitForExpectations:@[expectation] timeout:5];

	XCTAssertEqual(waiter.fulfilledExpectations.count, 1);
}

@end
