//
//  UIImage+AddOn.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 01/04/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "UIImage+AddOn.h"

@implementation UIImage (AddOn)

- (UIImage *)scaleToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
