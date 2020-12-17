#!/usr/bin/env bash

# xcframework.sh
# Usage example: ./xcframework.sh -output <some_path>/ProtocolProxy.xcframework

# Parse Arguments

while [[ $# -gt 0 ]]; do
    case "$1" in
        -output)
        OUTPUT_DIR="$2"
        shift # -output
        shift # <output_dir>
        ;;

        *)
        echo "Unknown argument: $1"
        echo "./xcframework.sh [-output <output_xcframework>]"]
        exit 1
    esac
done

if [ -z ${OUTPUT_DIR+x} ]; then
    OUTPUT_DIR="$(dirname $(realpath $0))/build/ProtocolProxy.xcframework"
fi

# Create Temporary Directory

TMPDIR=`mktemp -d /tmp/.protocolproxy.xcframework.build.XXXXXX`
cd "$(dirname $(dirname $(realpath $0)))"

check_result() {
    if [ $1 -ne 0 ]; then
        rm -rf "${TMPDIR}"
        exit $1
    fi
}

# Build iOS
xcodebuild -project "ProtocolProxy.xcodeproj" -scheme "ProtocolProxy" -destination "generic/platform=iOS" -archivePath "${TMPDIR}/iphoneos.xcarchive" -configuration Release SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="armv7 armv7s arm64 arm64e" archive
check_result $?

# Build iOS Simulator
xcodebuild -project "ProtocolProxy.xcodeproj" -scheme "ProtocolProxy" -destination "generic/platform=iOS Simulator" -archivePath "${TMPDIR}/iphonesimulator.xcarchive" -configuration Release SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="i386 x86_64 arm64" archive
check_result $?

# Build Mac Catalyst
xcodebuild -project "ProtocolProxy.xcodeproj" -scheme "ProtocolProxy" -destination "generic/platform=macOS,variant=Mac Catalyst" -archivePath "${TMPDIR}/maccatalyst.xcarchive" -configuration Release SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="x86_64 arm64 arm64e" archive
check_result $?

# Build Mac
xcodebuild -project "ProtocolProxy.xcodeproj" -scheme "ProtocolProxy macOS" -destination "generic/platform=macOS" -archivePath "${TMPDIR}/macos.xcarchive" -configuration Release SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="x86_64 arm64 arm64e" archive
check_result $?

# Build tvOS
xcodebuild -project "ProtocolProxy.xcodeproj" -scheme "ProtocolProxy tvOS" -destination "generic/platform=tvOS" -archivePath "${TMPDIR}/appletvos.xcarchive" -configuration Release SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="arm64 arm64e" archive
check_result $?

# Build tvOS Simulator
xcodebuild -project "ProtocolProxy.xcodeproj" -scheme "ProtocolProxy tvOS" -destination "generic/platform=tvOS Simulator" -archivePath "${TMPDIR}/appletvsimulator.xcarchive" -configuration Release SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="x86_64 arm64" archive
check_result $?

# Build watchOS
xcodebuild -project "ProtocolProxy.xcodeproj" -scheme "ProtocolProxy watchOS" -destination "generic/platform=watchOS" -archivePath "${TMPDIR}/watchos.xcarchive" -configuration Release SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="arm64_32 armv7k" archive
check_result $?

# Build watchOS Simulator
xcodebuild -project "ProtocolProxy.xcodeproj" -scheme "ProtocolProxy watchOS" -destination "generic/platform=watchOS Simulator" -archivePath "${TMPDIR}/watchsimulator.xcarchive" -configuration Release SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES ONLY_ACTIVE_ARCH=NO ARCHS="i386 x86_64 arm64" archive
check_result $?

# Make XCFramework

if [[ -d "${OUTPUT_DIR}" ]]; then
    rm -rf "${OUTPUT_DIR}"
fi

xcodebuild -create-xcframework                                                                            \
    -framework "${TMPDIR}/iphoneos.xcarchive/Products/Library/Frameworks/ProtocolProxy.framework"         \
    -framework "${TMPDIR}/iphonesimulator.xcarchive/Products/Library/Frameworks/ProtocolProxy.framework"  \
    -framework "${TMPDIR}/maccatalyst.xcarchive/Products/Library/Frameworks/ProtocolProxy.framework"      \
    -framework "${TMPDIR}/macos.xcarchive/Products/Library/Frameworks/ProtocolProxy.framework"            \
    -framework "${TMPDIR}/appletvos.xcarchive/Products/Library/Frameworks/ProtocolProxy.framework"        \
    -framework "${TMPDIR}/appletvsimulator.xcarchive/Products/Library/Frameworks/ProtocolProxy.framework" \
    -framework "${TMPDIR}/watchos.xcarchive/Products/Library/Frameworks/ProtocolProxy.framework"          \
    -framework "${TMPDIR}/watchsimulator.xcarchive/Products/Library/Frameworks/ProtocolProxy.framework"   \
    -output "${OUTPUT_DIR}"
check_result $?

# Cleanup

rm -rf "${TMPDIR}"
exit 0
