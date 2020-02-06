# ------------------------------------------------------------------------------
# DATABRICKS REQUIREMENTS
# ------------------------------------------------------------------------------

FROM databricksruntime/standard:latest

# control python version via pyenv
ENV PYTHON_VERSION 3.6.7

# use bash instead of sh
SHELL ["/bin/bash", "-c"]

RUN apt-get update \ 
  && apt-get install --yes \
    wget \
    libdigest-sha-perl \
    bzip2 \
    openjdk-8-jdk \
    iproute2 \
    bash \
    sudo \
    coreutils \
    procps \
  && /var/lib/dpkg/info/ca-certificates-java.postinst configure 


# DBFS FUSE is available in standard container. "https://github.com/databricks/containers/tree/master/ubuntu/standard"

# install fuse
RUN apt-get update \
  && apt-get install -y fuse 

# ------------------------------------------------------------------------------
# ADDITIONAL LINUX PACKAGES
# ------------------------------------------------------------------------------

# python3 and other dependencies
RUN apt-get update && apt-get install -y git zlib1g-dev  wget unzip \
    build-essential libssl-dev libbz2-dev libffi-dev libreadline-dev \
    libsqlite3-dev  jq git apt-utils

RUN apt-get install -y  python3-dev python-pip  python-tk virtualenv

## Add req from a dependency : psycopg2 (postgresql), req by sqlalchemy-redshift
RUN apt-get install -y libpq-dev 

# --------------------
# Install Python3 using pyenv
# --------------------
ENV PYENV_ROOT="/root/.pyenv" \
    PATH="/root/.pyenv/shims:/root/.pyenv/bin:${PATH}" \
    # PIPENV_YES=1 \
    # PIPENV_DONT_LOAD_ENV=1 \
    LC_ALL="C.UTF-8" \
    LANG="en_US.UTF-8"

# dependencies for python3 installation
# install pyenv
RUN apt-get install curl -y
RUN curl https://pyenv.run | bash
RUN echo 'export PATH="/root/.pyenv/bin:$PATH"' >>/root/.bashrc
RUN echo 'eval "$(pyenv init -)"'  >> /root/.bashrc
RUN echo 'eval "$(pyenv virtualenv-init -)"' >> /root/.bashrc
RUN source /root/.bashrc
RUN cat /root/.bashrc
RUN pyenv update \
   && pyenv install $PYTHON_VERSION \
   && pyenv global $PYTHON_VERSION \
   && pyenv rehash


# Initialize the default environment that Spark and notebooks will use
RUN virtualenv -p /root/.pyenv/versions/$PYTHON_VERSION/bin/python --system-site-packages /databricks/python3

# copy  python dependencies
COPY requirements.txt /databricks/requirements.txt

RUN /databricks/python3/bin/pip install -r /databricks/requirements.txt

# clean up
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



# ------------------------------------------------------------------------------
# CUSTOM INSTALLATIONS
# ------------------------------------------------------------------------------

