FROM meadml/cuda10.1-cudnn7-devel-ubuntu18.04-python3.6

COPY xpctl /usr/mead/xpctl
COPY mead-baseline /usr/mead/mead-baseline

WORKDIR /usr/mead

RUN cd xpctl/ && pip install -e .
RUN cd mead-baseline/layers && pip install -e .
RUN cd mead-baseline && pip install -e .[test,yaml]

# Set env variables
# Set baseline logging vars
ENV TIMING_LOG_LEVEL=DEBUG
# Set terminal encodings
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
# Set ENV to tensorflow can find cuda
ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Install baseline
COPY . /usr/mead

# Install tensorflow
RUN python3.6 -m pip install tensorflow-gpu==1.15.0 && \
    python3.6 -m pip install tensorflow-hub==0.6.0

ENTRYPOINT ["mead-train", "--config", "config/sst2.json"]
