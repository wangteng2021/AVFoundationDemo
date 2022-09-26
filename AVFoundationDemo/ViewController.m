//
//  ViewController.m
//  AVFoundationDemo
//
//  Created by 王腾 on 2022/9/23.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import "WTPhotoCollectionViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,strong) AVPlayerLayer *playerLayer;

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) NSMutableArray *results;

@property(nonatomic,copy) NSURL *outUrl;

@property (nonatomic,copy) NSURL *originUrl;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    int target = 18;
//    NSArray *array = @[@1,@9,@4,@199,@29,@3,@8,@10];
//    for (int i = 0 ; i < array.count; i++) {
//        for (int j = i + 1; j < array.count; ++j) {
//            int a = [array[i] intValue];
//            int b = [array[j] intValue];
//            if(a + b == target) {
//                NSLog(@"%d---%d",i,j);
//            }
//        }
//    }
//    return;
    /// UI
    self.imageView = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2.0, self.view.frame.size.height - 200)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.hidden = YES;
        [self.view addSubview:imageView];
        imageView;
    });
    [self.view.layer addSublayer:self.playerLayer];
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
    [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
    [self getVideo];
}

- (void)getVideo {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"456" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.originUrl = url;
    [self addWaterMarkTypeWithCorAnimationAndInputVideoURL:self.originUrl WithCompletionHandler:^(NSURL *outPutURL, int code) {
        
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:outPutURL];
        [self.player replaceCurrentItemWithPlayerItem:item];
        [self.player play];
    }];
