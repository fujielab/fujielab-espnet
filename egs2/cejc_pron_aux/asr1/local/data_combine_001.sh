# Evaluation set ID
eval="C001_007 K001_004 K001_014 K003_000 K005_006 K006_007 K007_006 K008_001 K009_015 \
      K009_020 K012_000 T004_002 T004_032 T005_015 T005_023 T005_026 T005_033 T005_059 \
      T005_060 T007_010 T008_008 T009_002 T009_011 T010_007 T011_009 T013_006 T015_029 \
      T016_000 T019_002 T021_002 T021_005 T023_018 W006_001 W008_003 W009_002"
excl="K004_004 T004_009 W001_011 T005_064 W001_013 K007_010 T005_065 T005_007 T005_049 \
      W001_019"

# move
ind=data/indiv
outd=data/indiv_other
mkdir -p $outd/eval
mkdir -p $outd/excluded

for list in $excl ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/excluded
done

for list in $eval ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval
done

# combine
ind=data/indiv_other
outd=data
utils/data/combine_data.sh $outd/eval $ind/eval/*
ind=data/indiv
utils/data/combine_data.sh $outd/train $ind/*
