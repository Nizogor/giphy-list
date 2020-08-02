//
//  PaginationJSONModel.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 01.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaginationJSONModel : JSONModel

@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSInteger count;

@end

NS_ASSUME_NONNULL_END
