//
//  CollectionViewLayout.m
//  Giphy List
//
//  Created by Nikita Teplyakov on 02.08.2020.
//  Copyright © 2020 Nikita Tepliakov. All rights reserved.
//

#import "CollectionViewLayout.h"

CGFloat const kLineHeight = 100;

@interface CollectionViewLayout ()

@property (nonatomic) NSArray<UICollectionViewLayoutAttributes *> *cachedAttributes;
@property (nonatomic) id<CollectionPresenterProtocol> presenter;
@property (nonatomic) CGFloat collectionViewWidth;

@end

@implementation CollectionViewLayout

- (instancetype)initWithPresenter:(id<CollectionPresenterProtocol>)presenter {
	self = [super init];
	if (self) {
		_cachedAttributes = @[];
		_presenter = presenter;
	}
	return self;
}

- (void)prepareLayout {
	[super prepareLayout];
	self.cachedAttributes = [self calculateAttributes];
}

- (nullable NSArray<UICollectionViewLayoutAttributes *> *)calculateAttributes {
	CGFloat availableWidth = CGRectGetWidth(self.collectionView.bounds);

	if (!availableWidth || !self.presenter.viewModels.count) {
		return nil;
	}

	NSInteger capacity = self.presenter.viewModels.count;
	NSMutableArray<UICollectionViewLayoutAttributes *> *result = [NSMutableArray arrayWithCapacity:capacity];

	CGFloat y = 0;
	CGFloat lineWidth = 0;
	NSInteger itemsInLine = 0;
	NSMutableArray<UICollectionViewLayoutAttributes *> *lineAttributes = @[].mutableCopy;

	for (NSInteger index = 0; index < self.presenter.viewModels.count; index++) {
		CollectionCellViewModel *viewModel = self.presenter.viewModels[index];

		CGFloat sizeMultiplier = (CGFloat)viewModel.height / kLineHeight;
		CGFloat desiredWidth = viewModel.width * sizeMultiplier;
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

		UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
		attributes.size = CGSizeMake(desiredWidth, kLineHeight);
		[lineAttributes addObject:attributes];

		lineWidth += desiredWidth;
		itemsInLine++;

		if (lineWidth >= availableWidth) {
			CGFloat x = 0;
			CGFloat delta = lineWidth - availableWidth;

			for (UICollectionViewLayoutAttributes *layoutAttributes in lineAttributes) {
				CGFloat widthCoefficient = layoutAttributes.size.width / lineWidth;
				CGFloat width = layoutAttributes.size.width - delta * widthCoefficient;
				layoutAttributes.frame = CGRectMake(x, y, width, kLineHeight);

				x += width;
			}

			[result addObjectsFromArray:lineAttributes];

			y += kLineHeight;
			lineWidth = 0;
			itemsInLine = 0;
			[lineAttributes removeAllObjects];
		}
	}

	return result;
}

- (CGSize)collectionViewContentSize {
	return CGSizeMake(self.collectionView.bounds.size.width, CGRectGetMaxY(self.cachedAttributes.lastObject.frame));
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
	NSRange range = NSMakeRange(0, self.cachedAttributes.count);
	UICollectionViewLayoutAttributes *attributes = [[UICollectionViewLayoutAttributes alloc] init];
	attributes.frame = rect;

	__auto_type comparator = ^NSComparisonResult(UICollectionViewLayoutAttributes *obj1,
												 UICollectionViewLayoutAttributes *obj2) {
		CGRect rect1 = obj1.frame;
		CGRect rect2 = obj2.frame;

		if (CGRectGetMaxY(rect1) < CGRectGetMinY(rect2)) {
			return NSOrderedAscending;
		}

		if (CGRectGetMinY(rect1) > CGRectGetMaxY(rect2)) {
			return NSOrderedDescending;
		}

		return NSOrderedSame;
	};

	NSInteger index = [self.cachedAttributes indexOfObject:attributes
											 inSortedRange:range
												   options:NSBinarySearchingFirstEqual
										   usingComparator:comparator];

	if (index != NSNotFound) {
		return [self layoutAttributesForElementsInRect:rect nearByElementAtIndex:index];
	} else {
		return nil;
	}
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
															  nearByElementAtIndex:(NSInteger)index {
	NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:index];

	for (NSInteger previousIndex = index - 1; previousIndex >= 0; previousIndex--) {
		UICollectionViewLayoutAttributes *previousAttributes = self.cachedAttributes[previousIndex];

		if (CGRectIntersectsRect(previousAttributes.frame, rect)) {
			[indexSet addIndex:previousIndex];
		} else {
			break;
		}
	}

	for (NSInteger nextIndex = index + 1; nextIndex < self.cachedAttributes.count; nextIndex++) {
		UICollectionViewLayoutAttributes *nextAttributes = self.cachedAttributes[nextIndex];

		if (CGRectIntersectsRect(nextAttributes.frame, rect)) {
			[indexSet addIndex:nextIndex];
		} else {
			break;
		}
	}

	return [self.cachedAttributes objectsAtIndexes:indexSet];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
	return self.cachedAttributes[indexPath.row];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
	return !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
}

@end
