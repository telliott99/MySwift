.. _chapter2:

###########
More Basics
###########


.. _command_line:

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

.. _files:

***************
File Operations
***************

Reading

.. sourcecode:: bash

    import Foundation
    let fn = Process.arguments[1]
    var error: NSError?
    
    var text:String? = String.stringWithContentsOfFile(
        fn, 
        encoding:NSUTF8StringEncoding, 
        error: &error)
    if error != nil { 
        println(error) 
    }
    else {
        var a = text!.componentsSeparatedByString(" ")
        println(a)
        var b = text!.componentsSeparatedByCharactersInSet(
            NSCharacterSet (charactersInString: " \n"))
        println(b)
    }

.. sourcecode:: bash

    > xcrun swift test.swift x.txt
    [abc
    def]
    [abc, def]

.. sourcecode:: bash

    > xcrun swift test.swift y.txt
    Optional(Error Domain=NSCocoaErrorDomain \
    Code=260 "The file “y.txt” couldn’t be opened because \
    there is no such file." \
    UserInfo=0x7f95907576b0 {NSFilePath=y.txt, \
    NSUnderlyingError=0x7f959079d090 \
    "The operation couldn’t be completed. \
    No such file or directory"})
    >

and writing:

``test.swift``

.. sourcecode:: bash

    import Foundation

    let s = "my data\n"
    let path = "x.txt"
    var error: NSError?
    s.writeToFile(path, 
        atomically:true, 
        encoding:NSUTF8StringEncoding, 
        error: &error)
    if error != nil { 
        println(error) 
    }

.. sourcecode:: bash

    > cat x.txt
    my data
    >
    
.. _stdin:

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

.. _random:

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

The definition must be at global scope.  (For more about this see  :ref:`operators`).  We compute

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

.. _binary_numbers:

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

.. _functions:

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

.. _closures_intro:

***********************
Closures:  introduction
***********************

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
