Feature: Register a cloud service in Primaza cluster without healthchecks nor constraints

    Background:
        Given Primaza Cluster "main" is running
        And On Primaza Cluster "main", Resource is created
        """
        apiVersion: v1
        kind: Secret
        metadata:
            name: $scenario_id
            namespace: primaza-system
        stringData:
            password: quedicelagente
        """

    Scenario: Cloud Service Registration, no Healthcheck provided and no ServiceCatalog exists
        When On Primaza Cluster "main", Resource is created
        """
        apiVersion: v1
        kind: Secret
        metadata:
            name: $scenario_id
            namespace: primaza-system
        stringData:
            password: quedicelagente
        """
        When On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: RegisteredService
        metadata:
          name: primaza-rsdb
          namespace: primaza-system
        spec:
          serviceClassIdentity:
            - name: type
              value: psqlserver
            - name: provider
              value: aws
          serviceEndpointDefinition:
            - name: host
              value: mydavphost.io
            - name: port
              value: "5432"
            - name: user
              value: davp
            - name: password
              valueFromSecret:
                name: $scenario_id
                key: password
            - name: database
              value: davpdata
          sla: L3
        """
        Then On Primaza Cluster "main", RegisteredService "primaza-rsdb" state will eventually move to "Available"
        And On Primaza Cluster "main", there are no ServiceCatalogs


    Scenario: Cloud Service Registration, no Healthcheck provided and ServiceCatalog exists
        Given Worker Cluster "worker" for ClusterEnvironment "worker" is running
        And   Clusters "main" and "worker" can communicate
        And   On Primaza Cluster "main", Worker "worker"'s ClusterContext secret "primaza-kw" for ClusterEnvironment "worker" is published
        And   On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: ClusterEnvironment
        metadata:
            name: worker
            namespace: primaza-system
        spec:
            environmentName: dev
            clusterContextSecret: primaza-kw
        """
        When On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: RegisteredService
        metadata:
          name: primaza-rsdb
          namespace: primaza-system
        spec:
          serviceClassIdentity:
            - name: type
              value: psqlserver
            - name: provider
              value: aws
          serviceEndpointDefinition:
            - name: host
              value: mydavphost.io
            - name: port
              value: "5432"
            - name: user
              value: davp
            - name: password
              valueFromSecret:
                name: $scenario_id
                key: password
            - name: database
              value: davpdata
          sla: L3
        """
        Then On Primaza Cluster "main", RegisteredService "primaza-rsdb" state will eventually move to "Available"
        And On Primaza Cluster "main", ServiceCatalog "dev" will contain RegisteredService "primaza-rsdb"


    Scenario: Cloud Service Registration, no Healthcheck provided, ServiceCatalog exists, and Registered Service deleted
        Given Worker Cluster "worker" for ClusterEnvironment "worker" is running
        And   Clusters "main" and "worker" can communicate
        And   On Primaza Cluster "main", Worker "worker"'s ClusterContext secret "primaza-kw" for ClusterEnvironment "worker" is published
        And   On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: ClusterEnvironment
        metadata:
            name: worker
            namespace: primaza-system
        spec:
            environmentName: dev
            clusterContextSecret: primaza-kw
        """
        And   On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: RegisteredService
        metadata:
          name: primaza-rsdb
          namespace: primaza-system
        spec:
          serviceClassIdentity:
            - name: type
              value: psqlserver
            - name: provider
              value: aws
          serviceEndpointDefinition:
            - name: host
              value: mydavphost.io
            - name: port
              value: "5432"
            - name: user
              value: davp
            - name: password
              valueFromSecret:
                name: $scenario_id
                key: password
            - name: database
              value: davpdata
          sla: L3
        """
        When On Primaza Cluster "main", RegisteredService "primaza-rsdb" is deleted
        Then On Primaza Cluster "main", ServiceCatalog "dev" will not contain RegisteredService "primaza-rsdb"


    Scenario: Cloud Service Registration, no Healthcheck provided, ServiceCatalog exists, and Registered Service claimed
        Given Worker Cluster "worker" for ClusterEnvironment "worker" is running
        And   Clusters "main" and "worker" can communicate
        And   On Primaza Cluster "main", Worker "worker"'s ClusterContext secret "primaza-kw" for ClusterEnvironment "worker" is published
        And   On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: ClusterEnvironment
        metadata:
            name: worker
            namespace: primaza-system
        spec:
            environmentName: dev
            clusterContextSecret: primaza-kw
        """
        And On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: RegisteredService
        metadata:
          name: primaza-rsdb
          namespace: primaza-system
        spec:
          serviceClassIdentity:
            - name: type
              value: psqlserver
            - name: provider
              value: aws
          serviceEndpointDefinition:
            - name: host
              value: mydavphost.io
            - name: port
              value: "5432"
            - name: user
              value: davp
            - name: password
              valueFromSecret:
                name: $scenario_id
                key: password
            - name: database
              value: davpdata
          sla: L3
        """
        When On Primaza Cluster "main", RegisteredService "primaza-rsdb" state moves to "Claimed"
        Then On Primaza Cluster "main", ServiceCatalog "dev" will not contain RegisteredService "primaza-rsdb"


    Scenario: Cloud Service Registration, no Healthcheck provided, ServiceCatalog exists, and Registered Service unclaimed
        Given Worker Cluster "worker" for ClusterEnvironment "worker" is running
        And   Clusters "main" and "worker" can communicate
        And   On Primaza Cluster "main", Worker "worker"'s ClusterContext secret "primaza-kw" for ClusterEnvironment "worker" is published
        And   On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: ClusterEnvironment
        metadata:
            name: worker
            namespace: primaza-system
        spec:
            environmentName: dev
            clusterContextSecret: primaza-kw
        """
        And On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: RegisteredService
        metadata:
          name: primaza-rsdb
          namespace: primaza-system
        spec:
          serviceClassIdentity:
            - name: type
              value: psqlserver
            - name: provider
              value: aws
          serviceEndpointDefinition:
            - name: host
              value: mydavphost.io
            - name: port
              value: "5432"
            - name: user
              value: davp
            - name: password
              valueFromSecret:
                name: $scenario_id
                key: password
            - name: database
              value: davpdata
          sla: L3
        """
        And  On Primaza Cluster "main", RegisteredService "primaza-rsdb" state moves to "Claimed"
        When On Primaza Cluster "main", RegisteredService "primaza-rsdb" state moves to "Available"
        Then On Primaza Cluster "main", ServiceCatalog "dev" will contain RegisteredService "primaza-rsdb"


    Scenario: Cloud Service Registration, no Healthcheck provided, ServiceCatalog does not exists, and Registered Service deleted
        Given On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: RegisteredService
        metadata:
          name: primaza-rsdb
          namespace: primaza-system
        spec:
          serviceClassIdentity:
            - name: type
              value: psqlserver
            - name: provider
              value: aws
          serviceEndpointDefinition:
            - name: host
              value: mydavphost.io
            - name: port
              value: "5432"
            - name: user
              value: davp
            - name: password
              valueFromSecret:
                name: $scenario_id
                key: password
            - name: database
              value: davpdata
          sla: L3
        """
        When On Primaza Cluster "main", RegisteredService "primaza-rsdb" is deleted
        Then On Primaza Cluster "main", there are no ServiceCatalogs

    Scenario: Cloud Service Registration, no Healthcheck, no constraints and multiple ServiceCatalog exists
        Given Worker Cluster "worker" is running
        And   On Worker Cluster "worker", a ServiceAccount for ClusterEnvironment "worker-dev" exists
        And   On Worker Cluster "worker", a ServiceAccount for ClusterEnvironment "worker-stage" exists
        And   Clusters "main" and "worker" can communicate
        And   On Primaza Cluster "main", Worker "worker"'s ClusterContext secret "primaza-kw-dev" for ClusterEnvironment "worker-dev" is published
        And   On Primaza Cluster "main", Worker "worker"'s ClusterContext secret "primaza-kw-stage" for ClusterEnvironment "worker-stage" is published
        And   On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: ClusterEnvironment
        metadata:
            name: worker-dev
            namespace: primaza-system
        spec:
            environmentName: dev
            clusterContextSecret: primaza-kw-dev
        ---
        apiVersion: primaza.io/v1alpha1
        kind: ClusterEnvironment
        metadata:
            name: worker-stage
            namespace: primaza-system
        spec:
            environmentName: stage
            clusterContextSecret: primaza-kw-stage
        """
        When On Primaza Cluster "main", Resource is created
        """
        apiVersion: primaza.io/v1alpha1
        kind: RegisteredService
        metadata:
          name: primaza-rsdb
          namespace: primaza-system
        spec:
          serviceClassIdentity:
            - name: type
              value: psqlserver
            - name: provider
              value: aws
          serviceEndpointDefinition:
            - name: host
              value: mydavphost.io
            - name: port
              value: "5432"
            - name: user
              value: davp
            - name: password
              valueFromSecret:
                name: $scenario_id
                key: password
            - name: database
              value: davpdata
          sla: L3
        """
        Then On Primaza Cluster "main", RegisteredService "primaza-rsdb" state will eventually move to "Available"
        And On Primaza Cluster "main", ServiceCatalog "dev" will contain RegisteredService "primaza-rsdb"
        And On Primaza Cluster "main", ServiceCatalog "stage" will contain RegisteredService "primaza-rsdb"
