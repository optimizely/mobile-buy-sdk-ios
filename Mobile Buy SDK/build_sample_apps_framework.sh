sh build.sh

FRAMEWORK_NAME="Buy"
FRAMEWORK_NAME_FRAMEWORK="${FRAMEWORK_NAME}.framework"
UNIVERSAL_LIBRARY_DIR="${BUILD_DIR}/${FRAMEWORK_NAME}"
FRAMEWORK="${UNIVERSAL_LIBRARY_DIR}/${FRAMEWORK_NAME_FRAMEWORK}"
CONFIGURATION="Release"

rm -rf "${SRCROOT}/../Mobile Buy SDK Sample Apps/${FRAMEWORK_NAME_FRAMEWORK}"
cp -r "${FRAMEWORK}" "${SRCROOT}/../Mobile Buy SDK Sample Apps"