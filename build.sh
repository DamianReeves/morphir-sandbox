#!/bin/bash
# ARG_OPTIONAL_BOOLEAN([offline],[o],[Offline mode],[off])
# ARG_VERBOSE([v])
# ARG_HELP([The general script's help msg])
# ARG_POSITIONAL_SINGLE([command],[],[])
# ARG_LEFTOVERS([])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.dev for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='ovh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_leftovers=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_offline="off"
_arg_verbose=0


print_help()
{
	printf '%s\n' "The general script's help msg"
	printf 'Usage: %s [-o|--(no-)offline] [-v|--verbose] [-h|--help] <command> ... \n' "$0"
	printf '\t%s\n' "-o, --offline, --no-offline: Offline mode (off by default)"
	printf '\t%s\n' "-v, --verbose: Set verbose output (can be specified multiple times to increase the effect)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-o|--no-offline|--offline)
				_arg_offline="on"
				test "${1:0:5}" = "--no-" && _arg_offline="off"
				;;
			-o*)
				_arg_offline="on"
				_next="${_key##-o}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-o" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-v|--verbose)
				_arg_verbose=$((_arg_verbose + 1))
				;;
			-v*)
				_arg_verbose=$((_arg_verbose + 1))
				_next="${_key##-v}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-v" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	local _required_args_string="'command'"
	test "${_positionals_count}" -ge 1 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require at least 1 (namely: $_required_args_string), but got only ${_positionals_count}." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_command "
	_our_args=$((${#_positionals[@]} - 1))
	for ((ii = 0; ii < _our_args; ii++))
	do
		_positional_names="$_positional_names _arg_leftovers[$((ii + 0))]"
	done

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

# Initialize variables
offline=$_arg_offline
verbose=$_arg_verbose
proto_bin_provided=0
subcommand=$_arg_command
leftovers=$_arg_leftovers

# Helper Functions

is_macos() {
	[[ "$OSTYPE" == "darwin"* ]]
}

check_cmd() {
	command -v "$1" > /dev/null 2>&1
	return $?
}

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

function log_err() {
     printf "[ERROR]: %s\n" "$*" >&2;
}

function log_warn() {
    printf "[WARN]: %s\n" "$*" >&2;
}

function log_info() {
    if [ "$verbose" -gt 0 ]; then
        echo "[INFO]: $1"
    fi
}


require_bun() {
	if ! check_cmd moon; then
		if [ "$offline" = "on" ]; then
			log_err "Error: bun is not installed and offline mode is enabled, you will need to install bun manually"
			exit 1
		else
			log_info "bun is not installed, attempting to install it..."
			proto install bun
		fi
		exit 1
	fi
}

require_moon() {
	if ! check_cmd moon; then
		if [ "$offline" = "on" ]; then
			log_err "Error: moon is not installed and offline mode is enabled, you will need to install moon manually"
			exit 1
		else
			log_info "moon is not installed, attempting to install it..."
			proto install moon
			#curl -fsSL https://moonrepo.dev/install/moon.sh | bash
		fi
		exit 1
	fi
}

ensure_scalaVersions() {
	if [ ${#scalaVersions[@]} -eq 0 ]; then
		log_info "Assigning default Scala version"
		scalaVersions=($default_scala_version)
		scalaVersion=$default_scala_version
	else
		echo "Scala versions is not empty: ${scalaVersions[@]}"
	fi
}


# Rest of script

# Check if PROTO_BIN_PATH is already set
if [ -z "$PROTO_BIN_PATH" ]; then
    log_info "PROTO_BIN_PATH is not set, attempting to derive it..."
    if command -v proto > /dev/null; then
        PROTO_BIN_PATH=$(command -v proto)
        log_info "PROTO_BIN_PATH set to: $PROTO_BIN_PATH"
    fi
else
    log_info "PROTO_BIN_PATH is already set to: $PROTO_BIN_PATH"
fi

# Check if PROTO_BIN_PATH is already set and exists
if [ -n "$PROTO_BIN_PATH" ] && [ -e "$PROTO_BIN_PATH" ]; then
    if [ -x "$PROTO_BIN_PATH" ]; then
        log_info "proto is provided by PROTO_BIN_PATH which is set to: $PROTO_BIN_PATH"
        proto_bin_provided=1
    else
        log_err "$PROTO_BIN_PATH is not executable"
        exit 1
    fi
else
    log_info "PROTO_BIN_PATH is not set, falling back to using PROTO_HOME"
fi

# If PROTO is not provided attempt to download and install it
if [ "$proto_bin_provided" -eq 0 ]; then
    log_info "PROTO_BIN_PATH is not provided, attempting to download and install PROTO..."
    if [ "$offline" = "on" ]; then
        log_err "Error: PROTO_BIN_PATH is not provided and offline mode is enabled"
        exit 1
    fi
    # Download and install PROTO
    log_info "Downloading and installing PROTO..."
    curl -fsSL https://moonrepo.dev/install/proto.sh | bash
fi


# Setup before running commands


case "$subcommand" in
	"build")
		moon run :build
		;;
	"clean")
		moon run :clean
		;;
	"fmt")
		moon run :fmt
		;;
	"install")
		require_bun
		require_moon
		bun install
		;;
	"lint")
		moon run :lint
		;;
	"purge")
		moon run :clean && moon clean
		;;
	"rebuild")
		moon run ":rebuild"
		;;
	"run")
		moon run "${leftovers[@]}"
		;;
	"setup")
		echo "TODO: Implement setup command"
		;;
	"test")
		moon run :test
		;;
	"about")
		echo "TODO: Implement about command"
		;;
	*)
		log_err "Error: Unknown command: $subcommand"
		exit 1
		;;
esac

# ] <-- needed because of Argbash
