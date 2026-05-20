default:
    @just --list ide

grammar-setup:
    hx -g fetch
    hx -g build
