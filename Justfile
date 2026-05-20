import "justfiles/symlinks.just"
import "justfiles/system.just"
import "justfiles/rust.just"
import "justfiles/engineering.just"
import "justfiles/ide.just"

# Run complete system bootstrap
setup-all: link-dots setup-repos install-core install-browser install-rust install-cargo set-defaults check-repos install-apps install-uv setup-workspace
    @echo "============================================="
    @echo " System fully configured."
    @echo "============================================="
