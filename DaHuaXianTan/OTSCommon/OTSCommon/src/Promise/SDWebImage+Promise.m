//
//  SDWebImage+Promise.m
//  OTSCore
//
//  Created by Jerry on 2017/9/14.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#import "SDWebImage+Promise.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SDWebImageDownloader (Promise)

- (OTSPromise*)downloadImageWithURL:(NSURL *)url
                            options:(SDWebImageDownloaderOptions)options {
    OTSPromise *promise = [OTSPromise new];
    [self downloadImageWithURL:url
                       options:options
                      progress:nil
                     completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                         if (error || !image) {
                             [promise reject:error];
                         } else {
                             [promise resolve:image];
                         }
                     }
     ];
    
    return promise;
}

@end

@implementation SDWebImageManager (Promise)

- (OTSPromise*)loadImageWithURL:(NSURL *)url
                        options:(SDWebImageOptions)options {
    OTSPromise *promise = [OTSPromise new];
    [self loadImageWithURL:url
                   options:options
                  progress:nil
                 completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     if (error || !image) {
                         [promise reject:error];
                     } else {
                         [promise resolve:image];
                     }
    }];
    return promise;
}

@end

@implementation UIImageView (SDWebImagePromise)

- (OTSPromise*)sd_setImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                          options:(SDWebImageOptions)options {
    OTSPromise *promise = [OTSPromise new];
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (error || !image) {
                           [promise reject:error];
                       } else {
                           [promise resolve:image];
                       }
    }];
    return promise;
}

@end
