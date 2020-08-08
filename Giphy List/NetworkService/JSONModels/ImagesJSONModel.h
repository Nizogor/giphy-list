//
//  ImagesJSONModel.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "FixedHeightImageJSONModel.h"

 NS_ASSUME_NONNULL_BEGIN

@interface ImagesJSONModel : JSONModel

@property (nonatomic) FixedHeightImageJSONModel *fixedHeightSmall;

@end

NS_ASSUME_NONNULL_END
