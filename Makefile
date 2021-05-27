target := x86_64-unknown-linux-musl
bin := target/$(target)/debug/rust-zig-musl
env := TARGET_CC=zcc RUSTFLAGS=-Clink-args=-Llib

run: $(bin)
	@$(bin)

clean:
	rm -rf lib sqlite3/*.o
	cargo clean

lib:
	mkdir -p $@

lib/lib%.a: lib
	cd $* && ../zcc -c $*.c
	ar crs lib/lib$*.a $*/$*.o

$(bin): lib/libsqlite3.a
	$(env) cargo build --target $(target)
