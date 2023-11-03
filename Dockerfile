# syntax=docker/dockerfile:1
# Build as `docker build . -t localgpt`, requires BuildKit.
# Run as `docker run -it --mount src="$HOME/.cache",target=/root/.cache,type=bind --gpus=all localgpt`, requires Nvidia container toolkit.

FROM nvidia/cuda:11.7.1-runtime-ubuntu22.04
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-get install -y g++-11 make python3 python-is-python3 pip
# only copy what's needed at every step to optimize layer cache
COPY ingestion.sh ./ingestion.sh
COPY ./requirements.txt .
# use BuildKit cache mount to drastically reduce redownloading from pip on repeated builds
RUN --mount=type=cache,target=/root/.cache CMAKE_ARGS="-DLLAMA_CUBLAS=ON -DLLAMA_AVX2=OFF -DLLAMA_F16C=OFF -DLLAMA_FMA=OFF" FORCE_CMAKE=1 pip install -r requirements.txt llama-cpp-python --no-cache-dir

COPY SOURCE_DOCUMENTS ./SOURCE_DOCUMENTS
COPY load ./load
COPY ingested ./ingested
COPY ingest.py constants.py ./
COPY run_localGPT_API.py ./
COPY . .

RUN chmod +x ingestion.sh

# Execute the ingestion script
#RUN --mount=type=cache,target=/root/.cache /ingestion.sh

# Docker BuildKit does not support GPU during *docker build* time right now, only during *docker run*.
# See <https://github.com/moby/buildkit/issues/1436>.
# If this changes in the future you can `docker build --build-arg device_type=cuda  . -t localgpt` (+GPU argument to be determined).
ARG device_type=cpu
ENV device_type=cuda

# Set the default command to start the FastAPI server using uvicorn
CMD ["uvicorn", "run_localGPT_API:app", "--host", "0.0.0.0", "--port", "8000"]
