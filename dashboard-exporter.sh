#!/usr/bin/env bash
ORGS=(
"Main Org.")
GRAFANA_URL="${GRAFANA_URL:-http://localhost:3000}"
FILE_DIR=Dashboards

if [ ! -d "$FILE_DIR" ] ; then
    mkdir -p "$FILE_DIR"
fi

for org in "${ORGS[@]}" ; do
    DIR="$FILE_DIR/$org"

    if [ ! -d "$DIR" ] ; then
        mkdir -p "$DIR"
    fi
    pushd "$DIR"
        for dash in $(curl -sSL -k -u admin:admin  "{$GRAFANA_URL}/api/search?query=&" | jq '.' |grep -i uri|awk -F '"uri": "' '{ print $2 }'|awk -F '"' '{print $1 }'); do
            DB=$(echo ${dash}|sed 's,db/,,g')
            # If the file exists curl will save to the .tmp extension, new files get written as .json files.
            if [[ -e "$DB.json" ]]; then
                EXTENSION=".tmp"
            else
                EXTENSION=".json"
            fi
            curl -k -u admin:admin "${GRAFANA_URL}/api/dashboards/${dash}" | jq '.dashboard.id = null' > "$DB$EXTENSION"
            # If .tmp file exists, compare it to the original. If it differs only by one of the following elements:
            #
            #     created timestamp
            #     updated timestamp
            #     version
            #     createdBy
            #
            # then the file has not really changed and we simply delete the .tmp copy.
            #
            # The output of the diff in the case we are trying to detect will look like this:
            # --- skylab-home.json	2017-04-28 05:56:24.000000000 +0000
            # +++ skylab-home.tmp	2017-04-28 16:58:56.000000000 +0000
            #@@ -117,2 +117,2 @@
            #-    "created": "2017-04-27T22:16:45Z",
            #-    "updated": "2017-04-27T22:16:45Z"
            #+    "created": "2017-04-27T22:22:59Z",
            #+    "updated": "2017-04-27T22:22:59Z"
            #
            # The subsequent grep -v -E removes the following lines:
            # * Lines starting with @@
            # * Lines starting with "created": OR "updated": followed by a timestamp
            # * Lines with a "version": element
            # * Lines with a "createdBy": element
            #
            # What remains are only the first two lines showing the names of the before and after copies of the file.

            if [[ -e "$DB.tmp" ]]; then
               LINECOUNT=$(diff -U 0 $DB.json $DB.tmp \
                | grep -v -E '(^@@|"version"\:|"createdBy"\:|("created"|"updated")\:.*[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}\:[0-9]{2}\:[0-9]{2}[A-Z])'\
                |wc -l | tr -d '[:space:]' )
                if [[ "$LINECOUNT" = "2" ]];then
                    rm "$DB.tmp"
                else
                    rm $DB.json
                    mv $DB.tmp $DB.json
                fi
            fi
        done
    popd 
done