//
//  SDWebImage+Promise.h
//  OTSCore
//
//  Created by Jerry on 2017/9/14.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "OTSPromise.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDWebImageDownloader (Promise)

- (OTSPromise*)downloadImageWithURL:(NSURL *)url
                            options:(SDWebImageDownloaderOptions)options;//promise with UIImage

@end

@interface SDWebImageManager (Promise)

- (OTSPromise*)loadImageWithURL:(NSURL *)url
                        options:(SDWebImageOptions)options;//promise with UIImage

@end

@interface UIImageView (SDWebImagePromise)

- (OTSPromise*)sd_setImageWithURL:(NSURL *)url
                 placeholderImage:(nullable UIImage *)placeholder
                          options:(SDWebImageOptions)options;//promise with UIImage


@end

NS_ASSUME_NONNULL_END
