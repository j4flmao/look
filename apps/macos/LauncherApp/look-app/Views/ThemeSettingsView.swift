import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct ThemeSettingsView: View {
    @EnvironmentObject private var appUIState: AppUIState
    @EnvironmentObject private var themeStore: ThemeStore
    @Binding var settings: ThemeSettings
    @State private var selectedTab = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Settings")
                    .font(.headline)
                Spacer()
                Button("Back to Launcher") {
                    appUIState.showsThemeSettings = false
                }
                Text("Cmd+Shift+, to close")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Picker("Tab", selection: $selectedTab) {
                Text("Appearance").tag(0)
                Text("Background").tag(1)
                Text("Shortcuts").tag(2)
            }
            .pickerStyle(.segmented)

            Group {
                if selectedTab == 0 {
                    appearanceTab
                } else if selectedTab == 1 {
                    backgroundTab
                } else {
                    shortcutsTab
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)

        }
    }

    private var appearanceTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Tint Color")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                LabeledSlider(title: "Red", value: $settings.tintRed, range: 0...1)
                LabeledSlider(title: "Green", value: $settings.tintGreen, range: 0...1)
                LabeledSlider(title: "Blue", value: $settings.tintBlue, range: 0...1)
                LabeledSlider(title: "Tint Opacity", value: $settings.tintOpacity, range: 0...1)

                LabeledSlider(title: "Blur Opacity", value: $settings.blurOpacity, range: 0...1)

                HStack(spacing: 10) {
                    Text("Blur Style")
                        .frame(width: AppConstants.ThemeUI.labelWidth, alignment: .leading)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Picker("Blur Style", selection: $settings.blurMaterial) {
                        ForEach(LauncherBlurMaterial.allCases) { item in
                            Text(item.title).tag(item)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: AppConstants.ThemeUI.pickerWidth)

                    Text(settings.blurMaterial.detail)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var backgroundTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Button("Choose Background Image") {
                        selectBackgroundImage()
                    }
                    if settings.backgroundImagePath != nil {
                        Button("Clear") {
                            themeStore.setBackgroundImage(url: nil)
                        }
                    }
                }

                Text(settings.backgroundImagePath ?? "No image selected")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 10) {
                    Text("Image Layout")
                        .frame(width: AppConstants.ThemeUI.labelWidth, alignment: .leading)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Picker("Image Layout", selection: $settings.backgroundImageMode) {
                        ForEach(BackgroundImageMode.allCases) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: AppConstants.ThemeUI.pickerWidth)

                    Text(settings.backgroundImageMode.detail)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                LabeledSlider(title: "Image Opacity", value: $settings.backgroundImageOpacity, range: 0...1)
                LabeledSlider(title: "Image Blur", value: $settings.backgroundImageBlur, range: 0...30)
            }
        }
    }

    private var shortcutsTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                ShortcutSection(
                    title: "Core launcher",
                    items: [
                        ShortcutItem(keys: "Tab", action: "Select next result"),
                        ShortcutItem(keys: "Shift+Tab", action: "Select previous result"),
                        ShortcutItem(keys: "Up / Down", action: "Move selection"),
                        ShortcutItem(keys: "Cmd+Enter", action: "Search query on Google"),
                        ShortcutItem(keys: "/", action: "Enter command mode"),
                        ShortcutItem(keys: "Shift+Esc", action: "Exit command mode"),
                    ]
                )

                ShortcutSection(
                    title: "Panels",
                    items: [
                        ShortcutItem(keys: "Cmd+Shift+,", action: "Open/close theme and docs panel"),
                    ]
                )

                ShortcutSection(
                    title: "Theme controls",
                    items: [
                        ShortcutItem(keys: "Appearance tab", action: "Tint, blur material, blur opacity"),
                        ShortcutItem(keys: "Background tab", action: "Image select, image opacity, image blur"),
                        ShortcutItem(keys: "Shortcuts tab", action: "In-app keyboard documentation"),
                    ]
                )

                Text("This panel is intended as living documentation. We can add command and workflow docs here as features grow.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 4)
        }
    }

    private func selectBackgroundImage() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.image]
        if panel.runModal() == .OK {
            themeStore.setBackgroundImage(url: panel.url)
        }
    }
}

private struct ShortcutItem: Identifiable {
    let id = UUID()
    let keys: String
    let action: String
}

private struct ShortcutSection: View {
    let title: String
    let items: [ShortcutItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ForEach(items) { item in
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(item.keys)
                        .font(.caption.monospaced())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.white.opacity(0.14), in: Capsule())
                    Text(item.action)
                        .font(.caption)
                        .foregroundStyle(.primary)
                    Spacer(minLength: 0)
                }
            }
        }
    }
}

private struct LabeledSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .frame(width: AppConstants.ThemeUI.labelWidth, alignment: .leading)
                .font(.caption)
                .foregroundStyle(.secondary)
            Slider(value: $value, in: range)
            Text(value, format: .number.precision(.fractionLength(2)))
                .font(.caption.monospacedDigit())
                .frame(width: 42, alignment: .trailing)
                .foregroundStyle(.secondary)
        }
    }
}
