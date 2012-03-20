ObjectiveMixin
==============

ObjectiveMixin allows Objective-C classes to receive additional functionality at runtime, similar to the way [Ruby mixins][1] work. You can extend a class using methods defined in some other class, and gain that class's functionality for free. Since Objective-C doesn't support multiple inheritance, this can be quite useful at times when subclassing isn't an option and protocols don't do exactly what you want.

This works by taking advantage of the Objective-C runtime environment and its ability to add methods to an existing class while the program is executing. By specifying source and destination classes when performing a "mixing" operation, the destination class gains all of the source class's method implementations.

There's a small limitation due to the fact that instance variables cannot be added after the class pair is created (see [Apple docs][2] for `class_addIvar`). Thus, the source class's method implementations must not contain direct references to instance variables. This can be easily circumvented by accessing ivars through properties instead of accessing them directly (i.e. `self.someValue` instead of `someValue`). The runtime will then synthesize the property in the destination instance (instance, not class!) and will work normally.

Usage
-----

1. Copy `Mixin.h` and `Mixin.m` into your project.
2. `#import "Mixin.h"`
3. Have fun.

Basic Example
-------------

Say you have a source class that looks like this:

	@interface Ninja : NSObject {
		NSString* clanName;
	}
	
	@property (nonatomic, retain) NSString* clanName;
	
	- (void) doNinjaStuff;
	
	@end
	
	@implementation Ninja
	@synthesize clanName;
	
	- (void) doNinjaStuff {
		self.clanName = @"Iga";
		NSLog(@"I'm a %@ and my clan name is %@", [[self class] description], self.clanName);
	}
	
	@end

If you then use `Mixin` to extend `Turtle` with `Ninja`, you get this:

	Turtle* turtle = [[Turtle alloc] init];
	[Mixin from:[Ninja class] into:[Turtle class]];
	[(id)turtle doNinjaStuff];	// Prints "I'm a Turtle and my clan name is Iga"

Even though the `clanName` instance variable does not exist in `Turtle`'s definition, it is synthesized at runtime in the `turtle` object, and everything works fine.

Note that in order to avoid "object may not respond to selector" compiler warnings you have to cast the `turtle` variable to the `id` type (or alternatively, to `Ninja`, but `id` is cleaner in my opinion). Read the next section to see how to avoid this.

You can also use `[Mixin from:[Ninja class] into:[Turtle class] followInheritance:YES];` to mix in all `Ninja`'s inherited methods, up to the common ancestor of `Ninja` and `Turtle`. In other words, if we have the following inheritance trees: `Ninja -> Human -> NSObject` and `Turtle -> NSObject`, then the `from:into:followInheritance:` method will mix in methods from both `Ninja` and `Human` into `Turtle`, but not from `NSObject` since it's their common ancestor (they already inherit its methods).

There's also a convenient category defined on top of `NSObject` (it's defined in `Mixin.h` as well), so you can use it instead of calling `Mixin` class methods:

	Turtle* turtle = [[turtle alloc] init];
	[turtle mixinFrom:[Ninja class]];	// Or mixinFrom:followInheritance:
	[(id)turtle doNinjaStuff];	// Prints "I'm a Turtle and my clan name is Iga"

Be aware that this is just syntactic sugar - even though the method is called on an object instance, it still extends the class itself. I actually prefer using the `Mixin` class, since it is more clear by reading the code that you're extending the class functionality, not just the functionality of a single object.

More Subtle Example
-------------------

Take a look at `Examples/Serializable.h`. There's a `Serializable` class there which you mix into your class at runtime, and there's a `SerializableMixin` protocol which your class should implement.

Methods that are marked as `@required` have to be implemented by your class, and methods that are marked as `@optional` will be mixed in from the `Serializable` class at runtime. The optional methods are defined in the protocol in order to avoid "object may not respond to selector" compiler warnings.

Now take a look at `ObjectiveMixinExamples/MountainBike.h`. This class complies with the `SerializableMixin` protocol, by implementing the two required methods from that protocol. In `ObjectiveMixinExamples/MountainBike.m` you can see that the `Serializable` class is mixed in in the `initialize` class method, which is invoked by the Obj-C runtime only once at class creation time. This way you're free from worrying about whether you already mixed in a certain class - this code is guaranteed to run only once.

(This approach was suggested to me by Benedict Cohen (@benedictC), thanks man!)

You should also check out the `Singleton` example in `Examples/Singleton.h`, I use that one a lot.

Why?
----

This is just another mechanism you can use when designing your class hierarchy, in addition to the usual Objective-C design patterns. For example, you can have an algorithm that is used by multiple classes and you don't want to "pollute" their ancestor by extending it with a category. Plus, this is a runtime feature so it opens a lot of doors for experimentation. Feel free to read up on some Ruby mixin usage examples and implement them in Obj-C.

Fun!




Update by Jamie Montgomerie
---------------------------

Dynamic Subclassing
-------------------

It's now also possible to dynamically create a subclass at runtime.  In some ways, this is akin to being able to create concrete methods in protocols.

For example, you might declare a UIView mixin that stores a block that will be called in place of -drawRect: like this:

    @protocol THDrawRectWithBlocks <NSObject>
    @property (nonatomic, copy) void(^drawRectBlock)(UIView *self, CGRect rect);
    @end

    @interface THDrawRectWithBlocksMixin : UIView <THDrawRectWithBlocks>
    @end

Implemented like this:

    @implementation THDrawRectWithBlocksMixin

    @synthesize drawRectBlock;

    - (void)drawRect:(CGRect)rect
    {
        self.drawRectBlock(self, rect);
    }

    @end

You can then instantiate objects using the -allocWithSuperclass: method.  For example, this will create a UIButton that has the methods from your THDrawRectWithBlocks class:

    UIButton<THDrawRectWithBlocks> *button = [(UIButton<THDrawRectWithBlocks> *)[THDrawRectWithBlocksMixin allocWithSuperclass:[UIButton class]] initWithFrame:self.view.bounds];
    
    button.drawRectBlock = ^(UIView *view, CGRect rect) {
        [[UIColor redColor] set];
        UIRectFill(rect);
    };
    
Because the subclass is a 'real' subclass, even though it's created at runtime, it is possible (as in the above example) to declare properties and even ivars in the mixin class.
    
If you name your class with a "Mixin" suffix, and your protocol without one (as in this example), Objective Mixin will ensure that the dynamically created class is correctly marked as conforming to the protocol (so, in thie example, objects will respond to [button conformsToProtocol:@protocol(THDrawRectWithBlocks)] with YES).

Note that calling 'super' in your mixin code will, at runtime, call the method of the _dynamic_ superclass (so, in this case, it would be _UIButton's_ methods that would be called, _not UIView's_).


More than one dynamic superclass
--------------------------------

The convenience -allocWithSuperclass: method isn't powerful enough to allow more than one dynamic superclass, but you can use the more general -classWithSuperclass: method to 'chain' mixins, like this:

    [[MySecondUIViewMixin classWithSuperclass:[MyFirstUIViewMixin classWithSuperclass:UIView] alloc] init];



[1]: http://www.ruby-doc.org/docs/ProgrammingRuby/html/tut_modules.html
[2]: https://developer.apple.com/library/ios/#documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html
