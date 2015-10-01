//
//  OLPhotoViewController.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 16/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import "OLPhotoViewController.h"
#import "OLFacebookAlbum.h"
#import "OLFacebookImagePickerCell.h"
#import "OLFacebookPhotosForAlbumRequest.h"
#import "OLFacebookImage.h"
#import "OLFacebookImagePickerController.h"

#import <tgmath.h>

static NSString *const kImagePickerCellReuseIdentifier = @"co.oceanlabs.facebookimagepicker.kImagePickerCellReuseIdentifier";
static NSString *const kSupplementaryViewFooterReuseIdentifier = @"co.oceanlabs.ps.kSupplementaryViewHeaderReuseIdentifier";

@interface SupplementaryView : UICollectionReusableView
@end

@interface OLPhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) OLFacebookAlbum *album;
@property (nonatomic, strong) OLFacebookPhotosForAlbumRequest *nextPageRequest, *inProgressRequest;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, strong) NSMutableArray/*<OLInstagramImage>*/ *selectedImagesInFuturePages; // selected images that don't yet occur in collectionView.indexPathsForSelectedItems as the user needs to load more instagram pages first
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSArray *overflowPhotos; // We can only insert multiples of 4 images each request, overflow must be saved and inserted on a subsequent request.
@end

@implementation OLPhotoViewController

