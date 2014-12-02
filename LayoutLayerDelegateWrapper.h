//
//  LayerDelegateWithoutLayoutWrapper.h
//  SecretSB
//
//  Created by Антон Буков on 03.12.14.
//  Copyright (c) 2014 Secret App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutLayerDelegateWrapper : NSObject

@property (nonatomic, weak) id delegate;

- (instancetype)initWithDelegate:(id)delegate;
- (void)retainSelfCount;
- (void)releaseSelfCount;

@end
