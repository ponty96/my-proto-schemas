#!/bin/bash -ex

BUILD_DIR="${BUILD_DIR:-/build}"
OUTPUT_DIR="${OUTPUT_DIR:-/output}"

# Patch a go package into all schema files. Required to make sure output
# files have the right package name for their path.
function prepare-build {
    echo "Preparing build"
    # Add go_package option to all proto files
	for file in `find schemas -name "*.proto" | grep -v google`; do
 		folder=$(dirname $file)
		# Now support multi level package structure
		pkg=${folder#"schemas/"}

		# NOTE! Purposely indented this way, don't change
		sed -i.bak "2i\\
option go_package = \"github.com/ponty96/my-proto-schemas/${pkg}\";" $file
	done

	# Clean up
	find schemas -name "*.bak" | xargs rm
}

# Compile all the protobuf for all the schema types
function build {
	for entry in `find schemas -type d -maxdepth 1 | grep -v "\/\." | xargs echo`; do
		INCLUDES="${INCLUDES} -I ${entry}"
	done

	mkdir -p proto_out

	for file in `find . -name "*.proto"`; do
	    echo "Compiling $file"
		protoc --go_out="./proto_out" $INCLUDES $file
	done

	cd "${OUTPUT_DIR}"
	cd -
	cp -r ./proto_out/github.com/ponty96/my-proto-schemas/* "${OUTPUT_DIR}"
}

# go install

cd $BUILD_DIR
prepare-build
build
