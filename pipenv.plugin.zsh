# Called by zsh when directory changes, append to chpwd_functions
chpwd_functions+=(chpwd_checkforpipenv)
function chpwd_checkforpipenv() {
    if [[ -a "${PWD}/Pipfile" ]]; then
        if [[ "${VIRTUAL_ENV}" != $(pipenv --venv) ]]; then
            echo -n "Pipfile exists. Do you want spawn a shell with the virtualenv? (y)"
            read answer
            if [[ "$answer" == "y" ]]; then
                cat Pipfile | grep python_version
                pipenv shell --fancy
            fi
        fi
    fi
}

_pipenv ()
{
    local -a _1st_arguments _dopts _dev _production
    local expl
    typeset -A opt_args

    _twothre=(
        '(--two)--two[Use Python 2 when creating virtualenv.]'
        '(--three)--three[Use Python 3 when creating virtualenv.]'
    )

    _shell=(
        '(--python)--python[Specify which version of Python virtualenv should use.]'
        '(--fancy)--fancy[Run in shell in fancy mode (for elegantly configured shells).]'
        '(--anyway)--anyway[Always spawn a subshell, even if one is already spawned.]'
        '(--help)--help[Show this message and exit.]'
    )

    _install=(
        '(--dev)--dev[Install package(s) in dev-packages.]'
        '(--python)--python[Specify which version of Python virtualenv should use.]'
        '(--system)--system[System pip management.]'
        '(--requirements)--requirements[Import a requirements.txt file.]'
        '(--code)--code[Import from codebase.]'
        '(--verbose)--verbose[Verbose mode.]'
        '(--ignore-pipfile)--ignore-pipfile[Ignore Pipfile when installing, using the Pipfile.lock.]'
        '(--sequential)--sequential[Install dependencies one-at-a-time, instead of concurrently.]'
        '(--skip-lock)--skip-lock[Ignore locking mechanisms when installing—use the Pipfile, instead.]'
        '(--deploy)--deploy[Abort if the Pipfile.lock is out–of–date, or Python version is wrong.]'
        '(--pre)--pre[Allow pre–releases.]'
        '(--keep-outdated)--keep-outdated[Keep out–dated dependencies from being updated in Pipfile.lock.]'
        '(--selective-upgrade)--selective-upgrade[Update specified packages.]'
        '(--help)--help[Show this message and exit.]'
    )

    _uninstall=(
        '(--python)--python[Specify which version of Python virtualenv should use.]'
        '(--system)--system[System pip management.]'
        '(--verbose)--verbose[Verbose mode.]'
        '(--lock)--lock[Lock afterwards.]'
        '(--all-dev)--all-dev[Un-install all package from dev-packages.]'
        '(--all)--all[Purge all package(s) from virtualenv. Does not edit Pipfile.]'
        '(--keep-outdated)--keep-outdated[Keep out–dated dependencies from being updated in Pipfile.lock.]'
        '(--help)--help[Show this message and exit.]'
    )

    _update=(
        '(--python)--python[Specify which version of Python virtualenv should use.]'
        '(--verbose)--verbose[Verbose mode.]'
        '(--dev)--dev[Install package(s) in dev-packages.]'
        '(--clear)--clear[Clear the dependency cache.]'
        '(--bare)--bare[Minimal output.]'
        '(--pre)--pre[Allow pre–releases.]'
        '(--keep-outdated)--keep-outdated[Keep out–dated dependencies from being updated in Pipfile.lock.]'
        '(--sequential)--sequential[Install dependencies one-at-a-time, instead of concurrently.]'
        '(--outdated)--outdated[List out–of–date dependencies.]'
        '(--dry-run)--dry-run[List out–of–date dependencies.]'
        '(--help)--help[Show this message and exit.]'
    )
    
    _1st_arguments=(
        '--where:Output project home information.' \
        '--venv:Output virtualenv information.' \
        '--py:Output Python interpreter information.' \
        '--envs:Output Environment Variable options.' \
        '--rm:Remove the virtualenv.' \
        '--bare:Minimal output.' \
        '--completion:Output completion (to be evald).' \
        '--man:Display manpage.' \
        '--python:Specify which version of Python virtualenv should use.' \
        '--site-packages:Enable site-packages for the virtualenv.' \
        '--version:Show the version and exit.' \
        '--help:Show this message and exit.' \

        'check:Checks for security vulnerabilities and against PEP 508 markers provided in Pipfile.' \
        'clean:Uninstalls all packages not specified in Pipfile.lock.' \
        'graph:Displays currently–installed dependency graph information.' \
        'install:Installs provided packages and adds them to Pipfile, or (if none is given), installs all packages.' \
        'lock:Generates Pipfile.lock.' \
        'open:View a given module in your editor.' \
        'run:Spawns a command installed into the virtualenv.' \
        'shell:Spawns a shell within the virtualenv.' \
        'sync:Installs all packages specified in Pipfile.lock.' \
        'uninstall:-installs a provided package and removes it from Pipfile.' \
        'update:Runs lock, then sync.' \
    )
    _arguments \
    '*:: :->subcmds' && return 0

    if (( CURRENT == 1 )); then
        _describe -t commands "pipenv subcommand" _1st_arguments
        return
    fi

    case "$words[1]" in
        shell)
        _arguments \
        $_twothre \
        $_shell
        ;;
        install)
        _arguments \
        $_twothre \
        $_install
        ;;
        uninstall)
        _arguments \
        $_twothre \ 
        $_uninstall
        ;;
        update)
        _arguments \
        $_twothre \ 
        $_update
        ;;
        *)
        _arguments \
        ;;
    esac

}

compdef _pipenv pipenv
