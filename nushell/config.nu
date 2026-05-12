$env.EDITOR = "hx"
$env.VISUAL = "hx"
$env.PATH = ($env.PATH | append ($env.HOME | path join ".cargo/bin"))

$env.config = {
    show_banner: false
    edit_mode: vi
    history: {
        max_size: 10000
        sync_on_enter: true
        file_format: "plaintext"
    }
}

# source AFTER config is set
source "~/.cargo/env.nu"
source ~/.cache/.zoxide.nu
source ~/.cache/starship/init.nu
source ~/.cache/atuin/init.nu

if "ZELLIJ" not-in ($env | columns) {
    if (which zellij | is-not-empty) {
        zellij
    }
}
