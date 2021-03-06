# Generated by Neurodocker version 0.4.0
# Timestamp: 2018-06-22 09:08:27 UTC
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/kaczmarj/neurodocker

FROM neurodebian:stretch-non-free

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN export ND_ENTRYPOINT="/neurodocker/startup.sh" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           apt-utils \
           bzip2 \
           ca-certificates \
           curl \
           locales \
           unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG="en_US.UTF-8" \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT" \
    &&   echo 'set -e' >> "$ND_ENTRYPOINT" \
    &&   echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT"; \
    fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker

ENTRYPOINT ["/neurodocker/startup.sh"]

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           fsl-core \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sed -i '$isource /etc/fsl/fsl.sh' $ND_ENTRYPOINT

RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "neurodebian:stretch-non-free" \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "fsl-core" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "add_to_entrypoint", \
    \n      "source /etc/fsl/fsl.sh" \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json

RUN apt-get update \
    && apt-get -y install git g++ python python-numpy libeigen3-dev zlib1g-dev libqt4-opengl-dev libgl1-mesa-dev libfftw3-dev libtiff5-dev curl \
    && apt-get -y install git-core python-setuptools python-dev build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN easy_install pip \
    && pip install wheel numpy scipy nilearn matplotlib scikit-image nibabel \
    && pip install http://download.pytorch.org/whl/cpu/torch-0.4.0-cp27-cp27mu-linux_x86_64.whl

# This command does not get cached -> very slow each time when building container -> use prebuild mrtrix_RC3.tar.gz instead
RUN mkdir /code && cd /code \
    && git clone https://github.com/MRtrix3/mrtrix3.git \
    && cd mrtrix3/ \
    && git checkout 3.0_RC3 \
    && ./configure \
    && ./build \
    && ./set_path \

# This is a lot faster
#RUN mkdir /code
#COPY mrtrix3_RC3.tar.gz /code
#RUN tar -zxvf /code/mrtrix3_RC3.tar.gz -C code \
#    && /code/mrtrix3/set_path

RUN mkdir -p ~/.tractseg \
    && curl -SL -o ~/.tractseg/pretrained_weights_tract_segmentation_v1.npz https://www.dropbox.com/s/nygr0j2zgztedh0/TractSeg_best_weights_ep448.npz?dl=1 \
    && curl -SL -o ~/.tractseg/pretrained_weights_endings_segmentation_v3.npz https://www.dropbox.com/s/i6a5c5cf6j5ok4r/EndingsSeg_best_weights_ep234.npz?dl=1 \
    && curl -SL -o ~/.tractseg/pretrained_weights_peak_regression_v1.npz https://www.dropbox.com/s/ogywkbrj3165v3e/PeakReg_best_weights_ep229.npz?dl=1 \
    && curl -SL -o ~/.tractseg/pretrained_weights_dm_regression_v1.npz https://www.dropbox.com/s/d82iv95flz8n5a2/DmReg_best_weights_ep427.npz?dl=1

RUN pip install https://github.com/MIC-DKFZ/batchgenerators/archive/master.zip \
    && pip install https://github.com/MIC-DKFZ/TractSeg/archive/v1.4.zip

# Does not work -> added mrtrix to path in python
ENV PATH /code/mrtrix3/bin:$PATH

# Using this we can avoid having to call TractSeg each time -> but has problems finding bet then
#ENTRYPOINT ["TractSeg"]

