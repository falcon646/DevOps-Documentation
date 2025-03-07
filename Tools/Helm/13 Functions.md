## **Helm Functions**  

Helm provides built-in functions that allow dynamic transformation and manipulation of data within chart templates. These functions help modify strings, process lists and dictionaries, perform type conversions, and more.  

### **1. Understanding Functions**  
A function in Helm takes an input, processes it, and returns an output in the desired format. Functions operate within the `{{ ... }}` template directives in Helm charts.  

For example, to convert a string to uppercase:  
```yaml
{{ "helm" | upper }}
### **Output:** `HELM`  

# Similarly, to remove spaces from a string:  
{{ "  helm  " | trim }}
### **Output:** `helm`  
```

### **2. Using Functions in Helm Templates**  
Helm templates process values from various sources, such as:  
- `.Values` from `values.yaml`  
- `.Release` details  
- `.Chart` metadata  

These values can be transformed using functions within templates.  

For example, to convert an image repository name to uppercase:  
```yaml
{{ .Values.image.repository | upper }}
```
If `values.yaml` contains:  
```yaml
image:
  repository: nginx
```
The output in the final manifest will be:  
```yaml
NGINX
```

### **3. Common String Functions**  
Helm provides several string functions for modifying text.  

- **`upper`** – Converts a string to uppercase.  
  ```yaml
  {{ "nginx" | upper }}
  ```
  **Output:** `NGINX`  

- **`lower`** – Converts a string to lowercase.  
  ```yaml
  {{ "NGINX" | lower }}
  ```
  **Output:** `nginx`  

- **`trim`** – Removes spaces from both ends of a string.  
  ```yaml
  {{ "  nginx  " | trim }}
  ```
  **Output:** `nginx`  

- **`quote`** – Wraps a string in double quotes.  
  ```yaml
  {{ "nginx" | quote }}
  ```
  **Output:** `"nginx"`  

- **`replace`** – Replaces a substring within a string.  
  ```yaml
  {{ "nginx" | replace "x" "y" }}
  ```
  **Output:** `nginy`  

- **`shuffle`** – Randomly shuffles the characters of a string.  
  ```yaml
  {{ "nginx" | shuffle }}
  ```
  **Output:** (randomized, e.g., `xgnin`)  

### **4. Functions with Multiple Arguments**  
Some functions accept multiple arguments.  

For example, the `replace` function replaces a character in a string:  
```yaml
{{ "hello world" | replace "world" "helm" }}
```
**Output:** `hello helm`  

### **5. Other Categories of Functions**  
Helm functions are not limited to string operations. They also include:  

- **Cryptographic functions** – Hashing, encryption, and security-related operations.  
- **Date functions** – Handling and formatting dates.  
- **Dictionary and list functions** – Manipulating lists and key-value mappings.  
- **Kubernetes functions** – Retrieving cluster-related details.  
- **Network functions** – Handling URLs, IPs, and domain-related operations.  
- **Type conversion functions** – Converting between strings, numbers, and booleans.  
- **Regular expression (RegEx) functions** – Performing pattern matching and replacements.  

### **6. Reference and Documentation**  
A complete list of supported functions is available in the Helm documentation. When working with functions, always refer to the official Helm documentation for syntax and usage details.


# **Handling Missing Values in Helm Templates**  

When generating Kubernetes manifests using Helm templates, values from the `values.yaml` file are often used. However, if a required value is not set, the generated manifest may be incomplete, leading to deployment failures.  

### **Issue with Missing Values**  
If a field is not defined in `values.yaml`, it will not be present in the rendered manifest. For example, consider a Helm template referencing `.Values.image.repository` like this:  
```yaml
image:
  repository: {{ .Values.image.repository }}
```  
If `image.repository` is missing from `values.yaml`, the generated manifest will also exclude this field, potentially causing a failed deployment.  

### **Using the `default` Function**  
To prevent such failures, Helm provides the `default` function, which assigns a fallback value if the variable is undefined.  
```yaml
image:
  repository: {{ .Values.image.repository | default "nginx" }}
```  
### **How the `default` Function Works**  
- If `image.repository` is **defined** in `values.yaml`, Helm uses that value.  
- If `image.repository` is **not defined**, Helm substitutes `"nginx"` as the default value.  

### **Syntax Considerations**  
- **Always enclose default values in quotes**:  
  - **Correct**: `"nginx"`  
  - **Incorrect**: `nginx` (Helm may interpret it as a variable and raise an error)  

### **Example**  
#### **Case 1: Value Provided** (`values.yaml`)  
```yaml
image:
  repository: "custom-nginx"
```  
**Rendered output:**  
```yaml
image:
  repository: "custom-nginx"
```  

#### **Case 2: Value Missing** (`values.yaml`)  
```yaml
# image.repository is not set
```  
**Rendered output (fallback applied):**  
```yaml
image:
  repository: "nginx"
```  

By using `default`, Helm templates can ensure robustness, preventing failures due to missing values.