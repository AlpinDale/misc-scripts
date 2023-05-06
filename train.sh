#!/usr/bin/env bash

export OMP_NUM_THREADS=4
export WANDB_PROJECT="pygmalion-3b"
CUDA_VISIBLE_DEVICES=1,3
OUTPUT_DIR="/home/alpin/checkpoints/$WANDB_PROJECT"

MODEL_NAME='togethercomputer/RedPajama-INCITE-Base-3B-v1'
TRAIN_DATASET="/data/$WANDB_PROJECT/train.arrow"
EVAL_DATASET="/data/$WANDB_PROJECT/eval.arrow"

BSZ=8

accelerate launch \
    './training/hf_trainer.py' \
    --model_name_or_path "$MODEL_NAME" \
    --train_file "$TRAIN_DATASET" \
    --eval_file "$EVAL_DATASET" \
    --output_dir "$OUTPUT_DIR" \
    --report_to "wandb" \
    --do_train --do_eval \
    --ddp_find_unused_parameters false \
    --optim 'adamw_torch_fused' \
    --seed 42 --data_seed 42 \
    --logging_first_step true --logging_steps 1 \
    --dataloader_num_workers 1 \
    --per_device_train_batch_size "$BSZ" --per_device_eval_batch_size "$BSZ" \
    --bf16 true \
    --evaluation_strategy "steps" --eval_steps 128 \
    --save_strategy "steps" --save_steps 128 \
    --save_total_limit 10 \
    --gradient_accumulation_steps 8 \
    --learning_rate 1.0e-5 \
    --lr_scheduler_type "cosine" \
    --warmup_steps 64 \
    --num_train_epochs 1 \
    $@
