//
//  UIImage+ImageUtilities.m
//  Video Player
//
//  Created by Avikant Saini on 5/30/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

@import QuartzCore;
@import Accelerate;

#import "UIImage+ImageUtilities.h"

@implementation UIImage (ImageUtilities)

+ (UIImage *)plainColoredImageWithColor:(UIColor *)color andSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	UIBezierPath *beizerPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
	[color setFill];
	[beizerPath fill];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+ (UIImage *)underlinedImageWithColor:(UIColor *)color lineThicknessPercentage:(CGFloat)thickness {
	return [self underlinedImageWithColor:color size:CGSizeMake(100, 100) andLineThickness:thickness];
}

+ (UIImage *)underlinedImageWithColor:(UIColor *)color size:(CGSize)size andLineThickness:(CGFloat)thickness {
	UIGraphicsBeginImageContext(size);
	UIBezierPath *beizerPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, size.height - thickness, size.width, thickness)];
	[color setFill];
	[beizerPath fill];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

#pragma mark - Cropping

- (UIImage *)circleImageWithSize:(CGFloat)size {
	return [self imageAsCircle:YES
				   withDiamter:size
				   borderColor:[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.8f alpha:1.0f]
				   borderWidth:1.0f
				  shadowOffSet:CGSizeMake(0.0f, 1.0f)];
}

- (UIImage *)squareImageWithSize:(CGFloat)size {
	return [self imageAsCircle:NO
				   withDiamter:size
				   borderColor:[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.8f alpha:1.0f]
				   borderWidth:1.0f
				  shadowOffSet:CGSizeMake(0.0f, 1.0f)];
}

- (UIImage *)crop:(CGRect)rect {
	CGFloat scale = self.scale;
	CGRect scaledRect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
	CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, scaledRect);
	UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
	CGImageRelease(imageRef);
	return newImage;
}

