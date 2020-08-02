//
//  ImagesJSONModel.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "ImagesJSONModel.h"

@implementation ImagesJSONModel

+ (JSONKeyMapper *)keyMapper {
	return JSONKeyMapper.mapperForSnakeCase;
}

@end
