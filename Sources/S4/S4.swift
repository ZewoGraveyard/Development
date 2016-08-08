@_exported import C7

#if swift(>=3.0)
#else
    public typealias Error = ErrorType
    public typealias RangeReplaceableCollection = RangeReplaceableCollectionType
    public typealias MutableCollection = MutableCollectionType
    public typealias Sequence = SequenceType
#endif
