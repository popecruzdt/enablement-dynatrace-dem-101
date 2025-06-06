# Synthetic Monitoring
--8<-- "snippets/send-bizevent/7-synthetic-monitoring.js"

You can configure log ingestion rules in Dynatrace to control which logs should be collected from your Kubernetes environment. The rules leverage Kubernetes metadata and other common log entry attributes to determine which logs are to be ingested. The standard log processing features from OneAgent, including sensitive data masking, timestamp configuration, log boundary definition, and automatic enrichment of log records, are also available for Kubernetes logs.

!!! tip "Dynatrace Automatic Log Ingest"
    Dynatrace automatically discovers and analyzes new log files, including Kubernetes pod logs.  The out-of-the-box configuration will discover, parse, and ingest the logs from our `astroshop` application.  In order to exercise some of the advanced log monitoring configurations, we'll ingest sample CronJobs with logs that will need further configuration.

## Ingest CronJob Logs

Dynatrace log ingest configuration allows you to remotely configure installed OneAgents to either include specific log sources for forwarding to Dynatrace or exclude them from upload. While log discovery refers to the automatic detection of log files so that no additional log source configuration effort is required on your environment, log ingestion involves the process of collecting logs and sending required log sources into Dynatrace.

Log ingest configuration is based on rules that use matchers to target process groups, content, log levels, log paths, and other attributes described in this document. These rules determine which log files are ingested among those automatically detected by OneAgent or defined as custom log sources. 

Log ingest rules are ordered configurations processed from top to bottom. For higher configuration granularity, log ingest rules can be defined at four scopes: host, Kubernetes cluster, host group, and environment, with host scope rules having the highest priority.

![Rule Processing Priority](./img/configure-dynatrace_settings_rule_processing_priority.png)

### Log Ingest Rule

In your Dynatrace tenant, open the (new) `Settings` app.  Select the `Collect and capture` submenu.  Click on the `Log monitoring` menu.  Click on `Log ingest rules` to open the setting in the `Settings Classic` app.

![Log Monitoring Settings](./img/configure-dynatrace_settings_collect_and_capture.png)

Here you will find the log ingest rules set at the environment-level.  Rules configured here will be inherited by every host group, Kubernetes cluster, and host in the environment.  However, these settings can be overridden at the granular entity-level.

Click on `Hierarchy and overrides`.  Locate your Kubernetes cluster override for `enablement-log-ingest-101` and click on it.

![Log Monitoring Hierarchy and Overrides](./img/configure-dynatrace_settings_log_ingest_hierarchy.png)

Add a new rule that will capture logs from specific pods within the `cronjobs` namespace.  Click on `Add rule`.

![Add Rule](./img/configure-dynatrace_settings_log_ingest_cluster_rules.png)

Configure the rule with the following details:

Rule Name:
```text
CronJob Logs
```

Rule Type:
```text
Include in storage
```

Conditions:

Kubernetes namespace name is
```text
cronjobs
```

Kubernetes pod annotation is
```text
logs.dynatrace.io/ingest=true
```

![Create Rule](./img/configure-dynatrace_settings_log_ingest_create_rule.png)

This rule will enable the Log Module to collect logs from pods that belong to the `cronjobs` namespace **AND** have the annotation `logs.dynatrace.io/ingest: true`.

However, for this use case, configuring this rule alone will not start capturing these logs...

### Log Module Feature Flag

