import Foundation

let chains = [
    "{[{[a=*(a,a)]a}]!((a|a))}a=a",
    "a=+(*(a,a),a)a=a",
    "+(a,a(",
    "{[a]a}a",
    "{[a=a]!a=a}",
]

print("МЕТОД РЕКУРСИВНОГО СПУСКА")
try chains.forEach { chain in
    print("Разбирается строка: \(chain)")
    
    let recursiveParser = RecursiveParser(chain: chain)

    do {
        try recursiveParser.parse("S")
        print("Строка принадлежит языку")
    } catch RecursiveParser.ParserError.runtimeError(_) {
        print("Строка не принадлежит языку")
    }
    
    print("")
}

print("МЕТОД МП-РАСПОЗНАВАТЕЛЯ")
try chains.forEach { chain in
    print("Разбирается строка: \(chain)")
    
    let recognizer = Recognizer(chain: chain)

    do {
        try recognizer.recognize()
        print("Строка принадлежит языку")
    } catch Recognizer.RecognizerError.runtimeError(_) {
        print("Строка не принадлежит языку")
    }
    
    print("")
}
