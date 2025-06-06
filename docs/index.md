--8<-- "snippets/send-bizevent/index.js"

--8<-- "snippets/disclaimer.md"

<!-- TODO: Before go-live, remove this warning -->
!!! warning "Under Construction"
    This lab and lab guide are currently a work-in-progress and are not ready at this time!

## Lab Overview

During this hands-on training lab, we’ll move through the complete lifecycle of digital experience monitoring, starting with the deployment of the Dynatrace OneAgent and progressing through the configuration of key features:

* Real User Monitoring (RUM): Capture and analyze real-time user interactions across web and mobile applications to understand behavior, performance, and satisfaction.
* Session Replay: Visualize user sessions to uncover usability issues and performance bottlenecks with pixel-perfect replays.
* Synthetic Monitoring: Simulate user journeys from global locations to proactively detect and resolve issues before they impact real users.

Participants will then explore Dynatrace’s powerful analytics capabilities to interpret the collected data, identify performance trends, and uncover actionable insights. By the end of the lab, attendees will have a comprehensive understanding of how to leverage Dynatrace to deliver seamless, high-performing digital experiences.

**Lab tasks:**

1. Deploy Dynatrace
2. Real User Monitoring
3. Session Replay
4. Synthetic Monitoring
5. Problem and Anomaly Detection

## Technical Specification

### Technologies Used
- [Dynatrace](https://www.dynatrace.com/trial)
- [Kubernetes Kind](https://kind.sigs.k8s.io/)
    - tested on Kind tag 0.27.0
- [Cert Manager](https://cert-manager.io/) - *prerequisite for OpenTelemetry Operator
    - tested on cert-manager v1.15.3
- [Dynatrace Operator](https://github.com/Dynatrace/dynatrace-operator)
    - tested on v1.4.2 (April 2025)
- Dynatrace OneAgent
    - tested on v1.309 (April 2025)

### Reference Architecture

[Dynatrace on Kubernetes: Application observability](https://docs.dynatrace.com/docs/ingest-from/setup-on-k8s/how-it-works/application-monitoring)

[Dynatrace on Kubernetes: Platform monitoring](https://docs.dynatrace.com/docs/ingest-from/setup-on-k8s/how-it-works/kubernetes-monitoring)

[OpenTelemetry Astronomy Shop Demo Architecture](https://opentelemetry.io/docs/demo/architecture/)

## Continue

In the next section, we'll review the prerequisites for this lab needed before launching our Codespaces instance.

<div class="grid cards" markdown>
- [Continue to getting started:octicons-arrow-right-24:](2-getting-started.md)
</div>