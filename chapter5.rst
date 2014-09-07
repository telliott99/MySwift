.. _chapter5:

##############
Advanced Swift
##############

.. _closures:

****************
More on Closures
****************

The description of closures given in the docs gives these advantages:

    Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages.

    Closures can capture and store references to any constants and variables from the context in which they are defined. This is known as closing over those constants and variables, hence the name "closures." Swift handles all of the memory management of capturing for you.

They go on:

    Global and nested functions, as introduced in Functions, are actually special cases of closures. Closures take one of three forms:

    -Global functions are closures that have a name and do not capture any values.
    
    -Nested functions are closures that have a name and can capture values from their en closing function.
    
    -Closure expressions are unnamed closures written in a light weight syntax that can capture values from their surrounding context.

So a key feature is that closures capture values from the environment when they are called.  Global functions don't do this.  Or they shouldn't.  However this:

.. sourcecode:: bash

    let s = "Hello"
    func f() { println(s) }
    f()
    
Actually *does* print ``Hello``.

In the next example, we return a function from a function.  The function's type is ``() -> ()``, that is, it takes no arguments and returns void.

.. sourcecode:: bash

    let s = "Hello"
    func f() -> () -> () {
        func g() {
             println(s)
        }
        return g
    }
    let h = f()
    h()
    
.. sourcecode:: bash
    
    > xcrun swift test.swift
    Hello
    >
    
We can modify it to eliminate the identifier ``g``:

.. sourcecode:: bash

    let s = "Hello"
    func f() -> () -> () {
        return { println(s) }
    }
    let h = f()
    h()
    
.. sourcecode:: bash
    
    > xcrun swift test.swift
    Hello
    >
    
The following also works, but I can't say I think it's a good idea:

.. sourcecode:: bash

    let s = "Hello"
    var x = 5
    func f() { 
        x += 1
        println(x) 
    }
    f()
    f()

.. sourcecode:: bash

    > xcrun swift test.swift
    6
    7
    >

A great example of progressive simplification of closures is the global ``sorted`` function, which takes an array to be sorted and a sort method as the second argument.  So to sort Strings you might write this code:

.. sourcecode:: bash

    func rev(s1: String, s2: String) -> Bool { return s1 > s2 }
    var a = ["a","b","c"]
    a.sort(rev)
    println(a)
    // [c, b, a]
    
To sort Ints *or* Strings, you could write a "generic" function, something like this:

.. sourcecode:: bash

    func rev <T:Comparable> (s1: T, s2: T) 
        -> Bool { return s1 > s2 }
    var a = ["a","b","c"]
    a.sort(rev)
    println(a)

    var b = [1, 2, 3]
    b.sort(rev)
    println(b)

.. sourcecode:: bash

    > xcrun swift test.swift
    [c, b, a]
    [3, 2, 1]
    >

but we'll hold off on those until :ref:`generics`.

Or we might use the ``rev`` function with ``sorted``

.. sourcecode:: bash

    func rev(s1: String, s2: String) -> Bool { return s1 > s2 }
    let names = ["Bob", "Alex", "Charlie"]
    let a = sorted(names, rev)
    println(a)
    // ["Charlie", "Bob", "Alex"]

In this case, it does seem silly to use a name for ``rev``, since we only put it immediately as the second argument to ``sorted``.  Use a closure:

.. sourcecode:: bash

    let names = ["Bob", "Alex", "Charlie"]
    let reversed = sorted(names, {
         (s1: String, s2: String) -> (Bool)
         in return s1 > s2})
    println(reversed)
    // [Charlie, Bob, Alex]

In fact, the docs say that the closure's argument types can *always* be inferred from the context when a closure is passed as an argument to another function.  In fact, the return type can be inferred as well.  So we can lose them and the compiler won't complain:

.. sourcecode:: bash

    let names = ["Bob", "Alex", "Charlie"]
    let reversed = sorted(names,{ s1, s2 in return s1 > s2})
    println(reversed)
    // [Charlie, Bob, Alex]

If the entire closure is a single expression, the return can also be omitted.

.. sourcecode:: bash

    let names = ["Bob", "Alex", "Charlie"]
    let reversed = sorted(names,{ s1, s2 in s1 > s2})
    println(reversed)
    // [Charlie, Bob, Alex]

Now admittedly, this is pretty brief.  

In addition to that, the ``in`` looks weird, so I try to suppress my instinct to parse its meaning, but just remember that it means:  the closure body is beginning now.

