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

Contribute
==========================
You are welcome to fork, PR, create issues ... 
