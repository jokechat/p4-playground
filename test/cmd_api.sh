#!/bin/bash

PROJECT_PATH="$PWD/../.."

# Colorful output functions
print_info() {
    echo -e "\033[32m[INFO]\033[0m $1"
}

print_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

print_warning() {
    echo -e "\033[33m[WARNING]\033[0m $1"
}

# Check if the log file contains the expected output, supports checking match count
# Parameter description:
# $1: Log file path
# $2: Expected matching string
# $3: Test name
# $4: Match count (optional, default is 1)
check_log_result() {
    local log_file=$1
    local expect=$2
    local test_name=$3
    local count=${4:-1}

    local match_count=$(grep -c "$expect" "$log_file")
    if [ $match_count -eq $count ]; then
        print_info "$test_name success"
        return 0
    else
        print_error "$test_name fail"
        return 1
    fi
}
