# Configure Dynatrace
--8<-- "snippets/send-bizevent/5-configure-dynatrace.js"

You can configure log ingestion rules in Dynatrace to control which logs should be collected from your Kubernetes environment. The rules leverage Kubernetes metadata and other common log entry attributes to determine which logs are to be ingested. The standard log processing features from OneAgent, including sensitive data masking, timestamp configuration, log boundary definition, and automatic enrichment of log records, are also available for Kubernetes logs.

!!! tip "Dynatrace Automatic Log Ingest"
    Dynatrace automatically discovers and analyzes new log files, including Kubernetes pod logs.  The out-of-the-box configuration will discover, parse, and ingest the logs from our `astroshop` application.  In order to exercise some of the advanced log monitoring configurations, we'll ingest sample CronJobs with logs that will need further configuration.

## Ingest CronJob Logs

### Log Ingest Rule

### Log Module Feature Flag

### Query CronJob Logs

## Configure Sensitive Data Masking

### Sensitive Data Masking Rule

### Query CronJob Logs

## Configure Timestamp/Splitting Patterns

### Timestamp Configuration Rule

### Query Logs

## Ingest Dynatrace Logs

### Query Logs

## Continue

In the next section, we'll query, view, and analyze logs ingested into Dynatrace.

<div class="grid cards" markdown>
- [Continue to analyzing logs in Dynatrace:octicons-arrow-right-24:](6-analyze-logs.md)
</div>