#: shell-fragment : bash shell fragment, not a script


# Print an ansi escape sequence if attached to a terminal
function ansi_color () {
  local outfd=1
  if [ "${1}" = "--stderr" ]; then outfd=2; shift; fi

  local color=$1 ; shift

  if [ -t ${outfd} ]; then
    echo -e >&${outfd} "\x1b[${color}m${*}\x1b[0m"
  else
    echo ${*}
  fi
}

# Helper: Report an error and exit non-zero
function die () {
  ansi_color --stderr 91 "ERROR: ${*}"
  exit 1
}

# Helper: Report a warning
function warn () {
  ansi_color --stderr 31 "WARNING: $*"
}

# Note: Report a sub-nominal, non-warning condition
function note () {
  ansi_color 93 "Note: $*"
}

# Nominal status
function info () {
  echo "-- $*"
}

# Debug message
function debug () {
  if [ -n "${DEBUG}" ]; then ansi_color 90 "# $*"; fi
}

# Report a successful event
function success () {
  ansi_color 92 "++ $@"
}

# Add one or more paths to the PATH variable and export the result,
# unless '-x' is specified.
#
function add_paths () {
  local added=0
  local do_export=1

  while [ -n "${1}" ]; do
    local path="${1}"; shift
    if [ "${path}" = "-x" ]; then
      do_export=0
    elif [[ ! "${PATH}" =~ "(^|:)${path}(:|\$)" ]]; then
      if [ -n "${PATH}" ]; then PATH+=":"; fi
      PATH+="${path}"
      added=$((added + 1))
      debug "Added ${path} to PATH"
    fi
  done

  # My reason for doing this is lost in the annals of time,
  # but avoid exporting the path when it hasn't changed.
  if [ ${do_export} -a ${added} ]; then export PATH; fi
}

# Create a directory with a given permissions mode,
# but only if it does not exist.
function ensure_folder () {
	local permissions="$1"; shift
	local folder="$1"; shift

	if [ ! -d "${folder}" ]; then
		info "Creating ${folder}"
		mkdir -p -m "${permissions}" "${folder}" || die "Creating ${folder} failed: $?"
	else
		chmod "${permissions}" "${folder}" || die "Could not set ${folder} permissions ${permissions}."
	fi
}

