# ConfigMaps

ConfigMap are resources that allow you to decouple configuration artifacts from containerized applications
It is an API object used to store configuration data as key-value pairs. It provides a way to separate configuration from the application code, making it easier to manage and update configurations without rebuild and redeploying the application.

ConfigMaps are useful for several reasons:


- Separation of Configuration and Code:

    ConfigMaps enable a clear separation between the configuration of an application and its code, which makes it easier to manage configuration changes independently of the application code.

- Dynamic Configuration Updates:

    ConfigMaps allow you to update configuration settings dynamically without redeploying the application. 

- Consistent Configuration Across Environments:

    ConfigMaps can be used to define environment-specific configuration settings. This ensures that the same application code can be deployed in different environments with different configurations.

- Compatibility with Various Configurations:

    ConfigMaps support various types of configuration data, including key-value pairs,environment variables, command-line arguments, properties files, JSON or XML configurations, and even entire configuration files.

- Multiple Use Cases: 

    ConfigMaps can be used to configure applications running in pods, as well as provide configuration data to other Kubernetes objects such as Deployments, StatefulSets, and DaemonSets

- Mutability/Immutability: 

    ConfigMaps by default are mutable. But it also supports immutability meaning they cannot be modified once created. To update configuration data, you need to create a new ConfigMap with the updated values. We need to specify `immutable: true` inside configuration file.

### Strcuture of a ConfigMap

Configmaps has 4 important  , apiVersion , kind , metadata and `data`(not spec)

- data:

    This is where you define the key-value pairs that make up the configuration data of the ConfigMap. Each key-value pair represents a piece of configuration information.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-configmap
data:
  key1: value1
  key2: value2
```

### Creating configmaps for different format

ConfigMaps support various types of configuration data, including key-value pairs,environment variables, command-line arguments, properties files, JSON or XML configurations, and even entire configuration files.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-configmap
data:
  # for sinle key value pair 
  key1: value1
  key2: value2
  # to pass and application.properties file
  application.properties: |
    key1=value1
    key2=value2
  # to pass a json file
  config.json: |
    {
      "key1": "value1",
      "key2": "value2"
    }
  # to pass a yaml file
  config.yaml: |
    key1: value1
    key2: value2
  # to pass Multi-line Configuration
  multiline-config: |
    line1: value1
    line2: value2
    line3: value3
  #  External File (Multiline)
  external-config.txt: |
    # Contents of an external file
    key1=value1
    key2=value2
```


```bash
# To list ConfigMaps
kubectl get cm
kubectl get configmap
kubectl get cm <config-map-name>

# To describe ConfigMap
kubectl describe configmap my-configmap

# edit a configmap
kubectl edit cm <configmap-name>

# to Delete a ConfigMap
$ kubectl delete cm my-configmap

# Creating a ConfigMap from Key-Value Pairs
kubectl create configmap example-configmap --from-literal=key1=value1 --from-literal=key2=value2

# Creating a ConfigMap from a Properties File
kubectl create configmap example-configmap --from-file=application.properties=config.properties

# Creating a ConfigMap from a JSON File
kubectl create configmap example-configmap --from-file=config.json=config.json


# Creating a ConfigMap from a Single File
kubectl create configmap example-configmap --from-file=config-file.txt

# Creating a ConfigMap from a Directory
kubectl create configmap example-configmap --from-file=config-directory

# Creating a ConfigMap from a Single File with a Specific Key
kubectl create configmap example-configmap --from-file=special-key=config-file.txt

# Creating a ConfigMap from Multiple Files with Specific Keys
kubectl create configmap example-configmap \
  --from-file=key1=config-files/file1.txt \
  --from-file=key2=config-files/file2.txt
```

### Passing ConfigMaps to the container

There are several ways to pass ConfigMap data to a container. The choice of method depends on your specific use case, application requirements, and how your application consumes configuration data

