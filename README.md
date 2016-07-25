# eos-dropbox-app

## Description

This package is used by EOS to package the Drobpox Client as a flatpak, it's
a wrapper script used as a 'headless-app' that will get the non-free bits as
part of the eos machinery

## Detailed description

This package provides the following elements:
  * `dropbox-start.sh`: launcher script that takes care of launching the
     dropboxd binary 

All this files will be included inside the flatpak bundle, and will be run from
the outside with `flatpak run com.Dropbox.Client`.

The non-free parts will be fetched on installation and add as a runtime extension.

## License

eos-dropbox-app is Copyright (C) 2016 Endless Mobile, Inc. and is licensed
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version.

See the COPYING file for the full version of the GNU GPLv2 license
