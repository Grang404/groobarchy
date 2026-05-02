#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

print_msg() { echo -e "${BOLD}${BLUE}[*]${NC} $1"; }
print_success() { echo -e "${BOLD}${GREEN}[+]${NC} $1"; }
print_error() { echo -e "${BOLD}${RED}[!]${NC} $1"; }
print_warning() { echo -e "${BOLD}${YELLOW}[!]${NC} $1"; }

die() {
	print_error "$1"
	exit "${2:-1}"
}

require_sudo() {
	[[ "$EUID" -eq 0 ]] && return
	sudo -n true 2>/dev/null && return
	die "This module requires sudo. Run setup.sh first or run: sudo -v"
}
