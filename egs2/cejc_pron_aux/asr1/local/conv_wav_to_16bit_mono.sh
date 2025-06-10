#! /bin/bash
set -e
set -u
set -o pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <src-dir> <dst-dir>"
    echo "e.g.: $0 data/conv data/conv_16k"
    exit 1
fi

src_dir=$1
dst_dir=$2

mkdir -p ${dst_dir}

find ${src_dir} -name "*.wav" | sort | while read -r filename; do
    dst_file_dir=$(dirname ${filename} | sed -e "s,${src_dir},${dst_dir},g")
    dst_filename=${dst_file_dir}/$(basename ${filename})
    echo "Converting ${filename} to ${dst_filename}"
    mkdir -p ${dst_file_dir}
    sox ${filename} -b 16 -r 16000 -c 1 -t wav ${dst_filename} remix 1
done


