#!/bin/bash -e

source /build_environment.sh

# Grab the last segment from the package name
name=${pkgName##*/}

#
# Optional OUTPUT env var to use the "-o" go build switch
# forces build to write the resulting executable or object
# to the named output file
#
output=""
if [[ ! -z "${OUTPUT}" ]];
then
  output="-o ${OUTPUT}"
fi

# Compile statically linked version of package
echo "Building $pkgName"
(
  CGO_ENABLED=${CGO_ENABLED:-0} \
  go build \
  -a \
  ${output} \
  --installsuffix cgo \
  --ldflags="${LDFLAGS:--s}" \
  $pkgName
)

if [[ "$COMPRESS_BINARY" == "true" ]];
then
  if [[ ! -z "${OUTPUT}" ]];
  then
    goupx ${OUTPUT}
  else
    goupx $name
  fi
fi
