.. _compiling_swift:

###############
Compiling Swift
###############

In order to compile Swift programs, you need Xcode.  I got Xcode6-Beta5.app (and now -Beta6).  I set it as the default (since I also have Xcode5):

.. sourcecode:: bash

    sudo xcode-select -s /Applications/Xcode6-Beta5.app/Contents/Developer
    
Then, the following method will work.  

With this file on the Desktop

``Hello.swift``:

.. sourcecode:: bash

    print("Hello Swift world")

.. sourcecode:: bash

    > xcrun swift Hello.swift
    Hello Swift world
    >

Some other options are to run swift as an "interpreter" by just doing ``xcrun swift`` and then try out some code, or to place this as the first line in your code ``#! /usr/bin/xcrun swift``.  Make the file executable before running it:

.. sourcecode:: bash

    > chmod u+x Hello.swift
    > ./Hello.swift 
    Hello Swift world
    >

Another possibility is to use a "playground" in Xcode.  And finally, one can compile and then run a file of swift code:

.. sourcecode:: bash

    > xcrun -sdk macosx swiftc test.swift
    > ./test

or both steps at once

.. sourcecode:: bash

    > xcrun -sdk macosx swiftc test.swift && ./test
    
I have observed a few constructs that work correctly by this last method and not by my standard one.

As shown above, a basic print statement is ``print("a string")`` or ``print("a string")``.  Notice the absence of semicolons.

One can also do variable substitution, like this

``Hello.swift``:

.. sourcecode:: bash

    var n = "Tom"
    print("Hello \(n)")

.. sourcecode:: bash

    > xcrun swift Hello.swift 
    Hello Tom
    >

Variables are *typed* (with the type coming after the variable name) and there is no implicit conversion between types (except when doing ``print(anInt)`` or ``print(anArray)``).  

We're going to switch filenames now to

``test.swift``:

.. sourcecode:: bash

    var x: Int = 2
    print(x)
    var s: String = String(x)
    print(s)
    
This works, and prints what you'd expect.  If a value is not going to change (a constant), use ``let``:

.. sourcecode:: bash

    let s = "Hello"
    print("\(s)")

which also works, and prints what you'd expect.  

The reason it works (without the ``:String`` type declaration is that the compiler can almost always infer type information from the context.

The usual Swift style would be:

.. sourcecode:: bash

    var x = 2
    var f = 1.23e4
    print(f)
    // prints:  12300
