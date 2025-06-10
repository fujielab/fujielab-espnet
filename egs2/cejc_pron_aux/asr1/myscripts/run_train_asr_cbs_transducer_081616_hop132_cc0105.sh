#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set=train_nodup_cc_01_05
valid_set=train_dev_cc
test_sets="eval10m eval10f eval20m eval20f eval30m eval30f eval40m eval40f eval50m eval50f eval60m eval60f eval70m eval70f eval1_csj eval2_csj eval3_csj"

asr_config=myconf/train_asr_cbs_transducer_081616_hop132.yaml
asr_tag=train_asr_cbs_transducer_081616_hop132_cc0105

inference_config=myconf/decode_cbs_transducer.yaml
inference_asr_model=valid.cer_transducer.ave_10best.pth

lm_config=conf/train_lm.yaml
use_lm=false
use_wordlm=false

use_wandb=true
wandb_project="espnet_ninjal"
# wandb_id="cejc_alt_${asr_tag}"
wandb_name="cejc_cbs_td_081616_hop132_cc0105"

# speed perturbation related
# (train_set will be "${train_set}_sp" if speed_perturb_factors is specified)
# speed_perturb_factors="0.9 1.0 1.1"

./asr.sh                                               \
    --ngpu 2                                           \
    --lang jp                                          \
    --feats_type raw                                   \
    --token_type word                                  \
    --asr_config "${asr_config}"                       \
    --asr_tag "${asr_tag}"                             \
    --train_set "${train_set}"                         \
    --valid_set "${valid_set}"                         \
    --test_sets "${test_sets}"                         \
    --use_streaming false                              \
    --inference_config "${inference_config}"           \
    --inference_asr_model "${inference_asr_model}"     \
    --use_lm ${use_lm}                                 \
    --use_word_lm ${use_wordlm}                        \
    --lm_config "${lm_config}"                         \
    --lm_train_text "data/${train_set}/text"           \
    --nj 8 \
    --inference_nj 8 \
    --skip_stages "1 2 5 " \
    --asr_args "--use_wandb ${use_wandb} --wandb_project ${wandb_project} --wandb_name ${wandb_name} " \
    "$@"
