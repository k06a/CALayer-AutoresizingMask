//
//  CALayerAutoresizingMask.m
//  SecretSB
//
//  Created by Антон Буков on 01.12.14.
//  Copyright (c) 2014 Secret App. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <JRSwizzle/JRSwizzle.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
#import "LayoutLayerDelegateWrapper.h"
#import "CALayer+AutoresizingMask.h"

@implementation CALayer (AutoresizingMask)

SYNTHESIZE_ASC_PRIMITIVE(autoresizingMask, setAutoresizingMask, UIViewAutoresizing)
SYNTHESIZE_ASC_OBJ(view, setView)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [CALayer jr_swizzleMethod:@selector(removeFromSuperlayer) withMethod:@selector(xxx_removeFromSuperlayer) error:NULL];
        [CALayer jr_swizzleMethod:@selector(setBounds:) withMethod:@selector(xxx_setBounds:) error:NULL];
    });
}

- (void)xxx_removeFromSuperlayer
{
    [self xxx_removeFromSuperlayer];
    LayoutLayerDelegateWrapper *wrapper = self.delegate;
    if ([wrapper isKindOfClass:[LayoutLayerDelegateWrapper class]]) {
        self.delegate = wrapper.delegate;
        [wrapper releaseSelfCount];
    }
    self.view = nil;
}

- (void)xxx_setBounds:(CGRect)bounds
{
    for (CALayer *layer in self.sublayers)
        if (layer.autoresizingMask != UIViewAutoresizingNone)
            [layer autoresizeWhileParentSize:self.bounds.size toSize:bounds.size];
    [self xxx_setBounds:bounds];
}

- (void)autoresizeWhileParentSize:(CGSize)size toSize:(CGSize)newSize
{
    UIViewAutoresizing mask = self.autoresizingMask;
    
    CGFloat dx = newSize.width - size.width;
    CGFloat dy = newSize.height - size.height;

    dx /= ((mask & UIViewAutoresizingFlexibleLeftMargin)?1:0)
        + ((mask & UIViewAutoresizingFlexibleWidth)?1:0)
        + ((mask & UIViewAutoresizingFlexibleRightMargin)?1:0);
    dy /= ((mask & UIViewAutoresizingFlexibleTopMargin)?1:0)
        + ((mask & UIViewAutoresizingFlexibleHeight)?1:0)
        + ((mask & UIViewAutoresizingFlexibleBottomMargin)?1:0);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    if ((abs(dx) < 1.0/scale) && (abs(dy) < 1.0/scale))
        return;
    
    CGRect frame = self.frame;
    frame.origin.x += (mask & UIViewAutoresizingFlexibleLeftMargin)?dx:0;
    frame.origin.y += (mask & UIViewAutoresizingFlexibleTopMargin)?dy:0;
    frame.size.width += (mask & UIViewAutoresizingFlexibleWidth)?dx:0;
    frame.size.height += (mask & UIViewAutoresizingFlexibleHeight)?dy:0;
    [self setFrame:frame];
}

@end
