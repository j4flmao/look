pub const APP_SCAN_ROOTS: [&str; 3] = [
    "/Applications",
    "/System/Applications",
    "/System/Applications/Utilities",
];

pub const APP_SCAN_DEPTH: usize = 3;

pub const FILE_SCAN_ROOT_SUFFIXES: [&str; 3] = ["Desktop", "Documents", "Downloads"];
pub const FILE_SCAN_DEPTH: usize = 2;
pub const FILE_SCAN_LIMIT: usize = 2000;

pub const SCORE_TITLE_CONTAINS: i64 = 1200;
pub const SCORE_SUBTITLE_CONTAINS: i64 = 900;
pub const SCORE_TOKEN_ALL_MATCH: i64 = 850;

pub const BIAS_APP: i64 = 220;
pub const BIAS_FOLDER: i64 = 0;
pub const BIAS_FILE: i64 = -20;

pub const BIAS_SETTINGS_MATCH: i64 = 420;
pub const BIAS_APP_ON_SETTINGS_QUERY: i64 = 120;
pub const BIAS_NON_APP_ON_SETTINGS_QUERY: i64 = -260;

pub const QUERY_SETTINGS_HINTS: [&str; 6] = [
    "setting",
    "display",
    "network",
    "bluetooth",
    "privacy",
    "sound",
];

pub const SKIP_DIR_NAMES: [&str; 7] = [
    "node_modules",
    "target",
    "build",
    "dist",
    "library",
    "applications",
    "old firefox data",
];
