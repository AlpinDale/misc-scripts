#!/bin/bash

export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
# This is however your W&B project will be named
export WANDB_PROJECT="guano-7b"

MODEL_NAME="~/llama-7b"
TRAIN_DATASET="~/train.arrow"
EVAL_DATASET="~/val.arrow"
EVAL_STRATEGY="steps"
EVAL_STEPS=5000
OUTPUT_DIR="~/guana"
BATCH_SIZE=1
LEARNING_RATE=3e-5

python training/hf_trainer.py \
    --model_name_or_path $MODEL_NAME \
    --train_file $TRAIN_DATASET \
    --eval_file $EVAL_DATASET \
    --output_dir $OUTPUT_DIR \
    --per_device_train_batch_size $BATCH_SIZE \
    --per_device_eval_batch_size $BATCH_SIZE \
    --evaluation_strategy $EVAL_STRATEGY \
    --eval_steps $EVAL_STEPS \
    --learning_rate $LEARNING_RATE \
    --bf16 \
