#!/bin/bash

mkdir -p /git
cd /git

for chart in $(cat /tmp/charts.txt); do
    chart_name=$(echo ${chart##*/})
    git clone --mirror $chart
    cd $chart_name
    git config http.receivepack true
    cd ..
done

    