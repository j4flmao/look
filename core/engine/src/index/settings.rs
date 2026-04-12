use crate::index::SETTINGS_CANDIDATE_ID_PREFIX;
use look_indexing::{Candidate, CandidateKind};
use std::sync::mpsc;

const SETTINGS_URL_SCHEME_PREFIX: &str = "x-apple.systempreferences:";
const SETTINGS_SUBTITLE_PREFIX: &str = "System Settings ";

struct SettingsEntry {
    title: &'static str,
    target: &'static str,
    candidate_id_suffix: &'static str,
    aliases: &'static str,
}

const SETTINGS_CATALOG: [SettingsEntry; 30] = [
    SettingsEntry {
        title: "General",
        target: "com.apple.systempreferences.GeneralSettings",
        candidate_id_suffix: "com.apple.systempreferences.generalsettings",
        aliases: "settings general about software update storage",
    },
    SettingsEntry {
        title: "Apple ID",
        target: "com.apple.systempreferences.AppleIDSettings",
        candidate_id_suffix: "com.apple.systempreferences.appleidsettings",
        aliases: "settings apple id icloud media purchases",
    },
    SettingsEntry {
        title: "iCloud",
        target: "com.apple.systempreferences.AppleIDSettings:icloud",
        candidate_id_suffix: "com.apple.systempreferences.appleidsettings.icloud",
        aliases: "settings icloud cloud drive photos backup hide my email private relay",
    },
    SettingsEntry {
        title: "Wi-Fi",
        target: "com.apple.wifi-settings-extension",
        candidate_id_suffix: "com.apple.wifi-settings-extension",
        aliases: "settings wifi wireless network internet",
    },
    SettingsEntry {
        title: "Bluetooth",
        target: "com.apple.BluetoothSettings",
        candidate_id_suffix: "com.apple.bluetoothsettings",
        aliases: "settings bluetooth devices pairing",
    },
    SettingsEntry {
        title: "Network",
        target: "com.apple.Network-Settings.extension",
        candidate_id_suffix: "com.apple.network-settings.extension",
        aliases: "settings network ethernet dns proxy vpn",
    },
    SettingsEntry {
        title: "Internet Accounts",
        target: "com.apple.Internet-Accounts-Settings.extension",
        candidate_id_suffix: "com.apple.internet-accounts-settings.extension",
        aliases: "settings internet accounts account google exchange outlook imap icloud",
    },
    SettingsEntry {
        title: "Sound",
        target: "com.apple.Sound-Settings.extension",
        candidate_id_suffix: "com.apple.sound-settings.extension",
        aliases: "settings sound audio input output volume",
    },
    SettingsEntry {
        title: "Display",
        target: "com.apple.Displays-Settings.extension",
        candidate_id_suffix: "com.apple.displays-settings.extension",
        aliases: "settings display monitor resolution refresh night shift",
    },
    SettingsEntry {
        title: "Appearance",
        target: "com.apple.Appearance-Settings.extension",
        candidate_id_suffix: "com.apple.appearance-settings.extension",
        aliases: "settings appearance light dark accent highlight",
    },
    SettingsEntry {
        title: "Accessibility",
        target: "com.apple.Accessibility-Settings.extension",
        candidate_id_suffix: "com.apple.accessibility-settings.extension",
        aliases: "settings accessibility vision hearing voiceover zoom contrast",
    },
    SettingsEntry {
        title: "Wallpaper",
        target: "com.apple.Wallpaper-Settings.extension",
        candidate_id_suffix: "com.apple.wallpaper-settings.extension",
        aliases: "settings wallpaper background screen saver",
    },
    SettingsEntry {
        title: "Screen Saver",
        target: "com.apple.ScreenSaver-Settings.extension",
        candidate_id_suffix: "com.apple.screensaver-settings.extension",
        aliases: "settings screen saver idle lock background",
    },
    SettingsEntry {
        title: "Desktop & Dock",
        target: "com.apple.Desktop-Settings.extension",
        candidate_id_suffix: "com.apple.desktop-settings.extension",
        aliases: "settings desktop dock menu bar stage manager desk dock",
    },
    SettingsEntry {
        title: "Screen Time",
        target: "com.apple.Screen-Time-Settings.extension",
        candidate_id_suffix: "com.apple.screen-time-settings.extension",
        aliases: "settings screen time limits downtime",
    },
    SettingsEntry {
        title: "Focus",
        target: "com.apple.Focus-Settings.extension",
        candidate_id_suffix: "com.apple.focus-settings.extension",
        aliases: "settings focus do not disturb notifications",
    },
    SettingsEntry {
        title: "Notifications",
        target: "com.apple.Notifications-Settings.extension",
        candidate_id_suffix: "com.apple.notifications-settings.extension",
        aliases: "settings notifications alerts",
    },
    SettingsEntry {
        title: "Battery",
        target: "com.apple.Battery-Settings.extension",
        candidate_id_suffix: "com.apple.battery-settings.extension",
        aliases: "settings battery power energy",
    },
    SettingsEntry {
        title: "Lock Screen",
        target: "com.apple.Lock-Screen-Settings.extension",
        candidate_id_suffix: "com.apple.lock-screen-settings.extension",
        aliases: "settings lock screen timeout",
    },
    SettingsEntry {
        title: "Touch ID & Password",
        target: "com.apple.Touch-ID-Settings.extension",
        candidate_id_suffix: "com.apple.touch-id-settings.extension",
        aliases: "settings touch id password touchid pass fingerprint",
    },
    SettingsEntry {
        title: "Users & Groups",
        target: "com.apple.Users-Groups-Settings.extension",
        candidate_id_suffix: "com.apple.users-groups-settings.extension",
        aliases: "settings users groups login items accounts user group",
    },
    SettingsEntry {
        title: "Privacy & Security",
        target: "com.apple.settings.PrivacySecurity.extension",
        candidate_id_suffix: "com.apple.settings.privacysecurity.extension",
        aliases: "settings privacy security permissions firewall",
    },
    SettingsEntry {
        title: "Control Center",
        target: "com.apple.ControlCenter-Settings.extension",
        candidate_id_suffix: "com.apple.controlcenter-settings.extension",
        aliases: "settings control center menu bar modules",
    },
    SettingsEntry {
        title: "Siri & Apple Intelligence",
        target: "com.apple.Siri-Settings.extension",
        candidate_id_suffix: "com.apple.siri-settings.extension",
        aliases: "settings siri apple intelligence apple intelligent ai assistant",
    },
    SettingsEntry {
        title: "Keyboard",
        target: "com.apple.Keyboard-Settings.extension",
        candidate_id_suffix: "com.apple.keyboard-settings.extension",
        aliases: "settings keyboard shortcuts input",
    },
    SettingsEntry {
        title: "Mouse",
        target: "com.apple.Mouse-Settings.extension",
        candidate_id_suffix: "com.apple.mouse-settings.extension",
        aliases: "settings mouse pointer scrolling click speed",
    },
    SettingsEntry {
        title: "Trackpad",
        target: "com.apple.Trackpad-Settings.extension",
        candidate_id_suffix: "com.apple.trackpad-settings.extension",
        aliases: "settings trackpad gestures pointer",
    },
    SettingsEntry {
        title: "Printers & Scanners",
        target: "com.apple.Print-Scan-Settings.extension",
        candidate_id_suffix: "com.apple.print-scan-settings.extension",
        aliases: "settings printers scanners printer scanner airprint",
    },
    SettingsEntry {
        title: "Wallet & Apple Pay",
        target: "com.apple.WalletSettingsExtension",
        candidate_id_suffix: "com.apple.walletsettingsextension",
        aliases: "settings wallet apple pay cards payments",
    },
    SettingsEntry {
        title: "Game Center",
        target: "com.apple.Game-Center-Settings.extension",
        candidate_id_suffix: "com.apple.game-center-settings.extension",
        aliases: "settings game center gaming friends",
    },
];

