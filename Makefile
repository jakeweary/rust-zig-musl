target := aarch64-unknown-linux-musl
zcc := zig cc -target aarch64-linux-musl
env := RUSTFLAGS=-Clink-args=-Llibs

# .a/.so - static/dynamic linking
build: libs/libsqlite3.a
	$(env) cargo build --target $(target)

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
