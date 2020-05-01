FROM g3wsuite/g3w-suite-deps-py3:latest

LABEL maintainer="Gis3W" Description="This image is used to install python requirements and code for g3w-suite deployment" Vendor="Gis3W" Version="1.0"
# Based on main CI Docker from  g3w-suite, checkout code + caching,
# custom settings file
RUN apt update && apt upgrade -y && apt install git -y && \
    git clone https://github.com/g3w-suite/g3w-admin.git --single-branch --branch dj22-py3 /code && \
    cd /code && \
    git checkout dj22-py3

# Override settings
COPY requirements_rl.txt .
RUN pip3 install -r requirements_rl.txt

# Caching
RUN cd /code/g3w-admin/ && git submodule add -b dev -f https://github.com/g3w-suite/g3w-admin-caching.git caching
RUN pip3 install -r /code/g3w-admin/caching/requirements.txt

# Filemanager
RUN cd /code/g3w-admin/ && git submodule add -b dev -f https://github.com/g3w-suite/g3w-admin-filemanager.git filemanager
RUN pip3 install -r /code/g3w-admin/filemanager/requirements.txt

CMD echo "Base image for g3w-suite-dev with tile caching" && tail -f /dev/null