.. _matrix:

########
Matrices
########

The docs have an example of a two-dimensional array or matrix of double values.  I've modified it to store Ints

.. sourcecode:: bash

    struct Matrix {
        let rows: Int, columns: Int
        var grid: [Int]
        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            grid = Array(count: rows * columns, repeatedValue: 0)
        }
        func indexIsValidForRow(row: Int, column: Int) -> Bool {
            return row >= 0 && row < rows && column >= 0 && column < columns
        }    
        subscript(row: Int, column: Int) -> Int {
            get {
                assert(indexIsValidForRow(row, column: column), "Index out of range")
                return grid[(row * columns) + column]
            }
            set {
                assert(indexIsValidForRow(row, column: column), "Index out of range")
                grid[(row * columns) + column] = newValue
            }
        }
    }

    var m = Matrix(rows: 2, columns: 2)
    m[0, 1] = 1
    m[1, 0] = 3
    println(m)
    println("\(m[0,0]) \(m[0,1])\n\(m[1,0]) \(m[1,1])")

.. sourcecode:: bash

    > xcrun swift test.swift
    test.Matrix
    0 1
    3 0

I'm going to strip out the error checking since I never make mistakes.  :)
And then I want to a more flexible way of printing the matrix.  To build each line of the output, I want to convert a slice, obtained by calling ``grid[range]``, to a String.  I found this:

http://vperi.com/2014/06/04/flatten-an-array-to-a-string-swift-extension/

.. sourcecode:: bash

    extension Slice {
      func combine(separator: String) -> String{
        var str : String = ""
        for (idx, item) in enumerate(self) {
          str += "\(item)"
          if idx < self.count-1 {
            str += separator
          }
        }
        return str
      }
    }

    var a = [1,2,3]
    var s = a[0...2]
    println(s.combine("*"))

.. sourcecode:: bash

    > xcrun swift test.swift
    1*2*3
    >

This extension builds the string by repeated concatenation.  Probably the library method ``join(sep,array)`` would be better, except it takes an array of String values.  So we'll go with it for the time being.

Now, we take the modified class (no error checking), and add to it a method ``repr``

.. sourcecode:: bash

    struct Matrix {
        let rows: Int, columns: Int
        var grid: [Int]
        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            grid = Array(count: rows * columns, repeatedValue: 0)
        }
        subscript(row: Int, column: Int) -> Int {
            get {
                return grid[(row * columns) + column]
            }
            set {
                grid[(row * columns) + column] = newValue
            }
        }
        var repr: String {
            // limit on Ints to be used, only 1...10
            get {
                var s = ""
                for i in 0...rows-1 {
                    let start = i*rows
                    let end = start + columns - 1
                    let slice = grid[start...end]
                    s += slice.combine(" ") + "\n"
                }
                return s
            }
        }
    }

    var m = Matrix(rows: 2, columns: 2)
    m[0, 1] = 1
    m[1, 0] = 3
    println(m.repr)

.. sourcecode:: bash

    > xcrun swift test.swift
    0 1
    3 0
    
    >
    
It still has an extra newline I have to get rid of.