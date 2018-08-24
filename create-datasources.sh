#!/bin/bash
# Add in the telegraf data soruce
GRAFANA_URL="${GRAFANA_URL:-http://localhost/grafana}"
echo "Adding telegraf data source"
curl -u admin:admin -X POST ${GRAFANA_URL}/api/datasources \
-H 'Content-Type: application/json; charset=utf-8' \
-d @- << EOF
{
"name": "telegraf",
"type": "influxdb",
"access": "proxy",
"url": "http://influxdb:8086",
"password": "root",
"user": "root",
"database": "telegraf",
"basicAuth": false
}
EOF
printf "\n\n"

# Read the dashboard.id where the skylab-home dashboard was stored.
DASHBOARD_ID="$(curl -s -0 -u admin:admin -X GET ${GRAFANA_URL}/api/dashboards/db/skylab-home| jq '.dashboard.id')"

# Set the Home dashboard for the organization.
echo "Creating home dashboard."
curl -u admin:admin -X PUT ${GRAFANA_URL}/api/org/preferences \
-H 'Content-Type: application/json; charset=utf-8' \
-d @- << EOF
{
"theme": "",
"homeDashboardId": $DASHBOARD_ID,
"timezone": ""
}
EOF
printf "\n"
