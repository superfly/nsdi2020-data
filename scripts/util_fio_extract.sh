#! /bin/sh


while [ $# -gt 0 ]; do
    case $1 in
        -d) shift; DIR=$1
            ;;
    esac
    shift
done

TESTS="rand-read-4k rand-read-4k-qd1"
TESTS="$TESTS rand-write-4k rand-write-4k-qd1"
TESTS="$TESTS rand-read-128k rand-read-128k-qd1"
TESTS="$TESTS rand-write-128k rand-write-128k-qd1"

RAW=${DIR}/raw

process() {
    local bm=$1
    local in=$2
    local out=$3

    local r_iops=$(cat $in | jq '.jobs[0].read.iops')
    local r_bw=$(cat $in | jq '.jobs[0].read.bw')
    local r_lat99=$(cat $in | jq '.jobs[0].read.clat_ns.percentile["99.000000"]')
    local w_iops=$(cat $in | jq '.jobs[0].write.iops')
    local w_bw=$(cat $in | jq '.jobs[0].write.bw')
    local w_lat99=$(cat $in | jq '.jobs[0].write.clat_ns.percentile["99.000000"]')

    case $bm in
        rand-read-4k)
            local test="read_4k"
            local iops=$r_iops
            local bw=$r_bw
            local lat99=$r_lat99
            ;;
        rand-read-4k-qd1)
            local test="read_4k_qd1"
            local iops=$r_iops
            local bw=$r_bw
            local lat99=$r_lat99
            ;;
        rand-read-128k)
            local test="read_128k"
            local iops=$r_iops
            local bw=$r_bw
            local lat99=$r_lat99
            ;;
        rand-read-128k-qd1)
            local test="read_128k_qd1"
            local iops=$r_iops
            local bw=$r_bw
            local lat99=$r_lat99
            ;;

        rand-write-4k)
            local test="write_4k"
            local iops=$w_iops
            local bw=$w_bw
            local lat99=$w_lat99
            ;;
        rand-write-4k-qd1)
            local test="write_4k_qd1"
            local iops=$w_iops
            local bw=$w_bw
            local lat99=$w_lat99
            ;;
        rand-write-128k)
            local test="write_128k"
            local iops=$w_iops
            local bw=$w_bw
            local lat99=$w_lat99
            ;;
        rand-write-128k-qd1)
            local test="write_128k_qd1"
            local iops=$w_iops
            local bw=$w_bw
            local lat99=$w_lat99
            ;;
        *)
            echo "Unknown benchmark"
            exit 1
    esac

    echo "$test $iops $bw $lat99" >> $out
}


PRE=fio-fc
OUT=${DIR}/${PRE}.dat
echo "# Benchmark iops bw lat99" > $OUT
for TEST in $TESTS; do
    process $TEST ${RAW}/${PRE}-${TEST}.json $OUT
done

PRE=fio-chv
OUT=${DIR}/${PRE}.dat
echo "# Benchmark iops bw lat99" > $OUT
for TEST in $TESTS; do
    process $TEST ${RAW}/${PRE}-${TEST}.json $OUT
done

PRE=fio-qemu
OUT=${DIR}/${PRE}.dat
echo "# Benchmark iops bw lat99" > $OUT
for TEST in $TESTS; do
    process $TEST ${RAW}/${PRE}-${TEST}.json $OUT
done

PRE=fio-metal
OUT=${DIR}/${PRE}.dat
echo "# Benchmark iops bw lat99" > $OUT
for TEST in $TESTS; do
    process $TEST ${RAW}/${PRE}-${TEST}.json $OUT
done