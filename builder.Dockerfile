FROM quay.io/pypa/manylinux_2_28_x86_64

RUN curl -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain stable
ENV PATH=/root/.cargo/bin:$PATH

ARG PYTHON_TAG=cp314-cp314
ENV PATH=/opt/python/${PYTHON_TAG}/bin:$PATH
RUN pip install maturin

WORKDIR /src
COPY . .

# CARGO_BUILD_JOBS bounds compile parallelism so the build fits a small host.
ENV CARGO_BUILD_JOBS=4
CMD ["maturin", "build", "--release", "--compatibility", "manylinux_2_28", "-o", "/src/dist"]
