import Foundation

enum IndentType: Character {
    case parentheses = "(", square = "[", curly = "{", ifelse = "f"

    func stopSymbol() -> Character {
        switch self {
        case .parentheses:
            return ")"
        case .square:
            return "]"
        case .curly:
            return "}"
        case .ifelse:
            return "{"
        }
    }

}

class Indent {
    static var char: String = "" {
        didSet {
            size = char.count
        }
    }
    static var size: Int = 0
    static var paraAlign = false
    var block: IndentType
    var count: Int // general indent count
    var extra: Int // from extra indent
    var extraAdd: Bool
    var inCase: Bool // is case statement
    var inEnum: Bool // is in enum block
    var inSwitch: Bool // is in switch block
    var indentAdd: Bool // same line flag, if same line add only one indent
    var isLeading: Bool
    var leading: Int // leading for smart align
    var line: Int // count number of line

    init() {
        block = .curly
        count = 0
        extra = 0
        extraAdd = false
        inCase = false
        inEnum = false
        inSwitch = false
        indentAdd = false
        isLeading = false
        leading = 0
        line = 0
    }

    init(with indent: Indent, offset: Int, type: IndentType?) {
        self.block = type ?? .curly
        self.count = indent.count
        self.extra = indent.extra
        self.extraAdd = false
        self.inCase = false
        self.inEnum = false
        self.inSwitch = false
        self.indentAdd = false
        self.isLeading = indent.isLeading
        self.leading = indent.leading
        self.line = 0

        if (block != .parentheses || !Indent.paraAlign) && !indent.indentAdd {
            self.count += 1
            self.indentAdd = true
        } else if indent.indentAdd {
            self.indentAdd = true
            if indent.count > 0 {
                indent.count -= 1
            }
        } else {
            self.indentAdd = false
        }
        if !indent.extraAdd {
            self.count += indent.extra
            self.extraAdd = true
        } else {
            self.extraAdd = false
        }

        if Indent.paraAlign {
            if block != .curly {
                self.leading = max(offset - count * Indent.size - 1, 0)
            }
        } else {
            self.leading = 0
        }
    }

}
