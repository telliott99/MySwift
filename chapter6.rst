.. _chapter6:

###################
More Advanced Swift
###################

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

.. _NSCoding:

*****************
NSCoding protocol
*****************

This works, but I have to run it in a special way.

http://stackoverflow.com/questions/25701476/how-to-implement-nscoding

.. sourcecode:: bash

    import Foundation

    class C: NSObject, NSCoding {
        var n: String = ""

        override init() {
            super.init()
            n = "instance of class C"
        }

        convenience init(_ name: String) {
            self.init()
            n = name
        }

        required init(coder: NSCoder) {
            n = coder.decodeObjectForKey("name") as String
        }

        func encodeWithCoder(coder: NSCoder) {
            coder.encodeObject(n, forKey:"name")
        }

        override var description: String {
            get { return "C instance: \(n)" }
        }
    }

    let c = C("Tom")
    println(c)
    if NSKeyedArchiver.archiveRootObject(c, toFile: "demo") {
        println("OK")
    }
    let c2: C = NSKeyedUnarchiver.unarchiveObjectWithFile("demo") as C
    println(c2)
    

.. sourcecode:: bash

    > xcrun -sdk macosx swiftc coder.swift && ./coder
    C instance: Tom
    OK
    C instance: Tom
    >