1. <u> Environment Variables </u>:

    You can expose ConfigMap data as environment variables within a container. Each key-value pair in the ConfigMap becomes an environment variable.

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: example-pod
    spec:
      containers:
        - name: my-container
          image: my-image
          envFrom:
            - configMapRef:
                name: example-configmap
    ```

    In this example, environment variables are created in the container for each key-value pair in the example-configmap ConfigMap.

2. <u> Volume Mounts </u>:

    You can mount ConfigMap data as files in a volume, and the container can read the configuration from those files.

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: example-pod
    spec:
      containers:
        - name: my-container
          image: my-image
          volumeMounts:
            - name: config-volume
              mountPath: /etc/config
      volumes:
        - name: config-volume
          configMap:
            name: example-configmap
    ```
    Here, a volume named "config-volume" is defined in the volumes section. It is of type configMap, indicating that it will be populated with data from a ConfigMap. The name field specifies the name of the volume, and the configMap field specifies the ConfigMap to be used, in this case, the ConfigMap named "example-configmap."


    The volumeMounts part specifies a volume mount for the container. It says that a volume named "config-volume" should be mounted at the path "/etc/config" inside the container.

3. Subpath with Volume Mounts:

    You can use a subpath to mount specific keys from a ConfigMap into specific paths within the container.

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: example-pod
    spec:
      containers:
        - name: my-container
          image: my-image
          volumeMounts:
            - name: config-volume
              mountPath: /etc/config
      volumes:
        - name: config-volume
          configMap:
            name: example-configmap
            items:
            - key: key1
              path: key1.txt
         #  - key: key2
         #    path: key2.txt
    ```
    In this example, only the key key1 from the ConfigMap is mounted at /etc/config/key1.txt inside the container.

    - items: This is an optional field that allows you to specify a list of specific keys from the ConfigMap to include in the volume.

    - key: key1: It specifies that the key named "key1" from the ConfigMap should be included.

    - path: key1.txt: It specifies the path where the key should be mounted inside the Pod, and in this case, it will be mounted as a file named "key1.txt."



4. <u> Environment Variable with a Subpath </u>:

    You can use environment variables with a subpath to point to a specific key in a ConfigMap.

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: example-pod
    spec:
      containers:
        - name: my-container
          image: my-image
          env:
            - name: KEY1_VALUE
              valueFrom:
                configMapKeyRef:
                  name: example-configmap
                  key: key1
    ```
    In this example, the environment variable KEY1_VALUE is set to the value of the key1 key in the ConfigMap.

    The `valueFrom` field is utilized to dynamically retrieve a value from a ConfigMap in Kubernetes. The `configMapKeyRef` section specifies the details of this retrieval process. The `name` attribute designates the name of the ConfigMap, in this case, "example-configmap." The `key` attribute specifies a particular key within that ConfigMap, here named "key1."



# Secrets

Secrets are a way to securely store and manage sensitive information, such as passwords, tokens, and API keys. They are like ConfigMaps but are specifically designed to handle confidential or sensitive data. 

Secrets are a resource type used to store sensitive information, such as passwords, API keys, and other confidential data. Secrets are encoded in base64 format, providing a basic level of encoding, but they are not designed to be secure encryption mechanisms. It's important to note that while base64 encoding obscures the information, it doesn't provide encryption or strong security measures

- Data Storage:

    Secrets store sensitive data in key-value pairs.
    The data is stored in a base64-encoded format to provide a simple form of encoding.

- Use Cases:

    Secrets are commonly used for storing credentials, such as database passwords, API tokens, or certificates.
    They enable the secure distribution of sensitive information to containers running in a Kubernetes cluster.

- Creation:

    Secrets can be created manually or through imperative commands.
    They can also be created from files, literals, or other existing Secret objects.

- Mounting Secrets:

    Containers in a Pod can consume Secrets by mounting them as files or as environment variables.
    This allows applications to access sensitive information securely.

