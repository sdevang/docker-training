FROM ubuntu:18.04 

# Run OS update and install some packages
RUN apt-get update && \
    apt-get install -y curl unzip jq git python3-pip python3 ruby && \
    apt-get clean

# Install Python packages
RUN pip3 install awscli boto3 ansible==2.8.6
RUN pip3 freeze
