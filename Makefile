target := x86_64-unknown-linux-musl
zcc := zig cc -target x86_64-linux-musl
bin := target/$(target)/debug/rust-zig-musl
env := RUSTFLAGS=-Clink-args=-Llibs

run: $(bin)
	@$(bin)

clean:
	rm -rf libs sqlite3/*.o
	cargo clean

libs:
	mkdir -p $@

libs/lib%.a: libs
	cd $* && $(zcc) -c *.c
	ar crs libs/lib$*.a $*/*.o

libs/lib%.so: libs
	cd $* && $(zcc) -fPIC -c *.c
	$(zcc) -shared -o libs/lib$*.so $*/*.o

# .a/.so - static/dynamic linking
$(bin): libs/libsqlite3.a
	$(env) cargo build --target $(target)
