# VERSION contains the project verison e.g. 0.1.0-alpha.1
VERSION := $(shell grep -E -o "[0-9]+\.[0-9]+\.[0-9]+[^\"]*" pkg/version/version.go)
# VERSION_MINOR contains the project version up to the minor value e.g. v0.1
VERSION_MINOR := $(shell echo ${VERSION} | grep -E -o "[0-9]+\.[0-9]+")
# VERSION_STAGE contains the project version stage e.g. alpha
VERSION_STAGE := $(shell echo ${VERSION} | grep -E -o "(pre-alpha|alpha|beta|rc)")

# Extract git Information of current commit.
GIT_SHA := $(shell ${GIT} rev-parse HEAD)
GIT_SHA_SHORT := $(shell ${GIT} rev-parse --short HEAD)
GIT_SHA_MASTER := $(shell ${GIT} rev-parse ${MASTER_BRANCH})
GIT_TAG := $(shell ${GIT} tag -l --contains HEAD | head -n1)
GIT_BRANCH := $(shell ${GIT} branch | grep -E '^* ' | cut -c3- )
IS_DIRTY := $(shell ${GIT} status --porcelain)

ifndef IS_DIRTY
  ifeq (${GIT_SHA},${GIT_SHA_MASTER})
    IS_CANARY       := true
    ifeq (${GIT_TAG},${VERSION})
      IS_RELEASE      := true
      ifeq (${LATEST},${VERSION_MINOR})
        IS_LATEST := true
      endif
    endif
  endif
endif

# Set build reference.
ifdef IS_DIRTY
  BUILD_REF      := ${GIT_SHA_SHORT}-dev
else
  BUILD_REF      := $(GIT_SHA_SHORT)
endif

# BUILD_VERSION will be compiled into the projects binaries.
ifdef IS_RELEASE
  BUILD_VERSION    ?= ${VERSION}
else
  BUILD_VERSION    ?= ${VERSION}+${BUILD_REF}
endif

# Set image tags.
TAGS :=
ifeq (${IS_CANARY},true)
  TAGS := canary ${TAGS}
endif
ifdef IS_RELEASE
  TAGS := ${VERSION} ${TAGS}
  ifdef VERSION_STAGE
    TAGS := ${VERSION_MINOR}-${VERSION_STAGE} ${TAGS}
  else
    TAGS := ${VERSION_MINOR} ${TAGS}
  endif
  ifeq (${IS_LATEST},true)
    TAGS := latest ${TAGS}
  endif
endif
