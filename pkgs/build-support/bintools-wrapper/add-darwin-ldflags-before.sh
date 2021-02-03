# Unconditionally adding in platform version flags will result in warnings that
# will be treated as errors by some packages. Add any missing flags here.

# There are two things to be configured: the "platform version" (oldest
# supported version of macos, ios, etc), and the "sdk version".
#
# The modern way of configuring these is to use:
#    -platform_version $platform $platform_version $sdk_version"
#
# The old way is still supported, and uses flags like:
#    -${platform}_version_min $platform_version
#    -sdk_version $sdk_version
#
# If both styles are specified ld will combine them. If multiple versions are
# specified for the same platform, ld will emit an error.
#
# The following adds flags for whichever properties have not already been
# provided.

havePlatformVersionFlag=
haveDarwinSDKVersion=
haveDarwinPlatformVersion=

n=0
nParams=${#params[@]}
while (( n < nParams )); do
    p=${params[n]}
    case "$p" in
        -macos_version_min|-ios_version_min)
            haveDarwinPlatformVersion=1
            ;;

        -sdk_version)
            haveDarwinSDKVersion=1
            ;;

        -platform_version)
            havePlatformVersionFlag=1
            if [ "${params[n+3]-}" = 0.0.0 ]; then
                params[n+3]=@darwinSdkVersion@
            fi
            ;;
    esac
    n=$((n + 1))
done

# If the caller has set -platform_version, trust they're doing the right thing.
# This will be the typical case for clang in nixpkgs.
if [ ! "$havePlatformVersionFlag" ]; then
    if [ ! "$haveDarwinSDKVersion" ] && [ ! "$haveDarwinPlatformVersion" ]; then
        # Nothing provided. Use the modern "-platform_version" to set both.
        extraBefore+=(-platform_version @darwinPlatform@ @darwinMinVersion@ @darwinSdkVersion@)
    elif [ ! "$haveDarwinSDKVersion" ]; then
        # Add missing sdk version
        extraBefore+=(-sdk_version @darwinSdkVersion@)
    elif [ ! "$haveDarwinPlatformVersion" ]; then
        # Add missing platform version
        extraBefore+=(-@darwinPlatform@_version_min @darwinSdkVersion@)
    fi
fi
