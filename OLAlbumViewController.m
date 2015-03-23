//
//  OLAlbumViewController.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 16/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import "OLAlbumViewController.h"
#import "OLFacebookAlbumRequest.h"
#import "OLFacebookAlbum.h"
#import "OLPhotoViewController.h"
#import "UIImageView+FacebookFadeIn.h"

static const NSUInteger kAlbumPreviewImageSize = 78;

@interface OLAlbumCell : UITableViewCell
@property (nonatomic, strong) OLFacebookAlbum *album;
@end

@implementation OLAlbumCell

- (void)setAlbum:(OLFacebookAlbum *)album {
    static UIImage *placeholderImage = nil;
    if (!placeholderImage) {
        placeholderImage = [UIImage imageNamed:@"album_placeholder"];
    }
    
    [self.imageView setAndFadeInFacebookImageWithURL:album.coverPhotoURL placeholder:placeholderImage];
    self.imageView.clipsToBounds = YES;
    self.textLabel.text         = album.name;
    self.detailTextLabel.text   = [NSString stringWithFormat:@"%lu", (unsigned long)album.photoCount];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.bounds = CGRectMake(0, 0, kAlbumPreviewImageSize, kAlbumPreviewImageSize);
    self.imageView.frame  = CGRectMake(15, (self.frame.size.height - kAlbumPreviewImageSize) / 2, kAlbumPreviewImageSize, kAlbumPreviewImageSize);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 15;
    self.textLabel.frame = tmpFrame;
    
    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 15;
    self.detailTextLabel.frame = tmpFrame;
}

@end

@interface OLAlbumViewController () <UITableViewDelegate, UITableViewDataSource, OLPhotoViewControllerDelegate>
@property (nonatomic, strong) OLFacebookAlbumRequest *albumRequestForNextPage;
@property (nonatomic, strong) OLFacebookAlbumRequest *inProgressRequest;
@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *loadingFooter;
@property (nonatomic, strong) OLPhotoViewController *photoViewController;
@property (nonatomic, strong) NSError *getAlbumError;

@end

@implementation OLAlbumViewController

- (id)init {
    if (self = [super init]) {
        self.title = @"Photos";
        self.albums = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onButtonDoneClicked)];
    self.albumRequestForNextPage = [[OLFacebookAlbumRequest alloc] init];
    [self loadNextAlbumPage];
    
    UIView *loadingFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake((320 - activityIndicator.frame.size.width) / 2, (44 - activityIndicator.frame.size.height) / 2, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
    [activityIndicator startAnimating];
    [loadingFooter addSubview:activityIndicator];
    self.loadingFooter = loadingFooter;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.getAlbumError) {
        self.loadingIndicator.hidden = YES;
        NSError *error = self.getAlbumError;
        self.getAlbumError = nil;
        [self.delegate albumViewController:self didFailWithError:error];
        
    }
}

- (void)loadNextAlbumPage {
    self.inProgressRequest = self.albumRequestForNextPage;
    self.albumRequestForNextPage = nil;
    [self.inProgressRequest getAlbums:^(NSArray/*<OLFacebookAlbum>*/ *albums, NSError *error, OLFacebookAlbumRequest *nextPageRequest) {
        self.inProgressRequest = nil;
        self.loadingIndicator.hidden = YES;
        self.albumRequestForNextPage = nextPageRequest;

        if (error) {
            if (self.parentViewController.isBeingPresented) {
                self.loadingIndicator.hidden = NO;
                self.getAlbumError = error; // delay notification so that delegate can dismiss view controller safely if desired.
            } else {
                [self.delegate albumViewController:self didFailWithError:error];
            }
            return;
        }

        NSMutableArray *paths = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < albums.count; ++i) {
            [paths addObject:[NSIndexPath indexPathForRow:self.albums.count + i inSection:0]];
        }
        
        [self.albums addObjectsFromArray:albums];
        if (self.albums.count == albums.count) {
            // first insert request
            [self.tableView reloadData];
        } else {
            [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        }
        
        if (nextPageRequest) {
            self.tableView.tableFooterView = self.loadingFooter;
        } else {
            self.tableView.tableFooterView = nil;
        }
        
    }];
}

- (void)updateSelectedFromPhotoViewController {
    if (self.photoViewController) {
        // we're coming back from a photo view so update the selected to reflect any changes the user made
        self.selected = self.photoViewController.selected;
        self.photoViewController = nil;
    }
}

- (void)onButtonDoneClicked {
    [self.delegate albumViewControllerDoneClicked:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateSelectedFromPhotoViewController];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AlbumCell";
    OLAlbumCell *cell = (OLAlbumCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OLAlbumCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.album = [self.albums objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kAlbumPreviewImageSize + 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OLFacebookAlbum *album = [self.albums objectAtIndex:indexPath.row];
    self.photoViewController = [[OLPhotoViewController alloc] initWithAlbum:album];
    self.photoViewController.selected = self.selected;
    self.photoViewController.delegate = self;
    [self.navigationController pushViewController:self.photoViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // this is actually the UICollectionView scrollView
    if (self.inProgressRequest == nil && scrollView.contentOffset.y >= self.tableView.contentSize.height - (self.tableView.frame.size.height + self.loadingFooter.frame.size.height)) {
        // we've reached the bottom, lets load the next page of albums.
        [self loadNextAlbumPage];
    }
}

#pragma mark - OLPhotoViewControllerDelegate methods

- (void)photoViewControllerDoneClicked:(OLPhotoViewController *)photoController {
    NSAssert(self.photoViewController != nil, @"oops");
    [self updateSelectedFromPhotoViewController];
    [self.delegate albumViewControllerDoneClicked:self];
}

- (void)photoViewController:(OLPhotoViewController *)photoController didFailWithError:(NSError *)error {
    [self.delegate albumViewController:self didFailWithError:error];
}

@end
