//
//  UIImage+ImageUtilities.h
//  Video Player
//
//  Created by Avikant Saini on 5/30/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageUtilities)

+ (UIImage *)plainColoredImageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (UIImage *)underlinedImageWithColor:(UIColor *)color lineThicknessPercentage:(CGFloat)thickness;
+ (UIImage *)underlinedImageWithColor:(UIColor *)color size:(CGSize)size andLineThickness:(CGFloat)thickness;

- (UIImage *)circleImageWithSize:(CGFloat)size;
- (UIImage *)squareImageWithSize:(CGFloat)size;

- (UIImage *)crop:(CGRect)rect;

- (UIImage *)imageAsCircle:(BOOL)clipToCircle withDiamter:(CGFloat)diameter borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth shadowOffSet:(CGSize)shadowOffset;

- (UIImage*)resizedImageToSize:(CGSize)dstSize;
- (UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

- (UIImage *)blurredImageWithRadius:(CGFloat)radius;

@end
