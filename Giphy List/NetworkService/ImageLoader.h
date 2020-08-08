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

- (void)imageLoader:(ImageLoader *)imageLoader didLoadImage:(NSData *)image fromURL:(NSString *)urlString;
- (void)imageLoader:(ImageLoader *)imageLoader didFailLoadingImageWithURL:(NSString *)urlString;

@end

@interface ImageLoader : NSObject

- (void)addListener:(id<ImageLoaderListener>)listener;
- (void)removeListener:(id<ImageLoaderListener>)listener;

- (void)loadImageWithURL:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