- Multiple Use Cases:

    Kubernetes supports different types of Secrets, including generic Secrets, Docker registry Secrets, and TLS Secrets for handling SSL certificates.

- Immutability:

    Once created, Secrets are immutable. If changes are required, a new Secret must be created.
    To update Secrets, you need to create a new Secret with the updated data. We need to specify immutable: true inside configuration file.

### Strcuture of a Secret

Similar to cinfigmaps , secrets has 4 important  , apiVersion , kind , metadata and `data`(not spec)

- data:

    data section is used to store key-value pairs where the values are base64-encoded representations of sensitive information. Each key-value pair in the data section represents a piece of confidential data that can be accessed by containers running in a Pod.

    The values under data are encoded in base64 to provide a basic level of encoding for sensitive information. It's important to note that base64 encoding is not a secure encryption mechanism; it's a simple encoding method.

    hen creating a Secret, you would replace `<base64-encoded-username>` and `<base64-encoded-password>` with the actual base64-encoded values of your sensitive information. You can use the `echo -n 'your-secret' | base64` command in a terminal to obtain the base64-encoded value for a string.

    ``` yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: <secret-name>
    type: Opaque
      data:
        username: <base64-encoded-username>
        password: <base64-encoded-password>
    ```

    - data: Holds the actual key-value pairs in base64-encoded format. Each key-value pair represents a piece of sensitive information.
        - username: The key for the username field.
        - password: The key for the password field.

### Types of Secrets

There are several types of Secrets designed to handle different use cases. The most common types include:

- Opaque:

    The most basic abd Default type of Secret used for arbitrary key-value pairs.
    Suitable for generic use cases where the data does not fit into more specialized Secret types.

    When you create a Secret using kubectl, you must use the generic subcommand to indicate an Opaque Secret type. For example, the following command creates an empty Secret of type Opaque:

    `kubectl create secret generic empty-secret`

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  username: <base64-encoded-username>
  password: <base64-encoded-password>
```

- Service Account Token:

    Automatically created by Kubernetes and associated with a service account.

    Contains a token that can be used by pods to authenticate to the API server.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-serviceaccount-token
  annotations:
    kubernetes.io/service-account.name: my-serviceaccount
type: kubernetes.io/service-account-token
```
- Docker Registry:

    Used to store credentials for accessing private Docker registries.

    Helps pull images from private repositories during pod deployment.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-docker-secret
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: <base64-encoded-docker-config>
```
You can also use kubectl to create a Secret for accessing a container registry, such as when you don't have a Docker configuration file:

```bash
kubectl create secret docker-registry secret-tiger-docker \
  --docker-email=tiger@acme.example \
  --docker-username=tiger \
  --docker-password=pass1234 \
  --docker-server=my-registry.example:5000
```

- TLS:

    Used for storing TLS certificates and private keys.
    Enables secure communication within a Kubernetes cluster.

    One common use for TLS Secrets is to configure encryption in transit for an Ingress, but you can also use it with other resources or directly in your workload. When using this type of Secret, the tls.key and the tls.crt key must be provided in the data (or stringData) field of the Secret configuration, although the API server doesn't actually validate the values for each key.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-tls-secret
type: kubernetes.io/tls
data:
  tls.crt: <base64-encoded-certificate>
  tls.key: <base64-encoded-private-key>
```
To create a TLS Secret using kubectl, use the tls subcommand:
```
kubectl create secret tls my-tls-secret \
  --cert=path/to/cert/file \
  --key=path/to/key/file
``` 

- SSH authentication Secrets

    is provided for storing data used in SSH authentication. When using this Secret type, you will have to specify a ssh-privatekey key-value pair in the data (or stringData) field as the SSH credential to use.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: secret-ssh-auth
type: kubernetes.io/ssh-auth
data:
  # the data is abbreviated in this example
  ssh-privatekey: |
    UG91cmluZzYlRW1vdGljb24lU2N1YmE=    
