//
//  GIFJSONModel.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "ImagesJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GIFJSONModel : JSONModel

@property (nonatomic, nonnull) ImagesJSONModel *images;

@end

NS_ASSUME_NONNULL_END
