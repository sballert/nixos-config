function s7_git_config() {
    git config user.email "sballert@silversurfer7.de"
    git config user.name "sballert"
    git config commit.gpgsign "false"
}

function pass_find_tag() {
    pass grep -q ${1} | sed -r '/^\s*$/d' | sed 's/.$//'
}
