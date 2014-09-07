.. _chapter1:

############
Basic syntax
############

***************
Compiling Swift
***************

In order to compile Swift programs, you need Xcode.  I got Xcode6-Beta5.app.  I set it as the default (since I also have Xcode5):

.. sourcecode:: bash

    sudo xcode-select -s /Applications/Xcode6-Beta5.app/Contents/Developer
    
Then, the following method will work.  

With this file on the Desktop

``Hello.swift``

.. sourcecode:: bash

    println("Hello Swift world")

.. sourcecode:: bash

    > xcrun swift Hello.swift
    Hello Swift world
    >

Some other options are to run swift as an "interpreter" by just doing ``xcrun swift`` and then try out some code, or place this as the first line in your code ``#! /usr/bin/xcrun swift``, and then make the file executable before running it:

.. sourcecode:: bash

    > chmod u+x Hello.swift
    > ./Hello.swift 
    Hello Swift world
    >

And yet another possibility is to use a "playground" in Xcode.

As shown above, a basic print statement is ``println("a string")`` or ``print("a string")``.  Notice the absence of semicolons.

One can also do variable substitution, like this

``Hello.swift``:

.. sourcecode:: bash

    var s = "Hello"
    println("\(s)")

.. sourcecode:: bash

    > xcrun swift Hello.swift 
    Hello
    >

Variables are typed (with the type coming after the variable name) and there is no implicit conversion between types (except when doing ``print(anInt)`` or ``print(anArray)``).  

We're going to switch filenames now to

``test.swift``:

.. sourcecode:: bash

    var x: Int = 2
    println(x)
    var s: String = String(x)
    println(s)
    
This works, and prints what you'd expect.  If a value is not going to change (a constant), use ``let``:

.. sourcecode:: bash

    let s = "Hello"
    println("\(s)")

which also works, and prints what you'd expect.  

