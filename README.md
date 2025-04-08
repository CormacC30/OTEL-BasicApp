# TestApp-Ping-OTEL - I use this to demonstrate OTEL instrumentation

### Instructions

1. Ensure that Loki Operator, Logging Operator, COO and the Red Hat Build of OpenTelemetry operator is installed on your cluster

2. Ensure a secret is configured and a serviceAccount for log collection

```
 oc create sa collector -n openshift-logging
```

3. https://docs.redhat.com/en/documentation/openshift_container_platform/4.16/html/logging/logging-6-2#quick-start-opentelemetry_logging-6x-6.2


```
 oc adm policy add-cluster-role-to-user collect-application-logs system:serviceaccount:openshift-logging:collector
 oc adm policy add-cluster-role-to-user collect-infrastructure-logs system:serviceaccount:openshift-logging:collector
 oc adm policy add-cluster-role-to-user cluster-logging-write-application-logs system:serviceaccount:openshift-logging:collector 
 oc adm policy add-cluster-role-to-user cluster-logging-write-infrastructure-logs system:serviceaccount:openshift-logging:collector
```

4. lokistack, ClusterLogForwarder, UIPlugin are all created: example can be found here:
https://docs.redhat.com/en/documentation/openshift_container_platform/4.16/html/logging/logging-6-2#quick-start-opentelemetry_logging-6x-6.2

5. Clone this repository.

6. Navigate to `manifests` directory

```
 cd ~/OTEL-BasicApp/manifests
```

7. Create a namespace, launch deployment, create service and route.

```
 oc apply -f otel-deploy.yaml
 oc apply -f expose.yaml
```

8. Create namespace for OTEL collector, ServiceAccount, ClusterRole, ClusterRoleBinding, and the Collector (as a deployment).

```
 oc apply -f observability-ns.yaml
 oc apply -f otel-collector-deployment-sa.yaml
 oc apply -f otel-rolebinding.yaml
 oc apply -f otel-collector.yaml
```

9. Make some HTTP requests to the "ping" endpoint to generate traces: 
 
```
 curl -I $(oc get route  -n otel-sample -o jsonpath='{.items[].spec.host}')/ping 
```
  The response should appear as follows:

```
HTTP/1.1 200 OK
date: Mon, 07 Apr 2025 11:16:52 GMT
content-length: 4
content-type: text/plain; charset=utf-8
set-cookie: 27c7a5203dbedf674a50081de44f4d21=988339b9fa945761da4593a9313905b9; path=/; HttpOnly
```

10. Check the logs for your collector to see the traces exported to stdout of otel collector

```
 oc project observability
 oc logs -n observability $(oc get pod -n observability -o jsonpath='{.items[].metadata.name}'
```
