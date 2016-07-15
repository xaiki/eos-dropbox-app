#!/bin/bash
#
# kalite-start-sh
#
# Copyright (C) 2016 Endless Mobile, Inc.
# Authors:
#  Mario Sanchez Prada <mario@endlessm.com>
#  Niv Sardi <xaiki@endlessm.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

base_dir="/var/lib/kalite"
preloaded_dir="${base_dir}/PRELOADED"
content_dir="${base_dir}/content"
assessment_dir="${content_dir}/assessment"

# This function checks if there's any pre-loaded files with
# language (content packs), importing them into KA Lite if
# needed, early returning if they were already imported.
install_language_packs() {
    temp_dir=$(mktemp -d)
    done_file="${base_dir}/done"

    if [ ! -d ${base_dir} ]; then
        echo "No '${base_dir}' directory found"
        return
    fi

    if [ ! -d ${preloaded_dir} ]; then
        echo "No preloaded contentpacks found"
        return
    fi

    # ok we really need to do this, first get some base data working
    kalite manage setup -n

    # check if we have any uninstalled language pack first.
    had_errors=false
    for f in $(find ${preloaded_dir} -type f -name "*.zip"); do
        lang=$(basename $f | sed s/'-minimal'//g | sed s/'.zip'//g)
        kalite manage retrievecontentpack local $lang $f
        if [ $? -eq 0 ]; then
            echo "Language pack '${f}' successfully installed. Removing..."
            rm -f ${f}
        else
            echo "Could not install language pack '${f}'"
            had_errors=true
        fi
    done

    if ! had_errors; then
        echo "All language packs successfully installed."
        rm -rf ${preloaded_dir}
    fi
}

# Make sure there's access to the assessment data
mkdir -p ${content_dir}
ln -snf /app/share/kalite/assessment ${assessment_dir}

# This is a no-op if the language packs were installed.
install_language_packs

# Use --foreground to prevent systemd establishing
# the connection via the socket too early
kalite start --foreground
