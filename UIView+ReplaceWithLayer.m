//
//  UIView+ReplaceWithLayer.m
//  SecretSB
//
//  Created by Антон Буков on 01.12.14.
//  Copyright (c) 2014 Secret App. All rights reserved.
//

#import <objc/runtime.h>
#import <JRSwizzle/JRSwizzle.h>
#import "UIView+ReplaceWithLayer.h"
#import "CALayer+AutoresizingMask.h"

@implementation UIView (ReplaceWithLayer)

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

- (void)setReplaceWithLayer:(BOOL)replaceWithLayer
{
    for (UIView *subview in self.subviews)
        [subview setReplaceWithLayer:YES];
    
    self.layer.view = self;
    self.layer.delegate = nil;
    self.layer.autoresizingMask = self.autoresizingMask;
    self.layer.superlayerSize = self.layer.superlayer.bounds.size;
    
    CALayer *superlayer = self.layer.superlayer;
    [self removeFromSuperview];
    [superlayer addSublayer:self.layer];
}

@end
