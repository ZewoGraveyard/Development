protocol LocatedTag: Tag {
    var templateID: TemplateID? { get }
    var lineNumber: Int { get }
}
