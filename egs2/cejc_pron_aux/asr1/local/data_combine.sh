# Evaluation set ID
eval10m="T015_021 T018_003"
eval10f="K002_003 T018_004"
eval20m="C002_002 T006_009 T010_002"
eval20f="K001_018 S002_002 T009_015"
eval30m="K005_015 T005_006 W008_003"
eval30f="C002_010 K002_007 K004_012"
eval40m="K007_009 T008_008 T015_007"
eval40f="K004_008 T007_011 T020_022"
eval50m="K010_005 T008_003 T022_006"
eval50f="K002_004 T011_005 T017_012"
eval60m="K005_004 T013_023 T017_002 T023_005"
eval60f="K006_013 T006_001 T008_007"
eval70m="T004_011 T005_052"
eval70f="K009_020 T014_002"

excl="K004_004 T004_009 W001_011 T005_064 W001_013 K007_010 T005_065 T005_007 T005_049 W001_019"

# move
ind=data/indiv
outd=data/indiv_other
mkdir -p $outd/eval10m $outd/eval10f $outd/eval20m $outd/eval20f $outd/eval30m $outd/eval30f \
         $outd/eval40m $outd/eval40f $outd/eval50m $outd/eval50f $outd/eval60m $outd/eval60f \
         $outd/eval70m $outd/eval70f
mkdir -p $outd/excluded

for list in $excl ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/excluded
done

for list in $eval10m ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval10m
done

for list in $eval10f ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval10f
done

for list in $eval20m ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval20m
done

for list in $eval20f ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval20f
done

for list in $eval30m ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval30m
done

for list in $eval30f ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval30f
done

for list in $eval40m ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval40m
done

for list in $eval40f ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval40f
done

for list in $eval50m ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval50m
done

for list in $eval50f ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval50f
done

for list in $eval60m ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval60m
done

for list in $eval60f ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval60f
done

for list in $eval70m ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval70m
done

for list in $eval70f ; do
    find $ind -type d -name $list | xargs -i mv {} $outd/eval70f
done

# combine
ind=data/indiv_other
outd=data
utils/data/combine_data.sh $outd/eval10m $ind/eval10m/*
utils/data/combine_data.sh $outd/eval10f $ind/eval10f/*
utils/data/combine_data.sh $outd/eval20m $ind/eval20m/*
utils/data/combine_data.sh $outd/eval20f $ind/eval20f/*
utils/data/combine_data.sh $outd/eval30m $ind/eval30m/*
utils/data/combine_data.sh $outd/eval30f $ind/eval30f/*
utils/data/combine_data.sh $outd/eval40m $ind/eval40m/*
utils/data/combine_data.sh $outd/eval40f $ind/eval40f/*
utils/data/combine_data.sh $outd/eval50m $ind/eval50m/*
utils/data/combine_data.sh $outd/eval50f $ind/eval50f/*
utils/data/combine_data.sh $outd/eval60m $ind/eval60m/*
utils/data/combine_data.sh $outd/eval60f $ind/eval60f/*
utils/data/combine_data.sh $outd/eval70m $ind/eval70m/*
utils/data/combine_data.sh $outd/eval70f $ind/eval70f/*

ind=data/indiv
utils/data/combine_data.sh $outd/train $ind/*
