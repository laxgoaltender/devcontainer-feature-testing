#!/usr/bin/env bash

set -e

rm -rf /var/lib/apt/lists/*

FLUX_VERSION=${VERSION:-"latest"}

DEPENDENCIES=('ca-certificates' 'curl')

export DEBIAN_FRONTEND=noninteractive

apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

install_dependencies()
{
	apt-get update
	apt-get install -y --no-install-recommends "${DEPENDENCIES[@]}"
	apt-get clean all
	rm -rf /var/lib/apt/lists/*
}

install_flux()
{
	echo "Activating feature 'flux2'"

	if [ "${FLUX_VERSION}" = "none" ] || type flux > /dev/null 2>&1; then
	    echo "FLux already installed. Skipping..."
	else

	  echo "Installing flux...'"

	  if [ "${FLUX_VERSION}" = "latest" ] ; then
	    curl -s https://fluxcd.io/install.sh | bash
	  else
	    curl -s https://fluxcd.io/install.sh | FLUX_VERSION=$FLUX_VERSION bash
	  fi
	
	fi
}

apt_get_update
install_dependencies
install_flux

set +e

echo "Done!"
