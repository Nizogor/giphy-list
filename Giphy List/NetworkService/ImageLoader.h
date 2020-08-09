//
//  ImageLoader.h
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageLoader;

NS_ASSUME_NONNULL_BEGIN

@protocol ImageLoaderListener <NSObject>

@property (nonatomic, readonly) NSString *urlString;

- (void)imageLoaderDidFinishLoadingImage:(NSData *)image;
- (void)imageLoaderDidFailLoadingImage;

@end

@interface ImageLoader : NSObject

- (void)addListener:(id<ImageLoaderListener>)listener;
- (void)removeListener:(id<ImageLoaderListener>)listener;

- (void)loadImageWithURL:(NSString *)urlString;
- (void)cancelLoadingImageWithURL:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
