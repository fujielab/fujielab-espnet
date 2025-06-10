
# split the training set into 1000 subsets per utterance (ignore the speaker information)
./utils/data_split_data.sh --per-utt data_csj/train_nodup 1000

# combine the training set
./utils/combine_data.sh data/train_nodup_csj_01 data_csj/train_nodup/split1000utt/*1
./utils/combine_data.sh data/train_nodup_csj_02 data_csj/train_nodup/split1000utt/*2
./utils/combine_data.sh data/train_nodup_csj_03 data_csj/train_nodup/split1000utt/*3
./utils/combine_data.sh data/train_nodup_csj_04 data_csj/train_nodup/split1000utt/*4
./utils/combine_data.sh data/train_nodup_csj_05 data_csj/train_nodup/split1000utt/*5
./utils/combine_data.sh data/train_nodup_csj_06 data_csj/train_nodup/split1000utt/*6
./utils/combine_data.sh data/train_nodup_csj_07 data_csj/train_nodup/split1000utt/*7
./utils/combine_data.sh data/train_nodup_csj_08 data_csj/train_nodup/split1000utt/*8
./utils/combine_data.sh data/train_nodup_csj_09 data_csj/train_nodup/split1000utt/*9
./utils/combine_data.sh data/train_nodup_csj_10 data_csj/train_nodup/split1000utt/*0

# combine the training set incrementally
./utils/combine_data.sh data/train_nodup_csj_01_02 data/train_nodup_csj_0{1,2}
./utils/combine_data.sh data/train_nodup_csj_01_03 data/train_nodup_csj_0{1,2,3}
./utils/combine_data.sh data/train_nodup_csj_01_04 data/train_nodup_csj_0{1,2,3,4}
./utils/combine_data.sh data/train_nodup_csj_01_05 data/train_nodup_csj_0{1,2,3,4,5}
./utils/combine_data.sh data/train_nodup_csj_01_06 data/train_nodup_csj_0{1,2,3,4,5,6}
./utils/combine_data.sh data/train_nodup_csj_01_07 data/train_nodup_csj_0{1,2,3,4,5,6,7}
./utils/combine_data.sh data/train_nodup_csj_01_08 data/train_nodup_csj_0{1,2,3,4,5,6,7,8}
./utils/combine_data.sh data/train_nodup_csj_01_09 data/train_nodup_csj_0{1,2,3,4,5,6,7,8,9}
./utils/combine_data.sh data/train_nodup_csj_01_10 data/train_nodup_csj_0{1,2,3,4,5,6,7,8,9} data/train_nodup_csj_10

# combine the cejc and csj training set
./utils/combine_data.sh data/train_nodup_cc_01 data/train_nodup data/train_nodup_csj_01
./utils/combine_data.sh data/train_nodup_cc_01_02 data/train_nodup data/train_nodup_csj_01_02
./utils/combine_data.sh data/train_nodup_cc_01_03 data/train_nodup data/train_nodup_csj_01_03
./utils/combine_data.sh data/train_nodup_cc_01_04 data/train_nodup data/train_nodup_csj_01_04
./utils/combine_data.sh data/train_nodup_cc_01_05 data/train_nodup data/train_nodup_csj_01_05
./utils/combine_data.sh data/train_nodup_cc_01_06 data/train_nodup data/train_nodup_csj_01_06
./utils/combine_data.sh data/train_nodup_cc_01_07 data/train_nodup data/train_nodup_csj_01_07
./utils/combine_data.sh data/train_nodup_cc_01_08 data/train_nodup data/train_nodup_csj_01_08
./utils/combine_data.sh data/train_nodup_cc_01_09 data/train_nodup data/train_nodup_csj_01_09
./utils/combine_data.sh data/train_nodup_cc_01_10 data/train_nodup data/train_nodup_csj_01_10

# combine the dev set
./utils/combine_data.sh data/train_dev_cc data/train_dev data_csj/train_dev

# copy CSJ eval set
cp -r data_csj/eval1 data/eval1_csj
cp -r data_csj/eval2 data/eval2_csj
cp -r data_csj/eval3 data/eval3_csj


