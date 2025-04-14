# Deploy Dynatrace
--8<-- "snippets/send-bizevent/4-deploy-dynatrace.js"

Dynatrace provides integrated Log management and analytics for your Kubernetes environments by either running the OneAgent Log module or integrating with log collectors such as Fluent Bit, Dynatrace OpenTelemetry Collector, Logstash, or Fluentd.

Dynatrace provides a flexible approach to Kubernetes observability where you can pick and choose the level of observability you need for your Kubernetes clusters. The Dynatrace Operator manages all the components needed to get the data into Dynatrace for you. This also applies to collecting logs from Kubernetes containers. Depending on the selected observability option, the Dynatrace Operator configures and manages the Log module to work in conjunction with or without a OneAgent on the node.

<div class="grid cards" markdown>
- [Learn More:octicons-arrow-right-24:](https://docs.dynatrace.com/docs/ingest-from/setup-on-k8s/deployment/k8s-log-monitoring)
</div>

## Kubernetes Platform Monitoring + Application Observability

Kubernetes platform monitoring sets the foundation for understanding and troubleshooting your Kubernetes clusters. This setup does not include OneAgent or application-level monitoring by default, but it can be combined with other monitoring and injection approaches.

!!! tip "[Kubernetes Platform Monitoring](https://docs.dynatrace.com/docs/ingest-from/setup-on-k8s/how-it-works/kubernetes-monitoring): Capabilities"
    - Provides insights into the health and utilization of your Kubernetes clusters, including object relationships (topology)
    - Uses the Kubernetes API and cAdvisor to get node- and container-level metrics and Kubernetes events
    - Enables out-of-the-box alerting and anomaly detection for workloads, Pods, nodes, and clusters

Application observability focuses on monitoring application-level metrics by injecting code modules into application Pods. This mode offers multiple injection strategies (automatic, runtime, and build-time) to collect application-specific metrics. For infrastructure-level insights, combine it with Kubernetes platform monitoring.

!!! tip "[Application Observability](https://docs.dynatrace.com/docs/ingest-from/setup-on-k8s/how-it-works/application-monitoring): Capabilities"
    - Dynatrace injects code modules into Pods using the Kubernetes admission controller.
    - Get granular control over the instrumented Pods using namespaces and annotations.
    - Route Pod metrics to different Dynatrace environments within the same Kubernetes cluster.
    - Enable data enrichment for Kubernetes environments.

### Start Monitoring Kubernetes

In your Dynatrace tenant, launch the `Kubernetes` app.  From the Overview tab, click on `Add cluster`.

SCREENSHOT

**1. Select distribution**

Choose `Other distributions` as your distribution, as we will be deploying Dynatrace on a generic Kind Kubernetes cluster.

**2. Select observability options**

Choose `Kubernetes platform monitoring + Application observability` as your observability option.  This will define your Dynakube spec/configuration.

Toggle the `Log Management and Analytics` flag/setting to `Enabled`.  Expand the option and select `Fully managed with Dynatrace Log Module`.

Check the box for `Restrict Log monitoring to certain resources`.  In the `Namespaces` field, type `astroshop`.  This will filter log ingestion on logs related to the `astroshop` Kubernetes namespace.

Toggle the `Extensions` flag/setting to `Disabled`.  We will not be using this feature in this lab.

SCREENSHOT

**3. Configure cluster**

Give your Kubernetes cluster a name, enter `enablement-log-ingest-101`.

**4. Install Dynatrace Operator**

Generate a Dynatrace Operator Token.  Copy and save the value somewhere, in case you need it.  The value will automatically be added to the `dynakube.yaml` file.

Generate a Data Ingest Token.  Copy and save the value somewhere, in case you need it.  The value will automatically be added to the `dynakube.yaml` file.

Download the `dynakube.yaml` file.

Copy the `helm install dynatrace-operator` command to your clipboard.  Use the command from your Dynatrace tenant, but it should look similar to this:
```sh
helm install dynatrace-operator oci://public.ecr.aws/dynatrace/dynatrace-operator \
--create-namespace \
--namespace dynatrace \
--atomic
```

SCREENSHOT

### Deploy Dynatrace Operator

Navigate back to your GitHub Codespaces instance.  From the terminal, paste the `helm install dynatrace-operator` command.

SCREENSHOT

Validate the new Dynatrace pods are running:
```sh
kubectl get pods -n dynatrace
```

SCREENSHOT

### Snippets

Snippets allow you to reuse text, banners, code or pieces of code.

This is a snippet with an admonition:

```bash

--8<-- "snippets/view-code.md"

```

--8<-- "snippets/view-code.md"

### Admonitions

This is a warning admonition
```bash
!!! warning "Warning"
    This is a Warning 
```
looks like:
!!! warning "Warning"
    This is a Warning 

This are the available admonitions added with a snippet:

--8<-- "snippets/admonitions.md"

### The relation between the mkdocs.yaml file, the md files and the javascript files (BizEvents) in the snippets folder.
In the MKDocs you define the menu. The firs page needs to be called index.md, You can call it whatever you want. The name from the mkdocs.yaml file will be set as title as long as you add in the same .md file a js file.

Example the ```index.md``` file has at the top a snippet ```--8<-- "snippets/index.js"```

This is because we want to monitor the Github pages and since we are using agentless rum, we need to add this to each page. in the JS file we add the same name we defined in the Menu Navigation in the mkdocs.yaml file for having consistency. This way we can understand the engagement of each page, the time the users spent in each page so we can improve our trainings.

As a best practice I recommend for each MD file have a JS file with the same name, and this should be reflected in the mkdocs.yaml file. 

Meaning before going live, after you have created all your MD files, make sure th:
- each page.md file has a snippet/page.js file associated with it
- the page.js file inside reflects the same name as in the mkdocs.yaml file, so RUM reflects the page the user is reading.

### Headings in MKDocs
if you start the md file with a snippet, automatically it'll take the name defined in the mkdocs file. You can override it by adding a Heading1 # which is only one #. For example this page is overriding the heading. As you can see there is no number 4 in the Content. All H2, H3 and so forth will be shown on the right pane for enhanced navigation and better user experience.


### Writing live the MKDocs
This codespace has in the `postCreate.sh` the function `installMkdocs` which installs `runme` and the `mkdocs`. This will publish automatically the mkdocs so you can see in an instant the changes. 

In the `postStart.sh` file the MKDocs will be exposed with the function `exposeMkdocs`. This function exposes the mkdocs in the port 8000. Before going live you should comment out both funtions for two reasons, 1.- you'll improve the rampup time of all the containers created for your session and 2.- you dont want your users to go to the local copy of the labguide but to the one in the internet so we can monitor all user interactions with your lab guide. 

To watch the local mkdocs just go to the terminal and see the process exposed in port 8000.

When you call it it should look something like this:

```bash
@sergiohinojosa ➜ /workspaces/enablement-codespaces-template (main) $ deployGhdocs 
INFO    -  Cleaning site directory
INFO    -  Building documentation to directory: /workspaces/enablement-codespaces-template/site
INFO    -  The following pages exist in the docs directory, but are not included in the "nav" configuration:
             - snippets/admonitions.md
             - snippets/disclaimer.md
             - snippets/grail-requirements.md
             - snippets/view-code.md
INFO    -  Documentation built in 0.31 seconds
INFO    -  Copying '/workspaces/enablement-codespaces-template/site' to 'gh-pages' branch and pushing to GitHub.
Enumerating objects: 61, done.
Counting objects: 100% (61/61), done.
Delta compression using up to 2 threads
Compressing objects: 100% (21/21), done.
Writing objects: 100% (33/33), 1.31 MiB | 6.24 MiB/s, done.
Total 33 (delta 15), reused 1 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (15/15), completed with 12 local objects.
To https://github.com/dynatrace-wwse/enablement-codespaces-template
   bca482c..db42f7f  gh-pages -> gh-pages
INFO    -  Your documentation should shortly be available at: https://dynatrace-wwse.github.io/enablement-codespaces-template/

```

Make sure that there is no warning in there, if there is a warning is because most likely you are referencing a page or an image that is missing or wrong.


### Deploying the Github pages.
For this you'll need write access to the repo where the enablement is being hosted. There is a function loaded in the shell called `deployGhdocs`. Before calling it, be sure that you have commited your changes to origin/main. 


## Adding apps and instantiating apps in CS
The architecture is done in a way that will help us troubleshoot issues faster and has a good separation of concerns. All the logic is found in the `functions.sh` file. So the best is to add the deployment of the app in there and then reference it in the `postCreate.sh` or `postStart.sh` file. 

Now, the terminal loads this functions as well, this gives you the possibility to have interactive trainings. Let's say that you want to add an error, or block a firewall, anything, well you can add it in a function that the user can call `startTraining` or whatever we want to do. 

<!--FIXME: Explanation in-here -->


## The greeting
The cool Dynatrace message is nothing else but echos in a function which are loaded in the user shell, in this case we are using an image with `zsh`. If you want to modify the greeting, this file is under ```.devcontainer/greeting.sh````

Just by typing `zsh` a new terminal is created and you'll see your changes. Be aware that we want to keep consistency in all trainings, so don't change the template too much.



## Before Going Live

Make sure to install the plugin Todo Tree. This is a great plugin for tracking TODOs in repositories. I've added a couple of TODOs that you'll need to take care before going live. 



## Enhancing the CS template
Multiple ways to collaborate:
- You can create a Fork and add a PR. 
- Add an issue directly in the Github repository. I have tons of enhancements in my head, but you can help me prioritize them so your work is more effective. Let's work together.


<div class="grid cards" markdown>
- [Let's continue:octicons-arrow-right-24:](cleanup.md)
</div>
