#!bin/bash

pkg update && pkg upgrade -y
pkg install python clang python-pip git openssl -y
git clone https://github.com/LostRuins/koboldcpp && cd koboldcpp
make
wget https://huggingface.co/alpindale/pygmalion-6b-ggml/resolve/main/pygmalion-6b-v3-q4_0.bin
python koboldcpp.py pygmalion-6b-v3-q4_0.bin
