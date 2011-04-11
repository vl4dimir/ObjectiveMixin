ObjectiveMixin
==============

The ObjectiveMixin class is a quick hack that allows Objective-C classes to receive additional functionality at runtime, similar to the way [Ruby mixins][1] work. You can extend a class using methods defined in some other class, and gain that class's functionality for free. Since Objective-C doesn't support multiple inheritance, this can be quite useful at times when subclassing isn't an option and protocols don't do exactly what you want.

This works by taking advantage of the Objective-C runtime environment and its ability to add methods to an existing class while the program is executing. By specifying source and destination classes when performing a "mixing" operation, the destination class gains all of the source class's method implementations.

There's a small limitation due to the fact that instance variables cannot be added after the class pair is created (see the [Apple docs][2] for the `class_addIvar` function). Thus, the source class's method implementations must not contain direct references to instance variables. This can be easily circumvented by accessing ivars through properties instead of accessing them directly (i.e. `self.someValue` instead of `someValue`). The runtime will then synthesize the property in the destination instance (instance, not class!) and will work normally.

Example
-------

Say you have a source class that looks like this:

	@interface SourceClass : NSObject {
		NSString* myClassName;
	}
	
	@property (nonatomic, retain) NSString* myClassName;
	
	- (void) whatsMyName;
	
	@end
	
	@implementation SourceClass
	@synthesize myClassName;
	
	- (void) whatsMyName {
		self.myClassName = [[self class] description];
		NSLog(@"My class name is: %@", myClassName);
	}
	
	@end

If you then use the `Mixin` class to extend `DestinationClass` with `SourceClass`, you get this:

	DestinationClass* destination = [[DestinationClass alloc] init];
	[Mixin from:[SourceClass class] into:[DestinationClass class]];
	[(id)destination whatsMyName];	// Prints "My class name is: DestinationClass"

Even though the `myClassName` instance variable does not exist in `DestinationClass` definition, it is synthesized at runtime in the `destination` object, and everything works fine.

Note that in order to avoid "object may not respond to selector" compiler warnings you have to cast the `destination` variable to the `id` type (or alternatively, to `SourceClass`, but `id` is cleaner in my opinion).

You can also use `[Mixin from:[SourceClass class] into:[DestinationClass class] followInheritance:YES];` to mix in all `SourceClass`'s inherited methods, up to the common ancestor of `SourceClass` and `DestinationClass`. In other words, if we have the following inheritance trees: `SourceClass -> BaseClass -> NSObject` and `DestinationClass -> NSObject`, then the `from:into:followInheritance:` method will mix in methods from both `SourceClass` and `BaseClass` into `DestinationClass`, but not from `NSObject` since it's their common ancestor (they already inherit its methods).

Why?
----

This is just another mechanism you can use when designing your class hierarchy, in addition to the usual Objective-C design patterns. For example, you can have an algorithm that is used by multiple classes and you don't want to "pollute" their ancestor by extending it with a category. Plus, this is a runtime feature so it opens a lot of doors for experimentation.

I can't think of anything else right now, but this README is already longer than the actual code. :P

[1]: http://www.ruby-doc.org/docs/ProgrammingRuby/html/tut_modules.html
[2]: https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html