- (UIImage *)imageAsCircle:(BOOL)clipToCircle
			   withDiamter:(CGFloat)diameter
			   borderColor:(UIColor *)borderColor
			   borderWidth:(CGFloat)borderWidth
			  shadowOffSet:(CGSize)shadowOffset {
	
	CGFloat increase = diameter * 0.15f;
	CGFloat newSize = diameter + increase;
	
	CGRect newRect = CGRectMake(0.0f,
								0.0f,
								newSize,
								newSize);
	
	CGRect imgRect = CGRectMake(increase,
								increase,
								newRect.size.width - (increase * 2.0f),
								newRect.size.height - (increase * 2.0f));
	
	UIGraphicsBeginImageContextWithOptions(newRect.size, NO, [UIScreen mainScreen].scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);

	if(!CGSizeEqualToSize(shadowOffset, CGSizeZero))
		CGContextSetShadowWithColor(context,
									CGSizeMake(shadowOffset.width, shadowOffset.height),
									3.0f,
									[UIColor colorWithWhite:0.0f alpha:0.45f].CGColor);
	
	CGPathRef borderPath = (clipToCircle) ? CGPathCreateWithEllipseInRect(imgRect, NULL) : CGPathCreateWithRect(imgRect, NULL);
	
	CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
	CGContextSetLineWidth(context, borderWidth);
	CGContextAddPath(context, borderPath);
	CGContextDrawPath(context, kCGPathFillStroke);
	CGPathRelease(borderPath);
	CGContextRestoreGState(context);
	
	if(clipToCircle) {
		UIBezierPath *imgPath = [UIBezierPath bezierPathWithOvalInRect:imgRect];
		[imgPath addClip];
	}
	
	[self drawInRect:imgRect];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

#pragma mark - Resizing

- (UIImage *)resizedImageToSize:(CGSize)dstSize {
	
	CGImageRef imgRef = self.CGImage;
	CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	
	if (CGSizeEqualToSize(srcSize, dstSize)) {
		return self;
	}
	
	CGFloat scaleRatio = dstSize.width / srcSize.width;
	UIImageOrientation orient = self.imageOrientation;
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	switch(orient) {
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(0.0, srcSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}

	UIGraphicsBeginImageContextWithOptions(dstSize, NO, self.scale);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (!context) {
		return nil;
	}
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -srcSize.height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -srcSize.height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (UIImage *)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale {
	
	CGImageRef imgRef = self.CGImage;
	CGSize srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	
	UIImageOrientation orient = self.imageOrientation;
	switch (orient) {
		case UIImageOrientationLeft:
		case UIImageOrientationRight:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRightMirrored:
			boundingSize = CGSizeMake(boundingSize.height, boundingSize.width);
			break;
		default:
			break;
	}
	
	CGSize dstSize;
	
	if (!scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height) ) {
		dstSize = srcSize;
	}
	else {
		CGFloat wRatio = boundingSize.width / srcSize.width;
		CGFloat hRatio = boundingSize.height / srcSize.height;
		
		if (wRatio < hRatio) {
			dstSize = CGSizeMake(boundingSize.width, floorf(srcSize.height * wRatio));
		}
		else {
			dstSize = CGSizeMake(floorf(srcSize.width * hRatio), boundingSize.height);
		}
	}
	
	return [self resizedImageToSize:dstSize];
}

#pragma mark - Blur

- (UIImage *)blurredImageWithRadius:(CGFloat)radius {
	return  [self applyBlurWithRadius:radius iterationsCount:3 tintColor:UIColor.clearColor saturationDeltaFactor:-1.0 maskImage:nil];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius iterationsCount:(NSInteger)iterationsCount tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
	// check pre-conditions
	if (self.size.width < 1 || self.size.height < 1) {
		NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
		return nil;
	}
	if (!self.CGImage) {
		NSLog (@"*** error: image must be backed by a CGImage: %@", self);
		return nil;
	}
	if (maskImage && !maskImage.CGImage) {
		NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
		return nil;
	}
	
	CGRect imageRect = { CGPointZero, self.size };
	UIImage *effectImage = self;
	
	BOOL hasBlur = blurRadius > __FLT_EPSILON__;
	BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
	if (hasBlur || hasSaturationChange) {
		UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
		CGContextRef effectInContext = UIGraphicsGetCurrentContext();
		CGContextScaleCTM(effectInContext, 1.0, -1.0);
		CGContextTranslateCTM(effectInContext, 0, -self.size.height);
		CGContextDrawImage(effectInContext, imageRect, self.CGImage);
		
		vImage_Buffer effectInBuffer;
		effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
		effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
		effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
		effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
		
		UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
		CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
		vImage_Buffer effectOutBuffer;
		effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
		effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
		effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
		effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
		
		BOOL resultImageAtInputBuffer = YES;
		if (hasBlur) {

			CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
			NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
			if (radius % 2 != 1) {
				radius += 1; // force radius to be odd so that the three box-blur methodology works.
			}
			for (int i = 0; i+1 < iterationsCount; i+=2) {
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
				vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
			}
			if (iterationsCount % 2) {
				vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
				resultImageAtInputBuffer = NO;
			}
		}
		if (hasSaturationChange) {
			CGFloat s = saturationDeltaFactor;
			CGFloat floatingPointSaturationMatrix[] = {
				0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
				0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
				0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
				0,                    0,                    0,  1,
			};
			const int32_t divisor = 256;
			NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
			int16_t saturationMatrix[matrixSize];
			for (NSUInteger i = 0; i < matrixSize; ++i) {
				saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
			}
			if (hasBlur ^ resultImageAtInputBuffer) {
				vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
			}
			else {
				vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
			}
		}
		if (!resultImageAtInputBuffer)
			effectImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		if (resultImageAtInputBuffer)
			effectImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	
	// set up output context
	UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
	CGContextRef outputContext = UIGraphicsGetCurrentContext();
	CGContextScaleCTM(outputContext, 1.0, -1.0);
	CGContextTranslateCTM(outputContext, 0, -self.size.height);
	
	// draw base image
	CGContextDrawImage(outputContext, imageRect, self.CGImage);
	
	// draw effect image
	if (hasBlur) {
		CGContextSaveGState(outputContext);
		if (maskImage) {
			CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
		}
		CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
		CGContextRestoreGState(outputContext);
	}
	
	// add in color tint
	if (tintColor) {
		CGContextSaveGState(outputContext);
		CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
		CGContextFillRect(outputContext, imageRect);
		CGContextRestoreGState(outputContext);
	}
	
	// output image is ready
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return outputImage;
}


@end
