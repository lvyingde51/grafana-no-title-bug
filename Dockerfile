ARG GRAFANA_VERSION

FROM grafana/grafana:5.2.2


COPY provisioning /etc/grafana/provisioning
COPY Dashboards  /Dashboards

