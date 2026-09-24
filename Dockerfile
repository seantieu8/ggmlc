FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    cmake \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY . /app/

WORKDIR /app

ARG CUDA_ARCHITECTURES=61 # Pascal architecture (Change to compatible architecture)

RUN mkdir -p build && cd build && \
    cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DGGMLC_ENABLE_CUDA=ON \
      -DGGMLC_BUILD_EXAMPLES=ON \
      -DCMAKE_CUDA_ARCHITECTURES=${CUDA_ARCHITECTURES} && \
    cmake --build . --config Release -j$(nproc)

ENV PATH="/app/build/examples/laya:/app/build:${PATH}"
