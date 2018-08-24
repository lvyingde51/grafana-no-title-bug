# Dashboard provisioning error: "Dashboard title cannot be empty" #13029

This is a demonstration of Grafana dashboard provisioning failure filed as [bug 13029](https://github.com/grafana/grafana/issues/13029)

To reproduce, follow these steps. 

- git clone https://github.com/mottati/grafana-no-title-bug.git
- cd grafana-no-title-bug/
- docker-compose up 

```
AUTOCHOOSEEARN:z-temp michael.ottati$ cd grafana-no-title-bug/
AUTOCHOOSEEARN:grafana-no-title-bug michael.ottati$ docker-compose up
Recreating grafana-no-title-bug_grafana_1 ... done
Attaching to grafana-no-title-bug_grafana_1
grafana_1  | t=2018-08-24T21:37:48+0000 lvl=info msg="Starting Grafana" logger=server version=5.2.2 commit=aeaf7b2 compiled=2018-07-25T11:17:28+0000

<REDACTED STARTUP LOG > 

grafana_1  | t=2018-08-24T21:37:50+0000 lvl=info msg="Initializing Stream Manager"
grafana_1  | t=2018-08-24T21:37:50+0000 lvl=eror msg="failed to load dashboard from " logger=provisioning.dashboard type=file name=default file="/Dashboards/Main Org./this-dashboard-has-a-title.json" error="Dashboard title cannot be empty"
grafana_1  | t=2018-08-24T21:37:50+0000 lvl=info msg="HTTP Server Listen" logger=http.server address=0.0.0.0:3000 protocol=http subUrl= socket=
grafana_1  | t=2018-08-24T21:37:53+0000 lvl=eror msg="failed to load dashboard from " logger=provisioning.dashboard type=file name=default file="/Dashboards/Main Org./this-dashboard-has-a-title.json" error="Dashboard title cannot be empty"
grafana_1  | t=2018-08-24T21:37:56+0000 lvl=eror msg="failed to load dashboard from " logger=provisioning.dashboard type=file name=default file="/Dashboards/Main Org./this-dashboard-has-a-title.json" error="Dashboard title cannot be empty"

```
 