The reason it works (without the ``:String`` type declaration is that the compiler can almost always infer type information from the context.

The usual Swift style would be:

.. sourcecode:: bash

    var x = 2
    var f = 1.23e4
    println(f)
    // prints:  12300

*******
Strings
*******

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

Not only is the ``NSString`` method called, but the type that is returned is a Swift [String] rather than an Objective C NSArray of NSString objects.

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
    - ``isEmpty: Bool { get }``
    - ``hasPrefix(s) -> Bool``
    - ``hasSuffix(s) -> Bool``
    - ``toInt -> Int?``
    - ``isEqual(s) -> Bool``
    
To check identity, use the operator ``===``.  (And we'll have more to say about the ``Int?`` type, see :ref:`optionals`)

Operators 
    - ``+``
    - ``+=``
    - ``==``
    - ``<``

**********
Characters
**********

A character is a type in Swift and may be represented as ``'a'`` for example, with single quotes, representing the single character a.  But you don't initialize a character with a literal character.  Instead do this:

.. sourcecode:: bash

    let c: Character = "a"
    
which converts the string ``"a"`` to the corresponding character.  Or, when iterating through a string, we get characters:

.. sourcecode:: bash

    for c in "abc":  println(c)
    
To put a character back into a String, you can do this:

.. sourcecode:: bash

    var s = ""
    let c: Character = "a"
    s.append(c)
    println(s)  // a
    
As of recently, the ``+=`` operator is only for "concatenate", so this doesn't work any more:

.. sourcecode:: bash

    let c: Character = "a"
    s += c
    
     String and Character have been revised to follow the changes to Array, which clarifies that the + operator is only for "concatenation", not "append”. Therefore String + Character, Character + String, and String += Character, as well as the analogous Array + Element combinations, have been removed.
     
A concatenation example:

.. sourcecode:: bash

    let c1: Character = "a"
    let c2: Character = "b"
    let a = [c1,c2]
    let s = "" + a
    println(a)
    println(s)
    
.. sourcecode:: bash

    > xcrun swift test.swift
    [a, b]
    ab
    >
    
Again, the type of ``c`` is Character.


Unicode
-------

Swift is very modern when it comes to Unicode, even more so than NSString.

In Unicode every character that can be written is represented as a "code point", a number.  Originally it was thought that 2e16, or two bytes (more than one million), was enough to represent them all.  

Now some are three bytes.  A unicode code point comes in both decimal and binary equivalents, though binary is probably more usual.  From the docs:

    A Unicode scalar is any Unicode code point in the range U+0000 to U+D7FF inclusive or U+E000 to U+10FFFF inclusive. Unicode scalars do not include the Unicode surrogate pair code points in the range U+D800 to U+DFFF inclusive.

The question then becomes, how to represent Unicode characters in memory and on in disk.  The apparent two byte limit argued for a two byte representation, but there are two different orders for the single bytes, leading to big- and little-endian UTF-16 encoding.

It may be because we managed pretty well with characters represented in a single byte (or even just 7 bits with ASCII), that the UTF-8 encoding was developed.  UTF-8 is a variable length encoding, usually taking only a single byte, but extending to two or three (or four) bytes when necessary.  It is much more compact, yet flexible.

So really the first issue that comes up with Unicode, after realizing that the representation is critical, is how to count length correctly as characters rather than as bytes when we have variable length, multibyte characters.

The second issue is that the same character may be formed in different ways (admittedly, this is fairly rare), and we would like those two representations to compare as equal.

Let's look at length first.  

Here is an example of a String literal formed from a Unicode scalar

.. sourcecode:: bash

    let blackHeart = "\u{2665}"
    println(blackHeart)
    
.. sourcecode:: bash

    > xcrun swift test.swift 
    ♥
    >

To keep things simple, I will copy this character and paste it into the Python interpreter:

.. sourcecode:: bash

    >>> s = "♥"
    >>> s
    '\xe2\x99\xa5'

The default encoding here when we do the paste is UTF-8.  The hex value ``e2 99 a5`` is the UTF-8 encoded value of the code point known as "BLACK HEART SUIT".  To specify it in a Swift String, one way is to recall (or look up) its Unicode scalar value, which is typically written ``U+2665``.  Python again:

    >>> s = "♥"
    >>> s
    '\xe2\x99\xa5'
    >>> unicode(s,'utf-8')
    u'\u2665'
    >>> s.decode('utf-8')
    u'\u2665'
    >>>

In order to interpret these three bytes, one must know the encoding.

One could also write the data to disk and use ``hexdump``

.. sourcecode:: bash

    >>> s = "♥"
    >>> FH = open('x.txt','w')
    >>> FH.write(s)
    >>> FH.close()
    >>> 
    [2]+  Stopped                 python
    > hexdump -C x.txt
    00000000  e2 99 a5                                              
    |...|
    00000003
    >

The decimal equivalent is 9829.

.. sourcecode:: bash

    >>> h = '0x2665'
    >>> int(h,16)
    9829
    >>>

The official name for this character is:  "Unicode Character 'BLACK HEART SUIT' (U+2665)".  In html you can write it either as ``&#9829`` or ``&#x2665``.

Similarly, the "White smiling face"  ☺ is ``9786`` in Unicode, which in hexadecimal is ``U+263A``.

In Python, if I have the character as Unicode I convert it to UTF-8 before writing to disk:

.. sourcecode:: bash

    >>> u = unichr(9786)
    >>> u
    u'\u263a'
    >>> ord(u)
    9786
    >>> print u
    ☺
    >>> s = u.encode('utf-8')
    >>> s
    '\xe2\x98\xba'
    >>> FH = open('x.txt','w')
    >>> FH.write(s + "\n")
    >>> FH.close()
    >>> 
    [1]+  Stopped                 python
    > cat x.txt
    ☺
    >

In Swift, this is done as follows with ``.utf8``:

.. sourcecode:: bash

    let smiley = "\u{263a}"
    for codeUnit in smiley.utf8 {
        print("\(codeUnit) ")
    }
    print("\n")

.. sourcecode:: bash

    > xcrun swift test.swift 
    226 152 186 
    >
    
``226`` is the decimal value equal to ``e2``, and so on.  Python again:

.. sourcecode:: bash

    >>> hex(226)
    '0xe2'
    >>> hex(152)
    '0x98'
    >>> hex(186)
    '0xba'
    >>>
    

Counting characters
-------------------

And now, the big question is, how many characters are there in ``blackHeart``?  

.. sourcecode:: bash

    let blackHeart = "\u{2665}"
    print(blackHeart + " ")
    println(countElements(blackHeart))
    
.. sourcecode:: bash

    > xcrun swift test.swift 
    ♥ 1
    >

Three bytes in memory and on disk, but one character according to ``countElements``.

Expand the example:

.. sourcecode:: bash

    import Foundation

    let blackHeart = "\u{2665}"
    print(blackHeart + " ")
    println(countElements(blackHeart))

    var str = NSString.stringWithString(blackHeart)
    println(str.length)
    println(str.characterAtIndex(0))
    
NSString says:

.. sourcecode:: bash

    > xcrun swift test.swift 
    ♥ 1
    1
    9829
    >

Seems like NSString counts correctly too, in this case, though when it yields the character it gives us back the decimal value of the Unicode code point.

Here is another example, from the docs, where the same character can be formed in two different ways:

.. sourcecode:: bash

    // é
    let eAcute: Character = "\u{E9}"
    // e followed by ́
    let combinedEAcute: Character = "\u{65}\u{301}"

    let s1 = "" + eAcute
    let s2 = "" + combinedEAcute
    println(countElements(s1))
    println(countElements(s2))
    println(eAcute == combinedEAcute)

.. sourcecode:: bash

    > xcrun swift test.swift 
    1
    1
    true
    >

Now try the same thing with NSString:

.. sourcecode:: bash

    let s3 = NSString.stringWithString(s1)
    let s4 = NSString.stringWithString(s2)
    println("\(s3.length)")
    println("\(s4.length)")
    println(s3.isEqualTo(s4))

.. sourcecode:: bash

    > xcrun swift test.swift 
    1
    1
    true
    1
    2
    false
    >

So, the problem (solved by Swift and not by NSString) is how to deal with "extended grapheme clusters".  Such a cluster is a single character composed of multiple graphemes, such as ``"\u{65}\u{301}"``.

******************
Range and Interval
******************

Swift has the notions of intervals, ranges, and strides.

It also has both a closed interval or range (that includes both endpoints), and a half-open one, which extends up to but does not include the top value.

An interval contains the values between two endpoints, but it does not know anything about iterating through the values or incrementing them.  An interval can extend between one (or two) non-integer values, and another value can be tested for inclusion in the interval.

From StackOverflow

http://stackoverflow.com/questions/25308978/what-are-intervals-in-swift-ranges

    A Range type is optimized for generating values that increment through the range, and works with types that can be counted and incremented.

    An Interval type is optimized for testing whether a given value lies within the interval. It works with types that don't necessarily need a notion of incrementing, and provides [other] operations

    Because the ``..<`` and ``...`` operators have two forms each--one that returns a Range and one that returns an Interval--type inference automatically uses the right one based on context.

Here the type information isn't required, but I wanted to tell the compiler what we want:

.. sourcecode:: bash

    let i1: ClosedInterval = 1...5
    i1.contains(3)
    i1.contains(3.14159265)
    // both are true

A new operator tests for this:

.. sourcecode:: bash

    i1 ~= 6
    // false

The operators for ranges and intervals are the same.

.. sourcecode:: bash

    let r1: Range = 1...5
    let r2: Range = 1..<6
    if r1 == r2 { }
    // true

(The previously used ``..`` has been replaced by ``..<``).

To reverse a range, use ``reverse``

.. sourcecode:: bash

    for i in reverse(1...3) { print(String(i) + " ") }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift
    3 2 1
    >

There is also ``stride``

.. sourcecode:: bash

    for i in stride(from: 0, through: -4, by: -2) {
      print(i)
    }
    println

.. sourcecode:: bash

     > xcrun swift test.swift
    0 -2 -4
    >

.. sourcecode:: bash

    for i in lazy(0...5).reverse() {
        print(String(i) + " ")
    }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift
    5 4 3 2 1 0 
    >

And finally:

.. sourcecode:: bash

    let x = 6
    switch (x) {
        case (5...10):
            println("OK")
        default:
            println("not in interval")
    }
    // OK

.. sourcecode:: bash

    let x = 6
    let y = 5

    switch (x,y) {
        case (5...10, 3...6):
            println("OK")
        default:
            println("not in interval")
    }
    // also OK

************
Command line
************

As we said at the beginning, from the command line we can compile and run a swift program with

.. sourcecode:: bash

    xcrun swift test.swift

To obtain arguments passed in on the command line, just do this:

``test.swift``:

.. sourcecode:: bash

    println(Process.arguments)

.. sourcecode:: bash

    > xcrun swift test.swift a b c 1
    [test.swift, a, b, c, 1]
    >

***************
Read from StdIn
***************

Here is an example of reading data from a file input on the command line in swift.  We first compile the swift code, and then execute it.  The listing for 

``test.swift``

.. sourcecode:: bash

    import Foundation

    func readIntsFromStdIn() -> [Int]? {
        let stdin = NSFileHandle.fileHandleWithStandardInput()
        let data: NSData = stdin.availableData
        let s: String = NSString.init(data: data, 
            encoding:NSUTF8StringEncoding)
        let cs = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let sa: [String] = s.componentsSeparatedByCharactersInSet(cs)
        var a: [Int] = Array<Int>()
        for c in sa {
            if let n = c.toInt() {
                a.append(n)
            }
        }
        if a.count == 0 { return nil }
        return a
    }

    let arr = readIntsFromStdIn()
    if arr != nil {
        println("\(arr!)")
    }
    
Since we might not read any ``Int`` data, I made the return type an Optional.

The data we will read looks like this:

``x.txt``

.. sourcecode:: bash

    43 39 65
    22	102

When examined with ``hexdump`` we see that in addition to the newline (``\x0a``) and spaces (``\x20``), the data also has one tab (``\x09``):

.. sourcecode:: bash

    > hexdump -C x.txt
    00000000  34 33 20 33 39 20 36 35  0a 32 32 09 31 30 32     |43 39 65.22.102|
    0000000f
    >

.. sourcecode:: bash

    > xcrun -sdk macosx swiftc test.swift
    > ./test < x.txt
    [43, 39, 65, 22, 102]
    >

Looks like it's working fine.

*****
Loops
*****

We are going to use some arrays below, even though they haven't been introduced yet.  I hope what we're doing is fairly obvious, if not, see the next section.

.. sourcecode:: bash

    var intList = [2,4,6]
    for x in intList { print(String(x) + " ")}
    println()

.. sourcecode:: bash

    > xcrun swift test.swift 
    2 4 6 
    >

Here we need the explicit conversion to String, because the first thing that is evaluated inside ``print()`` is the addition of ``x`` to a String.

We can get a range of values (closed at the high end)

.. sourcecode:: bash

    var i:Int
    for i in 1...3 { print(String(i) + " ") }
    println()

.. sourcecode:: bash

    > xcrun swift test.swift 
    1 2 3 
    >

The docs talk about a ``1..3`` construct with only two dots, which is a half-open range, but it doesn't work for me.  What I did find later on is ``1..<3`` which is probably a replacement that is more explicit and less likely to be confused with ``1...3`` triple dot syntax.

.. sourcecode:: bash

    import Foundation

    let s = "Tom,Sean,Joan"
    let names = s.componentsSeparatedByString(",")
    println(names[0..<2])

.. sourcecode:: bash

    > xcrun swift x.swift
    [Tom, Sean]
    >

A while loop:

.. sourcecode:: bash

    while true {
        println("Yes")
        break
    }

.. sourcecode:: bash

    > xcrun swift test.swift 
    Yes
    >

And a traditional loop

.. sourcecode:: bash

    var count = 0
    for i = 0; i < 3; ++i {
        count += 1
    }
    println(count)

.. sourcecode:: bash

    > xcrun swift test.swift
    3
    >

If you want to access the value of ``i`` after the loop terminates, declare it outside the loop as ``var i: Int``.

.. sourcecode:: bash

    var i: Int
    for i = 0; i < 3; ++i {
        ..
    }
    println(i)
    // i == 3  !!!

An odd way to do something ``n`` times.  Notice the``_`` variable (a way of saying we will ignore this value, and it's not available inside the loop)

.. sourcecode:: bash

    let base = 2
    let power = 10
    var result = 1
    for _ in 1...power {
        result *= base
    }
    // result == 1024
    
This is legal!

.. sourcecode:: bash

    var i: Int
    ifeellikeit = true
    for i = 0; i < 10; i++ {
        print("\(i)) "
        if ifeellikeit {
            i += 7
        }
        println
    }
    \\ prints 0 9 10

.. _optionals:

*********
Optionals
*********

It's useful to have operations that may or may not succeed, and if it doesn't work, we just deal with it.  Swift has values called "Optionals" that may be ``nil``, or they may have a value including a basic type like Int or String.  Consider the following:

.. sourcecode:: bash

    var s: String = "123"
    let m: Int? = s.toInt()
    s += "x"
    let n: Int? = s.toInt()
    println(m)
    println(n)

The second conversion ``s.toInt()`` will fail because the value ``"123x"`` can't be converted to an integer.  Nevertheless, the code compiles and when run it prints

.. sourcecode:: bash

    > xcrun swift test.swift 
    Optional(123)
    nil
    >

The values ``m`` and ``n`` are "Optionals".  Test for ``nil`` by doing either of the following:

.. sourcecode:: bash

    let m: Int? = "123x".toInt()
    let n = "123".toInt()
    // "forced unwrapping"
    if m != nil { println("m = toInt() worked: \(m!)") }
    if n != nil { println("n = toInt() worked: \(n!)") }
    if let o = "123".toInt() {  println("really") }
    
.. sourcecode:: bash

    > xcrun swift test.swift
    n = toInt() worked: 123
    really
    >
    
Use of the ! symbol in ``n!`` forces the value of ``n`` as an Int to be used, which is fine, once we know for sure that it is not ``nil``.

.. sourcecode:: bash
    
    import Foundation
    func getOptional() -> Int? {
        let r = Int(arc4random_uniform(10))
        if r < 5 {
            return nil
        }
        return r*10
    }

    var n: Int?
    for i in 1...10 {
        n = getOptional()
        if (n != nil) { 
            println("\(i): \(n!)")
        }
    }

.. sourcecode:: bash

    > xcrun swift test.swift
    1: 80
    2: 60
    7: 50
    8: 70
    10: 70
    >

Another idiom in Swift is "optional binding"

.. sourcecode:: bash

    if let n = dodgyNumber.toInt() {
        println("\(dodgyNumber) has an integer value of \(n)")
           } 
    else {
        println("\(dodgyNumber) could not be converted to an integer")
    }

Normally one has to use a Boolean for an if construct, but here we're allowed to use an optional, if it evaluates to ``nil`` we do the ``else``, otherwise ``n`` has an Int value and we can use it.

**************
Random numbers
**************

Swift doesn't seem to have a built-in facility for getting random numbers.  However, there are some Unix functions available, after an ``import Foundation``.  These are ``arc4random``, ``arc4random_uniform``, ``rand``, and ``random``.  

Only ``rand`` and ``random`` allow you to set the seed (with ``srand`` or ``srandom`` respectively).  These are usually called with the time, as in ``srand(time(NULL))``.

http://iphonedevelopment.blogspot.com/2008/10/random-thoughts-rand-vs-arc4random.html

For *really* random numbers, it seems that ``arc4random`` is preferred, but it can't be seeded.

    - arc4random

.. sourcecode:: bash

    import Foundation

    var a = Array<Int>()
    for i in 1...100000 {
        a.append(Int(arc4random()))
    }

    var m = 0
    for value in a {
        if value > m { m = value }
    }

    println(m)
    // 4294948471

The error message when you try to put the result of ``arc4random`` directly into an ``[Int]`` says that it is a ``UInt32``, an unsigned integer of 32 bits.

We use a bit of trickery to obtain the familiar Python syntax:

.. sourcecode:: bash

    import Foundation

    infix operator **{}
    func ** (n: Double, p: Double) -> Double {
        return pow(n,p)

The definition must be at global scope.  (For more about this see:  :ref:`operators`).  We compute

.. sourcecode:: bash

    println("\(2**32)")
    // 4294967296.0

which sounds about right.  (The ``pow`` function takes a pair of ``Double`` values, and returns one as well).

We could certainly work with the result from ``arc4random``.  To obtain a random integer in a particular range, we first need to divide by the maximum value

.. sourcecode:: bash

    import Foundation

    var f = Double(arc4random())/Double(UInt32.max)
    println("\(f)")
    var str = NSString(format: "%7.5f", f)
    println(str)

.. sourcecode:: bash

    > xcrun swift test.swift
    0.333160816070894
    0.33316
    >

then do

.. sourcecode:: bash

    import Foundation

    func randomIntInRange(begin: Int, end: Int) -> Int {
        var f = Double(arc4random())/Double(UInt32.max)
        // we must convert to allow the * operation
        let range = Double(end - begin)
        let result: Int = Int(f*range)
        return result + begin
    }


    for i in 1...100 {
        println(randomIntInRange(0,2)) 
    }

which gives the expected result (only 0 and 1).

However, rather than doing that, do this:

.. sourcecode:: bash

    import Foundation
    for i in 1...10 {
        println(arc4random_uniform(2)) 
    }

The function ``arc4random_uniform(N)`` gives a result in ``0...N-1``, that is ``[0:N)``.

If you want to seed the generator, use ``rand`` or ``random``.  The first one generates a ``UInt32``.  The second generates an Int.

.. sourcecode:: bash

    import Foundation

    import Foundation
    var a = Array<Int>()
    for i in 1...100000 {
        a.append(random())
    }

    var m = 0
    for value in a {
        if value > m { m = value }
    }

    println("\(m)") 

.. sourcecode:: bash

    > xcrun swift test.swift
    2147469841
    >

which appears to be in the range 0 to

.. sourcecode:: bash

    pow(Double(2),Double(31)) - 1

as we would expect for a signed int32, which is what ``Int`` is.  So, ``random`` gives an Int, which is good, and it can be seeded:

.. sourcecode:: bash

    import Foundation

    func getSeries(seed: Int) -> [Int] {
        srandom(137)
        var a = Array<Int>()
        for i in 1...5 {
            a.append(random())
        }
        return a
    }

    func doOne(seed: Int) {
        let a = getSeries(seed)
        for v in a { print("\(v) ")}
        println()
    }

    for i in 1...2 { doOne(137) }

.. sourcecode:: bash

    > xcrun swift test.swift
    171676246 1227563367 950914861 1789575326 941409949 
    171676246 1227563367 950914861 1789575326 941409949 
    >

If you want to "shuffle", the correct algorithm is to move through the array and do an exchange with a random value from the current position *through the end of the array*

.. sourcecode:: bash

    import Foundation

    func shuffleIntArray(array: [Int]) {
        var j: Int, a: Int, b: Int, tmp: Int
        for i in 0...array.count-1 {
            let r = UInt32(array.count - i)
            j = i + Int(arc4random_uniform(r))
            // j = min(i + 1, array.count-1)
            tmp = array[i]
            array[i] = array[j]
            array[j] = tmp
        }
    }

    var a: [Int] = [1,2,3,4,5,6,7]
    shuffleIntArray(a)
    println("\(a)")
    
This should work, but I am getting the error:  ``error: '@lvalue $T5' is not identical to 'Int'    array[i] = array[j]``.  It is not letting me assign an Int to ``array[i]`` because the value ``array[i]`` is not an Int.  

It happens even when the ``random`` code is replaced by the fake version ``j = min(i + 1, array.count-1)``.

In simpler terms, this works:

.. sourcecode:: bash

    var a: [Int] = [1,2,3,4,5,6,7]
    println("\(a)")
    let tmp = a[0]
    a[0] = a[2]
    a[2] = tmp
    println("\(a)")

and this gives the error:

.. sourcecode:: bash

    func swapTwo(a: [Int], i: Int, j: Int) {
        let v1 = a[i]
        let v2 = a[j]
        a[i] = v2
        a[j] = v1
    }

It's weird but I believe it is due to a restriction on functions modifying arrays.

I was able to get around it by constructing an entirely new array for each call to ``swap``:

.. sourcecode:: bash

    import Foundation

    func swapTwo(input: [Int], i: Int, j: Int) -> [Int] {
        var a = input
        let first = a[i]
        let second = a[j]
        a.removeAtIndex(i)
        a.insert(second, atIndex:i)
        a.removeAtIndex(j)
        a.insert(first, atIndex:j)
        return a
    }

But a much better solution is to wrap the data in a struct and then have a function that is marked as ``mutating``

.. sourcecode:: bash

    import Darwin

    struct Ordering {
        var a: [Int]
        init() {
            self.a = Array(1...100)
        }
        var repr: String {
            get { return ("\(self.a[0...4])") }
        }
        mutating func shuffleArray() {
            var i: Int, j: Int, t: Int
            var a = self.a
            for i in 0...a.count-1 {
                let r = UInt32(a.count - i)
                j = i + Int(arc4random_uniform(r))
                t = a[i]
                a[i] = a[j]
                a[j] = t
            }
            self.a = a
        }
        mutating func sort() {
            self.a.sort { $0 < $1 }
        }
    }
    

.. sourcecode:: bash

    var o = Ordering()
    println("\(o.repr)")
    o.shuffleArray()
    println("\(o.repr)")
    o.sort()
    println("\(o.repr)")

This works:

.. sourcecode:: bash

    > xcrun swift test.swift
    [1, 2, 3, 4, 5]
    [54, 60, 34, 99, 80]
    [1, 2, 3, 4, 5]
    >

**************
Binary Numbers
**************

.. sourcecode:: bash

    import Foundation

    let b: UInt8 = 0b10100101
    println("\(b)")
    println(NSString(format: "%x", b))
    let b2 = ~b
    println("\(b2)")
    println(NSString(format: "%x", b2))

.. sourcecode:: bash

    > xcrun swift test.swift
    165
    a5
    90
    5a
    >

    - ``~`` not
    - ``|`` or
    - ``^`` xor
    - ``<<`` left shift
    - ``>>`` right shift

.. sourcecode:: bash

    import Foundation

    let b1: UInt8 =       0b10100101
    let b2: UInt8 =       0b00001111
    let b3 = b1 ^ b2  //  0b10101010
    println("\(b3)")
    println(NSString(format: "%x", b3))

.. sourcecode:: bash

    > xcrun swift test.swift
    170
    aa
    >

Note:  ``a`` is ``1010``.

.. sourcecode:: bash


    let pink: UInt32 = 0xCC6699
    let redComponent = (pink & 0xFF0000) >> 16    
    // redComponent is 0xCC, or 204
    let greenComponent = (pink & 0x00FF00) >> 8   
    // greenComponent is 0x66, or 102
    let blueComponent = pink & 0x0000FF           
    // blueComponent is 0x99, or 153

Having exclusive or immediately suggests encryption.  Here is a silly example:

.. sourcecode:: bash

    import Foundation

    let key = "MYFAVORITEKEY"
    let text = "TOMISANERD"
    let m = countElements(key)
    let n = countElements(text)
    assert (m > n)

    let kA = key.utf8
    let tA = text.utf8
    var cA = [UInt8]()
    for (k,t) in Zip2(kA,tA) {
        let c = t^k
        println("\(t) \(k) \(c)")
        cA.append(c)
    }

    var pA = [Character]()
    for (k,c) in Zip2(kA,cA) {
        let t = c^k
        print("\(t) ")
        let s = Character(UnicodeScalar(UInt32(t)))
        pA.append(s)
    }
    println()
    let p = "" + pA
    println(p)

.. sourcecode:: bash

    > xcrun swift test.swift
    84 77 25
    79 89 22
    77 70 11
    73 65 8
    83 86 5
    65 79 14
    78 82 28
    69 73 12
    82 84 6
    68 69 1
    84 79 77 73 83 65 78 69 82 68 
    TOMISANERD
    >

See discussion here:

http://stackoverflow.com/questions/24465475/how-can-i-create-a-string-from-utf8-in-swift

*********
Functions
*********

Function definitions are labeled with the keyword ``func``

.. sourcecode:: bash

    func greet(n:String) {
        println("Hello \(n)")
    }
    greet("Tom")

.. sourcecode:: bash

    > xcrun swift test.swift 
    Hello Tom
    >

If you want to return a value, it must be typed

.. sourcecode:: bash

    func count(n:String) -> Int {
        // global function
        return countElements(n)
    }
    println(count("Tom"))

.. sourcecode:: bash

    > xcrun swift test.swift 
    3
    >

Here is an example from the Apple docs:

.. sourcecode:: bash

    func sumOf(numbers: Int...) -> Int {
        var sum = 0
        for n in numbers {
            sum += n
        }
        return sum
    }

    println(sumOf())
    println(sumOf(42,597,12))

.. sourcecode:: bash

    > xcrun swift test.swift 
    0
    651
    >

The ``...`` means the function takes a variadic parameter (number of items is unknown at compile-time---see the docs).

But then they say:

    Functions can be nested. Nested functions have access to variables that were declared in the outer function. You can use nested functions to organize the code in a function that is long or complex.
    
So let's try something.  Add ``let x = 2`` as line 1.

.. sourcecode:: bash

    > xcrun swift test.swift 
    2
    653
    >

They're not kidding!  The ``x`` at global scope is available inside ``sumOf``.  You can nest deeper:

.. sourcecode:: bash

    let s = "abc"
    func f() {
        let t = "def"
        println(s)
        func g() {
            println(s + t)
            println(s + "xyz")
        }
        g()
    }
    f()

.. sourcecode:: bash

    > xcrun swift test.swift 
    abc
    abcdef
    abcxyz
    >

Functions can return multiple values (from the Apple docs, with slight modification):

.. sourcecode:: bash

    func minMax(a: [Int]) -> (Int,Int) {
        min = a[0]
        max = a[1]
        for i in a[1..<a.count] {
            if i < min  {
                min = i
            }
            if i > max {
                max = i
            }
        }
        return (min,max)
    }
    arr: [Int] = [8,-6,2,109,3,71]
    var (s1,s2) : (Int,Int) = minMax(arr)
    println("min = " + s1 + " and max = " + s2)

.. sourcecode:: bash

    > xcrun swift test.swift 
    x y
    >

Return a function:

.. sourcecode:: bash

    func adder(Int) -> (Int -> Int) {
        func f(n:Int) -> Int {
            return 1 + n
        }
        return f
    }
    var addOne = adder(1)
    println(addOne(5))

.. sourcecode:: bash

    > xcrun swift test.swift 
    6
    >

Notice how the return type of ``adder`` is specified.

Provide a function as an argument to a function:

.. sourcecode:: bash

    func filter(list: [Int], cond:Int->Bool) -> [Int] {
        var result:[Int] = []
        for e in list {
           if cond(e) {
              result.append(e)
           }
        }
        return result
    }
    func lessThanTen(number: Int) -> Bool {
        return number < 10
    }
    println(filter([1,2,13],lessThanTen))

.. sourcecode:: bash

    > xcrun swift test.swift 
    [1, 2]
    >

Function parameters
-------------------

It may be useful to require the caller to identify the parameters as they are entered into the function call.  For example, when calling ``NSMakeRect`` one would do something like this:

.. sourcecode:: bash

    let r = NSMakeRect(x:1.0,y:1.0,width:50.0,height:50.0)

``x``, ``y``, ``width`` and ``height`` are named parameters.  The declaration of the function might be something like this

.. sourcecode:: bash

    ``func NSMakeRect(x x: Double, y y: Double, width w: Double, height h: Double)``
    
The *external* parameter name preceeds the *internal* parameter name.  In this case, the internal name is already a good external name for ``x`` and ``y``.  So combine them, like this:

.. sourcecode:: bash

    ``func NSMakeRect(#x: Double, #y: Double, width w: Double, height h: Double)``

    
An example from the Apple docs:

.. sourcecode:: bash

    func join(string1 s1: String, string2 s2: String, withJoiner joiner: String) -> String {
        return s1 + joiner + s2
    }

    println(join(string1: "hello", string2: "world", withJoiner: ", "))

Prints:

.. sourcecode:: bash

    > xcrun swift test.swift 
    hello, world
    >

As the code shows, we have two identifiers for each variable, one used in calling the function, and the other used inside the function.

As we said, while the "external parameter" and the "internal parameter" identifiers can be different (above), they don't have to be.  In that case, the arguments are marked with "#".  Here is the example in the docs:

.. sourcecode:: bash

    func containsCharacter(#string: String, #char: Character) -> Bool {
        for c in string {
            if char == c {
                return true
            }
        }
        return false
    }

    let containsV = containsCharacter(string: "aardvark", char: "v")
    if containsV {
        println("aardvark contains a v")
    }

Prints:

.. sourcecode:: bash

    > xcrun swift test.swift 
    aardvark contains a v
    >

Default parameters
------------------

A function can also have default parameters.  As in Python, the *default parameters must come after all non-default parameters*:

.. sourcecode:: bash

    func join(s1: String, s2: String, joiner: String = " ") -> String {
        return s1 + joiner + s2
    }
    println(join("hello","world"))
    println(join("hello","world",joiner: "-"))
    
.. sourcecode:: bash
     
    > xcrun swift test.swift 
    hello world
    hello-world
    >
    
There are several other fancy twists on parameters that you can read about in the docs, for example:  variadic parameters, parameters that are constant.

********
Closures
********

According to the docs:

    Closures are self-contained blocks of functionality that can be passed around and used in your code. Closures in Swift are similar to blocks in C and Objective-C and to lambdas in other programming languages.

Here is the docs' example where the comparison function is turned into a closure:

.. sourcecode:: bash

    let names = ["Chris", "Alex", "Barry"]
    func backwards(s1: String, s2: String) -> Bool {
        return s1 > s2
    }
    var rev = sorted(names, backwards)
    println(rev)

    rev = sorted(names, { 
          (s1: String, s2: String) 
          -> Bool in return s1 > s2
          })
    println(rev)

.. sourcecode:: bash

    > xcrun swift test.swift 
    [Chris, Barry, Alex]
    [Chris, Barry, Alex]
    >

(I reformated the closure).  Personally, I don't see what the big deal is.  I prefer the named function for this one.

Where they do come in handy is for callbacks.  If we start a dialog to obtain a filename, we can pass into the dialog the code where we want execution to go after the name is obtained.
