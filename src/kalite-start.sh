#!/bin/bash

base_dir="/var/lib/kalite"
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

    if [ -e ${done_file} ]; then
        echo "Contentpacks already imported"
        return
    fi

    # ok we really need to do this, first get some base data working
    kalite manage setup -n

    # check if we have any uninstalled language pack first.
    for f in $(find ${content_dir} -type f -name "*.zip"); do
        lang=$(basename $f | sed s/'-minimal'//g | sed s/'.zip'//g)
        kalite manage retrievecontentpack local $lang $f
        if [ $? -eq 0 ]; then
            echo "Language pack '$f' successfully installed. Removing zip file..."
            rm -f $f
        else
            echo "Could not install language pack '$f'"
        fi
    done

    touch ${done_file}
}

# Make sure there's access to the assessment data
mkdir -p ${content_dir}
ln -snf /app/share/kalite/assessment ${assessment_dir}

# This is a no-op if the language packs were installed.
install_language_packs

# Use --foreground to prevent systemd establishing
# the connection via the socket too early
kalite start --foreground
