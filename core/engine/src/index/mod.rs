mod apps;
mod files;
mod settings;

use look_indexing::Candidate;
use std::collections::HashSet;

pub fn discover_candidates() -> Vec<Candidate> {
    let mut out = Vec::new();
    let mut seen = HashSet::new();

    apps::discover_installed_apps(&mut seen, &mut out);
    settings::discover_system_settings_entries(&mut seen, &mut out);
    files::discover_local_files_and_folders(&mut seen, &mut out);

    out
}
