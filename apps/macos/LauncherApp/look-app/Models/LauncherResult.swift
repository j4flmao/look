import Foundation

enum LauncherResultKind: String, Codable {
    case app
    case file
    case folder
}

struct LauncherResult: Identifiable {
    let id: String
    let kind: LauncherResultKind
    let title: String
    let subtitle: String?
    let path: String
    let score: Int
}