//    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey:@YES};
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:options];
//
//    NSArray *keys = @[@"duration"];
//    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
//
//        NSError *error = nil;
//        AVKeyValueStatus trackStatus = [asset statusOfValueForKey:@"duration" error:&error];
//        switch (trackStatus) {
//            case AVKeyValueStatusLoaded:
//
//                //                [self updateUserInterfaceForDuration];
//                break;
//            case AVKeyValueStatusFailed:
//                //                [self reportError:error forAsset:asset];
//                break;
//            case AVKeyValueStatusCancelled:
//                break;
//
//            default:
//                break;
//        }
//    }];
//
//    /// 获取单张图片
//    if ([asset tracksWithMediaType:AVMediaTypeVideo].count > 0) {
//        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
//        Float64 durationSeconds = CMTimeGetSeconds([asset duration]);
//        CMTime midpoint = CMTimeMakeWithSeconds(durationSeconds/3.0, 600);
//        NSError *error;
//        CMTime actualTime;
//
//        CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:midpoint actualTime:&actualTime error:&error];
//
//        if (halfWayImage != NULL) {
//
//            NSString *actualTimeString = (NSString *)CFBridgingRelease(CMTimeCopyDescription(NULL, actualTime));
//            NSString *requestedTimeString = (NSString *)CFBridgingRelease(CMTimeCopyDescription(NULL, midpoint));
//            NSLog(@"Got halfWayImage: Asked for %@, got %@", requestedTimeString, actualTimeString);
//
//            // Do something interesting with the image.
//            UIImage *image = [[UIImage alloc] initWithCGImage:halfWayImage];
//            self.imageView.image = image;
//            CGImageRelease(halfWayImage);
//        }
//    }
//
//    /// 获取多张图片
//    if ([asset tracksWithMediaType:AVMediaTypeVideo].count > 0) {
//        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
//        Float64 durationSeconds = CMTimeGetSeconds([asset duration]);
//        CMTime firstThird = CMTimeMakeWithSeconds(durationSeconds/3.0, 600);
//        CMTime secondThird = CMTimeMakeWithSeconds(durationSeconds*2.0/3.0, 600);
//        CMTime third = CMTimeMakeWithSeconds(durationSeconds*4.0/3.0, 600);
//        CMTime end = CMTimeMakeWithSeconds(durationSeconds, 600);
//        NSArray *times = @[[NSValue valueWithCMTime:kCMTimeZero],
//                           [NSValue valueWithCMTime:firstThird], [NSValue valueWithCMTime:secondThird],
//                           [NSValue valueWithCMTime:third],[NSValue valueWithCMTime:end]];
//        [imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
//            NSString *requestedTimeString = (NSString *)
//            CFBridgingRelease(CMTimeCopyDescription(NULL, requestedTime));
//            NSString *actualTimeString = (NSString *)
//            CFBridgingRelease(CMTimeCopyDescription(NULL, actualTime));
//            NSLog(@"Requested: %@; actual %@", requestedTimeString, actualTimeString);
//
//            if (result == AVAssetImageGeneratorSucceeded) {
//                // Do something interesting with the image.
//            }
//
//            if (result == AVAssetImageGeneratorFailed) {
//                NSLog(@"Failed with error: %@", [error localizedDescription]);
//            }
//            if (result == AVAssetImageGeneratorCancelled) {
//                NSLog(@"Canceled");
//            }
//            UIImage *newImage = [[UIImage alloc] initWithCGImage:image];
//            [self.results addObject:newImage];
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [self.collectionView reloadData];
//            });
//        }];
//    }
//    NSArray *compatiblePreset = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
//    if ([compatiblePreset containsObject:AVAssetExportPresetLowQuality]) {
//        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
//
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//
//        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//        NSDate *date = [NSDate date];
//        NSString *currentTime = [formatter stringFromDate:date];
//        /// 缓存路径
//        NSURL *outUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Library/Caches/movie_%@.mp4",NSHomeDirectory(),currentTime]];
//        self.outUrl = outUrl;
//        exportSession.outputURL = outUrl;
//        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
//
//        CMTime start = CMTimeMakeWithSeconds(1.0, 600);
//        CMTime duration = CMTimeMakeWithSeconds(20.0, 600);
//        CMTimeRange range = CMTimeRangeMake(start, duration);
//        exportSession.timeRange = range;
//
//        /// 创建新文件导出
//        [exportSession exportAsynchronouslyWithCompletionHandler:^{
//
//            switch ([exportSession status]) {
//
//                case AVAssetExportSessionStatusCompleted: {
//
//                    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:outUrl];
//                    [self.player replaceCurrentItemWithPlayerItem:item];
//                    [self.player play];
//
//                    /// 重新定位播放头（快进）
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        CMTime fiveSecondsIn = CMTimeMake(5, 1);
//                        [self.player seekToTime:fiveSecondsIn toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
//                    });
//
//                    [self editVideo];
//                    break;
//                }
//                case AVAssetExportSessionStatusFailed:
//                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
//                    break;
//                case AVAssetExportSessionStatusCancelled:
//                    NSLog(@"Export canceled");
//                    break;
//                default:
//                    break;
//            }
//        }];
//    }
}
- (void)editVideo {
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
    // Create the video composition track.
    AVMutableCompositionTrack *mutableCompositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    // Create the audio composition track.
    AVMutableCompositionTrack *mutableCompositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // You can retrieve AVAssets from a number of places, like the camera roll for example.
    AVAsset *videoAsset = [AVAsset assetWithURL:self.outUrl];
    AVAsset *anotherVideoAsset = [AVAsset assetWithURL:self.originUrl];
    // Get the first video track from each asset.
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVAssetTrack *anotherVideoAssetTrack = [[anotherVideoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    // Add them both to the composition.
    [mutableCompositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,videoAssetTrack.timeRange.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    [mutableCompositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,anotherVideoAssetTrack.timeRange.duration) ofTrack:anotherVideoAssetTrack atTime:videoAssetTrack.timeRange.duration error:nil];
    
    
    /// 音频处理
    AVMutableAudioMix *mutableAudioMix = [AVMutableAudioMix audioMix];
    // Create the audio mix input parameters object.
    AVMutableAudioMixInputParameters *mixParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:mutableCompositionAudioTrack];
    // Set the volume ramp to slowly fade the audio out over the duration of the composition.
    [mixParameters setVolumeRampFromStartVolume:1.f toEndVolume:0.f timeRange:CMTimeRangeMake(kCMTimeZero, mutableComposition.duration)];
    // Attach the input parameters to the audio mix.
    mutableAudioMix.inputParameters = @[mixParameters];
    
    AVMutableVideoCompositionInstruction *mutableVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mutableVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, mutableComposition.duration);
    mutableVideoCompositionInstruction.backgroundColor = [[UIColor redColor] CGColor];
    
    
    
}
#pragma mark CorAnimation 添加水印
- (void)addWaterMarkTypeWithCorAnimationAndInputVideoURL:(NSURL*)InputURL WithCompletionHandler:(void (^)(NSURL* outPutURL, int code))handler{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVAsset *videoAsset = [AVURLAsset URLAssetWithURL:InputURL options:opts];
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    NSError *errorVideo = [NSError new];
    AVAssetTrack *assetVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo]firstObject];
    CMTime endTime = assetVideoTrack.asset.duration;
    BOOL bl = [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, assetVideoTrack.asset.duration)
                                  ofTrack:assetVideoTrack
                                   atTime:kCMTimeZero error:&errorVideo];
    videoTrack.preferredTransform = assetVideoTrack.preferredTransform;
    NSLog(@"errorVideo:%ld%d",errorVideo.code,bl);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *outPutFileName = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",outPutFileName]];
    NSURL* outPutVideoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    CGSize videoSize = [videoTrack naturalSize];
    
    UIFont *font = [UIFont systemFontOfSize:60.0];
    CATextLayer *aLayer = [[CATextLayer alloc] init];
    [aLayer setFontSize:60];
    [aLayer setString:@"H"];
    [aLayer setAlignmentMode:kCAAlignmentCenter];
    [aLayer setForegroundColor:[[UIColor blueColor] CGColor]];
    [aLayer setBackgroundColor:[UIColor clearColor].CGColor];
    CGSize textSize = [@"H" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [aLayer setFrame:CGRectMake(240, 470, textSize.width, textSize.height)];
    aLayer.anchorPoint = CGPointMake(0.5, 1.0);

    
    CATextLayer *bLayer = [[CATextLayer alloc] init];
    [bLayer setFontSize:60];
    [bLayer setString:@"E"];
    [bLayer setAlignmentMode:kCAAlignmentCenter];
    [bLayer setForegroundColor:[[UIColor greenColor] CGColor]];
    [bLayer setBackgroundColor:[UIColor clearColor].CGColor];
    CGSize textSizeb = [@"E" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [bLayer setFrame:CGRectMake(240 + textSize.width, 470 , textSizeb.width, textSizeb.height)];
    bLayer.anchorPoint = CGPointMake(0.5, 1.0);

    
    CATextLayer *cLayer = [[CATextLayer alloc] init];
    [cLayer setFontSize:60];
    [cLayer setString:@"L"];
    [cLayer setAlignmentMode:kCAAlignmentCenter];
    [cLayer setForegroundColor:[[UIColor redColor] CGColor]];
    [cLayer setBackgroundColor:[UIColor clearColor].CGColor];
    CGSize textSizec = [@"L" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [cLayer setFrame:CGRectMake(240 + textSizeb.width + textSize.width, 470 , textSizec.width, textSizec.height)];
    cLayer.anchorPoint = CGPointMake(0.5, 1.0);

    
    CATextLayer *dLayer = [[CATextLayer alloc] init];
    [dLayer setFontSize:60];
    [dLayer setString:@"L"];
    [dLayer setAlignmentMode:kCAAlignmentCenter];
    [dLayer setForegroundColor:[[UIColor purpleColor] CGColor]];
    [dLayer setBackgroundColor:[UIColor clearColor].CGColor];
    CGSize textSized = [@"L" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [dLayer setFrame:CGRectMake(240 + textSizec.width+ textSizeb.width + textSize.width, 470 , textSized.width, textSized.height)];
    dLayer.anchorPoint = CGPointMake(0.5, 1.0);
    
    CATextLayer *eLayer = [[CATextLayer alloc] init];
    [eLayer setFontSize:60];
    [eLayer setString:@"O"];
    [eLayer setAlignmentMode:kCAAlignmentCenter];
    [eLayer setForegroundColor:[[UIColor greenColor] CGColor]];
    [eLayer setBackgroundColor:[UIColor clearColor].CGColor];
    CGSize textSizede = [@"O" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [eLayer setFrame:CGRectMake(240 + textSized.width + textSizec.width+ textSizeb.width + textSize.width, 470 , textSizede.width, textSizede.height)];
    eLayer.anchorPoint = CGPointMake(0.5, 1.0);

    CABasicAnimation* basicAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basicAni.fromValue = @(0.2f);
    basicAni.toValue = @(1.0f);
    basicAni.beginTime = AVCoreAnimationBeginTimeAtZero;
    basicAni.duration = 2.0f;
    basicAni.repeatCount = HUGE_VALF;
    basicAni.removedOnCompletion = NO;
    basicAni.fillMode = kCAFillModeForwards;
    [aLayer addAnimation:basicAni forKey:nil];
    [bLayer addAnimation:basicAni forKey:nil];
    [cLayer addAnimation:basicAni forKey:nil];
    [dLayer addAnimation:basicAni forKey:nil];
    [eLayer addAnimation:basicAni forKey:nil];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:aLayer];
    [parentLayer addSublayer:bLayer];
    [parentLayer addSublayer:cLayer];
    [parentLayer addSublayer:dLayer];
    [parentLayer addSublayer:eLayer];

    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = videoSize;
    parentLayer.geometryFlipped = true;
    videoComp.frameDuration = CMTimeMake(1, 30);
    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    AVMutableVideoCompositionInstruction* instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, endTime);
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    instruction.layerInstructions = [NSArray arrayWithObjects:layerInstruction, nil];
    videoComp.instructions = [NSArray arrayWithObject: instruction];
    
    
    AVAssetExportSession* exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=outPutVideoUrl;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = videoComp;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            NSLog(@"输出视频地址:%@ andCode:%@",myPathDocs,exporter.error);
            handler(outPutVideoUrl,(int)exporter.error.code);
        });
    }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"变化内容%@",context);
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
- (AVPlayer *)player {
    
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}
- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [[AVPlayerLayer alloc] init];
        _playerLayer.player = self.player;
        _playerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _playerLayer;
}
@end
