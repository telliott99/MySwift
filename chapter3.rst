.. _chapter3:

##############
Advanced Swift
##############

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

.. _generics:

********
Generics
********

As we saw in :ref:`functions`, one can even write a function that deliberately modifies a parameter which is a primitive type.

We convert call-by-value into call-by-reference!  The parameters are marked with the label ``inout`` and there is no return value:

.. sourcecode:: bash

    func swapInts(inout a: Int, inout b: Int) {
        let tmp = a
        a = b
        b = tmp
    }
    var x: Int = 1
    var y: Int = -1
    println(String(x) + " " + String(y))
    swapInts(&x,&y)
    println(String(x) + " " + String(y))
    
.. sourcecode:: bash
    
    > xcrun swift test.swift 
    1 -1
    -1 1
    >

Notice the use of ``&x`` and ``&y``, with a meaning at least analogous to that in C and C++.

We can replace the above by a generic version

.. sourcecode:: bash

    func swapTwo <T> (inout a: T, inout b: T) {
        let tmp = a
        a = b
        b = tmp
    }

    var x = 1, y = 2
    println("x = \(x), y = \(y)")
    swapTwo(&x,&y)
    println("x = \(x), y = \(y)")

.. sourcecode:: bash

    > xcrun swift test.swift
    x = 1, y = 2
    x = 2, y = 1
    >

An alternative approach is to just use multiple return values in a tuple:

.. sourcecode:: bash

    func swapTwo <T> (a: T, b: T) -> (T,T) {
        return (b, a)
    }

    var x = 1, y = 2
    println("x = \(x), y = \(y)")

    (x,y) = swapTwo(x,y)
    println("x = \(x), y = \(y)")

We declare the return type as `(T,T)`.

.. sourcecode:: bash

    > xcrun swift test.swift
    x = 1, y = 2
    x = 2, y = 1
    >

You might have wondered about the function's name (swapTwo).  The reason for this is that ``swap`` actually exists in the standard library as a generic:

.. sourcecode:: bash

    var x = 1, y = 2
    println("x = \(x), y = \(y)")

    swap(&x,&y)
    println("x = \(x), y = \(y)")

.. sourcecode:: bash

    > xcrun swift test.swift
    x = 1, y = 2
    x = 2, y = 1
    > 

-----
Stack
-----

Here is an implementation (from the docs, mostly) of a stack:

.. sourcecode:: bash

    struct StringStack {
        var items = [String]()
        mutating func push(item: String) {
            items.append(item)
        }
        mutating func pop() -> String {
            return items.removeLast()
        } 
    }

    var StrSt = StringStack()
    StrSt.push("uno")
    StrSt.push("dos")
    StrSt.push("tres")
    StrSt.push("cuatro")
    println(StrSt.pop())

.. sourcecode:: bash

    > xcrun swift test.swift
    cuatro
    >

And now, let's rewrite it to use generics

.. sourcecode:: bash

    struct Stack <T> {
        var items = [T]()
        mutating func push(item:T) {
            items.append(item)
        }
        mutating func pop() -> T {
            return items.removeLast()
        } 
    }

    var StrSt = Stack<String>()
    StrSt.push("uno")
    StrSt.push("dos")
    StrSt.push("tres")
    StrSt.push("cuatro")
    println(StrSt.pop())

Prints the same as before.

Use the same struct but with Ints:

.. sourcecode:: bash

    var IntSt = Stack<Int>()
    for i in 1...3 { IntSt.push(i) }
    println(IntSt.pop())

.. sourcecode:: bash

    > xcrun swift test.swift
    3
    >

I don't have a good use case yet, but you can have more than one generic type:

.. sourcecode:: bash

    func pp <S,T> (s: S, t: T) {
        println("The value of s is \(s) and t is \(t)")
    }
    pp(1.33, 17)

.. sourcecode:: bash

    > xcrun swift test.swift
    The value of s is 1.33 and t is 17
    >

And you can name them anything you like (although caps are standard)

.. sourcecode:: bash

    func pp <SillyType1,SillyType2> 
        (s: SillyType1, t: SillyType2) {
        println("The value of s is \(s) and t is \(t)")
    }
    pp(1.33, 17)

