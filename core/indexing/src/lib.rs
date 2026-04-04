use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Serialize, Deserialize, PartialEq, Eq)]
pub enum CandidateKind {
    App,
    File,
    Folder,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Candidate {
    pub id: String,
    pub kind: CandidateKind,
    pub title: String,
    pub subtitle: Option<String>,
    pub path: String,
    pub use_count: u64,
    pub last_used_at_unix_s: Option<i64>,
}

impl Candidate {
    pub fn new(id: &str, kind: CandidateKind, title: &str, path: &str) -> Self {
        Self {
            id: id.to_string(),
            kind,
            title: title.to_string(),
            subtitle: Some(path.to_string()),
            path: path.to_string(),
            use_count: 0,
            last_used_at_unix_s: None,
        }
    }
}

pub trait Source {
    fn collect(&self) -> Vec<Candidate>;
}
