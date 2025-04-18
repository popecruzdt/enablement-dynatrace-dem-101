# Analyze Logs
--8<-- "snippets/send-bizevent/6-analyze-logs.js"

## Enable Astroshop Problem Patterns

The `astroshop` demo provides several feature flags that you can use to simulate different scenarios. These flags are managed by flagd, a simple feature flag service that supports OpenFeature.

Flag values can be changed through the user interface provided at http://localhost:8080/feature when running the demo. Changing the values through this user interface will be reflected in the flagd service.

Navigate to the feature flag user interface by adding `/feature` to the end of your Codespaces instance URL.

Locate the flag **paymentServiceFailure**.  Click the drop down box and change it from `off` to `on`.  Click `save` at the top of the page.  The feature flag should start working within a minute.

![Flagd Configurator](../img/analyze-logs_enable_feature_flag.png)

## Analyze Logs in Context

Modern applications run in distributed environments. They generate observability data like metrics, logs and traces. Having all data in one place is often not enough because manual correlation can be required. Understanding the behavior and performance of distributed applications is important for effective troubleshooting. Dynatrace automatically connects and puts data in context for a smooth troubleshooting and analytics experience. This automated approach not only streamlines troubleshooting but also enhances the overall analytics experience, enabling teams to optimize application performance with ease.

https://docs.dynatrace.com/docs/analyze-explore-automate/logs/lma-use-cases/lma-e2e-troubleshooting

