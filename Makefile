build: sqlite3/libsqlite3.a
	TARGET_CC="./zcc-musl" RUSTFLAGS="-C link-args=-Lsqlite3" \
		cargo run --target x86_64-unknown-linux-musl --release

sqlite3/libsqlite3.a:
	cd sqlite3 && \
		../zcc-musl -c sqlite3.c && \
		ar cr libsqlite3.a sqlite3.o && \
		ranlib libsqlite3.a
