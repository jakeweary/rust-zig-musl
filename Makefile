target := x86_64-unknown-linux-musl
zcc := zig cc -target x86_64-linux-musl
bin := target/$(target)/debug/rust-zig-musl
env := RUSTFLAGS=-Clink-args=-Llib

run: $(bin)
	@$(bin)

clean:
	rm -rf lib sqlite3/*.o
	cargo clean

lib:
	mkdir -p $@

lib/lib%.a: lib
	cd $* && $(zcc) -c $*.c
	ar crs lib/lib$*.a $*/$*.o

lib/lib%.so: lib
	cd $* && $(zcc) -fPIC -c $*.c
	$(zcc) -shared -o lib/lib$*.so $*/$*.o

# .a/.so - static/dynamic linking
$(bin): lib/libsqlite3.a
	$(env) cargo build --target $(target)
