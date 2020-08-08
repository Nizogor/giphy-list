//
//  ImageLoader.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "ImageLoader.h"

@interface ImageLoader ()

@property (nonatomic) NSMutableDictionary<NSString *, NSData *> *sessionCache;
@property (nonatomic) NSMutableSet<NSString *> *imagesToLoad;
@property (nonatomic) NSMutableSet<NSString *> *loadingImages;
@property (nonatomic) NSMapTable<id<ImageLoaderListener>, NSString *> *listeners;

@property dispatch_semaphore_t semafor;
@property dispatch_queue_t loadingQueue;
@property dispatch_queue_t serialQueue;
@property (nonatomic) BOOL isLoading;

@end

@implementation ImageLoader

- (instancetype)init {
	self = [super init];
	if (self) {
		_sessionCache = @{}.mutableCopy;
		_imagesToLoad = [NSMutableSet set];
		_loadingImages = [NSMutableSet set];
		_listeners = [NSMapTable weakToWeakObjectsMapTable];

		_semafor = dispatch_semaphore_create(4);
		_loadingQueue = dispatch_queue_create("com.giphy-list.ImageLoader", DISPATCH_QUEUE_CONCURRENT);
	}
	return self;
}

- (BOOL)threadSafeIsLoading {
	__block BOOL result;
	dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		result = _isLoading;
	});

	return result;
}

- (void)setIsLoading:(BOOL)isLoading {
	dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		_isLoading = isLoading;
	});
}

- (void)addListener:(id<ImageLoaderListener>)listener {
	NSLog(@"addListener: %@", listener.urlString);
	[self.listeners setObject:listener.urlString forKey:listener];
}

- (void)removeListener:(id<ImageLoaderListener>)listener {
	NSLog(@"removeListener: %@", listener.urlString);
	[self.imagesToLoad removeObject:listener.urlString];
	[self.listeners removeObjectForKey:listener];
}

- (void)loadImageWithURL:(NSString *)urlString {
	NSData *image = self.sessionCache[urlString];

	if (image) {
		[self notifyListenersWithImage:image urlString:urlString];
		return;
	}

	if (![self.loadingImages containsObject:urlString]) {
		[self.imagesToLoad addObject:urlString];
	}

	if (!self.threadSafeIsLoading) {
		[self loadImages];
	}
}

- (void)loadImages {
	self.isLoading = YES;

	typeof(self) wself = self;
	dispatch_queue_t loadingQueue = self.loadingQueue;
	dispatch_semaphore_t semafor = self.semafor;

	dispatch_async(loadingQueue, ^{
		while (wself.threadSafeIsLoading) {
			dispatch_semaphore_wait(semafor, DISPATCH_TIME_FOREVER);

			dispatch_async(dispatch_get_main_queue(), ^{
				NSString *urlString = [wself nextImageToLoad];

				if (urlString) {
					dispatch_async(loadingQueue, ^{
						NSData *image = [wself loadImage:urlString];

						dispatch_async(dispatch_get_main_queue(), ^{
							[wself finishLoadingImage:image fromURL:urlString];
							dispatch_semaphore_signal(semafor);
						});
					});
				} else {
					wself.isLoading = NO;
					dispatch_semaphore_signal(semafor);
				}
			});
		}
	});
}

- (nullable NSString *)nextImageToLoad {
	NSString *urlString = [self.imagesToLoad anyObject];

	if (urlString) {
		[self.imagesToLoad removeObject:urlString];
		[self.loadingImages addObject:urlString];
	}

	return urlString;
}

- (nullable NSData *)loadImage:(NSString *)imageURL {
	NSURL *url = [NSURL URLWithString:imageURL];

	if (url) {
		return [NSData dataWithContentsOfURL:url];
	} else {
		return nil;
	}
}

- (void)finishLoadingImage:(nullable NSData *)image fromURL:(NSString *)urlString {
	[self.loadingImages removeObject:urlString];

	if (image) {
		self.sessionCache[urlString] = image;
	}

	[self notifyListenersWithImage:image urlString:urlString];
}

- (void)notifyListenersWithImage:(nullable NSData *)image urlString:(NSString *)urlString {
	NSMutableArray<id<ImageLoaderListener>> *listeners = [NSMutableArray array];

	for (id<ImageLoaderListener> listener in self.listeners) {
		if ([listener.urlString isEqualToString:urlString]) {
			[listeners addObject:listener];
		}
	}

	for (id<ImageLoaderListener> listener in listeners) {
		if (image) {
			[listener imageLoader:self didLoadImage:image fromURL:urlString];
		} else {
			[listener imageLoader:self didFailLoadingImageWithURL:urlString];
		}
	}
}

@end
