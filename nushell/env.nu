# Nushell Environment Config File
# version = "0.99.1"


def create_left_prompt [] { 
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~' 
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold }) 
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold }) 
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    let time_segment = ([ 
        (ansi reset) 
        (ansi magenta) 
        (date now | format date '%x %X') 
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" | str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {
        ([ (ansi rb) ($env.LAST_EXIT_CODE) ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

$env.PROMPT_INDICATOR = {|| "> " } 
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " } 
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " } 
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

$env.ENV_CONVERSIONS = { 
    "PATH": { 
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink } 
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": { 
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink } 
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

$env.NU_LIB_DIRS = [ 
    ($nu.default-config-dir | path join 'scripts')
    ($nu.data-dir | path join 'completions')
]

$env.NU_PLUGIN_DIRS = [ 
    ($nu.default-config-dir | path join 'plugins') 
]

# Set default CARGO_HOME if not already set
# Safely set CARGO_HOME if not already defined
$env.CARGO_HOME = ($env.CARGO_HOME? | default ($nu.home-path | path join ".cargo"))

# Add $CARGO_HOME/bin to PATH
$env.PATH ++= [($env.CARGO_HOME | path join "bin")]   

# Auto-start Zellij
if not ("ZELLIJ" in ($env | columns)) {
    if ("ZELLIJ_AUTO_ATTACH" in ($env | columns) and $env.ZELLIJ_AUTO_ATTACH == "true") {
        zellij attach -c
    } else {
        zellij
    }
}

$env.EDITOR = "hx"
$env.VISUAL = "hx"

# Zoxide initialization
zoxide init nushell | save -f ~/dotfiles/zoxide/init.nu 
starship init nu | save -f ~/dotfiles/starship/init.nu 
atuin init nu | save -f ~/dotfiles/atuin/init.nu 

source ~/dotfiles/zoxide/init.nu
source ~/dotfiles/starship/init.nu
source ~/dotfiles/atuin/init.nu

# pnpm
$env.PNPM_HOME = "/home/dherrera/.local/share/pnpm/bin"
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.PNPM_HOME | path join "bin") )
# pnpm end

# local bin
$env.LOCAL_BIN = "/home/dherrera/.local/bin"
$env.PATH = ($env.PATH | split row (char esep) | prepend $env.PNPM_HOME )
# end local bin