<div class="grid cards" markdown>
- [Learn More:octicons-arrow-right-24:](https://docs.dynatrace.com/docs/analyze-explore-automate/logs/lma-use-cases/lma-e2e-troubleshooting)
</div>

Shortly after enabling the feature flag for `paymentServiceFailure`, the Payment Service should start to fail every single payment transaction.  Let's observe, using logs in context, the impact on application reliability of this change.

### Problems App

Start by opening the (new) `Problems` app.  By now, Dynatrace - powered by the Davis AI engine, should have detected a problem with the Payment Service through the ingested log records.  Locate the problem and open it to view the details.

Notice the logs in context callout on the top right of the frame.  Dynatrace automatically searches for logs related to the entities that are root cause relevant.  Click on `Run query` to query the relevant logs.

![Problem Card](../img/analyze-logs_active_problem_card.png)

Relevant logs are queried based on the impacted entity using a pre-built DQL query.  Without any manual intervention or context switching, Dynatrace surfaces the root cause relevant logs.  The logs have the error message and even the exception stacktrace information the developers would need to debug the issue.

![Problem Logs](../img/analyze-logs_active_problem_query_logs.png)

!!! tip "Davis Co-Pilot Problem Explanation
    [Davis CoPilot provides clear summaries of problems](https://www.dynatrace.com/news/blog/davis-copilot-expands-get-answers-and-insights-across-the-dynatrace-platform/), their root causes, and the suggested remediation steps. Davis CoPilot explains individual issues in clear language from the problem details page and can perform a comparative analysis when multiple problems are selected from the list view. This helps you identify common root causes and propose corrective steps without relying on a team of experts and waiting for hours for critical insights.

If your Dynatrace tenant has Davis Co-Pilot capabilities enabled (optional, not part of this lab) then you should see a button that says `Explain`.  Click it to open a prompt that will automatically ask Davis Co-Pilot to explain the problem in natural language and suggest remediation steps! 

![Davis CoPilot](../img/analyze-logs_active_problem_davis_copilot.png)

### Kubernetes App

Next, let's approach this issue in the context of our Kubernetes environment.  Open the (new) `Kubernetes` app and click on the `Overview` tab at the top.

Notice the **Workloads**.  At least 1 workload should be identified as unhealthy, depending on what else you have monitored in your Dynatrace environment.  Click on `Workloads` to view them.

![Kubernetes Overview](../img/analyze-logs_kubernetes_overview.png)

All of the workloads are displayed. Click on the unhealthy workloads indicator to filter the view on just those that Dynatrace has identified as unhealthy.

![Kubernetes Workloads](../img/analyze-logs_kubernetes_explorer_workloads.png)

Now that only the unhealthy workloads are displayed, locate and click on the `astroshop-paymentservice` workload.  At the top, the Davis AI health indicators show how/why the workload is considered unhealthy.  There is a problem detected that's impacting this workload entity.  At the same time, we can immediate identify that there aren't issues with the workload related to Kubernetes workload conditions, CPU or memory resource usage, running/ready pods, or with the container health.

Let's explore the logs for this workload in the context of the Kubernetes entity.  Click on the `Logs` tab.

![Unhealthy Workloads](../img/analyze-logs_kubernetes_explorer_unhealthy_workload.png)

Dynatrace highlights that there are logs relevant to the root cause of the problem for this workload.  Additionally, the Davis AI recommends a query that can be executed to view these relevant log records.  Click on `Run query`.

![Query Workload Logs](../img/analyze-logs_kubernetes_explorer_unhealthy_workload_logs.png)

Relevant logs are queried based on the impacted Kubernetes entity using a pre-built DQL query.  Without any manual intervention or context switching, Dynatrace surfaces the root cause relevant logs.  The logs have the error message and even the exception stacktrace information the developers would need to debug the issue.

![Relevant Logs](../img/analyze-logs_kubernetes_explorer_query_logs.png)

!!! tip "Connecting log data to traces"
    [Dynatrace can enrich your ingested log data](https://docs.dynatrace.com/docs/analyze-explore-automate/logs/lma-log-enrichment) with additional information that helps Dynatrace to recognize, correlate, and evaluate the data.  Log enrichment enables you to seamlessly switch context and analyze individual spans, transactions, or entire workloads + empower development teams by making it easier and faster for them to detect and pinpoint problems.

From here, we can view the correlated distributed trace for the transaction that wrote this log record.  In the log record, specifically one of the log records where `content = PaymentService Fail Feature Flag Enabled`, locate the `trace_id` field.  Click on it and choose `Open field with`.  From there, choose the `Distributed Tracing` app to view the trace.

![Open Distributed Trace](../img/analyze-logs_kubernetes_explorer_view_trace.png)

### Distributed Tracing and Services Apps

A distributed trace is a collection of spans representing a request's journey through a distributed system.

The request is the call initiated by a user or system to perform a specific task. It interacts with various services and components within the distributed system. Spans are individual operations representing each request interaction with the distributed system.

The `Distributed Tracing` app will open already filtered to view the trace from the log record based on the `trace_id`.  From the trace waterfall view, expand and locate the `charge` span from the `PaymentService`.  The span includes response time information, but it also includes a lot of valuable span attributes and attached span events.  In the `Span Events` section, locate the `Exception` details.  Here you can see where the transaction encountered the exception that caused the transaction to fail.

![Analyze Distributed Trace](../img/analyze-logs_distributed_traces_view_trace.png)

Dynatrace automatically aggregates trace data into a `service` entity.  Traces, and ultimately spans, are analyzed out-of-the-box to measure the health of your endpoints and transactions across web, messaging, database, and other technologies.  Dynatrace provides aggregated metrics by default for things like response time, throughput, failure rate, and resource usage.  This allows you to easily find problems with your endpoints, identify hotspots, and analyze relevant trace data in real-time.

This span belongs to the `PaymentService`.  Open the service in the (new) `Services` app by click on `oteldemo.PaymentService`.

![Open Services App](../img/analyze-logs_distributed_traces_view_service.png)

The `Services` app opens with the `PaymentService` selected.  Here you can view the failure rate, response time, and throughput metrics for this service.  From here, you can drill down into more distributed traces for this service, find any correlated log records, view infrastructure health including Kubernetes entity details, and understand the topology and dependencies of this service.

Having logs, together and in context with metrics and traces, is essential to having a unified observability strategy.  Logs, metrics, and traces together is nice to have, but correlating them together and in context with application and infrastructure topology greatly speeds up troubleshooting.  Logs in context allow you to make better real-time business decisions by understanding business outcomes correlated with underlying system health.

## Continue

Now that the lab has been completed, in the next section we will clean up the codespaces instance.

<div class="grid cards" markdown>
- [Continue to cleanup:octicons-arrow-right-24:](cleanup.md)
</div>