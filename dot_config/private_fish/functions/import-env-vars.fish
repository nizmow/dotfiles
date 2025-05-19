function import-env-vars
    eval ( $argv | sed -E "s/^([^=]+)='([^']*)'\$/set -x \1 \"\2\"/" )
end
