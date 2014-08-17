.. _objects:

#######
Objects
#######

.. sourcecode:: bash

    class Obj {
        var name: String
        init(name: String) {
            self.name = name
        }
        func description() -> String {
            return "Obj: \(self.name)"
        }
    }

    var o = Obj(name: "Tom")
    println(o.name)
    println(o.description())

.. sourcecode:: bash

    > xcrun swift test.swift 
    Tom
    Obj: Tom
    >


