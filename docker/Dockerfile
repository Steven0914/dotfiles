ARG CUDA_VERSION=12.4.1
ARG OS_VERSION=ubuntu22.04
FROM nvidia/cuda:${CUDA_VERSION}-devel-${OS_VERSION}

ARG PYTHON_VERSION=3.11
ARG DEBIAN_FRONTEND=noninteractive

ENV SHELL=/bin/zsh
ENV CONDA_DIR=/opt/conda
ENV PATH=/opt/conda/bin:$PATH
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# 1. System packages for AI development & OpenCV/Vision dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    wget \
    git \
    zsh \
    tmux \
    vim \
    htop \
    tree \
    jq \
    rsync \
    procps \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Miniforge (Conda & Mamba compatible)
RUN ARCH="$(uname -m)" && \
    case "$ARCH" in \
        x86_64) MINIFORGE_ARCH="x86_64" ;; \
        aarch64|arm64) MINIFORGE_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac && \
    wget --quiet "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-${MINIFORGE_ARCH}.sh" -O /tmp/miniforge.sh && \
    /bin/bash /tmp/miniforge.sh -b -p "${CONDA_DIR}" && \
    rm /tmp/miniforge.sh && \
    "${CONDA_DIR}/bin/conda" clean -ya && \
    "${CONDA_DIR}/bin/conda" install -y python=${PYTHON_VERSION} pip gpustat && \
    "${CONDA_DIR}/bin/conda" init bash && \
    "${CONDA_DIR}/bin/conda" init zsh

# 3. Install uv & uvx (Fastest Python toolchain)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# 4. Create workspace directory
WORKDIR /workspace

# 5. Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/zsh"]
