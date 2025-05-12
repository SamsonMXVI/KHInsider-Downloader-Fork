# Makefile for cross-compiling Go project

# List of platforms (GOOS/GOARCH)
PLATFORMS = \
	darwin/amd64 \
	darwin/arm64 \
	linux/amd64 \
	linux/arm64 \
	windows/amd64 \
	windows/arm64

# Output directory
OUTDIR = build

# Binary name (change this if your main file is not in main.go)
BINARY = app

# Default target: build all
.PHONY: all build clean
build:
ifndef GOOS
	@echo "Building for all platforms..."
	@for platform in $(PLATFORMS); do \
		GOOS=$${platform%/*} GOARCH=$${platform#*/} \
		$(MAKE) _build_single; \
	done
else
	@echo "Building for GOOS=$(GOOS), GOARCH=$(GOARCH)..."
	$(MAKE) _build_single
endif

# Internal: build single target
.PHONY: _build_single
_build_single:
	@mkdir -p $(OUTDIR)
	@ext=$$( [ "$$GOOS" = "windows" ] && echo ".exe" || echo "" ); \
	output="$(OUTDIR)/$(BINARY)-$$GOOS-$$GOARCH$$ext"; \
	echo "→ Output: $$output"; \
	GOOS=$$GOOS GOARCH=$$GOARCH CGO_ENABLED=0 go build -o $$output .

# Clean build output
clean:
	rm -rf $(OUTDIR)