As we saw in the previous section :ref:`closures`, we don't need variable names

.. sourcecode:: bash

    let names = ["Bob", "Alex", "Charlie"]
    let reversed = sorted(names, { $0 > $1} )
    println(reversed)
    // [Charlie, Bob, Alex]

I found out later that even passing in an operator will work!

.. sourcecode:: bash

    let names = ["Bob", "Alex", "Charlie"]
    let reversed = sorted(names, >)
    println(reversed)
    // [Charlie, Bob, Alex]
    
And finally, you can do either one of these
    
.. sourcecode:: bash

.. sourcecode:: bash
    
    let a = [1,2,3]
    let b = sorted(a, { $0 > $1 } )
    println(b)
    //[3, 2, 1]
    
.. sourcecode:: bash
    
    let a = [1,2,3]
    let b = sorted(a) { $0 > $1 }
    println(b)
    // [3, 2, 1]

or even this (``sort`` with no other arguments):

.. sourcecode:: bash

    var a = [1,2,3]
    a.sort { $0 > $1 }
    println(a)
    // [3, 2, 1]
    
These are called "trailing" closures.

For a list of different ways to use closures in Swift, you might look here:

http://fuckingclosuresyntax.com

We covered most of these in the sort example above. 

A lot of the complexity comes from the compiler being able to infer argument types and return types, and even arguments and return values themselves, as well as being able to dispense with the call operator ``()`` in some cases.

At the top of the list in the web resource are these:

    - variable
    - typealias
    - constant

With this declaration syntax (``c`` is for closure, ``p`` for parameter, and ``r`` for return):

.. sourcecode:: bash

    var cName: (pTypes) -> (rType)
    typealias cType = (pTypes) -> (rType)
    let cName: closureType = { ... }

Let's start with a closure that takes a String argument and returns one as well:

.. sourcecode:: bash

    func f (name: String, myC: (String) -> String) -> String {
            let t = myC(name)
            return "*" + t + "*"
        }

    let result = f("Peter Pan", { s in "Hello " + s } )
    println(result)

.. sourcecode:: bash

    > xcrun swift test.swift
    *Hello Peter Pan*
    >

In this part of the above definition

.. sourcecode:: bash

    func f (name: String, myC: (String) -> String) -> String {

The last ``{`` is the beginning of the function, the last ``-> String`` is the functions return type, and the function's argument list consists of

.. sourcecode:: bash

    (name: String, myC: (String) -> String)

We can modify this example by using a ``typealias``, as follows

.. sourcecode:: bash

    typealias greeting = (String) -> (String)
    func f(name: String, myC: greeting) -> String {
        let t = myC(name)
        return "*" + t + "*"
    }

    let result = f("Peter Pan", { s in "Hello " + s } )
    println(result)

That helps, but only a little bit.  What helps more (though it makes things a little murkier), is being able to leave things out.  If the function doesn't return anything, we can do this:


(more)


One important usage is the Cocoa idiom to use blocks for callbacks from open and save panels.  In Objective C we have this method:

.. sourcecode:: bash

    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
                NSURL*  theFile = [panel URL];
                // Write the contents in the new format.
        }
    }];
    
The structure here is that the method takes an Objective C "block", similar to what we now know as closures in Swift.  The block's code is contained inside the method call, anonymously, comprising everything up to the ``}];``.

The second parameter is 

.. sourcecode:: bash

    completionHandler:^(NSInteger result) { }
    
An ``^(NSInteger result) { .. }`` defines a block that takes an ``NSInteger`` and doesn't return anything.  That's the type of block that this method on NSOpenPanel is declared to take, and the compiler looks for it.

If we're going to do this in Swift, we'll do something like