pub fn discover_system_settings_entries(tx: mpsc::SyncSender<Candidate>) {
    for entry in SETTINGS_CATALOG {
        let key = format!(
            "{SETTINGS_CANDIDATE_ID_PREFIX}{}",
            entry.candidate_id_suffix
        );
        let mut candidate = Candidate::new(
            &key,
            CandidateKind::App,
            entry.title,
            &format!("{SETTINGS_URL_SCHEME_PREFIX}{}", entry.target),
        );
        candidate.subtitle = Some(format!("{SETTINGS_SUBTITLE_PREFIX}{}", entry.aliases).into());
        let _ = tx.send(candidate);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use look_indexing::CandidateIdKind;
    use std::collections::HashSet;

    #[test]
    fn curated_settings_catalog_has_valid_fields() {
        let mut seen_targets = HashSet::new();
        let mut seen_candidate_id_suffixes = HashSet::new();
        let mut seen_titles = HashSet::new();

        for entry in SETTINGS_CATALOG {
            assert!(!entry.title.trim().is_empty(), "title must be non-empty");
            assert!(
                seen_titles.insert(entry.title.to_ascii_lowercase()),
                "duplicate title: {}",
                entry.title
            );

            assert!(!entry.target.trim().is_empty(), "target must be non-empty");
            assert!(
                entry.target.starts_with("com.apple."),
                "target should use com.apple.* namespace: {}",
                entry.target
            );
            assert!(
                entry.target.chars().all(|ch| ch.is_ascii_alphanumeric()
                    || ch == '.'
                    || ch == '-'
                    || ch == '_'
                    || ch == ':'),
                "target has invalid chars: {}",
                entry.target
            );
            assert!(
                seen_targets.insert(entry.target.to_ascii_lowercase()),
                "duplicate target: {}",
                entry.target
            );

            assert!(
                !entry.candidate_id_suffix.trim().is_empty(),
                "candidate_id_suffix must be non-empty"
            );
            assert!(
                entry
                    .candidate_id_suffix
                    .chars()
                    .all(|ch| ch.is_ascii_alphanumeric() || ch == '.' || ch == '-' || ch == '_'),
                "candidate_id_suffix has invalid chars: {}",
                entry.candidate_id_suffix
            );
            assert!(
                seen_candidate_id_suffixes.insert(entry.candidate_id_suffix.to_ascii_lowercase()),
                "duplicate candidate_id_suffix: {}",
                entry.candidate_id_suffix
            );

            assert!(
                !entry.aliases.trim().is_empty(),
                "aliases must be non-empty"
            );
            assert!(
                entry.aliases.contains("settings"),
                "aliases should include settings hint: {}",
                entry.aliases
            );
        }
    }

    #[test]
    fn discovery_outputs_valid_settings_candidates() {
        let (tx, rx) = mpsc::sync_channel(64);
        discover_system_settings_entries(tx);
        let discovered: Vec<Candidate> = rx.into_iter().collect();

        assert_eq!(discovered.len(), SETTINGS_CATALOG.len());

        for candidate in discovered {
            assert_eq!(candidate.kind, CandidateKind::App);
            assert!(candidate.id.starts_with(CandidateIdKind::PREFIX_SETTING));
            assert!(candidate.path.starts_with(SETTINGS_URL_SCHEME_PREFIX));
            assert!(
                candidate
                    .subtitle
                    .as_deref()
                    .is_some_and(|s| s.starts_with(SETTINGS_SUBTITLE_PREFIX))
            );
        }
    }
}
