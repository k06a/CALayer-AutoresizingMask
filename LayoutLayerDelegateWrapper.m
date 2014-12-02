//
//  LayerDelegateWithoutLayoutWrapper.m
//  SecretSB
//
//  Created by Антон Буков on 03.12.14.
//  Copyright (c) 2014 Secret App. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CALayer+AutoresizingMask.h"
#import "LayoutLayerDelegateWrapper.h"

@interface LayoutLayerDelegateWrapper ()

@property (nonatomic, strong) NSMutableArray *selfRefs;

@end

@implementation LayoutLayerDelegateWrapper

- (NSMutableArray *)selfRefs
{
    if (_selfRefs == nil)
        _selfRefs = [NSMutableArray array];
    return _selfRefs;
}

- (instancetype)initWithDelegate:(id)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
        [self retainSelfCount];
    }
    return self;
}

- (void)retainSelfCount
{
    [self.selfRefs addObject:self];
}

- (void)releaseSelfCount
{
    [self.selfRefs removeLastObject];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    // Really do nothing
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector]
        || [(id)self.delegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.delegate;
}

@end
