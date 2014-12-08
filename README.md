CALayer-AutoresizingMask
========================

Add UIViewAutoresize support to iOS CALayers and fast UIView to CALayer conversion method

Installation
==========================

```
pod 'CALayer-AutoresizingMask'
```

Usage
==========================

1. Not use Autolayout in this storyboard or xib and use autoresizing mask you need:

 <img src="https://raw.github.com/k06a/CALayer-AutoresizingMask/master/autolayout.png" width="30%" />
 <img src="https://raw.github.com/k06a/CALayer-AutoresizingMask/master/autoresizing.png" width="30%" />
 
2. Hot swap non touchable `UIView`s with `CALayer`s in IB:

 <img src="https://raw.github.com/k06a/CALayer-AutoresizingMask/master/udra.png" width="30%" />

3. Use your old `IBOutlet`s to views to access visible layers :)

Now all `CALayer`s have property `autoresizingMask` with type `UIVIewAutoresizing`. You can use it too!

How it works?
==========================

It just implements siple algorythm:

Increase `origin` and `size` of `self.frame` proportionaly to `superview`s `frame` increment divided by number of flexible elements on each axe. That is all!

```objective-c
CGFloat dx = self.superlayer.bounds.size.width - self.superlayerSize.width;
CGFloat dy = self.superlayer.bounds.size.height - self.superlayerSize.height;

dx /= ((mask & UIViewAutoresizingFlexibleLeftMargin)?1:0)
    + ((mask & UIViewAutoresizingFlexibleWidth)?1:0)
    + ((mask & UIViewAutoresizingFlexibleRightMargin)?1:0);
dy /= ((mask & UIViewAutoresizingFlexibleTopMargin)?1:0)
    + ((mask & UIViewAutoresizingFlexibleHeight)?1:0)
    + ((mask & UIViewAutoresizingFlexibleBottomMargin)?1:0);

CGRect frame = self.frame;
frame.origin.x += (mask & UIViewAutoresizingFlexibleLeftMargin)?dx:0;
frame.origin.y += (mask & UIViewAutoresizingFlexibleTopMargin)?dy:0;
frame.size.width += (mask & UIViewAutoresizingFlexibleWidth)?dx:0;
frame.size.height += (mask & UIViewAutoresizingFlexibleHeight)?dy:0;
self.frame = frame;
```

Contribute
==========================
You are welcome to fork, PR, create issues ... 
