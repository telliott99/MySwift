.. _command_line:

############
Command line
############

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

