# TestApp-Ping-OTEL - I use this to demonstrate OTEL instrumentation

### Instructions

1. Ensure the Red Hat Build of OpenTelemetry operator is installed on your cluster

2. Create a namespace, launch deployment, create service and route.

```
$ oc apply -f otel-deploy.yaml
$ oc apply -f expose.yaml
```

3. Create namespace for OTEL collector, ServiceAccount, ClusterRole, ClusterRoleBinding, and the Collector (as a deployment).

```
$ oc apply -f observability-ns.yaml
$ oc apply -f otel-collector-deployment-sa.yaml
$ oc apply -f otel-rolebinding.yaml
$ oc apply -f otel-collector.yaml
```

4. Make some HTTP requests to the "ping" endpoint to generate traces: 
 
```
$ curl -I $(oc get route  -n otel-sample -o jsonpath='{.items[].spec.host}')/ping 
```
  The response should appear as follows:

```
HTTP/1.1 200 OK
date: Mon, 07 Apr 2025 11:16:52 GMT
content-length: 4
content-type: text/plain; charset=utf-8
set-cookie: 27c7a5203dbedf674a50081de44f4d21=988339b9fa945761da4593a9313905b9; path=/; HttpOnly
```

5. Check the logs for your collector to see the traces exported to stdout of otel collector

```
$ oc project observability
$ oc logs -n observability $(oc get pod -n observability -o jsonpath='{.items[].metadata.name}'
```
