#!/bin/bash

readonly EXIT_FAILURE=1

function create_soft_links() {
    local -r SCRIPT="$(readlink -f "${0}")"
    local -r HOME_FILES="$(dirname "${SCRIPT}")/home"

    echo "Creating soft links to files in ${HOME_FILES}"

    local SRC
    local DST

    for SRC in "${HOME_FILES}"/{.[!.],}*
    do
        DST="${HOME}/$(basename "${SRC}")"

        # Remove existing symbolic links.
        if [ -h "${DST}" ] ; then
            if ! unlink "${DST}" ; then
                exit "${EXIT_FAILURE}"
            fi
        fi

        # Remove existing destination files.
        if [ -f "${DST}" ] ; then
            if ! rm -f "${DST}" ; then
                exit "${EXIT_FAILURE}"
            fi
        fi

        # Create symbolic link to file.
        echo "${DST} -> ${SRC}"
        
        if ! ln -s "${SRC}" "${DST}" ; then
            exit "${EXIT_FAILURE}"
        fi
    done
}

function create_vim_directories() {
    echo "Creating vim directories"

    local -r VIM_ROOT="${HOME}/.vim"

    # Create directories used by VIM as specified in .vimrc file.
    local -r VIM_DIRS=(
        "${VIM_ROOT}/backup"
        "${VIM_ROOT}/swap"
        "${VIM_ROOT}/undo"
        )

    for VIM_DIR in "${VIM_DIRS[@]}" ; do
        if ! mkdir -p "${VIM_DIR}" ; then
            exit "${EXIT_FAILURE}"
        fi
    done
}

function set_custom_login() {
    local -r BASHRC="${HOME}/.bashrc"
    local -r BASHRC_CUSTOM="${BASHRC}-custom"
    local -r VORNERC="${HOME}/.vornerc"

    if grep --no-messages --quiet "${VORNE_USERNAME}" "${BASHRC}" ; then
        if ! echo ". ${BASHRC_CUSTOM}" > "${VORNERC}" ; then
            exit "${EXIT_FAILURE}"
        fi
    elif grep --no-messages --quiet "${BASHRC_CUSTOM}" "${BASHRC}" ; then
        if ! echo ". ${BASHRC_CUSTOM}" >> "${BASHRC}" ; then
            exit "${EXIT_FAILURE}"
        fi
    fi
}

create_soft_links
create_vim_directories
set_custom_login
