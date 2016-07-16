# go build targets
#
BUILD_CMD = CGO_ENABLED=0 ${GO} build -ldflags "-X ${GO_PACKAGE}/pkg/version.Version=${BUILD_VERSION}" -o "$@" $(GO_PACKAGE)/cmd/$(basename $(notdir $@))

# arm
${BINARIES:%=bin/linux/arm/5/%}:
	GOOS=linux GOARCH=arm GOARM=5 ${BUILD_CMD}
${BINARIES:%=bin/linux/arm/7/%}:
	GOOS=linux GOARCH=arm GOARM=7 ${BUILD_CMD}

# 386
${BINARIES:%=bin/darwin/386/%}:
	GOOS=darwin GOARCH=386 ${BUILD_CMD}
${BINARIES:%=bin/linux/386/%}:
	GOOS=linux GOARCH=386 ${BUILD_CMD}
${BINARIES:%=bin/windows/386/%}:
	GOOS=windows GOARCH=386 ${BUILD_CMD}

# amd64
${BINARIES:%=bin/linux/amd64/%}:
	GOOS=linux GOARCH=amd64 ${BUILD_CMD}

${BINARIES:%=bin/freebsd/amd64/%}:
	GOOS=freebsd GOARCH=amd64 ${BUILD_CMD}
${BINARIES:%=bin/darwin/amd64/%}:
	GOOS=darwin GOARCH=amd64 ${BUILD_CMD}
${BINARIES:%=bin/windows/amd64/%.exe}:
	GOOS=windows GOARCH=amd64 ${BUILD_CMD}
