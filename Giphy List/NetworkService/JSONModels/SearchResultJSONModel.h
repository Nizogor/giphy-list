//
//  SearchResultJSONModel.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 01.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "GIFJSONModel.h"
#import "PaginationJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GIFJSONModel;

@interface SearchResultJSONModel : JSONModel

@property (nonatomic) NSArray<GIFJSONModel *><GIFJSONModel> *data;
@property (nonatomic) PaginationJSONModel *pagination;

@end

NS_ASSUME_NONNULL_END
