.. _protocols:

#########
Protocols
#########

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

For more about those, see :ref:`Generics <generics>`::

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