.. _strings:

#######
Strings
#######

I don't have much to put here at the moment. This is a good thing to remember:

    Swift’s String type is bridged seamlessly to Foundation’s NSString class. If you are working with the Foundation framework in Cocoa or Cocoa Touch, the entire NSString API is available to call on any String value you create, in addition to the String features described in this chapter. You can also use a String value with any API that requires an NSString instance.

Also, this helped me to finally figure out some things that confused me.  Without being explicit about the problems, the answer is that NSString methods are available to String variables, *but only if* we've done ``import Foundation``.

.. sourcecode:: bash

    import Foundation 

    let s = "Tom,Sean,Joan"
    let names = s.componentsSeparatedByString(",")
    println(names)

.. sourcecode:: bash

    > xcrun swift test.swift 
    [Tom, Sean, Joan]
    >

Not only is the ``NSString`` method called, but the type that is returned is a Swift [Int] rather than an Objective C NSArray.

Another useful thing is that one can go back and forth between String and NSString pretty easily:

.. sourcecode:: bash

    import Foundation 

    let s: NSString = "supercalifragilistic"
    let r = NSRange(location:0,length:5)
    println(s.substringWithRange(r))

.. sourcecode:: bash

    > xcrun swift test.swift 
    super
    >

.. sourcecode:: bash

    let s: NSString = "supercalifragilistic"
    println(s.rangeOfString("cali"))

.. sourcecode:: bash

    > xcrun swift test.swift 
    (5,4)
    >
    
The location is 5 and the length is 4.

Basic methods:

    - init(count sz: Int, repeatedValue c: Character)
    - isEmpty: Bool { get }
    - hasPrefix(s) -> Bool
    - hasSuffix(s) -> Bool
    - toInt -> Int?

Operators 
+
+= 
==
<