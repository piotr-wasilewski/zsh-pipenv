# Called by zsh when directory changes, append to chpwd_functions
chpwd_functions+=(chpwd_checkforpipenv)
function chpwd_checkforpipenv() {
    if [ ! "$(command -v pipenv)" ]; then
      echo "Pipenv not installed. See http://docs.pipenv.org/en/latest/"
      return 1
    fi
  
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

# Add activate to change pwd functions
chpwd_functions+=(zsh-pipenv-shell-activate)

# enable pipenv tab completion
eval "$(pipenv --completion)"
