CREATE TABLE ballots (
  user_id TEXT PRIMARY KEY NOT NULL,
  teams TEXT NOT NULL CHECK (json_valid(teams) AND json_array_length(teams) = 25),
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
