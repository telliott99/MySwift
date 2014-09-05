.. _closures2:

################
More on Closures
################

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