.. sourcecode:: bash

    func f (name: String, myC: (String) -> String) -> String {

from before, except our closure won't return anything and the method won't return anything either..

.. sourcecode:: bash

    panel.beginWithCompletionHandler(handler:###)

We need to replace the ``###`` with a block/closure that takes an NSInteger and doesn't return anything..

.. sourcecode:: bash

    import Cocoa
    var op = NSOpenPanel()

    op.prompt = "Open File:"
    op.title = "A title"
    op.message = "A message"
    // op.canChooseFiles = true  // default
    // op.worksWhenModal = true  // default
    op.allowsMultipleSelection = false
    // op.canChooseDirectories = true  // default
    op.resolvesAliases = true
    op.allowedFileTypes = ["txt"]

    let home = NSHomeDirectory()
    let d = home.stringByAppendingString("/Desktop/")
    op.directoryURL = NSURL(string: d)

    op.beginWithCompletionHandler( { (result: NSInteger) -> Void in 
        if (result == NSFileHandlingPanelOKButton) {
            let theFile = op.URL
            println(theFile)
        }
    })

It works!  (If you execute ``test.swift`` from the command line it just runs with no panel, paste it into an Xcode project to see it working).

Another example uses a "trailing" closure:

http://meandmark.com/blog/

.. sourcecode:: bash

    op.beginWithCompletionHandler { (result: NSInteger) -> Void in 
        if (result == NSFileHandlingPanelOKButton) {
            let theFile = op.URL
            println(theFile)
        }
    }

The method has no ``()`` call operator.

You can wrap everything from ``{ result: Int .. println(f) }}`` in parentheses like a regular method call, and that'll still work.

Also, since the types of the arguments can be figured out, it should be possible to lose the type information and just have:

.. sourcecode:: bash

    op.beginWithCompletionHandler {

but so far, this doesn't work.  I get

.. sourcecode:: bash

    > xcrun swift test.swift
    test.swift:5:15: error: cannot convert the \
    expression's type '() -> () -> $T0' \
    to type '() -> () -> $T0'
    var handler = { 
                  ^~
    >

I also thought I should be able to do:

.. sourcecode:: bash

    var handler = {
        if ($0 == NSFileHandlingPanelOKButton) {
            let f = op.URL
            println(f)
        }
    }

but that also doesn't work.

However, what does work is to separate the handler code from its invocation.  Define a variable to hold the ``handler``:

.. sourcecode:: bash

    var handler = { (result: Int) -> Void in
        if (result == NSFileHandlingPanelOKButton) {
            let f = op.URL
            println(f)
        }
    }

Put the above just after ``var op = NSOpenPanel()`` and call

.. sourcecode:: bash

    op.beginWithCompletionHandler(handler)

Or we could think about just turning it into a named function.

.. sourcecode:: bash

    func handler(result: NSInteger) {
        if (result == NSFileHandlingPanelOKButton) {
            let f = op.URL
            println(f)
        }
    }

That works.  And in this latter case, we can lose the return type of ``Void`` that seems to be required when we define ``handler`` as a closure.'

Note:  the function approach should not work, because according to the docs, a function should not be able to capture the variable ``op`` from the surrounding scope.  So fire up a new Xcode project (Swift-only) and let's see:

Stick this into the AppDelegate and call it from ``applicationDidFinishLaunching``:

.. sourcecode:: bash

    func doOpenPanel() {
        var op = NSOpenPanel()
        func handler(result: NSInteger) {
            if (result == NSFileHandlingPanelOKButton) {
                let f = op.URL
                println(f)
            }
            else {
                println("user cancelled")
            }
        }
        op.prompt = "Open File:"
        op.title = "A title"
        op.message = "A message"
        // op.canChooseFiles = true  // default
        // op.worksWhenModal = true  // default
        op.allowsMultipleSelection = false
        // op.canChooseDirectories = true  // default
        op.resolvesAliases = true
        op.allowedFileTypes = ["txt"]
        
        let home = NSHomeDirectory()
        let d = home.stringByAppendingString("/Desktop/")
        op.directoryURL = NSURL(string: d)
        op.beginWithCompletionHandler(handler)
        
    }

It works, printing ``file:///Users/telliott_admin/Desktop/x.txt``


.. image:: /figures/open_panel2.png
   :scale: 75 %

**********
Subscripts
**********

Here is a slightly reworked example from the docs

.. sourcecode:: bash

    struct TimesTable {
        let multiplier: Int
        subscript(index: Int) -> Int {
            return multiplier * index
        }
    }

    var n = 6
    let t3 = TimesTable(multiplier: 3)
    println("\(n) times \(t3.multiplier) is \(t3[n])")

I think you can guess what this is going to print.  Subscripts are like what we call the ``__getitem__`` operator in Python:  ``[index]``.

You define ``subscript(index: Int) -> Int { }`` and then you can use it by calling ``mystruct[3]`` or whatever.

.. sourcecode:: bash

    > xcrun swift test.swift
    6 times 3 is 18
    > 

Additional behavior includes the ability to replace both "getters" and "setters" with subscripts, as if your class were a type of dictionary.

    Subscripts can take any number of input parameters, and these input parameters can be of any type. Subscripts can also return any type. Subscripts can use variable parameters and variadic parameters, but cannot use in-out parameters or provide default parameter values.

    A class or structure can provide as many subscript implementations as it needs, and the appropriate subscript to be used will be inferred based on the types of the value or values that are contained within the subscript braces at the point that the subscript is used. This definition of multiple subscripts is known as subscript overloading.

    While it is most common for a subscript to take a single parameter, you can also define a subscript with multiple parameters if it is appropriate for your type.
    
OK, that's a mouthful.  Notice that we can use subscripts with either structs or classes.  Here's a simple example of overloading with a struct.  The first subscript takes an Int and returns a String, the second returns an Int.

.. sourcecode:: bash

    struct S {
        var a: [String] = ["Tom", "Joan", "Sean"]
        var ia: [Int] = [72, 63, 69]  // height
        subscript(i: Int) -> String {
            // drop the "get" b/c no setter
            return a[i]
        }
        subscript(i: Int) -> Int {
            get {
                return ia[i]
            }
            set(newValue) {
                ia[i] = newValue
            }
        }
    }

    var s = S()
    var result: String = s[0]
    println(result)
    var i: Int = s[0]
    println(i)

    i = s[2]
    println(i)
    s[2] = 70
    i = s[2]
    println(i)


This is a little tricky because the two subscripts are overloaded on the return type.  We help the compiler by providing explicit type information for the variables ``result`` and ``i``.  We can call the setter and find it.

.. sourcecode:: bash

    > xcrun swift test.swift
    Tom
    72
    69
    70
    >

.. _operators:

*********
Operators
*********

I believe I put this in the section on random numbers, but it is pretty cool so I'll repeat it here:

.. sourcecode:: bash

    import Foundation

    infix operator **{}
    func ** (n: Double, p: Double) -> Double {
        return pow(n,p)
    }
    println("\(2**5)")

This prints what you'd expect (except that the type of the result is Double).

Another operator is ``??``, defined as

    A new ?? nil coalescing operator.. ?? is a short-circuiting operator, similar to && and ||, which takes an optional on the left and a lazily-evaluated non-optional expression on the right.
    
    The nil coalescing operator provides commonly useful behavior when working with optionals, and codifies this operation with a standardized name. If the optional has a value, its value is returned as a non-optional; otherwise, the expression on the right is evaluated and returned.

.. sourcecode:: bash

    let D = ["a":"apple"]
    var v = D["a"]
    var result = v ?? "no result"
    println(result)
    result = D["b"] ?? "no result"
    println(result)

.. sourcecode:: bash

    > xcrun swift test.swift
    apple
    no result
    >

I think the key here is that the rhs is "lazily-evaluated", but I don't have a good example at the moment.

The docs say this:

.. sourcecode:: bash

    public func ?? <T> (optional: T?, defaultValue: @autoclosure () -> T?) ->
       T? {
         switch optional {
         case .Some(let value): return value
         case .None: return defaultValue()
         }
    !}

    let a: Int? = nil
    let b: Int? = 5
    a ?? b // was nil; is now .Some(5)

To understand this we have to go back to enumerations.

..


What is even better is that we can define new operators, and those can be any symbol we want, here is an obvious one:

.. sourcecode:: bash

    import Foundation

    prefix operator √{}
    prefix func √(f: Double) -> Double {
        return sqrt(f)
    }

    println("\(√(2.0))")

.. sourcecode:: bash

    > xcrun swift test.swift 
    1.4142135623731
    >


This one's not working yet

.. sourcecode:: bash

    import Foundation

    unary operator  ☂ {}
    unary func ☂ (a: [String:Int], b: [String:Int]) -> [String:Int] {
        var D = a
        for k in b {
            let v = b[k]
            if let value = D[k] {
                D.updateValue(value + v, forKey:k)
            }
            else {
                D[k] = v
            }
        }
        return a
    }

**********
Generators
**********

The Sequence protocol uses a generator:

.. sourcecode:: bash

    var seq = Range(start:1,end:5)
    var g: RangeGenerator<Int> = seq.generate()
    while let i = g.next() {
      print("\(i) ")
    }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift
    1 2 3 4 
    >

We don't need the type for ``g`` but I put it there just to document what it actually is.

Let's try to make a generator of our own.
    http://www.scottlogic.com/blog/2014/06/26/swift-sequences.html
    
.. sourcecode:: bash

    class FibonacciGenerator: GeneratorType {
        var a = 0, b = 1
        //typealias Element = Int
        func next() -> Int? {
            let ret = a
            a = b
            b = ret + b
            return ret 
        }
    }

    let fib = FibonacciGenerator()
    for _ in 1..<10 {
        print("\(fib.next()!) ")
    }
    println()
    
.. sourcecode:: bash    
    
    > xcrun swift test.swift
    0 1 1 2 3 5 8 13 21 
    >
    
We can spiff this up a little bit by adding a class that provides the ``generate`` method:

.. sourcecode:: bash

    class Fibonacci {
        typealias GeneratorType = FibonacciGenerator
        func generate() -> FibonacciGenerator {
            return FibonacciGenerator()
        }
    }
    
I'm not quite certain why the ``typealias`` is needed, but it is.  To run this we just substitute:

.. sourcecode:: bash

    let fib = Fibonacci().generate()

which gives the same output.

I thought it might be nice to have a class that generates random numbers suitable for encryption (that is, ``UInt8``).  What follows is not quite it, and I'll explain why afterward.  The motivation for this is the encryption demo shown in :ref:`random`.

.. sourcecode:: bash

    import Darwin

    class RandomGenerator: GeneratorType {
        var a = [UInt8]()
        var s: UInt32
        init(seed: Int) {
            s = UInt32(seed)
            srand(s)
        }
        func next() -> UInt8? {
            if a.isEmpty { 
                a = filledArray()
            }
            return a.removeLast()
        }
        func filledArray() -> [UInt8] {
            var a = [UInt8]()
            let r: UInt32 = UInt32(UInt(rand()))
            let b1 = (r & 0xFF0000FF) >> 24
            a.append(UInt8(b1))
            let b2 = (r & 0x00FF0000) >> 16
            a.append(UInt8(b2))
            let b3 = (r & 0x0000FF00) >> 8
            a.append(UInt8(b3))
            let b4 = r & 0x000000FF
            a.append(UInt8(b4))
            return a
        }
    }

    func test() {
        let rg = RandomGenerator(seed: 137)
        for _ in 1..<10 {
            print("\(rg.next()!) ")
        }
        println()
    }

    test()


.. sourcecode:: bash

    > xcrun swift test1.swift
    95 34 35 0 11 139 165 2 136 
    > xcrun swift test1.swift
    95 34 35 0 11 139 165 2 136 
    >

Two reasons why it's not suitable:  according to StackOverflow, ``rand`` should not be used for encryption because the low value bytes show cycles (they're not random).  Second, ``rand`` gives us an ``Int`` (a signed integer), which means it's missing the top half of its range, so if you repeat the stream for long enough you should see that the 4th 8th 12th and so on numbers are never > 127.

And then of course, it needs to be hooked up to an encryption routine that takes a string and a key and returns the encrypted text.

*********
Protocols
*********

http://www.scottlogic.com/blog/2014/06/26/swift-sequences.html

Here is an example from the docs

.. sourcecode:: bash

    protocol FullyNamed {
        var fullName: String { get }
    }

    struct Person: FullyNamed {
        var fullName: String
    }

    let john = Person(fullName: "John Appleseed")
    println("\(john): \(john.fullName)")

What this means is that we are constructing a protocol named ``FullyNamed``, and to follow the protocol an instance must have a property ``fullName`` that is a String and is accessible by ``get`` (``obj.fullName`` returns a String).  The ``struct`` Person is declared as following the protocol, and the compiler can check that it does.

.. sourcecode:: bash

    > xcrun swift test.swift
    test.Person: John Appleseed
    >

Here is another one:

.. sourcecode:: bash

    protocol FullyNamed {
        var fullName: String { get }
    }

    class Starship: FullyNamed {
        var prefix: String?
        var name: String
        init(name: String, prefix: String? = nil) {
            self.name = name
            self.prefix = prefix
        }
        var fullName: String {
            return (prefix != nil ? prefix! + " " : "") + name
        }
    }
    var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
    println("\(ncc1701): \(ncc1701.fullName)")

.. sourcecode:: bash

    > xcrun swift test.swift
    test.Starship: USS Enterprise
    >

    The neat thing about this example is we see a good use of Optional.  ``prefix`` is declared as ``var prefix: String?``, and when we call

.. sourcecode:: bash

    return (prefix != nil ? prefix! + " " : "") + name
    
We first test whether ``prefix`` holds a value, and if so, we get rid of the Optional part with ``prefix!``.

Some other common protocols defined already are Equatable, Comparable, Hashable, and Printable.  

For more about all of these, see Generics.

Here is a bit more about Printable:  an implementation that is done as an extension on ``Object``

.. sourcecode:: bash

    protocol Printable {
        var description:  String { get }
    }

    class Object {
        var n: String
        init(name: String) {
            self.n = name
        }
    }

    extension Object: Printable {
        var description: String { return n }
    }

    var o = Object(name: "Tom")
    println("\(o.description)")
    println("\(o)")

.. sourcecode:: bash

    > xcrun swift test.swift 
    Tom
    test.Object
    >
    
I believe the second call should work (that's the point of this?), but it doesn't yet.

As before, the protocol definition gives the property that must be present, specifies the type of what we'll get back and that a "getter" will do it.  That is, we will say ``o``.

Sequence type is a protocol.  Here is a demo that I got off the web:

.. sourcecode:: bash

    struct MyList {
        var args: [String]
        init(sL: [String]) {
            self.args = sL
        }
    }

    struct CollectionGenerator <T>: GeneratorType {
        var items: Slice<T>
        mutating func next() -> T? {
            if items.isEmpty { return .None }
            // my modification:
            let item = items.removeAtIndex(0)
            return item
        }
    }

    extension MyList: SequenceType {
        func generate() -> CollectionGenerator<String> {
            let n = args.count - 1
            return CollectionGenerator(items: args[0...n])
        }
    }

    let args = MyList(sL: ["a","b","c"])
    for arg in args {
       print("\(arg) ")
    }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift
    a b c 
    >

Some things don't work correctly the way that I normally build and run Swift programs on the command line.  Here is one example:

.. sourcecode:: bash

    struct S: Printable {
        var name = ""
        var description: String {
            return "S: \(name)"
        }
    }

    let value = S(name: "Tom")
    println("Created a \(value)")
    
    .. sourcecode:: bash
    
    > xcrun -sdk macosx swiftc test.swift && ./test
    Created a S: Tom
    > xcrun swift test.swift
    Created a test.S
    >

The first method gives the expected output.

.. _extensions:

**********
Extensions
**********
    
In this section I want to develop some extensions on the String type.  Currently, the syntax 

.. sourcecode:: bash

    var s = "Hello, world"
    println(s[0...4])

doesn't work.  We can fix that with the following code:

.. sourcecode:: bash

    extension String {
        subscript(i: Int) -> Character {
            let index = advance(startIndex, i)
            return self[index]
        }
        subscript(r: Range<Int>) -> String {
            let start = advance(startIndex, r.startIndex)
            let end = advance(startIndex, r.endIndex)
            return self[start..<end]
        }
    }

.. sourcecode:: bash

    var s = "Hello, world"
    println(s[4])
    println(s[0...4])
    

What is going on here is that the language does not provide the facility to just index into a String.  Instead, being prepared to deal gracefully with all the complexity of Unicode means that we are supposed to let the compiler generate a valid range for us.

Since ``r`` is a ``Range<Int>``, ``r.startIndex`` is just the first Int in the range.  However, the string indices are not Int values.  Hence, we ask for the ``self.startIndex`` and then advance it to where we want to be.  And after that we advance it to where we want to stop.

Let's use the extension to develop a global function ``lstrip``

.. sourcecode:: bash

    extension String {
        subscript(i: Int) -> Character {
            let index = advance(startIndex, i)
            return self[index]
        }
        subscript(r: Range<Int>) -> String {
            let start = advance(startIndex, r.startIndex)
            let end = advance(startIndex, r.endIndex)
            return self[start..<end]
        }

    }

    func lstrip(str: String) -> String {
        let space: Character = " "
        var i = 0
        for c in str {
            if c == space { 
                i += 1
            }
            else { break }
        }
        var j = 0
        for c in str { j += 1 }
        return str[i..<j]
    }

    func reversed(str: String) -> String {
        var c: Character
        var s = ""
        for c in reverse(str) {
            s += c
        }
        return s
    }

    func rstrip(str: String) -> String {
        var s = reversed(str)
        s = lstrip(s)
        return reversed(s)
    }

    func strip(str: String) -> String {
        return rstrip(lstrip(str))
    }

    var s = "  abc   "
    println("*\(lstrip(s))*")
    println("*\(rstrip(s))*")
    println("*\(strip(s))*")

.. sourcecode:: bash

    > xcrun swift test.swift 
    *abc   *
    *  abc*
    *abc*
    >

