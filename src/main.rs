use rusqlite::{Connection, Result};

fn main() -> Result<()> {
  let db = Connection::open_in_memory()?;

  let version: String = db
    .prepare("select sqlite_version()")?
    .query_row([], |row| row.get(0))?;

  Ok(println!("SQLite version: {}", version))
}
