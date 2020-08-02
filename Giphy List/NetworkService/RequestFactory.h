//
//  RequestFactory.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 01.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestFactory : NSObject

- (nullable NSURLRequest *)searchRequestWithQuery:(NSString *)query limit:(NSInteger)limit offset:(NSInteger)offset;

@end

NS_ASSUME_NONNULL_END
