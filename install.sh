#!/usr/bin/env bash

GROOB_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || {
	echo "failed to resolve dir"
	exit 1
}

EXPECTED_DIR=$HOME/.local/share/groob

if [[ "$GROOB_DIR" != "$EXPECTED_DIR" ]]; then
	echo "Moving repo to $EXPECTED_DIR..."
	mkdir -p "$(dirname "$EXPECTED_DIR")"
	mv "$GROOB_DIR" "$EXPECTED_DIR" || {
		echo "mv failed"
		exit 1
	}
	exec "$EXPECTED_DIR/install.sh" "$@"
fi

export GROOB_DIR
export PATH=$GROOB_DIR/bin:$PATH

source "$GROOB_DIR/install/core.sh" || {
	echo "failed to source core.sh"
	exit 1
}

source "$GROOB_DIR/install/detect.sh" || {
	die "failed to source detect.sh"
}

PROFILE="${PROFILE:-$(detect_platform)}"
GPU="${GPU:-$(detect_gpu)}"
export PROFILE GPU

mkdir -p "$HOME/.config/groob"
echo "export PROFILE=$PROFILE" >"$HOME/.config/groob/env"
echo "export GPU=$GPU" >>"$HOME/.config/groob/env"

LOG_FILE="$GROOB_DIR/logs/install.log"
mkdir -p "$GROOB_DIR/logs"
exec > >(tee -a "$LOG_FILE") 2>&1

# sudo keepalive
sudo -v
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &
KEEPALIVE_PID=$!
trap 'kill "$KEEPALIVE_PID" 2>/dev/null' EXIT

ensure_git() {
	groob_repo="https://github.com/Grang404/groobarchy.git"
	[[ -d "$GROOB_DIR/.git" ]] && return
	print_warning "No git repository detected"
	command -v git &>/dev/null || die "git is required"
	local tmp
	tmp="$(mktemp -d)"
	git clone "$groob_repo" "$tmp"
	mv "$tmp/.git" "$GROOB_DIR/.git"
	rm -rf "$tmp"
	git -C "$GROOB_DIR" checkout .
	print_success "Repo initialised"
}

install_cli() {
	local bin_dir=$HOME/.local/bin
	mkdir -p "$bin_dir"

	for script in "$GROOB_DIR/bin/"*; do
		[[ -f "$script" ]] || continue
		ln -sfn "$script" "$bin_dir/$(basename "$script")"
		print_msg "Linked $(basename "$script")"
	done

	[[ "$PATH" == *"$bin_dir"* ]] || print_warning "$bin_dir not in PATH"
	print_success "CLI installed"
}

source "$GROOB_DIR/install/banner.sh"

main() {
	show_banner
	ensure_git
	install_cli

	print_msg "Detected: $PROFILE / $GPU"
	print_msg "Running install scripts..."

	for script in "$GROOB_DIR"/install/[0-9]*; do
		[[ -x "$script" ]] || continue
		name="$(basename "$script")"

		if [[ "$name" == *"power"* && "$PROFILE" != "laptop" ]]; then
			print_msg "Skipping $name (desktop)"
			continue
		fi

		print_msg "Running $name..."
		bash "$script" || {
			die "$name failed"
		}
		print_success "$name done"
	done

	print_success "Install complete"
	print_warning "Reboot recommended"
}

main
