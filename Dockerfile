FROM ubuntu:22.04 AS builder

# Update package lists
RUN apt-get update && \
    apt-get install -y --no-install-recommends git build-essential ca-certificates autoconf libtool autotools-dev automake libibverbs-dev librdmacm-dev libibumad-dev libpci-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone perftest
RUN git clone https://github.com/linux-rdma/perftest.git

# Build perftest
WORKDIR /perftest
RUN ./autogen.sh && ./configure && make && DESTDIR=/install make install

FROM ubuntu:22.04

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends libibverbs1 librdmacm1 libibumad3 ibverbs-providers ibverbs-utils infiniband-diags libpci3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /

RUN useradd -m perftest

WORKDIR /home/perftest
USER perftest

ENTRYPOINT ["bash"]

CMD []