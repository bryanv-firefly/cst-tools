#!/bin/bash

help_string="Available values are: imx8, imx7"

DEST=${DEST:-$(pwd)}
SRC=${SRC:-$(pwd)}
ARCH_TOOLS=""

if [[ -z ${SOC} ]];then
cat << eom
SOC is not set.
${help_string}
eom
exit 1
fi

if [[ ${SOC} == 'imx8' ]] || [[ ${SOC} == 'imx7' ]];then
:
else
cat << eom
Invalid SOC value ${SOC}
${help_string}
eom
exit 2
fi

# Get the architecture to use
if [ "$(uname -m)" = "aarch64" ]; then
echo "Running on ARM64 (aarch64) architecture"
ARCH_TOOLS="cst-4.0.0-aarch64"
PLATFORM_BIN="linux-arm64"
else
echo "Running on x86_64 architecture"
ARCH_TOOLS="cst-4.0.0"
PLATFORM_BIN="linux64"
fi

do_configure () {
    install -d ${DEST}/cst-tools
    tar -C ${DEST}/cst-tools -xf ${SRC}/nxp/${ARCH_TOOLS}.tgz --strip-components=1 ${ARCH_TOOLS}/${PLATFORM_BIN} ${ARCH_TOOLS}/keys ${ARCH_TOOLS}/crts ${ARCH_TOOLS}/ca

    for d in env Makefile hab tools;do
        cp -a ${SRC}/${SOC}/${d} ${DEST}/cst-tools/
    done
}

do_configure
