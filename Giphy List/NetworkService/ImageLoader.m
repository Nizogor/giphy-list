//
//  ImageLoader.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "ImageLoader.h"

@interface ImageLoader ()

@property (nonatomic) NSMapTable<NSString *, id<ImageLoaderListener>> *listeners;
@property (nonatomic) NSMapTable<NSString *, NSBlockOperation *> *operations;
@property (nonatomic) NSOperationQueue *operationQueue;
@property (nonatomic) dispatch_queue_t loadingQueue;

@end

@implementation ImageLoader

- (instancetype)init {
	self = [super init];
	if (self) {
		_listeners = [NSMapTable strongToWeakObjectsMapTable];
		_operations = [NSMapTable strongToWeakObjectsMapTable];
		_operationQueue = [[NSOperationQueue alloc] init];
		_loadingQueue = dispatch_queue_create("com.giphy-list.ImageLoader", DISPATCH_QUEUE_CONCURRENT);

		self.operationQueue.underlyingQueue = self.loadingQueue;
		self.operationQueue.maxConcurrentOperationCount = 4;
	}
	return self;
}

- (void)addListener:(id<ImageLoaderListener>)listener {
	[self.listeners setObject:listener forKey:listener.urlString];
}

- (void)removeListener:(id<ImageLoaderListener>)listener {
	[self.listeners setObject:nil forKey:listener.urlString];

	NSOperation *operation = [self.operations objectForKey:listener.urlString];
	[operation cancel];
}

- (void)loadImageWithURL:(NSString *)urlString {
	NSLog(@"%ld", self.operationQueue.operationCount);

	NSBlockOperation *existingOperation = [self.operations objectForKey:urlString];
	if (existingOperation.isReady || existingOperation.isExecuting) {
		return;
	}

	__weak typeof(self) wself = self;
	NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
		NSURL *url = [NSURL URLWithString:urlString];
		NSData *image;

		if (url) {
			image = [NSData dataWithContentsOfURL:url];
		}

		dispatch_async(dispatch_get_main_queue(), ^{
			id<ImageLoaderListener> listener = [wself.listeners objectForKey:urlString];

			if (image) {
				[listener imageLoaderDidFinishLoadingImage:image];
			} else {
				[listener imageLoaderDidFailLoadingImage];
			}

			[wself removeListener:listener];
		});
	}];

	[self.operationQueue addOperation:operation];
	[self.operations setObject:operation forKey:urlString];
}

- (void)cancelLoadingImageWithURL:(NSString *)urlString {
	NSOperation *operation = [self.operations objectForKey:urlString];
	[operation cancel];
}

@end
