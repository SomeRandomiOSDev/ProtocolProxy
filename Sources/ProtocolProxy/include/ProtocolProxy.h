//
//  ProtocolProxy.h
//  ProtocolProxy
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ProtocolProxy Interface

/**
 A proxy object for observing or overriding selectors of one or more protocols
 */
@interface ProtocolProxy: NSProxy

#pragma mark Public Properties

/**
 The object, if any, that implements the protocols found in @p adoptedProtocols
 */
@property (nonatomic, weak, readonly, nullable) id implementer;

/**
 A list of protocols that this proxy conforms to. This list will likely be larger
 than the original list of protocols passed in to the initializer of this object
 given that some protocols conform to protocols themself and most (if not all)
 protocols conform to the @p NSObject protocol.
 */
@property (nonatomic, strong, readonly) NSArray<Protocol *> *adoptedProtocols;

/**
 A flag that determines whether or not this proxy will responds to optional
 selectors when there are registered observers but no implementer or an
 implementer that doesn't respond to the selector. The default value is @p NO.

 @discussion @p ProtocolProxy relies on a two main points when determining
 whether or not it responds to a given selector: whether or not the selector is
 declared as optional in the protocol, and whether or not the @p implementer (if
 any) responds to the selector.

 For required selectors, @p ProtocolProxy can easily say that it @a does respond
 to that selector, however, when the selector is optional @p ProtocolProxy has to
 fall back to consulting the @p implementer responds to the selector. If the @p
 implementer doesn't respond to the selector this could potentially cause an
 issue when observers expect that the given method will be called at some point.
 To remedy this one could set this flag to @p YES which would tell @p
 ProtocolProxy to return @p YES when asked whether or not is responds to a given
 selector.

 @warning A word of caution: although this resolves one issue, this could
 potentially cause unforseen issues as other code may make logical decisions
 based on whether or not this object responds to certain selectors. Additionally,
 when this is performed on selectors that have a return value, the bytes of the
 value returned to the calling code are always set to zero.
 */
@property (nonatomic, assign) BOOL respondsToSelectorsWithObservers;

#pragma mark Initialization

/**
 Initializes a new proxy object that declares conformance to @p protocol, and all
 protocols that @p protocol conforms to, and forwards selectors from those
 protocols to @p implementer (if present).

 @param protocol The Objective-C protocol that this proxy object will declare
 conformance to. An exception is thrown if this parameter is @p nil.
 @param implementer The object that this proxy will forward messages to. This
 object is captured with a @a weak reference. This object is also @a assumed to
 conform to @p protocol and therefore all required selectors from @p protocol are
 sent without checking @p -respondsToSelector: first.
 */
- (instancetype)initWithProtocol:(Protocol *)protocol implementer:(nullable id)implementer NS_SWIFT_NAME(init(protocol:implementer:));

/**
 Initializes a new proxy object that declares conformance to @p protocol, and all
 protocols that @p protocol conforms to, and forwards selectors from those
 protocols to @p implementer (if present).

 @param protocol The Objective-C protocol that this proxy object will declare
 conformance to. An exception is thrown if this parameter is @p nil.
 @param implementer The object that this proxy will forward messages to. This
 object is captured with a @a strong reference. This object is also @a assumed to
 conform to @p protocol and therefore all required selectors from @p protocol are
 sent without checking @p -respondsToSelector: first.
 */
- (instancetype)initWithProtocol:(Protocol *)protocol stronglyRetainedImplementer:(nullable id)implementer NS_SWIFT_NAME(init(protocol:stronglyRetainedImplementer:));

/**
 Initializes a new proxy object that declares conformance to all protocols
 contained within @p protocols, and all protocols that each protocol in
 @p protocols conforms to, and forwards selectors from those protocols to
 @p implementer (if present).

 @param protocols The Objective-C protocols that this proxy object will declare
 conformance to. An exception is thrown if this parameter is @p nil or empty.
 @param implementer The object that this proxy will forward messages to. This
 object is captured with a @a weak reference. This object is also @a assumed to
 conform to @p protocol and therefore all required selectors from @p protocol are
 sent without checking @p -respondsToSelector: first.
 */
- (instancetype)initWithProtocols:(NSArray<Protocol *> *)protocols implementer:(nullable id)implementer NS_DESIGNATED_INITIALIZER;

/**
 Initializes a new proxy object that declares conformance to all protocols
 contained within @p protocols, and all protocols that each protocol in
 @p protocols conforms to, and forwards selectors from those protocols to
 @p implementer (if present).

 @param protocols The Objective-C protocols that this proxy object will declare
 conformance to. An exception is thrown if this parameter is @p nil or empty.
 @param implementer The object that this proxy will forward messages to. This
 object is captured with a @a strong reference. This object is also @a assumed to
 conform to @p protocol and therefore all required selectors from @p protocol are
 sent without checking @p -respondsToSelector: first.
 */
- (instancetype)initWithProtocols:(NSArray<Protocol *> *)protocols stronglyRetainedImplementer:(nullable id)implementer NS_DESIGNATED_INITIALIZER;

#pragma mark Public Methods

/**
 Adds an override for a given @p selector.

 @param selector The selector from one of the adopted protocols to override.
 @param target The object to send the overriden selector message to. This object
 is captured with a @a weak reference therefore it needs to be retained
 elsewhere. If this object is deallocated after registering this override, the
 override will be automatically unregistered.

 @returns @p YES if the selector was successfully overriden, @p NO otherwise. The
 override will fail to be registered if @p selector or @p target are @p nil, if
 @p selector doesn't belong to any of the adopted protocols, or if there is
 already an override registered for this selector.
 */