```

- Basic authentication Secret

    is provided for storing credentials needed for basic authentication. When using this Secret type, the data field of the Secret must contain one of the following two keys:

    - username: the user name for authentication
    - password: the password or token for authentication

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: secret-basic-auth
type: kubernetes.io/basic-auth
stringData:
  username: admin # required field for kubernetes.io/basic-auth
  password: t0p-Secret # required field for kubernetes.io/basic-auth
```



- Note : The SSH authentication Secret & basic authentication type is provided only for convenience. You can create an Opaque type for credentials used for SSH authentication and basic authentication. However, using the defined Secret type helps other people to understand the purpose of your Secret, and sets a convention for what key names to expect.


### Passing Secrets to the container

We can use Secrets in containers and Pods to securely manage and access sensitive information, such as passwords, API keys, or TLS certificates. Here are the primary ways to use Secrets:

- Environment Variables:

    Inject secret values as environment variables in a container.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mycontainer
    image: myimage
    env:
    - name: MY_USERNAME
      valueFrom:
        secretKeyRef:
          name: my-secret
          key: username
    - name: MY_PASSWORD
      valueFrom:
        secretKeyRef:
          name: my-secret
          key: password
```

- Volume Mounts:

    Mount secret data as files in a volume inside a container.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mycontainer
    image: myimage
    volumeMounts:
    - name: secret-volume
      mountPath: "/etc/secret"
  volumes:
  - name: secret-volume
    secret:
      secretName: my-secret
```

- ImagePullSecrets:
    
    Use Docker registry credentials stored in a Secret for pulling private images.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mycontainer
    image: myprivateregistry/myimage
imagePullSecrets:
- name: my-docker-secret
```

### Commands 

```bash
# Create a generic secret from literal values
kubectl create secret generic my-secret --from-literal=username=myuser --from-literal=password=mypassword

# Create a generic secret from a file
kubectl create secret generic my-secret --from-file=credentials.txt

# Create a TLS secret from files
kubectl create secret tls my-tls-secret --cert=tls.crt --key=tls.key

# Create a Docker registry secret
kubectl create secret docker-registry my-docker-secret \
  --docker-server=my-registry.io \
  --docker-username=myuser \
  --docker-password=mypassword \
  --docker-email=myemail@example.com

# Display the details of a secret
kubectl get secret my-secret

# Display the decoded values of a secret
kubectl get secret my-secret -o jsonpath='{.data.username}' | base64 --decode

# Describe a secret
kubectl describe secret my-secret

# Delete a secret
kubectl delete secret my-secret

# Edit a secret
kubectl edit secret my-secret

# Extract the content of a secret to a file
kubectl get secret my-secret -o jsonpath='{.data.username}' | base64 --decode > username.txt

# Replace the data of a secret with a literal value
kubectl patch secret my-secret -p '{"data":{"new-key":"new-value"}}'

# Replace the data of a secret with a file
kubectl create secret generic my-secret --from-file=new-credentials.txt --dry-run=client -o yaml | kubectl apply -f -

# Create a new secret by merging two existing secrets
kubectl create secret generic merged-secret \
  --from=first-secret \
  --from=second-secret

# Create a new secret by combining data from files and literals
kubectl create secret generic combined-secret \
  --from-file=credentials.json \
  --from-literal=additional-key=additional-value

# Create docker secrets based on existing credentials
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=<path/to/.docker/config.json> \
    --type=kubernetes.io/dockerconfigjson

# Export a secret to a YAML file
kubectl get secret my-secret -o yaml > my-secret.yaml

# Import a secret from a YAML file
kubectl apply -f my-secret.yaml

# List all secrets in a namespace
kubectl get secrets

# List all secrets with labels
kubectl get secrets --show-labels

# Label a secret
kubectl label secret my-secret environment=production

# Delete all secrets in a namespace
kubectl delete secrets --all

```