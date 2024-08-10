.PHONY: help
GO_IMAGE_TAG=go_build
# Go
# --------------------

build-container:
	docker build \
		-t $(GO_IMAGE_TAG):latest \
		.

build: build-container
	cd ..
	# Local cleanup
	rm -rf build output
	mkdir -p build output
	cp -r schemas build/
	docker run --rm \
		-e LOCAL_BUILD=true \
		-v `pwd`/build/:/build \
		-v `pwd`/output:/output \
		$(GO_IMAGE_TAG)
