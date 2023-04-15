#!/usr/bin/env bash

export OMP_NUM_THREADS=4
export HUGGINGFACE_HUB_CACHE='/mnt/gpt-storage/0x000011b/cache/huggingface/hub'

OUTPUT_DIR='/path/to/outputdir'

MODEL_NAME='/path/to/model'
TRAIN_DATASET='/path/to/train.arrow'
EVAL_DATASET='/path/to/e\val.arrow'

BS=1

torchrun --nproc_per_node=4 --master_port=20001 \
    './training/hf_trainer.py' \
    --model_name_or_path "$MODEL_NAME" \
    --train_file "$TRAIN_DATASET" \
    --eval_file "$EVAL_DATASET" \
    --output_dir "$OUTPUT_DIR" \
    --optim "adamw_torch" \
    --report_to "wandb" \
    --ddp_find_unused_parameters false \
    --bf16 true \
    --do_train --do_eval \
    --evaluation_strategy "steps" --eval_steps 256 \
    --save_strategy "steps" --save_steps 64 \
    --per_device_train_batch_size "$BS" --per_device_eval_batch_size "$BS" \
    --gradient_accumulation_steps 8 \
    --learning_rate 1.0e-5 \
    --lr_scheduler_type "cosine" \
    --warmup_steps 64 \
    --num_train_epochs 1 \
    --seed 42 --data_seed 42 \
    --logging_first_step true \
    --logging_steps 1 \
    --dataloader_num_workers 1 \
    --model_load_delay_per_rank 0 \
    --gradient_checkpointing true \
    --fsdp "full_shard auto_wrap" \
    --fsdp_transformer_layer_cls_to_wrap 'LlamaDecoderLayer' \
    $@
    # --apply_xformers \
    # --use_lora \
