# Configure Dynatrace
--8<-- "snippets/send-bizevent/5-configure-dynatrace.js"

You can configure log ingestion rules in Dynatrace to control which logs should be collected from your Kubernetes environment. The rules leverage Kubernetes metadata and other common log entry attributes to determine which logs are to be ingested. The standard log processing features from OneAgent, including sensitive data masking, timestamp configuration, log boundary definition, and automatic enrichment of log records, are also available for Kubernetes logs.


