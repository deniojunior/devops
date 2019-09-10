#!/bin/bash
set -e

remove_quotes(){
    sed -e 's/^"//' -e 's/"$//' <<<"$1"
}

IP="$(dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com)"
jq -n --arg internetip "$(remove_quotes $IP)" '{"internet_ip":$internetip}'