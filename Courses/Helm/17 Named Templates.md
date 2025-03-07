### **Using Named Templates in Helm**  

Helm provides **named templates** (also called **partials**) to eliminate repetitive code and maintain consistency across multiple manifest files.



### **Problem: Repetitive Labels**  

Consider a **Deployment** and **Service** manifest where the labels are repeated:  

#### **Example: Deployment YAML**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
    environment: production
spec:
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
        environment: production
```

#### **Example: Service YAML**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app
  labels:
    app: my-app
    environment: production
```

- The **labels section is duplicated** in both files.  
- Maintaining consistency becomes difficult as the project grows.  
- Any manual changes must be applied to multiple files.  



### **Solution: Named Templates (`_helpers.tpl`)**  

Helm allows the creation of **named templates** inside a `_helpers.tpl` file.  
The underscore (`_`) in `_helpers.tpl` ensures that Helm does not treat it as a Kubernetes manifest.

#### **Step 1: Create `_helpers.tpl`**
Move the repeated labels to `_helpers.tpl` and define a reusable template:

```yaml
{{- define "common.labels" -}}
app: my-app
environment: production
{{- end }}
```

- `define "common.labels"`: Defines a named template called `common.labels`.  
- **Indentation is preserved** when using named templates.  
- The `-` symbols remove unwanted whitespace.



### **Step 2: Use the Named Template in Deployment and Service**  

Instead of repeating labels, **include** the named template:

#### **Deployment YAML**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    {{- include "common.labels" . | indent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "common.labels" . | indent 6 }}
  template:
    metadata:
      labels:
        {{- include "common.labels" . | indent 8 }}
```

#### **Service YAML**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app
  labels:
    {{- include "common.labels" . | indent 4 }}
```



### **Handling Scope in Named Templates**  

#### **Issue: Hardcoded Values**
If the labels contain **hardcoded values**, they won't adapt dynamically:

```yaml
{{- define "common.labels" -}}
app: my-app
release: my-release
{{- end }}
```

- If multiple Helm releases are deployed, **`release: my-release` remains constant**, causing conflicts.

#### **Solution: Pass the Scope (`.`) to the Template**  
Modify `_helpers.tpl` to use `.Release.Name` dynamically:

```yaml
{{- define "common.labels" -}}
app: my-app
release: {{ .Release.Name }}
{{- end }}
```

Then, **pass the current scope (`.`) when including the template**:

```yaml
metadata:
  labels:
    {{- include "common.labels" . | nindent 4 }}
```

Now, `release:` will be dynamically replaced with the actual Helm release name.



### **Key Takeaways**  
✅ **Named templates reduce repetition** and improve maintainability.  
✅ **Use `_helpers.tpl` to store reusable templates**, preventing unnecessary manifest creation.  
✅ **Pass `.` to ensure scope is transferred** to the helper template.  
✅ **Use `nindent` to maintain proper indentation** when including templates.  

By structuring templates this way, Helm charts remain **clean, scalable, and consistent** across multiple deployments.