//
//  SearchResultJSONModel.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 01.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "SearchResultJSONModel.h"

@implementation SearchResultJSONModel

+ (JSONKeyMapper *)keyMapper {
	return JSONKeyMapper.mapperForSnakeCase;
}

@end