This next example deals with both generics and protocols.  The efficient collection to use when you want to check whether a value is present is a dictionary.  Since String and Int types can be KeyValue types for a dictionary, this works great:

.. sourcecode:: bash

    func singles <T: Hashable> (input: [T]) -> [T] {
        var D = [T: Bool]()
        var a = [T]()
        for k in input {
            if let v = D[k] {
                // pass
            }
            else {
                D[k] = true
                a.append(k)
            }
        }
        return a
    }

    println(singles(["a","b","a"]))
    println(singles([0,0,0,0,0]))

What this says is that we'll take an array of type T and then return an array of type T.  For each value in the input, we check if we've seen it (by checking if it's in the dictionary).  The subscript operator is defined, and it returns an optional.  So we use the ``if let value = D[key]`` construct, which returns ``nil`` if the key is not in the dictionary.

The ``Hashable`` protocol requires that the array contain objects that are "hashable", i.e. either the compiler (or we) have to be able to compute from it an integer value that is (almost always) unique.  The compiler does this for primitive types on its own.

Looks like it works:

.. sourcecode:: bash

    > xcrun swift test.swift 
    [a, b]
    [0]
    > 

In order to use this for a user-defined object, that object must follow the Hashable protocol.  

However before dealing with Hashable, let's start by looking at Comparable and Equatable.  For Comparable, an object must respond to the operators ``==`` and ``<``.  These functions must be defined *at global scope*.

We obtain a unique id for each object from the current time (slightly different since they are initialized sequentially):

.. sourcecode:: bash

    import Cocoa

    class Obj: Comparable, Equatable {
        var n: Int
        init() {
            var d = NSDate().timeIntervalSince1970
            let i = Int(1000000*d)
            self.n = i
        }    
    }

    // must be at global scope
    func < (a: Obj, b: Obj) -> Bool {
        return a.n < b.n
    }

    func == (a: Obj, b: Obj) -> Bool {
        return a.n == b.n
    }

    var o1 = Obj()
    var o2 = Obj()
    println("\(o1.n) \(o2.n)")
    println(o1 == o2)
    println(o1 < o2)

.. sourcecode:: bash

    > xcrun swift test.swift 
    1409051635.29793
    1409051635.29838
    1409051635297932 1409051635298383
    false
    true
    >

As you can see, the second object was initialized approximately 0.45 milliseconds after the first one, so it compares as not equal, and less than the second.

For the Hashable protocol, an object is required to have a property ``hashValue``, but is also required to respond to ``==`` (it's undoubtedly faster to check that first).

.. sourcecode:: bash

    import Cocoa

    class Obj: Hashable, Printable {
        var n: Int
        var name: String
        init(name: String) {
            var d = NSDate().timeIntervalSince1970
            self.n = Int(1000000*d)
            self.name = name
        }
        var hashValue: Int {
            get { return self.n }
        }
        var description: String {
            get { return "\(self.name):\(self.n)" }
        }
    }

    func == (a: Obj, b: Obj) -> Bool {
        return a.n == b.n
    }

    func singles <T: Hashable> (input: [T]) -> [T] {
        var D = [T: Bool]()
        var a = [T]()
        for v in input {
            if let f = D[v] {
                // pass
            }
            else {
                D[v] = true
                a.append(v)
            }
        }
        return a
    }

    var o1 = Obj(name:"o1")
    var o2 = Obj(name:"o2")
    let result = singles([o1,o2,o1])
    for o in result {
        print("\(o) ")
    }
    println()
    println(singles([o1,o1,o1,o1,o1,o1]))


This *almost* works.  For some reason, it isn't printing the representation correctly.

.. sourcecode:: bash

    > xcrun swift test.swift
    test.Obj test.Obj 
    [test.Obj]
    >

Here is another simple example that follows the instructions but fails currently.  Of course, Xcode is beta at the moment I write this, so it might not be me  :)

.. sourcecode:: bash

    import Foundation
    class Obj: Printable {
        var n: Int
        init() {
            var d = NSDate().timeIntervalSince1970
            self.n = Int(1000000*d)
        }
        var description: String {
            get { return "Obj: \(n)" }
        }
    }

    var o = Obj()
    println("\(o)")
    // test.Obj

***************
Sort Algorithms
***************

.. sourcecode:: bash

    func pp (s: String, a: [Int]) {
        print (s + " ")
        for n in a { print("\(n) ") }
        println()
    }

    func swap(inout a: [Int], i: Int, j: Int) {
        let tmp = a[i]
        a[i] = a[j]
        a[j] = tmp
    }

    func bubble_sort(inout a: [Int]){
        for _ in 0...a.count - 1 {
            for i in 0...a.count - 2 {
                if a[i] > a[i+1] {
                    swap(&a,i,i+1)
                }
            }
        }
    }

    func selection_sort(inout a: [Int]) {
        for i in 0...a.count - 2 {
            for j in i...a.count - 1 {
                if a[j] < a[i] {
                    swap(&a,i,j)
                }
            }
        }
    }

    func insertion_sort(inout a: [Int]) {
        for i in 1...a.count-1 {
            // a[0...i] are guaranteed to be sorted
            var tmp = Array(a[0...i])

            // go up to penultimate value
            let v = tmp.last!
            for j in 0...tmp.count - 2 {
                if tmp[j] > v {
                    tmp.insert(v, atIndex:j)
                    tmp.removeLast()
                    break
                }
            }
            a[0...i] = tmp[0...tmp.count-1]
        }
    }

    func merge(a1: [Int], a2: [Int]) -> [Int] {
        // a1 and a2 are sorted already
        var ret: [Int] = Array<Int>()
        var i: Int = 0
        var j: Int = 0
        while i < a1.count || j < a2.count {
            if j == a2.count {
                if i == a1.count - 1 { ret.append(a1[i]) }
                else { ret += a1[i...a1.count-1] }
                break
            }
            if i == a1.count {
                if j == a2.count - 1 { ret.append(a2[j]) }
                else { ret += a2[j...a2.count-1] }
                break
            }
            if a1[i] < a2[j] { ret.append(a1[i]); i += 1 }
            else { ret.append(a2[j]); j += 1 }
        }
        return ret
    }

    func merge_sort(a: [Int]) -> [Int] {
        if a.count == 1 { return a }
        if a.count == 2 { return merge([a[0]],[a[1]]) }
        let i = a.count/2
        var a1 = merge_sort(Array(a[0...i]))
        var a2 = merge_sort(Array(a[i+1...a.count-1]))
        return merge(a1, a2)
    }

    var a = [32,7,100,29,55,3,19,82,23]
    pp("before: ", a)
    println()

    let b = sorted(a, { $0 < $1 })
    pp("sorted: ", b)
    println()

    // make sure we bubble enough times
    var c = [32,7,100,29,55,19,82,23,3]
    pp("before: ", c)
    bubble_sort(&c)
    pp("bubble: ", c)
    println()

    c = a
    pp("before: ", c)
    selection_sort(&c)
    pp("select: ", c)
    println()

    c = a
    pp("before: ", c)
    insertion_sort(&c)
    pp("insert: ", c)
    println()

    c = a
    pp("before: ", c)
    c = merge_sort(c)
    pp("merge : ", c)
    
.. sourcecode:: bash

    > xcrun swift sort_algorithms.swift 
    before:  32 7 100 29 55 3 19 82 23 

    sorted:  3 7 19 23 29 32 55 82 100 

    before:  32 7 100 29 55 19 82 23 3 
    bubble:  3 7 19 23 29 32 55 82 100 

    before:  32 7 100 29 55 3 19 82 23 
    select:  3 7 19 23 29 32 55 82 100 

    before:  32 7 100 29 55 3 19 82 23 
    insert:  3 7 19 23 29 32 55 82 100 

    before:  32 7 100 29 55 3 19 82 23 
    merge :  3 7 19 23 29 32 55 82 100 
    >

*******
Drawing
*******

This is just for fun.  I wrote a ``Sorter`` class that generates an array of random values (either seeded or not), which I thought I might extend later to try out various sorting algorithms.

Then, I remembered a post (stimulated by a great site I found on the web)

http://telliott99.blogspot.com/2012/05/view-with-no-window.html

that implements drawing to a pdf without actually having a window on-screen.  So that's where the second class (``MyView``) comes from.  

As it grew, it got a bit complicated.  To just have a view and write to the file, you don't need to ``override init``.  But I wanted to pass in the data upon initialization, so there is a convenience initializer.  And having done that, the compiler required the ``init(coder: NSCoder)``, even though we don't really implement it correctly.  Also, I'm having trouble initializing the instance variables properly when ``init`` is there, so I just zero them all out at first, and then set the correct values later.

It's not really the best code, but it generates an image.

Here is the resulting figure:

.. image:: /figures/x.png
   :scale: 75 %

.. sourcecode:: bash

    import Cocoa

    class MyView : NSView {
        var data: [Int] = [Int]()
        var maxValue: Int = 0
        var width: Int = 0
        var height: Int = 0
        override init(frame: NSRect) {
            super.init(frame: frame)
        }
        required init(coder: NSCoder) {
            super.init(coder: coder)
        }
        convenience init(data: [Int], maxValue: Int) {
            let frame = NSRect(x:0, y:0, 
                        width:400, height:300)
            self.init(frame: frame)
            self.data = data
            self.maxValue = maxValue
            width = 400
            height = 300
        }
        override func drawRect(dirtyRect: NSRect) {
            NSColor.whiteColor().set()
            NSRectFill(self.bounds)
            //let maxValue = data.reduce(Int.min, { max($0,$1) })

            var num = Double(maxValue)
            var den = Double(height-20)
            let f = num/den * 1.8

            var x: Int = 20
            let y: Int = 20

            let maxw = Int(Double(width - 100)/Double(data.count))
            let w = min(10, maxw)

            let pad = 5 // padding between rects
            for v in data {
                let h = Int(Double(v)*f)
                let r = NSRect(x:x, y:y, width:w, height:h)
                var col: NSColor
                let c = 1.0 - CGFloat(v)/CGFloat(maxValue)
                col = NSColor(calibratedWhite:c, alpha:1.0)
                col.set()
                NSRectFill(r)
                let p = NSBezierPath(rect:r)
                NSColor.blackColor().set()
                p.stroke()
                x += w + pad
            }
        }
        func plotData(fn: String) {
            self.display()
            let data = self.dataWithPDFInsideRect(frame)
            data.writeToFile(fn, atomically: true)
        }
    }

    class Sorter: Printable {
        var data: [Int] = [Int]()
        var N: Int
        var n: Int
        //let seed = 1337
        init(_ maxValue: Int, _ numValues: Int) {
            N = maxValue
            n = numValues
            resetNonRandom()
        }
        func resetNonRandom(seed: Int = 137){
            srand(UInt32(seed))
            var b: [Int] = [Int]()
            var r: Int
            for i in 0...n-1 {
                r = Int(rand())
                let f = Double(r) / Double(Int32.max)
                r = Int(f*Double(N)) + 1
                b.append(r)
            }
            data = b
        } 
        func resetRandom() {
            var b: [Int] = [Int]()
            var r: Int
            for i in 0...n-1 {
                let t = UInt32(N)
                r = Int(arc4random_uniform(t))
                // no duplicates
                while contains(data, r) {
                    r = Int(arc4random_uniform(t))
                }
                b.append(r+1)
            }
            data = b
        }
        var description: String {
            var s = ""
            for (i,r) in enumerate(data) {
                s += String(r)
                if !(i == countElements(data) - 1) {
                    s += " "
                }
            }
            return s
        }
        func test() {
            println("\(sb)")
            sb.resetRandom()
            println("\(sb)")
            sb.resetRandom()
            println("\(sb)")
            sb.resetNonRandom()
            println("\(sb)")
            // let t = UnsafeMutablePointer(null())
            // sb.resetNonRandom(seed: time(t))
            // println("\(sb)")
        }
        func plotData(fn: String) {
            let view = MyView(data: data, maxValue: N)
            view.plotData(fn)
        }
        func sort() {
            data.sort(<)
        }
    }

    var sb = Sorter(200, 20)
    sb.resetRandom()
    // sb.sort()
    sb.plotData("x.pdf")
    
