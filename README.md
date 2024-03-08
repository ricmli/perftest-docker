# perftest-docker

```bash
docker build -t perftest:latest .
docker run -it --rm --net=host --device=/dev/infiniband/uverbs0 --device=/dev/infiniband/rdma_cm perftest:latest
```
