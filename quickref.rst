.. _quickref:

###############
Quick reference
###############

From

https://developer.apple.com/library/prerelease/mac/documentation/General/Reference/APIDiffsMacOSX10_10SeedDiff/modules/Swift.html

(a few are not listed)

String methods:

.. sourcecode:: bash

    append(Character)
    init(count: Int, repeatedValue: Character)
    endIndex
    extend(String)
    hasPrefix(String) -> Bool
    hasSuffix(String) -> Bool
    insert(Character, atIndex: String.Index)
    isEmpty
    join(S) -> String
    removeAll(Bool)
    removeAtIndex(String.Index) -> Character
    removeRange(Range<String.Index>)
    replaceRange(Range<String.Index>, with: C)
    reserveCapacity(Int)
    init(seq: S)
    splice(S, atIndex: String.Index)
    startIndex
    toInt() -> Int?

Array methods:

.. sourcecode:: bash

    append(T)
    capacity
    count
    init(count: Int, repeatedValue: T)
    description
    endIndex
    extend(S)
    filter((T) -> Bool) -> [T]
    first
    insert(T, atIndex: Int)
    isEmpty
    join(S) -> [T]
    last
    map((T) -> U) -> [U]
    reduce(U, combine:(U, T) -> U) -> U
    removeAll(Bool)
    removeAtIndex(Int) -> T
    removeLast() -> T
    removeRange(Range<Int>)
    replaceRange(Range<Int>, with: C)
    reserveCapacity(Int)
    reverse() -> [T]
    sort((T, T) -> Bool)
    sorted((T, T) -> Bool) -> [T]
    splice(S, atIndex: Int)
    startIndex

Dictionary methods

.. sourcecode:: bash

    count
    description
    endIndex
    generate() -> DictionaryGenerator<Key, Value>
    indexForKey(Key) -> DictionaryIndex<Key, Value>?
    isEmpty
    keys
    init(minimumCapacity: Int)
    removeAll(Bool)
    removeAtIndex(DictionaryIndex<Key, Value>)
    removeValueForKey(Key) -> Value?
    startIndex
    updateValue(Value, forKey: Key) -> Value?
    values

