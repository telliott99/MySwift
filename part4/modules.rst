.. _modules:

#######
Imports
#######

I got curious about importing modules in Swift.

I can do it easily in Xcode.  Make a new project for a command line tool (or whatever).  Do File > New > File and get a new Swift file in the project named whatever you like.  In that file put this code:

.. sourcecode:: bash

    class C { var x = 5 }

``main.swift`` has ``println("Hello, World!")``, now add this:

.. sourcecode:: bash

    let c = C()
    println("yes " + String(c.x))
    
Build and run, and the console shows:

.. sourcecode:: bash

    Hello, World!
    yes 5
    Program ended with exit code: 0

No import statement is needed!
 
Really, you're supposed to use Xcode, but from the command line it isn't hard to compile and then import an Objective C module.

http://stackoverflow.com/questions/24131476/compiling-and-linking-swift-plus-objective-c-code-from-the-os-x-command-line

``C.m``

.. sourcecode:: bash

    import "C.h"

    @implementation C

    - (id)init {
      self = [super init];
      self.c = @"Hello world!";
      return self;
    }

    @end

``C.h``

.. sourcecode:: bash

    #import <Cocoa/Cocoa.h>
    @interface C : NSObject
    @property (retain) NSString *c;
    @end

.. sourcecode:: bash

    > xcrun clang C.m -o C.o -c
    >

And we get ``C.o``.  Now we write our Swift code:

``S.swift``

.. sourcecode:: bash

    let c = C()
    println(c.c)

To compile, we need to do this:

.. sourcecode:: bash

    >xcrun swiftc -c S.swift -import-objc-header C.h\
     -F /System/Library/Frameworks -I/usr/include
 
The Framework is for ``Cocoa.h``.  I think the ``-I`` is for something that can generate the "bridging header" from ``C.h``.  What is emitted by the compiler is ``S.o``.  Now we just need to link and run:

.. sourcecode:: bash

    > xcrun swiftc -o app C.o S.o
    > ./app
    Hello world!
    >

So the question becomes, is it possible to do this for a swift module?

Starting from Xcode I made a Framework MyF and then copied MyF.h and File.swift to the Desktop and this:

xcrun swiftc -c File.swift -import-objc-header MyF.h -F /System/Library/Frameworks -I/usr/include

gave File.o

xcrun swiftc -c File.swift -import-objc-header MyF.h -F /System/Library/Frameworks -I/usr/include

xcrun swiftc -c test.swift -import-objc-header MyF.h -F /System/Library/Frameworks -I.



xcrun swiftc -o app File.o