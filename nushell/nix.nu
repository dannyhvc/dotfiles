# --- NIX PACKAGE MANAGER SETUP ---
let nix_link = $"($env.HOME)/.nix-profile"

$env.NIX_PROFILES = $"/nix/var/nix/profiles/default ($nix_link)"

# populate .desktop files and bash completions
$env.XDG_DATA_DIRS = if ('XDG_DATA_DIRS' in $env) {
    $"($env.XDG_DATA_DIRS):($nix_link)/share:/nix/var/nix/profiles/default/share"
} else {
    $"/usr/local/share:/usr/share:($nix_link)/share:/nix/var/nix/profiles/default/share"
}

# ssl certificates so tools like curl work properly inside nixpkgs
# use the certs bundled directly in the nix default profile
$env.NIX_SSL_CERT_FILE = "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem"

# only use MANPATH if it is already set
if ('MANPATH' in $env) {
    $env.MANPATH = $"($nix_link)/share/man:($env.MANPATH)"
}

# prepend nix bin directory to path
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($nix_link)/bin")
# ---------------------------------
