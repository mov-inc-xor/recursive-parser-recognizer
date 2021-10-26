import Foundation

class RecursiveParser {
    enum ParserError: Error {
        case runtimeError(reason: String)
    }
    
    private var chain: String
    
    init(chain: String) {
        self.chain = chain + "⊣"
    }
    
    public func parse(_ rp: String) throws -> Void {
        var rightPart = rp
        
        while !rightPart.isEmpty {
            let head: Character = rightPart.first!
            let tail = rightPart[rightPart.index(after: rightPart.startIndex)...]
            
            if self.isTerminal(head) {
                if head != self.chain.first {
                    throw RecursiveParser.ParserError.runtimeError(reason: "Ошибка разбора символа \(head) в строке \(self.chain)")
                }
                self.chain = String(self.chain.dropFirst())
            } else {
                switch head {
                case "S":
                    try self.parseS()
                case "O":
                    try self.parseO()
                case "Y":
                    try self.parseY()
                case "E":
                    try self.parseE()
                case "K":
                    try self.parseK()
                case "L":
                    try self.parseL()
                default:
                    throw RecursiveParser.ParserError.runtimeError(reason: "Неизвестный нетерминал: \(head)")
                }
            }
            rightPart = String(tail)
        }
    }
    
    private func isTerminal(_ symbol: Character) -> Bool {
        return !symbol.isUppercase
    }
    
    private func parseToken(token: Character, firstSet: Dictionary<Character, String>, following: String? = nil) throws -> Void {
        guard let firstSymbol: Character = self.chain.first else {
            throw RecursiveParser.ParserError.runtimeError(reason: "Цепочка неожиданно закончилась")
        }
        if following != nil && following!.contains(firstSymbol) {
            print("\(token) → ε")
        } else {
            guard let rightPart = firstSet[firstSymbol] else {
                throw RecursiveParser.ParserError.runtimeError(reason: "Символа \(firstSymbol) нет в множестве первых")
            }
            print("\(token) → \(rightPart)")
            try self.parse(rightPart)
        }
    }
    
    private func parseS() throws {
        try self.parseToken(token: "S", firstSet: [
            "{": "{[S]Y}K",
            "a": "a=EK",
        ])
    }
    
    private func parseO() throws {
        try self.parseToken(token: "O", firstSet: [
            "{": "{[S]Y}",
            "a": "a=E",
        ])
    }
    
    private func parseY() throws {
        try self.parseToken(token: "Y", firstSet: [
            "(": "(YL",
            "!": "!(Y)",
            "a": "a",
        ])
    }
    
    private func parseE() throws {
        try self.parseToken(token: "E", firstSet: [
            "+": "+(E,E)",
            "*": "*(E,E)",
            "a": "a",
        ])
    }
    
    private func parseK() throws {
        try self.parseToken(token: "K", firstSet: [
            "{": "OK",
            "a": "OK",
        ], following: "⊣]")
    }
    
    private func parseL() throws {
        try self.parseToken(token: "L", firstSet: [
            "|": "|Y)",
            "&": "&Y)",
        ])
    }
}
