# ProtocolProxy
Flexible proxy for overriding and observing protocol method/property messages.

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d30d31c29f17449481b97a04610ff5b9)](https://app.codacy.com/app/SomeRandomiOSDev/ProtocolProxy?utm_source=github.com&utm_medium=referral&utm_content=SomeRandomiOSDev/ProtocolProxy&utm_campaign=Badge_Grade_Dashboard)
[![License MIT](https://img.shields.io/cocoapods/l/ProtocolProxy.svg)](https://cocoapods.org/pods/ProtocolProxy)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ProtocolProxy.svg)](https://cocoapods.org/pods/ProtocolProxy) 
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Platform](https://img.shields.io/cocoapods/p/ProtocolProxy.svg)](https://cocoapods.org/pods/ProtocolProxy)
[![Build](https://travis-ci.com/SomeRandomiOSDev/ProtocolProxy.svg?branch=master)](https://travis-ci.com/SomeRandomiOSDev/ProtocolProxy)
[![Code Coverage](https://codecov.io/gh/SomeRandomiOSDev/ProtocolProxy/branch/master/graph/badge.svg)](https://codecov.io/gh/SomeRandomiOSDev/ProtocolProxy)

## Purpose

The purpose of this library is to provide a lightweight class that serves as a stand-in for objects that are required to implement one or more protocols (e.g. delegates, data sources, etc.). Additionally, this proxy allows for the selective overriding of specific methods/properties from the adopted protocol(s) as well as the observation of any of the protocol methods/properties before and after they're called.

## Installation

**ProtocolProxy** is available through [CocoaPods](https://cocoapods.org), [Carthage](https://github.com/Carthage/Carthage) and the [Swift Package Manager](https://swift.org/package-manager/).

To install via CocoaPods, simply add the following line to your Podfile:

```ruby
pod 'ProtocolProxy'
```

To install via Carthage, simply add the following line to your Cartfile:

```ruby
github "SomeRandomiOSDev/ProtocolProxy"
```

To install via the Swift Package Manager add the following line to your `Package.swift` file's `dependencies`:

```swift
.package(url: "https://github.com/SomeRandomiOSDev/ProtocolProxy.git", from: "0.1.0")
```

## Usage

After importing this library into your source file (Objective-C: `@import ProtocolProxy;`, Swift: `import ProtocolProxy`) `ProtocolProxy` can be instantiated by passing it one or more Objective-C protocols and an optional object that implements the protocol(s). At that point, any methods from the adopted protocol(s) that are sent to the proxy will be forwarded on to the implementer as appropriate. At this point this proxy is ready for overriding or observing particular methods of the adopted protocol(s).

Objective-C: 

```objc 
UIViewController *viewControler = ...;
id<UIAdaptivePresentationControllerDelegate> delegate = viewController.presentationController.delegate;

...

ProtocolProxy *proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(UIAdaptivePresentationControllerDelegate) implementer:delegate];

if (![delegate respondsToSelector:@selector(presentationControllerDidDismiss:)]) {
    // delegate doesn't respond to the `-presentationControllerDidDismiss:` selector so
    // we set `respondsToSelectorsWithObservers` to YES to ensure that our observer
    // block gets called.
    proxy.respondsToSelectorsWithObservers = YES;
}

[proxy overrideSelector:@selector(presentationControllerShouldDismiss:) usingBlock:^BOOL (id self, UIPresentationController *presentationController) {
    BOOL shouldDismiss;
    
    ...
    
    return shouldDismiss;
}];

[proxy addObserverForSelector:@selector(presentationControllerDidDismiss:) beforeObservedSelector:NO usingBlock:^(id self, UIPresentationController *presentationController) {
    // `viewController` was interactively dismissed by the user; here we can update our state or UI if necessary.
}];
```

Swift:  

```swift 
let viewControler: UIViewController = ...;
let delegate = viewController.presentationController?.delegate

...

let proxy = ProtocolProxy(protocol: UIAdaptivePresentationControllerDelegate.self, implementer: delegate)

if delegate?.responds(to: #selector(presentationControllerDidDismiss(_:))) != true {
    // delegate doesn't respond to the `presentationControllerDidDismiss(_:)` selector
    // so we set `respondsToSelectorsWithObservers` to true to ensure that our observer
    // closure gets called.
    proxy.respondsToSelectorsWithObservers = true
}

let overrideBlock: @convention(block) (AnyObject, UIPresentationController) -> Bool = { self, presentationController in 
    var shouldDismiss = false
    
    ...
    
    return shouldDismiss
}
let observerBlock: @convention(block) (AnyObject, UIPresentationController) -> Void = { self, presentationController in 
    // `viewController` was interactively dismissed by the user; here we can update our state or UI if necessary.
}

proxy.override(#selector(presentationControllerShouldDismiss(_:)), using: overrideBlock)
proxy.addObserver(for: #selector(presentationControllerDidDismiss(_:)), beforeObservedSelector: false, using: observerBlock)
```

During initialization `ProtocolProxy` builds a list of protocols that it conforms to, starting with the protocol(s) passed into its initializers and all protocols that are adopted by them. This search is done recursively so any hierical protocol structure like the following: 

```objc
@protocol Protocol1 <NSObject>
...
@end

@protocol Protocol2 <Protocol1>
...
@end

@protocol Protocol3 <Protocol2>
...
@end

...

ProtocolProxy *proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(Protocol3) implementer:...];
```

will be traversed accordingly and turned into a protocol list like:

```objc
@[@protocol(Protocol3), @protocol(Protocol2), @protocol(Protocol1), @protocol(NSObject)]
```

After initialization, the `ProtocolProxy` object can be *safely* cast to an object that adopts any of those protocols:

Objective-C:

```objc 
... = (id<Protocol1>)proxy; // safe
... = (id<Protocol2>)proxy; // safe
... = (id<Protocol3>)proxy; // safe
... = (id<NSObject>)proxy; // safe
... = (id<NSCopying>)proxy; // UNSAFE: -copyWithZone: does not belong to any of the adopted protocols so attempting to call it will throw an exception
```

Swift:

```swift
... = proxy as! Protocol1 // safe
... = proxy as? Protocol1 // produces a nonnil value

... = proxy as! Protocol2 // safe
... = proxy as? Protocol2 // produces a nonnil value

... = proxy as! Protocol3 // safe
... = proxy as? Protocol3 // produces a nonnil value

... = proxy as! NSObjectProtocol // safe
... = proxy as? NSObjectProtocol // produces a nonnil value

... = proxy as! NSCopying // UNSAFE: This cast will fail and cause a crash
... = proxy as? NSCopying // produces a nil value
```

---

When overriding a selector, there are three methods available:

```objc
- (BOOL)overrideSelector:(SEL)selector withTarget:(id)target;
- (BOOL)overrideSelector:(SEL)selector withTarget:(id)target targetSelector:(SEL __nullable)targetSelector;

- (BOOL)overrideSelector:(SEL)selector usingBlock:(id)block;
```

The first two methods override the given selector by registering an object (weak retention) as the target for the given selector. The object is expected to implement the exact method from the protocol its overriding. If the object already implements the protocol method for a different purpose, the second override method can be used to provide a differently named selector to call on the target object. This differently named method is expected to have the same signature as the method that's being overriden.

The third method is used to override the given selector by registering a block to be called instead. The block is expected to have an identical signature to the method being overriden with the exception of the hidden `_cmd` parameter: `method_return_type (^)(id self, method_args...)`. If the overriden method has no parameters aside from the hidden `self` and `_cmd` parameters or if none of the method parameters are needed within the block, it is safe to pass a block whose signature is: `method_return_type (^)(void)`. See [Limitations](#limitations) for working with Swift closures for this method. 

---

When observing a selector, there are three methods available:

```objc
- (BOOL)addObserver:(id)observer forSelector:(SEL)selector beforeObservedSelector:(BOOL)before;
- (BOOL)addObserver:(id)observer forSelector:(SEL)selector beforeObservedSelector:(BOOL)before observerSelector:(SEL __nullable)observerSelector;

- (BOOL)addObserverForSelector:(SEL)selector beforeObservedSelector:(BOOL)before usingBlock:(id)block;
```

The first two methods add an observer by registering an object (weak retention) to receive messages for the observed selector. The object is expected to implement the exact method from the protocol its observing. If the object already implements the protocol method for a different purpose, the second observer method can be used to provide a differently named selector to call on the target object. This differently named method is expected to have the same signature as the method that's being observed. For both cases, the `beforeObservedSelector` argument determines whether the observer is called prior to the observed selector being called (`YES`), or after the observed selector is called (`NO`).   

The third method is used to observe the given selector by registering a block. The block is expected to have an identical signature to the method being observed with the exception of the hidden `_cmd` parameter and with a `void` return type: `void (^)(id self, method_args...)`. If the observed method has no parameters aside from the hidden `self` and `_cmd` parameters or if none of the method parameters are needed within the block, it is safe to pass a block whose signature is: `void (^)(void)`. See [Limitations](#limitations) for working with Swift closures for this method.

Any values returned from the observers are ignored. Additionally, given that observers aren't supposed to iterrupt the normal flow of code that they are observing, any exceptions thrown from the observers are caught and ignored. Any observers that are registered to be called after an observed selector are called regardless of whether or not that selector throws an exception. 

---

ProtocolProxy's `-conformsToProtocol:` method will return `YES` for any protocol contained within the `adoptedProtocols` property, and its `-respondsToSelector:` method will return `YES` for any selector or property accessor declared by any of the adopted protocols that is either a required selector of the protocol or an optional selector that the `implementer` responds to.

## Considerations

`ProtocolProxy` declares a public property entitled `respondsToSelectorsWithObservers` that controls whether or not `ProtocolProxy` returns `YES` from `-respondsToSelector:` for optional methods that `implementer` doesn't respond to and the proxy has observers for. The purpose behind this property is for the situations where the `implementer` doesn't actually respond to a given method, but the code is setup in such a way that the observer for that method is expecting that method is get called. In this scenario the `respondsToSelectorsWithObservers` property gets set to `YES`. When the code working with this proxy gets to the point where it would call the observed method it's expected, given that the method is optional, would first call `-respondsToSelector:` to confirm that the proxy responds to the method. Since the proxy now declares that it responds to the method, the code should call the method which triggers the observation. 

This property, although useful, should be used sparingly given the potential of unintended side-effects as some pieces of code may make logical decisions based on whether or not the proxy responds to particular selectors.

Consider the scenario where a `ProtocolProxy` object is instantiated to conform to `UIAdaptivePresentationControllerDelegate` and set as the delegate of a `UIPresentationController`. Addtionally we setup an observer for the `-[UIAdaptivePresentationControllerDelegate adaptivePresentationStyleForPresentationController:traitCollection:` method of the protocol and the `implementer` for the proxy only implements the `-[UIAdaptivePresentationControllerDelegate adaptivePresentationStyleForPresentationController:` method. When the view controller associated with the presention controller presents, the controller would check its delegate (`ProtocolProxy`) to see if it responds to the `-[UIAdaptivePresentationControllerDelegate adaptivePresentationStyleForPresentationController:traitCollection:` method *first*. With the `respondsToSelectorsWithObservers` property set to `NO`, the proxy returns `NO` for `-respondsToSelector:` and the presentation controller falls back to calling `-[UIAdaptivePresentationControllerDelegate adaptivePresentationStyleForPresentationController:`.

For the same scenario but with the `respondsToSelectorsWithObservers` property set to `YES`, the proxy returns `YES` for `-respondsToSelector:`, which in turn causes the presentation controller to call the `-[UIAdaptivePresentationControllerDelegate adaptivePresentationStyleForPresentationController:traitCollection:` method instead. If the proxy has an override for this selector then there's really no issue, however, absent an override this method doesn't ever get forwarded anywhere leaving the value returned to the presentation controller as all zeros (`UIModalPresentationFullScreen`) which may be very different than the default value for when there is no delegate or when the delegate doesn't respond to either of these methods. 

If this property is used, it's recommended to narrow its use to only those methods that don't have a return value nor return values through pointer arguments. Using this property can be avoided altogether in some scenarios by conditionally overriding the method, running the observer's code, then forwarding on the method to the `implementer` if it responds to the method:

```objc
UIViewController *viewControler = ...;
id<UIAdaptivePresentationControllerDelegate> delegate = viewController.presentationController.delegate;

ProtocolProxy *proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(UIAdaptivePresentationControllerDelegate) implementer:delegate];

... 

[proxy overrideSelector:@selector(adaptivePresentationStyleForPresentationController:traitCollection:) usingBlock:^(id self, UIPresentationController *presentationController, UITraitCollection *traitCollection) {
    // observer code
    
    if ([delegate respondsToSelector:@selector(adaptivePresentationStyleForPresentationController:traitCollection:)]) {
        return [delegate adaptivePresentationStyleForPresentationController:presentationController traitCollection:traitCollection];
    } else {
        return <Default UIModalPresentationStyle>; 
    }
}];

OR

void (^observerBlock)(id, UIPresentationController *, UITraitCollection *) = ^(id self, UIPresentationController *presentationController, UITraitCollection *traitCollection) {
    // observer code
};

if ([delegate respondsToSelector:@selector(adaptivePresentationStyleForPresentationController:traitCollection:)]) {
    [proxy addObserverForSelector:@selector(adaptivePresentationStyleForPresentationController:traitCollection:) usingBlock:observerBlock];
} else {
    [proxy overrideSelector:@selector(adaptivePresentationStyleForPresentationController:traitCollection:) usingBlock:^(id self, UIPresentationController *presentationController, UITraitCollection *traitCollection) {
        observerBlock(self, presentationController, traitCollection);
        return <Default UIModalPresentationStyle>;
    }];
}
```

---

`ProtocolProxy` provides three properties, mostly being for convenience:

- `implementer` gets the object that was passed into one of its initializers.
- `adoptedProtocols` gets the list of protocols this proxy conforms to.
- `respondsToSelectorsWithObservers` gets or sets a flag for determining how to respond to optional methods that `implementer` doesn't implement.

Given that `ProtocolProxy` is supposed to serve as a stand-in for protocols there's a chance, however slight, that this object could be initialized with a protocol that declares methods or properties whose names overlap exactly with the names of these properties. In that scenario, calling the overlapped property(ies) will no longer get or set the values listed above. Instead, the call will follow the normal forwarding routine regardless of whether or not `implementer` is `nil` or if the overlapped methods/properties are optional and not implemented by `implementer`.

In this scenario, these properties can still be accessed by using the `object_getIvar`/`object_setIvar` Objective-C runtime functions with the respective propery names preceded by an underscore: `_implementer`, `_adoptedProtocols`, `_respondsToSelectorsWithObservers`.

---

For the  `-overrideSelector:usingBlock:` and `-addObserverForSelector:beforeObservedSelector:usingBlock:` methods, the first paramater (if any) for the block is the `self` parameter, which for normal methods would correspond to the object being sent the message. Per convention this should be `implementer`, however, due to threading considerations this is instead a temporary stand-in object that inherits directly from `NSProxy`. This object has no value other than filling a required argument slot.

## Limitations

The main limitation of this library is its interoperability with Swift closures. Unfortunately due to compiler differences Swift closures aren't directly compatible with the `-overrideSelector:usingBlock:` and `-addObserverForSelector:beforeObservedSelector:usingBlock:` methods, however, Swift closures declared with the `@convention(block)` attribute are and can be done so in the following way:

```swift
let proxy: ProtocolProxy = ...
let observerBlock: @convention(block) () -> Void = {
    // Do some stuff here...
}

proxy.addObserver(for: #selector(foobar), beforeObservedSelector: true, using: observerBlock)
```

Presently there is no way to inline the `@convention(block)` attribute to be able to declare the closure within the method call, therefore a local variable with an explicit type must be created for compatability with these methods. If this attribute is forgotten both of these methods will return `false` when attempting to register an override or an observer. 

## Author

Joseph Newton, somerandomiosdev@gmail.com

## License

ProtocolProxy is available under the MIT license. See the LICENSE file for more info.
