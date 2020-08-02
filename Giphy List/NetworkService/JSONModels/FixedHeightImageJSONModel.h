//
//  FixedHeightImageJSONModel.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface FixedHeightImageJSONModel : JSONModel

@property (nonatomic, nonnull) NSString *width;
@property (nonatomic, nonnull) NSString *height;
@property (nonatomic, nonnull) NSString *url;

@end

NS_ASSUME_NONNULL_END
