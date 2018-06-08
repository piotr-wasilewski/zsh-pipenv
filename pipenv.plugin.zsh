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

#compdef pipenv
_pipenv() {
  eval $(env COMMANDLINE="${words[1,$CURRENT]}" _PIPENV_COMPLETE=complete-zsh  pipenv)
}

if [[ "$(basename ${(%):-%x})" != "_pipenv" ]]; then
  autoload -U compinit && compinit
  compdef _pipenv pipenv
fi
