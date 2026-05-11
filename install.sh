#!/usr/bin/env bash

[[ -z "$SUDO_USER" ]] && {
	echo "Must be run via sudo, not as root directly... unless 👀"
	exit 1
}

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

GROOB_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || {
	echo "Failed to resolve dir"
	exit 1
}

EXPECTED_DIR=$USER_HOME/.local/share/groobarchy

if [[ "$GROOB_DIR" != "$EXPECTED_DIR" ]]; then
	echo "Moving repo to $EXPECTED_DIR..."
	mkdir -p "$(dirname "$EXPECTED_DIR")"
	mv "$GROOB_DIR" "$EXPECTED_DIR" || {
		echo "Failed to move $GROOB_DIR -> $EXPECTED_DIR"
		exit 1
	}
	exec "$EXPECTED_DIR/install.sh" "$@"
fi

export GROOB_DIR
export PATH=$GROOB_DIR/bin:$PATH

source "$GROOB_DIR/install/core.sh" || {
	echo "Failed to source core.sh"
	exit 1
}

source "$GROOB_DIR/install/detect.sh" || {
	die "Failed to source detect.sh"
}

PROFILE=${PROFILE:-$(detect_platform)}
GPU=${GPU:-$(detect_gpu)}
export PROFILE GPU

mkdir -p "$USER_HOME/.config/groobarchy"
echo "export PROFILE=$PROFILE" >"$USER_HOME/.config/groobarchy/env"
echo "export GPU=$GPU" >>"$USER_HOME/.config/groobarchy/env"

LOG_FILE=$GROOB_DIR/logs/install.log
mkdir -p "$GROOB_DIR/logs"

# sudo keepalive
sudo -v
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &
KEEPALIVE_PID=$!
trap 'kill "$KEEPALIVE_PID" 2>/dev/null' EXIT

exec > >(tee -a "$LOG_FILE") 2>&1

ensure_git() {
	print_msg "Checking if this is a git repo..."
	groob_repo="https://github.com/Grang404/groobarchy.git"
	[[ -d "$GROOB_DIR/.git" ]] && return
	print_warning "No git repository detected"
	command -v git &>/dev/null || die "git is required"
	local tmp
	tmp="$(mktemp -d)"
	git clone "$groob_repo" "$tmp" || {
		rm -rf "$tmp"
		die "Failed to clone $groob_repo into $tmp. Removing $tmp."
	}
	mv "$tmp/.git" "$GROOB_DIR/.git"
	rm -rf "$tmp"
	git -C "$GROOB_DIR" checkout .
	print_success "Repo initialised"
}

install_cli() {
	print_msg "Installing CLI..."
	local bin_dir=$USER_HOME/.local/bin
	mkdir -p "$bin_dir"

	for script in "$GROOB_DIR/bin/"*; do
		[[ -f "$script" ]] || continue
		ln -sfn "$script" "$bin_dir/$(basename "$script")" || { print_warning "failed to link $(basename "$script")"; continue; }
		print_msg "Linked $(basename "$script")"
	done

	export PATH="$bin_dir:$PATH"
	[[ "$PATH" == *"$bin_dir"* ]] || print_warning "$bin_dir not in PATH"
	print_success "CLI installed"
}

source "$GROOB_DIR/install/banner.sh"

main() {
	show_banner
	sleep 2
	ensure_git
	install_cli

	print_msg "Detected: $PROFILE / $GPU"
	print_msg "Running install scripts..."

	shopt -s nullglob
	scripts=("$GROOB_DIR"/install/[0-9]*)
	[[ ${#scripts[@]} -eq 0 ]] && die "No install scripts found!"

	ran=0
	for script in "${scripts[@]}"; do
		[[ -f "$script" ]] || continue
		name="$(basename "$script")"

		if [[ "$name" == *"power"* && "$PROFILE" != "laptop" ]]; then
			print_msg "Skipping $name (desktop)"
			continue
		fi

		print_msg "Running $name..."
		bash "$script" || die "$name failed"
		print_success "$name done"
		((ran++))
	done

	[[ $ran -eq 0 ]] && die "Install failed: no scripts were executed (none executable?)"

	shopt -u nullglob

	print_success "Install complete"
	print_warning "Reboot recommended"
}

main
