import Foundation

struct Stack<T> {
    private var items: [T] = []
    
    func peek() -> T {
        guard let topElement = items.first else { fatalError("This stack is empty.") }
        return topElement
    }
    
    mutating func pop() -> T {
        return items.removeFirst()
    }
  
    mutating func push(_ element: T) {
        items.insert(element, at: 0)
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

class Recognizer {
    enum RecognizerError: Error {
        case runtimeError(reason: String)
    }
    
    private let table: [Character: [Character: String]] = [
        "S": [
            "{": "{[S]Y}K",
            "a": "a=EK",
        ],
        "O": [
            "{": "{[S]Y}",
            "a": "a=E",
        ],
        "Y": [
            "(": "(YL",
            "!": "!(Y)",
            "a": "a",
        ],
        "E": [
            "+": "+(E,E)",
            "*": "*(E,E)",
            "a": "a",
        ],
        "K": [
            "{": "OK",
            "a": "OK",
            "⊣": "",
            "]": "",
        ],
        "L": [
            "|": "|Y)",
            "&": "&Y)",
        ],
    ]
    
    private var chain: String
    
    init(chain: String) {
        self.chain = chain + "⊣"
    }
    
    private func isTerminal(_ symbol: Character) -> Bool {
        return !symbol.isUppercase
    }
    
    private func printRule(left: Character, right: String) {
        print("\(left) → \(right == "" ? "ε" : right)")
    }
    
    public func recognize() throws {
        var stack = Stack<Character>()
        stack.push("⊣")
        stack.push("S")
        
        var index = 0
        
        while true {
            let currentChar = stack.peek()
            
            if self.isTerminal(currentChar) || currentChar == "⊣" {
                if currentChar == self.chain[index] {
                    let _ = stack.pop()
                    index += 1
                } else {
                    throw Recognizer.RecognizerError.runtimeError(reason: "Ожидалось \(self.chain[index]), получено \(currentChar)")
                }
            } else {
                guard let rightPart = self.table[currentChar]?[self.chain[index]] else {
                    throw Recognizer.RecognizerError.runtimeError(reason: "Ошибка при обработке символа \(currentChar). Нет правил, где первым символом в правой части был \(chain[index])")
                }
                let _ = stack.pop()
                for i in stride(from: rightPart.count - 1, through: 0, by: -1) {
                    stack.push(rightPart[i])
                }
                self.printRule(left: currentChar, right: rightPart)
            }
            
            if currentChar == "⊣" {
                return
            }
        }
    }
}
