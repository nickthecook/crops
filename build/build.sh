#!/bin/sh

export CRYSTAL_PATH="src:lib:$(crystal env CRYSTAL_PATH)"

platform=`uname -sm | tr A-Z a-z | tr ' ' _`
bindir="build/$platform"
mkdir -p "$bindir"

crystal -v
crystal build --release --static ops.cr -o "$bindir/ops"
