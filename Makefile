prefix ?= /usr/local
bindir = $(prefix)/bin
all:
	swiftc iconmake.swift -o iconmake
intel:
	swiftc iconmake.swift -target x86_64-apple-macos11 -o iconmake
arm:
	swiftc iconmake.swift -target arm64e-apple-macos11 -o iconmake
universal:
	swiftc iconmake.swift -target arm64e-apple-macos11 -o iconmakearm
	swiftc iconmake.swift -target x86_64-apple-macos11 -o iconmakeintel
	lipo -create iconmakeintel iconmakearm -output iconmake
	rm iconmakearm
	rm iconmakeintel
install:
	-mkdir "$(prefix)/bin"
	swiftc iconmake.swift -target arm64e-apple-macos11 -o iconmakearm
	swiftc iconmake.swift -target x86_64-apple-macos11 -o iconmakeintel
	lipo -create iconmakeintel iconmakearm -output "$(bindir)/iconmake"
	rm iconmakearm
	rm iconmakeintel
uninstall:
	rm "$(bindir)/iconmake"
