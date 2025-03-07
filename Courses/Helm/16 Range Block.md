### **Using Loops and Ranges in Helm Templates**  

Helm provides the `range` keyword to iterate over lists in a `values.yaml` file and dynamically generate structured output in templates.



### **Example: Iterating Over a List of Regions**  

#### **`values.yaml`**
```yaml
regions:
  - ohio
  - newyork
  - ontario
  - londion
  - singapore
  - mumbai
```
The goal is to generate a `ConfigMap` where each region is listed as a string in an array:

#### **Expected Output (`configmap.yaml`)**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-release-regioninfo
data:
  regions:
    - "ohio"
    - "newyork"
    - "ontario"
    - "londion"
    - "singapore"
    - "mumbai"
```



### **Step-by-Step Breakdown**  

#### **Basic `ConfigMap` Structure**
First, the template starts with a basic `ConfigMap` structure:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-regioninfo
data:
  regions:
```
- `.Release.Name` dynamically injects the Helm release name.  
- The `regions` key is defined but initially empty.  



### **Using `range` to Iterate Over the List**  

Helm’s `range` function loops through the `regions` list and outputs each item:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-regioninfo
data:
  regions:
  {{- range .Values.regions }}
    - {{ . | quote }}
  {{- end }}
```



### **How It Works**
1. **Using `range`**
   - `range .Values.regions` iterates over the `regions` list in `values.yaml`.  
   - Within the loop, `.` represents the **current item** in the iteration (e.g., `ohio` in the first iteration).  

2. **Accessing List Elements**
   - Since `.` is already scoped to an individual region string, using `{{ . }}` inside the loop prints the value directly.  

3. **Adding Quotes Using the `quote` Function**
   - `{{ . | quote }}` ensures that each region is enclosed in double quotes.  
   - Without `quote`, YAML would treat values as unquoted strings.  



### **Scope in `range` Blocks**  
Just like `with`, the `range` block **changes the scope** during iteration:
- Initially, `.` represents the root scope.
- Inside `range .Values.regions`, `.` represents each list item (`ohio`, `newyork`, etc.).
- `$` can be used to access the root scope if needed.



### **Key Takeaways**  
- **Use `range` for looping** over lists in `values.yaml`.  
- **Inside `range`, `.` refers to the current item** in the list.  
- **Use `quote` to ensure proper YAML formatting** for string values.  
- **Use `$` to reference the root scope** if required inside a `range` block.  

This approach ensures **clean, structured, and dynamic Helm templates**.