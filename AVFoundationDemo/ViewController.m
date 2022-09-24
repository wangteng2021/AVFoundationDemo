//
//  ViewController.m
//  AVFoundationDemo
//
//  Created by 王腾 on 2022/9/23.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import "WTPhotoCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UIImageView *imageView;

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) NSMutableArray *results;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /// UI
    self.imageView = ({
       
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        imageView;
    });
    
    self.collectionView = ({
       
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 180);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180, self.view.frame.size.width, 180) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[WTPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"WTPhotoCollectionViewCell"];
        [self.view addSubview:collectionView];
        collectionView;
    });
    [self getVideo];
}

- (void)getVideo {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey:@YES};
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:options];
    
    NSArray *keys = @[@"duration"];
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
       
        NSError *error = nil;
        AVKeyValueStatus trackStatus = [asset statusOfValueForKey:@"duration" error:&error];
        switch (trackStatus) {
            case AVKeyValueStatusLoaded:
                
//                [self updateUserInterfaceForDuration];
                break;
            case AVKeyValueStatusFailed:
//                [self reportError:error forAsset:asset];
                break;
            case AVKeyValueStatusCancelled:
                break;
                
            default:
                break;
        }
    }];
    
    /// 获取单张图片
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count > 0) {
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        Float64 durationSeconds = CMTimeGetSeconds([asset duration]);
        CMTime midpoint = CMTimeMakeWithSeconds(durationSeconds/3.0, 600);
        NSError *error;
        CMTime actualTime;
        
        CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:midpoint actualTime:&actualTime error:&error];
        
        if (halfWayImage != NULL) {
            
            NSString *actualTimeString = (NSString *)CFBridgingRelease(CMTimeCopyDescription(NULL, actualTime));
            NSString *requestedTimeString = (NSString *)CFBridgingRelease(CMTimeCopyDescription(NULL, midpoint));
            NSLog(@"Got halfWayImage: Asked for %@, got %@", requestedTimeString, actualTimeString);
            
            // Do something interesting with the image.
            UIImage *image = [[UIImage alloc] initWithCGImage:halfWayImage];
            self.imageView.image = image;
            CGImageRelease(halfWayImage);
        }
    }
    
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count > 0) {
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        Float64 durationSeconds = CMTimeGetSeconds([asset duration]);
        CMTime firstThird = CMTimeMakeWithSeconds(durationSeconds/3.0, 600);
        CMTime secondThird = CMTimeMakeWithSeconds(durationSeconds*2.0/3.0, 600);
        CMTime third = CMTimeMakeWithSeconds(durationSeconds*4.0/3.0, 600);
        CMTime end = CMTimeMakeWithSeconds(durationSeconds, 600);
        NSArray *times = @[[NSValue valueWithCMTime:kCMTimeZero],
                      [NSValue valueWithCMTime:firstThird], [NSValue valueWithCMTime:secondThird],
                      [NSValue valueWithCMTime:third],[NSValue valueWithCMTime:end]];
        [imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
            NSString *requestedTimeString = (NSString *)
            CFBridgingRelease(CMTimeCopyDescription(NULL, requestedTime));
            NSString *actualTimeString = (NSString *)
            CFBridgingRelease(CMTimeCopyDescription(NULL, actualTime));
            NSLog(@"Requested: %@; actual %@", requestedTimeString, actualTimeString);
            
            if (result == AVAssetImageGeneratorSucceeded) {
                // Do something interesting with the image.
            }
            
            if (result == AVAssetImageGeneratorFailed) {
                NSLog(@"Failed with error: %@", [error localizedDescription]);
            }
            if (result == AVAssetImageGeneratorCancelled) {
                NSLog(@"Canceled");
            }
            UIImage *newImage = [[UIImage alloc] initWithCGImage:image];
            [self.results addObject:newImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
            });
        }];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.results.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WTPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WTPhotoCollectionViewCell" forIndexPath:indexPath];
    cell.image = self.results[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *image = self.results[indexPath.item];
    self.imageView.image = image;
}
#pragma init
- (NSMutableArray *)results {
    
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}
@end
