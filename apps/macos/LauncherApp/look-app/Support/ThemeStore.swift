import Foundation
import Combine

final class ThemeStore: ObservableObject {
    @Published private(set) var backgroundImageURL: URL?

    @Published var settings: ThemeSettings {
        didSet {
            save()
            if oldValue.backgroundImagePath != settings.backgroundImagePath
                || oldValue.backgroundImageBookmark != settings.backgroundImageBookmark
            {
                refreshBackgroundImageURL()
            }
        }
    }

    private let defaultsKey = "look.theme.settings"
    private var scopedBackgroundURL: URL?

    init() {
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
            let decoded = try? JSONDecoder().decode(ThemeSettings.self, from: data)
        {
            settings = decoded
        } else {
            settings = .default
        }

        refreshBackgroundImageURL()
    }

    func reset() {
        settings = .default
    }

    func setBackgroundImage(url: URL?) {
        guard let url else {
            settings.backgroundImagePath = nil
            settings.backgroundImageBookmark = nil
            return
        }

        let bookmark = try? url.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        settings.backgroundImagePath = url.path
        settings.backgroundImageBookmark = bookmark
    }

    deinit {
        scopedBackgroundURL?.stopAccessingSecurityScopedResource()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        UserDefaults.standard.set(data, forKey: defaultsKey)
    }

    private func refreshBackgroundImageURL() {
        scopedBackgroundURL?.stopAccessingSecurityScopedResource()
        scopedBackgroundURL = nil
        backgroundImageURL = nil

        if let bookmark = settings.backgroundImageBookmark {
            var isStale = false
            if let resolved = try? URL(
                resolvingBookmarkData: bookmark,
                options: .withSecurityScope,
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            ) {
                _ = resolved.startAccessingSecurityScopedResource()
                scopedBackgroundURL = resolved
                backgroundImageURL = resolved
                return
            }
        }

        if let path = settings.backgroundImagePath {
            backgroundImageURL = URL(fileURLWithPath: path)
        }
    }
}
