.. _closures_intro:

########
Closures
########

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
