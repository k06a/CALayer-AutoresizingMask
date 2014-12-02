//
//  UIView+ReplaceWithLayer.m
//  SecretSB
//
//  Created by Антон Буков on 01.12.14.
//  Copyright (c) 2014 Secret App. All rights reserved.
//

#import <objc/runtime.h>
#import <JRSwizzle/JRSwizzle.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>
#import "LayoutLayerDelegateWrapper.h"
#import "UIView+ReplaceWithLayer.h"
#import "CALayer+AutoresizingMask.h"

@implementation UIView (ReplaceWithLayer)

SYNTHESIZE_ASC_PRIMITIVE_BLOCK(replaceWithLayer, setReplaceWithLayer, BOOL, ^{}, ^{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.replaceWithLayer)
            [self replace];
    });
})

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIView jr_swizzleMethod:@selector(layoutSubviews) withMethod:@selector(xxx_layoutSubviews) error:NULL];
    });
}

- (void)xxx_layoutSubviews
{
    [self xxx_layoutSubviews];
    [self.layer layoutSublayersRecursive];
}

- (void)replace
{
    for (UIView *subview in self.subviews)
        [subview replace];
    
    self.layer.view = self;
    self.layer.delegate = [[LayoutLayerDelegateWrapper alloc] initWithDelegate:self.layer.delegate];
    self.layer.autoresizingMask = self.autoresizingMask;
    self.layer.superlayerSize = self.layer.superlayer.bounds.size;
    
    // Replacing views by layers in hierarhy and keeping z-order
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subview in self.superview.subviews) {
            if (subview.replaceWithLayer) {
                CALayer *layer = subview.layer;
                CALayer *superlayer = layer.superlayer;
                
                NSInteger i = [superlayer.sublayers indexOfObject:layer];
                id delegate = layer.delegate;
                [subview removeFromSuperview];
                layer.view = subview;
                layer.delegate = delegate;
                [layer.delegate retainSelfCount];
                [superlayer insertSublayer:layer atIndex:i];
            }
        }
    });
}

@end
