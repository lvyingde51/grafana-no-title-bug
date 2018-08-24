#!/usr/bin/env bash
ORGS=(
"Main Org.")
GRAFANA_URL="${GRAFANA_URL:-http://localhost:3000}"
FILE_DIR=Dashboards

import_dashboard(){
    if [ -f "$1" ]; then
        printf "Processing $1 file...\n"
        curl -k -u admin:admin --silent -XPOST "${GRAFANA_URL}/api/dashboards/db" --data-binary @./$1 -H "Content-Type: application/json" -H "Accept: application/json"
        printf "\n\n"
    else
        echo "$file not found."
    fi
}
# Start of script
scriptDir=$(cd `dirname $0`; pwd)
cd ${scriptDir}

for org in "${ORGS[@]}" ; do
    DIR="$FILE_DIR/$org"

    # This pushd is required to deal with spaces in directory name
    pushd "$DIR"
        echo Importing Grafana dashboards for organization: $(basename "$(pwd)")
        for file in *.json; do
            import_dashboard $file $KEY
        done
    popd
done
