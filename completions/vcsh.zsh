#compdef vcsh

function __vcsh_repositories () {
	local -a repos
	repos=( ${(f)"$(_call_program repositories vcsh list)"} )
	_describe -t repositories 'repository' repos
}

function __vcsh_not_implemented_yet () {
	_message "Subcommand completion '${1#*-}': not implemented yet"
}

function _vcsh-clone () {
	__vcsh_not_implemented_yet "$0" #TODO
}

function _vcsh-delete () {
	(( CURRENT == 2 )) && __vcsh_repositories
}

function _vcsh-enter () {
	(( CURRENT == 2 )) && __vcsh_repositories
}

function _vcsh-foreach () {
	_dispatch vcsh-foreach git
}

function _vcsh-help () {
	_nothing
}

function _vcsh-init () {
	_nothing
}

function _vcsh-list () {
	_nothing
}

function _vcsh-list-tracked () {
	(( CURRENT == 2 )) && __vcsh_repositories
}

function _vcsh-list-untracked () {
	_nothing
}

function _vcsh-pull () {
	_nothing
}

function _vcsh-push () {
	_nothing
}

function _vcsh-rename () {
	case $CURRENT in
		2) __vcsh_repositories ;;
		3) _message "new repository name" ;;
		*) _nothing ;;
	esac
}

function _vcsh-run () {
	(( CURRENT == 2 )) && __vcsh_repositories
	(( CURRENT == 3 )) && _command_names -e
	if (( CURRENT >= 4 )); then
		# see _precommand in zsh
		words=( "${(@)words[3,-1]}" )
		(( CURRENT -= 2 ))
		_normal
	fi
}

function _vcsh-status () {
	(( CURRENT == 2 )) && __vcsh_repositories
}

function _vcsh-upgrade () {
	(( CURRENT == 2 )) && __vcsh_repositories
}

function _vcsh-version () {
	_nothing
}

function _vcsh-which () {
	_files
}

function _vcsh-write-gitignore () {
	(( CURRENT == 2 )) && __vcsh_repositories
}

function _vcsh () {
	local curcontext="${curcontext}" ret=1
	local state vcshcommand
	local -a args subcommands

	local VCSH_REPO_D
	: ${VCSH_REPO_D:="${XDG_CONFIG_HOME:-"$HOME/.config"}/vcsh/repo.d"}

	subcommands=(
		"clone:clone an existing repository"
		"commit:commit in all repositories"
		"delete:delete an existing repository"
		"enter:enter repository; spawn new <\$SHELL>"
		"foreach:execute for all repos"
		"help:display help"
		"init:initialize an empty repository"
		"list:list all local vcsh repositories"
		"list-tracked:list all files tracked by vcsh"
		"list-untracked:list all files not tracked by vcsh"
		"pull:pull from all vcsh remotes"
		"push:push to vcsh remotes"
		"rename:rename a repository"
		"run:run command with <\$GIT_DIR> and <\$GIT_WORK_TREE> set"
		"status:show statuses of all/one vcsh repositories"
		"upgrade:upgrade repository to currently recommended settings"
		"version:print version information"
		"which:find <substring> in name of any tracked file"
		"write-gitignore:write .gitignore.d/<repo> via git ls-files"
	)

	args=(
		'-c[source <file> prior to other configuration files]:config files:_path_files'
		'-d[enable debug mode]'
		'-v[enable verbose mode]'
		'*:: :->subcommand_or_options_or_repo'
	)

	_arguments -C ${args} && ret=0

	if [[ ${state} == "subcommand_or_options_or_repo" ]]; then
		if (( CURRENT == 1 )); then
			_describe -t subcommands 'vcsh sub-commands' subcommands && ret=0
			__vcsh_repositories && ret=0
		else
			vcshcommand="${words[1]}"
			if ! (( ${+functions[_vcsh-$vcshcommand]} )); then
				# There is no handler function, so this is probably the name
				# of a repository. Act accordingly.
				# FIXME: this may want to use '_dispatch vcsh git'
				GIT_DIR=$VCSH_REPO_D/$words[1].git _dispatch git git && ret=0
			else
				curcontext="${curcontext%:*:*}:vcsh-${vcshcommand}:"
				_call_function ret _vcsh-${vcshcommand} && (( ret ))
			fi
		fi
	fi
	return ret
}

_vcsh "$@"
