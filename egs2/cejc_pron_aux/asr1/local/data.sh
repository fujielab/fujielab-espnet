#!/usr/bin/env bash

set -e
set -u
set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}
SECONDS=0

stage=0
stop_stage=1

log "$0 $*"
. utils/parse_options.sh


if [ $# -ne 0 ]; then
    log "Error: No positional arguments are required."
    exit 2
fi

. ./path.sh || exit 1;
. ./cmd.sh || exit 1;
. ./db.sh || exit 1;

# if [ ! -e "${CSJDATATOP}" ]; then
#     log "Fill the value of 'CSJDATATOP' of db.sh"
#     exit 1
# fi
# if [ -z "${CSJVER}" ]; then
#     log "Fill the value of 'CSJVER' of db.sh"
#     exit 1
# fi
# if [ "${CSJVER}" != "usb" ]; then
#     log "Currently only supports 'usb' for CSJVER"
#     exit 1
# fi

train_set=train_nodup
train_dev=train_dev
# recog_set="eval1 eval2 eval3"
recog_set="eval"

if [ ${stage} -le 0 ] && [ ${stop_stage} -ge 0 ]; then
    # TODO
    
    # local/data_prep.sh ${CSJDATATOP}

    # for x in ${recog_set}; do
    #     local/csj_eval_data_prep.sh data/csj-data/eval ${x}
    # done

    # for x in train eval1 eval2 eval3; do
    #     local/csj_rm_tag_sp_space.sh data/${x}
    # done

    # local/data_indiv.sh ${CSJDATATOP}
    # TODO: specify the directory based on the command line argument
    python local/make_indiv_data.py \
        --cejc_dir="/autofs/diamond2/share/corpus/CEJC2304" \
        --cejc_orig_dir="/autofs/diamond2/share/corpus/CEJC" \
        --cejc_safia_dir="/autofs/diamond2/share/corpus/CEJC_safia"
    local/data_combine.sh
    echo;
fi

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
    # make a development set
    # utils/subset_data_dir.sh --first data/train 4000 data/${train_dev} # 6hr 31min
    # n=$(($(wc -l < data/train/segments) - 4000))
    # utils/subset_data_dir.sh --last data/train ${n} data/train_nodev

    # make a development set
    # 1. split the training set into 1000 subsets per utterance (ignore the speaker information)
    utils/data/split_data.sh --per-utt ./data/train 1000
    # 2. combine the 1/100 of the training set as the development set
    utils/data/combine_data.sh ./data/${train_dev} ./data/train/split1000utt/{100,200,300,400,500,600,700,800,900,1000}
    rm -rf ./data/train/split1000utt/{100,200,300,400,500,600,700,800,900,1000}
    # 3. combine the rest of the training set as the training set    
    utils/data/combine_data.sh ./data/train_nodev ./data/train/split1000utt/*
    rm -rf ./data/train/split1000utt

    # remove duplicated utterances in the training set
    utils/data/remove_dup_utts.sh 3000 data/train_nodev data/${train_set} # 233hr 36min

fi

# log "Successfully finished. [elapsed=${SECONDS}s]"
