//
//  UIImage+ResizeAndFitImage.h
//  SignUpMod
//
//  Created by Kishan Lal on 24/03/15.
//  Copyright (c) 2015 VGroup Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeAndFitImage)

typedef enum {
    MGImageResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
    MGImageResizeCropStart,
    MGImageResizeCropEnd,
    MGImageResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} MGImageResizingMethod;

- (UIImage *)imageToFitSize:(CGSize)size method:(MGImageResizingMethod)resizeMethod;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size;

- (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;

- (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize;


- (UIImage *)blurWithCoreImage:(UIImage *)sourceImage imageView:(UIImageView*)view radius:(id)inputRadius;

+ (UIImage*) maskImage:(UIImage *)bottomImage withMask:(UIImage *)topImage newSize:(CGSize)newSize;

+ (UIImage *)fixrotation:(UIImage *)image;

@end
