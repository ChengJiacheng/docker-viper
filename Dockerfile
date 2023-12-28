FROM nvidia/cuda:11.6.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update && apt-get install -y libsm6 libxext6 libxrender-dev vim wget sudo psmisc locales cmake vim g++ zip htop git screen git-lfs gnupg libgl1 bwm-ng iputils-ping dnsutils
# nvidia-cuda-toolkit
RUN locale-gen en_US.UTF-8

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda
    
# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH


# ADD https://raw.githubusercontent.com/ChengJiacheng/nautilus/master/yaml/torch19.yml /tmp/environment.yml
# RUN conda env create --file /tmp/environment.yml && conda init bash && echo "source activate base" >> ~/.bashrc
RUN conda create -n torch python=3.10 -y && conda init bash && echo "source activate torch" >> ~/.bashrc
ENV PATH /opt/conda/envs/torch/bin:$PATH

RUN conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.6 -c pytorch -c nvidia -y

RUN yes | pip install accelerate==0.18.0 bitsandbytes==0.38.1 transformers==4.28.1 pydantic==1.10.8 openai==0.28

