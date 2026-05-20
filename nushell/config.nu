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

alias za = zoxide add .

# source AFTER config is set
# source "~/.cargo/env.nu"
source ~/dotfiles/zoxide/init.nu
source ~/dotfiles/starship/init.nu
source ~/dotfiles/atuin/init.nu

if "ZELLIJ" not-in ($env | columns) {
    if (which zellij | is-not-empty) {
        zellij
    }
}
