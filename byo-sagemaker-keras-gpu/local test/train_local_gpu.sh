#!/bin/sh

image=$1 # Pass docker image as the first argument

mkdir -p test_dir/model
mkdir -p test_dir/output

# If the directories exist before hand then this will clean up the content.
rm test_dir/model/*
rm test_dir/output/*

# Run the docker image and execute the file "train"
#docker run --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 --rm nvidia/cuda nvidia-smi
docker run --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 -v $(pwd)/test_dir:/opt/ml --rm ${image} train