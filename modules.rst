.. _modules:

#######
Imports
#######

I got curious about importing modules in Swift.  

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

So the question becomes, how to do this for a swift module?
