import Foundation

enum StoreScreenshotLaunch {
    /// `-shot menu`, `-shot game`, or `-shot settings` (also `-shot=menu`).
    static var shot: String? {
        let args = ProcessInfo.processInfo.arguments
        if let index = args.firstIndex(of: "-shot") {
            let next = args.index(after: index)
            if next < args.endIndex {
                return args[next].lowercased()
            }
        }
        return args.compactMap { argument -> String? in
            guard argument.hasPrefix("-shot=") else { return nil }
            return String(argument.dropFirst(6)).lowercased()
        }.first
    }

    static var isActive: Bool { shot != nil }
}