- (BOOL)overrideSelector:(SEL)selector withTarget:(id)target NS_REFINED_FOR_SWIFT;

/**
 Adds an override for a given @p selector.

 @param selector The selector from one of the adopted protocols to override.
 @param target The object to send the overriden selector message to. This object
 is captured with a @a weak reference therefore it needs to be retained
 elsewhere. If this object is deallocated after registering this override, the
 override will be automatically unregistered.
 @param targetSelector The selector to call on @p target for this override. This
 selector should have the same method signature as the @p selector being
 overriden.

 @returns @p YES if the selector was successfully overriden, @p NO otherwise. The
 override will fail to be registered if @p selector or @p target are @p nil, if
 @p selector doesn't belong to any of the adopted protocols, or if there is
 already an override registered for this selector.
 */
- (BOOL)overrideSelector:(SEL)selector withTarget:(id)target targetSelector:(SEL __nullable)targetSelector NS_REFINED_FOR_SWIFT;

/**
 Adds an override for a given @p selector.

 @param selector The selector from one of the adopted protocols to override.
 @param block An Objective-C block to call in place of the overriden selector.
 The signature of this block should be: method_return_type ^(id self,
 method_args...). The first @p self parameter of the block can safely be omitted
 if the method has @a no @a additional @a parameters. This block is copied with
 @p Block_copy().

 @returns @p YES if the selector was successfully overriden, @p NO otherwise. The
 override will fail to be registered if @p selector or @p block are @p nil, if
 @p selector doesn't belong to any of the adopted protocols, if there is
 already an override registered for this selector or if @p block isn't a valid
 Objective-C block.

 @discussion The @p block parameter must be an Objective-C block type.
 Unfortunately standard Swift closures are incompatible and will not work with
 this method. To be able to call this method from Swift, the closure that you
 pass in needs to have been decorated with the @p @@convention(block) attribute at
 the time of declaration:

 @code
 let block: @convention(block) () -> Void = {
    ...
 }

 proxy.override(#selector(foobar), using: block)
 @endcode
 */
- (BOOL)overrideSelector:(SEL)selector usingBlock:(id)block NS_SWIFT_NAME(override(_:using:));

//

/**
 Adds an observer for a given @p selector.

 @param observer The object to send the observed selector message to. This object
 is captured with a @a weak reference therefore it needs to be retained
 elsewhere. If this object is deallocated after registering for observing, it
 will be automatically unregistered.
 @param selector The selector from one of the adopted protocols to observe.
 @param before A flag that determines whether the observer will be called @a
 before the message is sent the original implementation or @a after.

 @returns @p YES if the @p observer was successfully registered for the given @p
 selector, @p NO otherwise. The observer will fail to be registered if @p
 observer or @p selector are @p nil or if @p selector doesn't belong to any of
 the adopted protocols.

 @discussion If the observed @p selector's signature has a return value, the
 value returned from the observer is @a ignored.
 */
- (BOOL)addObserver:(id)observer forSelector:(SEL)selector beforeObservedSelector:(BOOL)before NS_REFINED_FOR_SWIFT;

/**
 Adds an observer for a given @p selector.

 @param observer The object to send the observed selector message to. This object
 is captured with a @a weak reference therefore it needs to be retained
 elsewhere. If this object is deallocated after registering for observing, it
 will be automatically unregistered.
 @param selector The selector from one of the adopted protocols to observe.
 @param before A flag that determines whether the observer will be called @a
 before the message is sent the original implementation or @a after.
 @param observerSelector The selector to call on @p observer for this
 observation. This selector should have the same method signature as the @p
 selector being observed.

 @returns @p YES if the @p observer was successfully registered for the given @p
 selector, @p NO otherwise. The observer will fail to be registered if @p
 observer or @p selector are @p nil or if @p selector doesn't belong to any of
 the adopted protocols.

 @discussion If the observed @p selector's signature has a return value, the
 value returned from the observer is @a ignored.
 */
- (BOOL)addObserver:(id)observer forSelector:(SEL)selector beforeObservedSelector:(BOOL)before observerSelector:(SEL __nullable)observerSelector NS_REFINED_FOR_SWIFT;

/**
 Adds an observer for a given @p selector.

 @param selector The selector from one of the adopted protocols to observe.
 @param before A flag that determines whether the observer will be called @a
 before the message is sent the original implementation or @a after.
 @param block An Objective-C block to call in place of the overriden selector.
 The signature of this block should be: void ^(id self, method_args...). The
 first @p self parameter of the block can safely be omitted if the method has
 @a no @a additional @a parameters. This block is copied with @p Block_copy().

 @returns @p YES if the @p observer was successfully registered for the given
 @p selector, @p NO otherwise. The observer will fail to be registered if
 @p selector or @p block are @p nil, if @p selector doesn't belong to any of the
 adopted protocols or if @p block isn't a valid Objective-C block.

 @discussion The @p block parameter must be an Objective-C block type.
 Unfortunately standard Swift closures are incompatible and will not work with
 this method. To be able to call this method from Swift, the closure that's
 passed in needs to have been decorated with the @p @@convention(block) attribute
 at the time of declaration:

 @code
 let block: @convention(block) () -> Void = {
    ...
 }

 proxy.addObserver(for: #selector(foobar), beforeObservedSelector: true, using: block)
 @endcode
 */
- (BOOL)addObserverForSelector:(SEL)selector beforeObservedSelector:(BOOL)before usingBlock:(id)block NS_SWIFT_NAME(addObserver(for:beforeObservedSelector:using:));

@end

NS_ASSUME_NONNULL_END