- (id)initWithAlbum:(OLFacebookAlbum *)album {
    NSBundle *currentBundle = [NSBundle bundleForClass:[OLPhotoViewController class]];
    if (self = [self initWithNibName:NSStringFromClass([OLPhotoViewController class]) bundle:currentBundle]) {
        self.album = album;
        self.title = album.name;
        self.photos = [[NSMutableArray alloc] init];
        self.selectedImagesInFuturePages = [[NSMutableArray alloc] init];
        self.overflowPhotos = @[];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onButtonDoneClicked)];
    
    CGFloat itemSize = MIN([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)/4.0 - 1.0;
    
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                     = CGSizeMake(itemSize, itemSize);
    layout.sectionInset                 = UIEdgeInsetsMake(9.0, 0, 0, 0);
    layout.minimumInteritemSpacing      = 1.0;
    layout.minimumLineSpacing           = 1.0;
    layout.footerReferenceSize          = CGSizeMake(0, 0);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.allowsMultipleSelection = YES;
    
    [self.collectionView registerClass:[OLFacebookImagePickerCell class] forCellWithReuseIdentifier:kImagePickerCellReuseIdentifier];
    [self.collectionView registerClass:[SupplementaryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSupplementaryViewFooterReuseIdentifier];
    
    self.nextPageRequest = [[OLFacebookPhotosForAlbumRequest alloc] initWithAlbum:self.album];
    [self loadNextPage];
}

- (NSArray *)selected {
    NSMutableArray *selectedItems = [[NSMutableArray alloc] init];
    NSArray *selectedPaths = self.collectionView.indexPathsForSelectedItems;
    for (NSIndexPath *path in selectedPaths) {
        OLFacebookImage *image = [self.photos objectAtIndex:path.item];
        [selectedItems addObject:image];
    }
    
    [selectedItems addObjectsFromArray:self.selectedImagesInFuturePages];
    
    return selectedItems;
}

- (void)setSelected:(NSArray *)selected {
    // clear currently selected
    for (NSIndexPath *path in self.collectionView.indexPathsForSelectedItems) {
        [self.collectionView deselectItemAtIndexPath:path animated:NO];
    }
    
    // select any items in the collection view as appropriate, any items that have yet to be downloaded (due to the user not scrolling far enough)
    // are stored for selecting later when we fetch future pages.
    NSMutableArray *selectedImagesInFuturePages = [[NSMutableArray alloc] init];
    for (OLFacebookImage *image in selected) {
        NSUInteger itemIndex = [self.photos indexOfObject:image];
        if (itemIndex == NSNotFound) {
            [selectedImagesInFuturePages addObject:image];
        } else {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    
    self.selectedImagesInFuturePages = selectedImagesInFuturePages;
}

- (void)loadNextPage {
    self.inProgressRequest = self.nextPageRequest;
    self.nextPageRequest = nil;
    [self.inProgressRequest getPhotos:^(NSArray *photos, NSError *error, OLFacebookPhotosForAlbumRequest *nextPageRequest) {
        self.inProgressRequest = nil;
        self.nextPageRequest = nextPageRequest;
        self.loadingIndicator.hidden = YES;
        
        if (error) {
            [self.delegate photoViewController:self didFailWithError:error];
            return;
        }
        
        NSAssert(self.overflowPhotos.count < 4, @"oops");
        NSUInteger photosStartCount = self.photos.count;
        [self.photos addObjectsFromArray:self.overflowPhotos];
        if (nextPageRequest != nil) {
            // only insert multiple of 4 images so we fill complete rows
            NSInteger overflowCount = (self.photos.count + photos.count) % 4;
            [self.photos addObjectsFromArray:[photos subarrayWithRange:NSMakeRange(0, photos.count - overflowCount)]];
            self.overflowPhotos = [photos subarrayWithRange:NSMakeRange(photos.count - overflowCount, overflowCount)];
        } else {
            // we've exhausted all the users images so show the remainder
            [self.photos addObjectsFromArray:photos];
            self.overflowPhotos = @[];
        }
        
        // Insert new items
        NSMutableArray *addedItemPaths = [[NSMutableArray alloc] init];
        for (NSUInteger itemIndex = photosStartCount; itemIndex < self.photos.count; ++itemIndex) {
            [addedItemPaths addObject:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
        }
        
        [self.collectionView insertItemsAtIndexPaths:addedItemPaths];
        ((UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout).footerReferenceSize = CGSizeMake(0, nextPageRequest == nil ? 0 : 44);
        
        // If any of the items in the newly loaded page were previously selected then make them selected
        NSMutableArray *selectedItemsInThisPage = [[NSMutableArray alloc] init];
        for (NSUInteger itemIndex = photosStartCount; itemIndex < self.photos.count; ++itemIndex) {
            OLFacebookImage *image = self.photos[itemIndex];
            if ([self.selectedImagesInFuturePages indexOfObject:image] != NSNotFound) {
                [selectedItemsInThisPage addObject:image];
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
        [self.selectedImagesInFuturePages removeObjectsInArray:selectedItemsInThisPage];
    }];

}

- (void)onButtonDoneClicked {
    [self.inProgressRequest cancel];
    [self.delegate photoViewControllerDoneClicked:self];
}

-(void) updateTitleWithSelectedIndexPaths:(NSArray *)indexPaths{
    // Reset title to group name
    if (indexPaths.count == 0)
    {
        self.title = self.album.name;
        return;
    }
    
    NSString *format = (indexPaths.count > 1) ? NSLocalizedString(@"%ld Photos Selected", nil) : NSLocalizedString(@"%ld Photo Selected", nil);
    self.title = [NSString stringWithFormat:format, (unsigned long)indexPaths.count];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OLFacebookImagePickerCell *cell = (OLFacebookImagePickerCell *) [collectionView dequeueReusableCellWithReuseIdentifier:kImagePickerCellReuseIdentifier forIndexPath:indexPath];
    OLFacebookImage *image = [self.photos objectAtIndex:indexPath.item];
    [cell bind:image];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SupplementaryView *v = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSupplementaryViewFooterReuseIdentifier forIndexPath:indexPath];
    return v;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // this is actually the UICollectionView scrollView
    if (self.inProgressRequest == nil && scrollView.contentOffset.y >= self.collectionView.contentSize.height - self.collectionView.frame.size.height) {
        // we've reached the bottom, lets load the next page of facebook images.
        [self loadNextPage];
    }
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self updateTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
    if ([self.delegate respondsToSelector:@selector(photoViewController:didDeSelectImage:)]){
        [self.delegate photoViewController:self didDeSelectImage:[self.photos objectAtIndex:indexPath.item]];
    }
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self updateTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
    if ([self.delegate respondsToSelector:@selector(photoViewController:didSelectImage:)]){
        [self.delegate photoViewController:self didSelectImage:[self.photos objectAtIndex:indexPath.item]];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(photoViewController:shouldSelectImage:)]){
        return [self.delegate photoViewController:self shouldSelectImage:[self.photos objectAtIndex:indexPath.item]];
    }
    else{
        return YES;
    }
}

@end

#pragma mark - SupplementaryView

@implementation SupplementaryView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        ai.frame = CGRectMake((frame.size.width - ai.frame.size.width) / 2, (frame.size.height - ai.frame.size.height) / 2, ai.frame.size.width, ai.frame.size.height);
        ai.color = [UIColor grayColor];
        [ai startAnimating];
        [self addSubview:ai];
    }
    
    return self;
}

@end
