.. _functional:

######################
Functional Programming
######################

In this section, we look at the three staples of functional programming:  ``filter``, ``map`` and ``reduce``, implemented using generics.

------
Filter
------

Filter takes an array of values and a predicate, a function that takes a single value, tests it, and returns a boolean.

There is a built-in ``filter`` global function.

.. sourcecode:: bash

    let a = Array(0...10)
    println("\(filter(a, { $0 < 5 && $0 % 2 == 0 } ) )")

.. sourcecode:: bash

    > xcrun swift test.swift
    [0, 2, 4]
    >

An example with String and a home-made version of split

.. sourcecode:: bash

    func mysplit(str: String) -> [String] {
        var ret = Array<String>()
        var s: String
        for c in str {
            // convert Character to String
            s = ""
            s.append(c)
            ret.append(s)
        }
        return ret
    }

    func isVowel(str: String) -> Bool {
        let vowels = mysplit("aeiou")
        return contains(vowels,str)
    }

    let a1 = mysplit("abcde")
    println("\(a1)")
    let a2 = filter(a1,isVowel)
    println("\(a2)")

.. sourcecode:: bash

    > xcrun swift test.swift
    [a, b, c, d, e]
    [a, e]
    >
    
Now, let's write our own version of filter, using generics:
    
    
.. sourcecode:: bash

    func genericFilter <T> (a: Array<T>, 
                     pred: (t: T) -> (Bool)) 
                     -> Array<T> {
        var ret = Array<T>()
        for t in a {
            if pred(t: t) { ret.append(t) }
        }
        return ret
    }

    let a1 = Array(0...4)
    func lessThan2(i: Int) -> Bool { return i < 2 }

    let a2 = genericFilter(a1,lessThan2)
    println("\(a2)")

    let a3 = genericFilter(a1, { $0 < 2 })
    println("\(a3)")

We pass either a function or a closure.

.. sourcecode:: bash

    > xcrun swift test.swift
    [0, 1]
    [0, 1]
    >

A String example:

.. sourcecode:: bash

    func genericFilter <T> (a: Array<T>, 
                     pred: (t: T) -> (Bool)) 
                     -> Array<T> {
        var ret = Array<T>()
        for t in a {
            if pred(t: t) { ret.append(t) }
        }
        return ret
    }

    let a1 = ["a","b","c","d","e"]
    func isVowel(s: String) -> Bool {
        let v = ["a","e","i","o","u"]
        return contains(v,s)
    }

    let a2 = genericFilter(a1,isVowel)
    println("\(a2)")
    
.. sourcecode:: bash

    > xcrun swift test.swift
    [a, e]
    >

---
Map
---

Map takes an array and a function ``transform``, and applies the function to each element of the array.

.. sourcecode:: bash

    func genericMap <T,U> (a: Array<T>, 
                  transform: (t: T) -> (U))
                  -> Array<U> {
          var ret = Array<U>()
          for t in a {
              ret.append(transform(t: t))
          }
          return ret
    }

    let a1 = Array(0...4)
    println("\(a1)")
    func sub(i: Int) -> Int { return i - 1 }
    let a2 = genericMap(a1,sub)
    println("\(a2)")
    
.. sourcecode:: bash

    > xcrun swift test.swift
    [0, 1, 2, 3, 4]
    [-1, 0, 1, 2, 3]
    >

According to 

http://robnapier.net/maps

Swift has three built-in ``map`` functions:

.. sourcecode:: bash

    /// Haskell's fmap for Optionals.
    func map<T, U>(x: T?, f: (T) -> U) -> U?

    /// Return an `Array` containing the results of mapping `transform` over `source`.
    func map<C : CollectionType, T>(source: C, transform: (C.Generator.Element) -> T) -> [T]

    /// Return an `Array` containing the results of mapping `transform` over `source`.
    func map<S : SequenceType, T>(source: S, transform: (S.Generator.Element) -> T) -> [T]

    Plus it has map methods on Array, Dictionary, Optional, Range, Slice, and a bunch of other classes.
    
Let's try them out.

I got ``ord`` from here:

https://github.com/practicalswift/Pythonic.swift/blob/master/src/Pythonic.swift

.. sourcecode:: bash

    import Foundation

    func ord(c: Character) -> Int {
        return ord(String(c))
    }

    func ord(s: String) -> Int {
        return Int((s as NSString).characterAtIndex(0))
    }

    func mysplit(str: String, seps: String) -> [String] {
        let cs = NSCharacterSet(charactersInString:seps)
        return str.componentsSeparatedByCharactersInSet(cs)
    }

    func toData(str: String) -> Int {
        var i: Int = 0
        for c in str {
            i += ord(c)
        }
        return i
    }

    let a1 = mysplit("My name is Tom", " ")
    let a2 = map(a1,toData)
    println("\(a2)")
    
.. sourcecode:: bash

    > xcrun swift test.swift
    [198, 417, 220, 304]
    >
    
Could have been accomplished with ``NSCharacterSet.whitespaceCharacterSet()``.

Rob Napier's example:

.. sourcecode:: bash

    import Foundation

    func map<T, U>(source: [T], transform: T -> U) -> [U] {
      var result = [U]()
      for element in source {
        result.append(transform(element))
      }
      return result
    }

    let domains = ["apple.com", "google.com", "robnapier.net"]

    // And here's our loop:
    let urls = map(domains, { NSURL(scheme: "http", host: $0, path: "/") })

    for url in urls { println("\(url)") }

    // Or we can use Array's method (implementation not shown)
    let urls2 = domains.map{ NSURL(scheme: "http", host: $0, path: "/") }

    // same as above
    // for url in urls { println("\(url)") }
    
.. sourcecode:: bash

    > xcrun swift test.swift 
    http://apple.com/
    http://google.com/
    http://robnapier.net/
    >

Another example

http://robnapier.net/maps

.. sourcecode:: bash

    import Foundation

    func embeddedURLs(text: String) -> [NSURL] {
      return text
        .componentsSeparatedByString(" ")
        .filter{ $0.hasPrefix("http://") }
        .map{ NSURL(string: $0) }
    }

    let s = "This text contains a link to http://www.apple.com."
    let e = embeddedURLs(s)
    println("\(e)")

It looks kind of funny but it works:

.. sourcecode:: bash

    > xcrun swift x.swift 
    [http://www.apple.com.]
    >

That return statement works by chaining the results of each call together.  It would never have occurred to me to do that.

Here is another one.  What it does is straightforward, it returns nil when the element is nil, and the transformed element otherwise.  To me the most interesting part is that we can switch on ``x`` as 

.. sourcecode:: bash

    func mymap<T, U>(x: T?, f: T -> U) -> U? {
      switch x {
      case .Some(let value): return .Some(f(value))
      case .None: return .None
      }
    }

This last doesn't work yet, but I figured out what the switch is about:

    var optstr: String? = "hello"
    switch optstr {
    case .Some:  println("some")
    case .None:  println("none")
    }

In the playground, this evaluates to "some".  Apparently, ``.Some`` and ``.None`` are the two possible enum values for an Optional.  (Note the absence of a ``default`` case).  If we do ``optstr = nil``, the ``println`` statement will give "none".

------
Reduce
------


