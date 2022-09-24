//
//  WTPhotoCollectionViewCell.m
//  AVFoundationDemo
//
//  Created by 王腾 on 2022/9/23.
//

#import "WTPhotoCollectionViewCell.h"

@interface WTPhotoCollectionViewCell ()

@property (nonatomic,strong) UIImageView *imageView;

@end
@implementation WTPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self bindView];
    }
    return self;
}
- (void)bindView {
    
    self.imageView = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 180)];
        [self.contentView addSubview:imageView];
        imageView;
    });
}
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = _image;
}
@end
