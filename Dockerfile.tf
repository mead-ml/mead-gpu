FROM tensorflow/tensorflow:1.15.2-gpu-py3

COPY xpctl /usr/mead/xpctl
COPY mead-baseline /usr/mead/mead-baseline

WORKDIR /usr/mead

RUN cd mead-baseline/layers && pip install -e .
RUN cd mead-baseline && pip install -e .[test,yaml]
RUN pip install mead-xpctl

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

ENTRYPOINT ["mead-train", "--config", "config/sst2.json"]
