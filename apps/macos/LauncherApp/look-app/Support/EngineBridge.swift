import Foundation

@_silgen_name("look_search_json")
nonisolated
private func look_search_json(_ query: UnsafePointer<CChar>?, _ limit: UInt32) -> UnsafeMutablePointer<CChar>?

@_silgen_name("look_search_json_compact")
nonisolated
private func look_search_json_compact(_ query: UnsafePointer<CChar>?, _ limit: UInt32) -> UnsafeMutablePointer<CChar>?

@_silgen_name("look_record_usage")
nonisolated
private func look_record_usage(_ candidateID: UnsafePointer<CChar>?, _ action: UnsafePointer<CChar>?) -> Bool

@_silgen_name("look_free_cstring")
nonisolated
private func look_free_cstring(_ ptr: UnsafeMutablePointer<CChar>?)

@_silgen_name("look_reload_config")
nonisolated
private func look_reload_config() -> Bool

@_silgen_name("look_translate_json")
nonisolated
private func look_translate_json(_ text: UnsafePointer<CChar>?, _ targetLang: UnsafePointer<CChar>?) -> UnsafeMutablePointer<CChar>?

final class EngineBridge {
    static let shared = EngineBridge()

    private init() {}

    nonisolated func search(query: String, limit: Int = 40) -> [LauncherResult] {
        let ptr = query.withCString { cstr in
            look_search_json_compact(cstr, UInt32(limit))
        }

        guard let ptr else {
            return fallbackResults()
        }

        defer {
            look_free_cstring(ptr)
        }

        let raw = String(cString: ptr)
        guard let data = raw.data(using: .utf8) else {
            return fallbackResults()
        }

        if let compactPayload = try? JSONDecoder().decode(CompactSearchPayload.self, from: data) {
            return compactPayload.results.map { item in
                LauncherResult(
                    id: item.id,
                    kind: LauncherResultKind(rawValue: item.kind) ?? .app,
                    title: item.title,
                    subtitle: item.subtitle,
                    path: item.path,
                    score: item.score
                )
            }
        }

        // Compatibility fallback for older JSON payload shape.
        guard let fullPayload = try? JSONDecoder().decode(SearchPayload.self, from: data),
            fullPayload.error == nil
        else {
            return fallbackResults()
        }

        return fullPayload.results.map { item in
            LauncherResult(
                id: item.id,
                kind: LauncherResultKind(rawValue: item.kind) ?? .app,
                title: item.title,
                subtitle: item.subtitle,
                path: item.path,
                score: item.score
            )
        }
    }

    nonisolated func recordUsage(candidateID: String, action: String) {
        _ = candidateID.withCString { idCstr in
            action.withCString { actionCstr in
                look_record_usage(idCstr, actionCstr)
            }
        }
    }

    nonisolated func reloadConfig() -> Bool {
        look_reload_config()
    }

    nonisolated func translate(text: String, targetLang: String = "en") -> TranslationResult? {
        let result = text.withCString { textCstr in
            targetLang.withCString { langCstr in
                look_translate_json(textCstr, langCstr)
            }
        }

        guard let result else {
            return nil
        }

        defer {
            look_free_cstring(result)
        }

        let raw = String(cString: result)
        guard let data = raw.data(using: .utf8) else {
            return nil
        }

        return try? JSONDecoder().decode(TranslationResult.self, from: data)
    }

    nonisolated private func fallbackResults() -> [LauncherResult] {
        []
    }
}

nonisolated struct TranslationResult: Decodable {
    let original: String
    let translated: String
    let error: BridgeError?
}

private nonisolated struct SearchPayload: Decodable {
    let query: String
    let count: Int
    let results: [SearchItem]
    let error: BridgeError?
}

private nonisolated struct CompactSearchPayload: Decodable {
    let count: Int
    let results: [SearchItem]
}

nonisolated struct BridgeError: Decodable {
    let code: String
    let message: String
}

private nonisolated struct SearchItem: Decodable {
    let id: String
    let kind: String
    let title: String
    let subtitle: String?
    let path: String
    let score: Int
}
