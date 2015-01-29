//
//  CALayerAutoresizingMask.h
//  SecretSB
//
//  Created by Антон Буков on 01.12.14.
//  Copyright (c) 2014 Secret App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (AutoresizingMask)

@property (nonatomic, assign) UIViewAutoresizing autoresizingMask;
@property (nonatomic, strong) UIView *view;

@end
