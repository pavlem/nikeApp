
import Foundation

class DebugPrint {
    
    static let logFileName = "debug_logs.txt"
    static let fileManager = FileManager.default
    
    static var logFileURL: URL = {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(logFileName)
    }()
    
    // Ensure the log file is cleared on app start
    static func initializeLogger() {
        try? fileManager.removeItem(at: logFileURL) // Remove the old log file if it exists
        fileManager.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
    }
    
    // Write log to file
    private static func logToFile(_ message: String) {
        guard let data = (message + "\n").data(using: .utf8) else { return }
        if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
            defer { fileHandle.closeFile() }
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
        }
    }
    
    static func printLogFilePath() {
#if DEBUG
        print("Log file is located at: \(logFileURL.path)")
#endif
    }
    
    static func print(_ string: String) {
#if DEBUG
        Swift.print(string)
#endif
    }
    
    static func print(_ error: Error) {
#if DEBUG
        Swift.print(error)
#endif
    }
    
    static func print(_ request: URLRequest, isHeaderPrinted: Bool = false, isBodyPrinted: Bool = true) {
#if DEBUG
        var output = "\n➡️➡️ [\(request.httpMethod ?? "")] \(request.url?.absoluteString ?? "")"
        
        if isHeaderPrinted, let headers = request.allHTTPHeaderFields {
            output += "\nHeaders: \(headers)"
        }
        
        if isBodyPrinted, let data = request.httpBody {
            output += "\nBody:"
            if let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                output += "\n\(dictionary)"
            } else if let bodyString = String(data: data, encoding: .utf8) {
                output += "\n\(bodyString)"
            }
        }
        
        Swift.print(output)
        logToFile(output)
#endif
    }
    
    static func print(_ response: URLResponse, andData data: Data? = nil) {
#if DEBUG
        var output = "\n⬅️⬅️⬅️⬅️ [\((response as? HTTPURLResponse)?.statusCode ?? 0)] \(response.url?.absoluteString ?? "")"
        
        guard let data = data else { return }
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else {
            Swift.print("Failed to pretty print JSON")
            return
        }
        output += "\nResponse Body: \n\n\(prettyPrintedString)"
        
        Swift.print(output)
        
        logToFile(output)
        
#endif
    }
    
    static func prettyPrint(_ json: Data) {
#if DEBUG
        guard let object = try? JSONSerialization.jsonObject(with: json, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else {
            Swift.print("Failed to pretty print JSON")
            return
        }
        Swift.print(prettyPrintedString)
        logToFile(prettyPrintedString)
#endif
    }
    
}