!!! tip "Log Autodiscovery"
    Logs will automatically be discovered by Dynatrace (OneAgent & Log Module).  However, not all logs may be discovered by default.  A log file must meet all of the [autodiscovery requirements](https://docs.dynatrace.com/docs/analyze-explore-automate/logs/lma-log-ingestion/lma-log-ingestion-via-oa/lma-autodiscovery#autodiscoveryrequirements){target=_blank} to be autodiscovered!

An enhancement to the log module for Kubernetes introduces a feature that enables Dynatrace to capture all container logs, even those that do not meet the autodiscovery requirements.  The logs from the CronJobs are written by a container echoing a message to stdout.  This prevents them from meeting the autodiscovery requirements, thus we will need to enable the feature flag to collect all container logs.

<div class="grid cards" markdown>
- [Learn More:octicons-arrow-right-24:](https://docs.dynatrace.com/docs/analyze-explore-automate/logs/lma-log-ingestion/lma-log-ingestion-via-oa/lma-feature-flags){target=_blank}
</div>

In your Dynatrace tenant, return to the Kubernetes settings for your cluster where you configured the log ingest rule.  In the Log Monitoring section, click on `Log module feature flags`.  Enable the setting `Collect all container logs`.  Click on `Save changes`.

![Log Module Feature Flags](./img/configure-dynatrace_settings_log_module_feature_flags.png)

With this feature enabled and the log ingest rule configured, Dynatrace will now start to collect logs from the CronJob containers.

### Query CronJob Logs

Validate that the logs are now being ingested into Dynatrace.  Open the `Logs` app.  Filter the logs on the `cronjobs` namespace and click `Run query`.

```text
k8s.namespace.name = cronjobs
```

![CronJob Logs](./img/configure-dynatrace_logs_query_new_cronjob_logs.png)

## Configure Sensitive Data Masking

Specific log messages may include user names, email addresses, URL parameters, and other information that you may not want to disclose. Log Monitoring features the ability to mask any information by modifying the configuration file on each OneAgent that handles information you consider to be sensitive.

Masking is performed directly on OneAgent, ensuring that sensitive data are never ingested into the system.

<div class="grid cards" markdown>
- [Learn More:octicons-arrow-right-24:](https://docs.dynatrace.com/docs/analyze-explore-automate/logs/lma-log-ingestion/lma-log-ingestion-via-oa/lma-sensitive-data-masking){target=_blank}
</div>

Within our CronJob logs, the `log-message-cronjob` writes out a message containing an email address.  While this email address isn't real, we can use it as an example of sensitive data masking.

```log
$TIMESTAMP INFO Log message from cronjob.  email=example@dynatrace.io Ending job.
```

!!! tip "Built-In Sensitive Data Masking"
    Dynatrace includes built-in sensitive data masking rules for email address, credit cards, URL queries, IBAN, and API-Tokens at the Environment-level.  If these settings are enabled, that may have already caused the email address in the CronJob log to be masked.
    ![Built In Masking](./img/configure-dynatrace_settings_log_sensitive_data_masking_builtin.png)

### Sensitive Data Masking Rule

In your Dynatrace tenant, return to the Kubernetes settings for your cluster where you configured the log ingest rule.  In the Log Monitoring section, click on `Sensitive data masking`.  Click on `Add rule`.

![Sensitive Data Masking Rules](./img/configure-dynatrace_settings_log_sensitive_data_masking.png)

Configure the rule with the following details:

Rule Name:
```text
CronJob Email Address
```

Search Expression:
```javascript
\b[\w\-\._]+?@[\w\-\._]+?\.\w{2,10}?\b
```

Masking Type:
```text
SHA-256
```

Conditions:

Kubernetes namespace name is
```text
cronjobs
```

![Sensitive Data Masking Rule](./img/configure-dynatrace_settings_log_sensitive_data_masking_rule.png)

The advantage of using the SHA-256 masking type is that every unique value (email address) will produce a unique hash value.  This may enable you to see if the log contains the same email address or different email addresses.  However, you will obviously not be able to decrypt what that email address is, keeping it secure!

### Query CronJob Logs

The CronJob will execute every few minutes.  Allow some time for the job to run again and produce new log records.

Return to the `Logs` app and filter on the logs that contain the email address.

```text
k8s.namespace.name = cronjobs k8s.deployment.name = log-message-cronjob-* content = "*email*"
```

![Email Masked](./img/configure-dynatrace_logs_query_email_logs.png)

The logs now contain the hashed value of the email address, `03cb5558c834be3796387a17763f315f22d3ab87cd1dc6d5d4817f8d27ec5913`.

## Configure Timestamp/Splitting Patterns

By default, log monitoring automatically detects only the most common and unambiguous subset of date formats supported. Each time a timestamp pattern is detected, the line will be treated as the beginning of the log entry. All following lines without a detected timestamp will be treated as a continuation and reported as a single multi-line log record.

In the event that a multi-line log record contains another supported timestamp, it is likely that Dynatrace will treat that line as a new log record.  If this is not the desired result, a timestamp configuration rule can be created to change this behavior.

<div class="grid cards" markdown>
- [Learn More:octicons-arrow-right-24:](https://docs.dynatrace.com/docs/analyze-explore-automate/logs/lma-log-ingestion/lma-log-ingestion-via-oa/lma-timestamp-configuration){target=_blank}
</div>

In our CronJob logs, the `timestamp-cronjob` writes a multi-line log record that contains multiple timestamps.  Dynatrace treats the extra timestamps as new log lines.  We want this log record to be treated as a single record.

![Three Log Records](./img/configure-dynatrace_logs_query_3_timestamp_logs.png)

### Timestamp Configuration Rule

In your Dynatrace tenant, return to the Kubernetes settings for your cluster where you configured the log ingest rule.  In the Log Monitoring section, click on `Timestamp/Splitting patterns `.  Click on `Add rule`.

![Timestamp Pattern Rules](./img/configure-dynatrace_settings_log_timestamp_patterns.png)

Configure the rule with the following details:

Rule Name:
```text
Timestamp CronJob
```

Search Expression:
```javascript
%^%FT%T%z
```

Conditions:

Kubernetes namespace name is
```text
cronjobs
```

![Timestamp Pattern Rule](./img/configure-dynatrace_settings_log_timestamp_patterns_rule.png)

Here is a breakdown of our pattern:

| Entry | Description |
|-------|-------------|
| %^    | Matches timestamp patterns only at the start of a log line |
| %F    | Shortcut for %Y-%m-%d, 2025-11-30 for example              |
| T     | The literal character 'T' as found in the ISO 8601  format |
| %T    | Shortcut for %H-%M-%S, 12:30:01 for example                |
| %z    | Timezone indicator as found in the ISO 8601 format         |

This rule will cause Dynatrace to stop splitting log records on new lines with timestamps, since they don't appear at the beginning of the log record.

### Query Logs

The CronJob will execute every few minutes.  Allow some time for the job to run again and produce new log records.

Return to the `Logs` app and filter on the logs that contain the multiple timestamps.

```text
k8s.namespace.name = cronjobs content != "*injection-startup*" k8s.workload.name="timestamp-cronjob"
```

![Single Log Record](./img/configure-dynatrace_logs_query_timestamp_logs.png)

Each log message is now treated as a single, multi-line, log record containing the entire message.

## Ingest Dynatrace Logs

In some cases, you may want to collect container logs from the Dynatrace components running in the `dynatrace` namespace.  By default, collection of these logs is disabled, even if you have a log ingest rule configured to do so.  Logs collected from the Dynatrace components are treated like any other log that you ingest - it consumes licensing, storage, etc.

In your Dynatrace tenant, return to the Kubernetes settings for your cluster where you configured the log ingest rule.  In the Log Monitoring section, click on `Advanced log settings`.  Enable the setting `Allow OneAgent to monitor Dynatrace logs`.  Click on `Save changes`.

![Allow Dynatrace Logs](./img/configure-dynatrace_settings_log_allow_dynatrace.png)

This allows the Log Module to discover the Dynatrace component logs.  However, we need to add an ingest rule to ship them to Dynatrace.

In the Log Monitoring section, click on `Log ingest rules`.  Modify your existing rule called `enablement-log-ingest-101` and add the `dynatrace` namespace to the matcher.  Save your changes.

![Ingest Dynatrace Namespace Logs](./img/configure-dynatrace_settings_log_ingest_rule_add_dynatrace.png)

### Query Logs

Return to the `Logs` app and filter on the logs from the `dynatrace` namespace.

```text
k8s.namespace.name = dynatrace
```

![Dynatrace Logs](./img/configure-dynatrace_logs_query_dynatrace_logs.png)

These logs can help with troubleshooting any observability issues on the Kubernetes cluster.  However, it is the Log Module that is collecting these logs, so if the Log Module is not working - the logs won't be shipped to Dynatrace!

## Configure OpenPipeline

OpenPipeline is the Dynatrace data handling solution to seamlessly ingest and process data from different sources, at any scale, and in any format in the Dynatrace Platform.

Dynatrace OpenPipeline can reshape incoming data for better understanding, processing, and analysis. OpenPipeline processing is based on rules that you create and offers a flexible way of extracting value from raw records.

![OpenPipeline](./img/configure-dynatrace_openpipeline_architecture.png)

<div class="grid cards" markdown>
- [Learn More:octicons-arrow-right-24:](https://docs.dynatrace.com/docs/discover-dynatrace/platform/openpipeline){target=_blank}
</div>

The logs written by the `paymentservice` within the `astroshop` application are missing some important context information, making them a great candidate for ingest processing with OpenPipeline.

Sample log snippet:
```json
{"level":30,"time":1744936198898,"pid":1,"hostname":"astroshop-paymentservice-7dbc46ff58-4msdx","dt.entity.host":"HOST-815866271C8841E1","dt.entity.kubernetes_cluster":"KUBERNETES_CLUSTER-FD9401B313C80ED9","dt.entity.process_group":"PROCESS_GROUP-F8DE358ACD7BA713","dt.entity.process_group_instance":"PROCESS_GROUP_INSTANCE-BE5376E9380A3175","dt.kubernetes.cluster.id":"dfc521db-c6be-471f-9e20-24f62e45bb69","dt.kubernetes.workload.kind":"deployment","dt.kubernetes.workload.name":"astroshop-paymentservice","k8s.cluster.name":"enablement-log-ingest-101","k8s.cluster.uid":"dfc521db-c6be-471f-9e20-24f62e45bb69","k8s.container.name":"paymentservice","k8s.namespace.name":"astroshop","k8s.node.name":"kind-control-plane","k8s.pod.name":"astroshop-paymentservice-7dbc46ff58-4msdx","k8s.pod.uid":"8992e584-dc50-48f9-b243-1facae6d1ba5","k8s.workload.kind":"deployment","k8s.workload.name":"astroshop-paymentservice","process.technology":"nodejs","dt.trace_id":"6977c25e6f6a6b4fcc0117087990d95b","dt.span_id":"54f824774f71e56c","dt.trace_sampled":"true","transactionId":"f762bcae-fdb7-4f55-9576-a99273683d12","cardType":"visa","lastFourDigits":"1278","amount":{"units":{"low":1173,"high":0,"unsigned":false},"nanos":999999999,"currencyCode":"USD"},"msg":"Transaction complete."}
```

### Configure Custom Logs Pipeline

In your Dynatrace tenant, open the `OpenPipeline` app.  Select `Logs` and click on the `Pipelines` tab.  Add a new Pipeline by clicking on `+ Pipeline`.

![OpenPipeline Logs Pipelines](./img/configure-dynatrace_opp_logs_pipelines.png)

Give the new pipeline a name, `AstroShop PaymentService`.  Click on the `Processing` tab to create processing rules.

![Name Your Pipeline](./img/configure-dynatrace_opp_name_pipeline.png)

!!! tip "Save Your Configuration"
    It is highly recommended to save your progress often by clicking the `Save` button and then re-opening your pipeline configuration to avoid losing your changes!

#### Processing Rules

Add a new processor rule by clicking on `+ Processor`.  Configure the processor rule with the following:

Name:
```text
NodeJS
```

Type:
```text
Technology Bundle: NodeJS
```

Matching condition:
```text
Pre-defined: matchesValue(process.technology, "Node.js") or matchesValue(process.technology, "nodejs")
```

This processor rule will apply built-in pattern detection for known NodeJS technology log frameworks to parse and enrich the log content.  In our example, this will be important to extract the numeric `loglevel` into a recognizable string value; such as "INFO" or "WARN".

![NodeJS Processor](./img/configure-dynatrace_opp_nodejs.png)

Add a new processor rule by clicking on `+ Processor`.  Configure the processor rule with the following:

Name:
```text
Parse Content
```

Type:
```text
DQL
```

Matching condition:
```text
isNotNull(log.raw_level) and loglevel != "NONE" and isNotNull(message)
```

DQL processor definition:
```text
parse content, "JSON:json_content"
| fieldsAdd content = json_content
| fieldsFlatten content, depth: 3
```

This processor rule will parse the JSON structured `content` field and flatten the object into new fields.  This will make accessing the details in the content field much easier.

![Parse Content Processor](./img/configure-dynatrace_opp_parse_content.png)

Add a new processor rule by clicking on `+ Processor`.  Configure the processor rule with the following:

Name:
```text
Message to Content
```

Type:
```text
DQL
```

Matching condition:
```text
isNotNull(log.raw_level) and loglevel != "NONE" and isNotNull(message) and isNotNull(json_content)
```

DQL processor definition:
```text
fieldsRemove content
| fieldsAdd content = message
```

This processor rule will replace the `content` field value with the `message` field value.  The JSON object in the content field is excessive and contains a ton of information that isn't relative to the field itself.  The same information already exists on the log, outside of the content field.

![Message to Content Processor](./img/configure-dynatrace_opp_message_to_content.png)

Add a new processor rule by clicking on `+ Processor`.  Configure the processor rule with the following:

Name:
```text
Transaction Fields
```

Type:
```text
DQL
```

Matching condition:
```text
matchesValue(content,"Transaction complete.") and isNotNull(content.amount.units.low) and isNotNull(content.transactionId)
```

DQL processor definition:
```text
fieldsAdd payment.amount = content.amount.units.low
| fieldsAdd payment.transactionid = content.transactionId
| fieldsAdd payment.currencycode = content.amount.currencyCode
| fieldsAdd payment.cardtype = content.cardType
| fieldsAdd payment.lastfourdigits = content.lastFourDigits
```

This processor rule will simplify the field names for extracting business information.  When the service successfully processes a payment transaction, a log record is written with the payment information.  We want this information extracted for business observability use cases.

![Transaction Fields Processor](./img/configure-dynatrace_opp_transaction_fields.png)

Add a new processor rule by clicking on `+ Processor`.  Configure the processor rule with the following:

Name:
```text
Mask Sensitive Data
```

Type:
```text
DQL
```

Matching condition:
```text
isNotNull(content.request.creditCard.creditCardNumber)
```

DQL processor definition:
```text
fieldsAdd maskedcreditcardnumber = hashMd5(content.request.creditCard.creditCardNumber)
| fieldsRemove content.request.creditCard.creditCardNumber
```

This processor rule will create a new field containing the MD5 hash value of the credit card number.  This is an example of masking sensitive data at ingest using OpenPipeline.

![Mask Sensitive Data Processor](./img/configure-dynatrace_opp_mask_sensitive.png)

Add a new processor rule by clicking on `+ Processor`.  Configure the processor rule with the following:

Name:
```text
Cleanup Fields
```

Type:
```text
DQL
```

Matching condition:
```text
isNotNull(log.raw_level) and loglevel != "NONE" and isNotNull(message) and isNotNull(json_content) and isNotNull(content)
```

DQL processor definition:
```text
fieldsRemove "content.dt.*", "content.k8s.*", "content.time","content.level", "content.process.technology", "content.hostname", "content.pid"
| fieldsRemove "content.request.creditCard.*"
| fieldsRemove json_content
```

This processor rule will cleanup (remove) fields that are no longer needed.  Parsing the `content` field resulted in many unwanted fields prefixed with `content.*`.  Additionally, the payment request log records contain sensitive credit card data (spoofed of course).  This processor will remove those fields with sensitive data.  This is an example of masking or deleting sensitive data at ingest using OpenPipeline.

![Cleanup Fields Processor](./img/configure-dynatrace_opp_cleanup_fields.png)

#### Data Extraction

Click on the `Data extraction` tab to create data extraction rules.

Add a new processor rule by clicking on `+ Processor`.  Configure the processor rule with the following:

Name:
```text
PaymentService Transaction
```

Type:
```text
Business Event
```

Matching condition:
```text
matchesValue(content,"Transaction complete.") and isNotNull(payment.amount) and isNotNull(payment.transactionid)
```

Event type:
```text
astroshop.paymentservice.transaction.complete
```

Event provider:
```text
astroshop
```

Field extraction:
```text
Extract all fields
```

This data extraction rule will generate a business event (bizevent) anytime the payment service successfully completes a payment transaction, as identified by the matching log message.  This new business event can then be used for business analytics and business observability use cases.

![BizEvent Processor](./img/configure-dynatrace_opp_transaction_bizevent.png)

Add a new processor rule by clicking on `+ Processor`.  Configure the processor rule with the following:

Name:
```text
PaymentService Fail Feature Flag Enabled
```

Type:
```text
Davis Event
```

Matching condition:
```text
matchesValue(status,"WARN") and matchesValue(message,"PaymentService Fail Feature Flag Enabled") and isNotNull(dt.entity.cloud_application)
```

Event name:
```text
PaymentService Fail Feature Flag Enabled
```

Event description:
```text
Generate an error when calling the charge method.
```

Event properties:

| Field                          | Value                                              |
|--------------------------------|----------------------------------------------------|
| event.type                     | ERROR_EVENT                                        |
| event.name                     | PaymentService Fail Feature Flag Enabled           |
| event.description              | Generate an error when calling the charge method.  |
| dt.davis.is_rootcause_relevant | true                                               |
| dt.davis.is_merging_allowed    | true                                               |
| dt.source_entity               | {dt.entity.cloud_application}                      |

This data extraction rule will generate a Davis event (alert) anytime the payment service fails to process a payment transaction due to the problem pattern (feature flag) being enabled.  This is an example of using OpenPipeline to alert on log data at ingest.

![Davis Event Processor](./img/configure-dynatrace_opp_fail_davis_event.png)

#### Metric Extraction

Click on the `Metric extraction` tab to create metric extraction rules.

Add a new processor rule by clicking on `+ Processor`.  Configure the processor rule with the following:

Name:
```text
PaymentService Failure
```

Type:
```text
Counter metric
```

Matching condition:
```text
matchesValue(status,"WARN") and matchesValue(message,"PaymentService Fail Feature Flag Enabled") and isNotNull(dt.entity.cloud_application)
```

Metric key:
```text
log.astroshop.paymentservice.failure
```

Dimensions:

| Pre-defined fields          |
|-----------------------------|
| dt.entity.cloud_application |
| dt.entity.process_group     |
| k8s.namespace.name          |
| k8s.workload.name           |          

This metric extraction rule will create a counter metric to count the number of payment service failures caused by the feature flag being enabled.  Using DQL, one could count the number of log messages, summarize or make a timeseries of that data on the fly.  However, in order to optimize query costs and reduce raw log query volume, converting specific log data to metrics is a best practice for a use case such as this.

![Metric Processor](./img/configure-dynatrace_opp_transaction_metric.png)

!!! tip "Permission and Storage Processors"
    OpenPipeline can also be used to set the security context of the log data to manage permissions to specific logs.  Additionally, you can use storage processor rules to store specific log data in a bucket that is configured for a desired retention time.  For this lab, we will not create permission or storage processor rules.

Click on `Save` to finish and save your new pipeline.

#### Dynamic Route

A pipeline will not have any effect unless logs are configured to be routed to the pipeline. With dynamic routing, data is routed based on a matching condition. The matching condition is a DQL query that defines the data set you want to route.

Click on `Dynamic Routing` to configure a route to the target pipeline. Click on `+ Dynamic Route` to add a new route.

![Dynamic Routes](./img/configure-dynatrace_opp_logs_routes.png)

Configure the `Dynamic Route` to use the `AstroShop PaymentService` pipeline.

Name:
```text
AstroShop PaymentService
```

Matching condition:
```text
matchesValue(k8s.namespace.name,"astroshop") and matchesValue(k8s.container.name,"paymentservice")
```

Pipeline:
```text
AstroShop PaymentService
```

Click `Save` to add your new route.

![Add Route](./img/configure-dynatrace_opp_add_route.png)

Validate that the route is enabled in the `Status` column. Click on `Save` to save the dynamic route table configuration.

![Save Routes](./img/configure-dynatrace_opp_save_routes.png)

Allow the `paymentservice` from `astroshop` to generate new log data that will be routed through the new pipeline (3-5 minutes).

### Query Logs

Return to the `Logs` app and filter on the logs generated by the payment service.

```text
k8s.namespace.name = "astroshop" k8s.container.name = "paymentservice" 
```

![PaymentService Logs](./img/configure-dynatrace_opp_query_new_logs.png)

## Continue

In the next section, we'll query, view, and analyze logs ingested into Dynatrace.

<div class="grid cards" markdown>
- [Continue to analyzing logs in Dynatrace:octicons-arrow-right-24:](6-analyze-logs.md)
</div>