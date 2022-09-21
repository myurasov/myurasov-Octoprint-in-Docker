FROM ubuntu:focal

# where external files are mapped to
ARG APP_DIR="/app"

# build directory
WORKDIR /tmp

# use bash as a default shell
ENV SHELL=/bin/bash
ENV force_color_prompt=yes

# apt setup
RUN apt-get update
ENV TZ=America/Los_Angles
ENV DEBIAN_FRONTEND=noninteractive

# python
RUN apt-get install -y python3-pip

# pip
RUN pip install --upgrade pip

# python packages
RUN pip install octoprint
RUN ln -s /app/config /root/.octoprint

# startup commands
RUN echo "octoprint serve --host 0.0.0.0 --port 80 --iknowwhatimdoing" >> /cmd
RUN echo "sleep infinity" >> /cmd
CMD ["sh", "/cmd"]

WORKDIR ${APP_DIR}
