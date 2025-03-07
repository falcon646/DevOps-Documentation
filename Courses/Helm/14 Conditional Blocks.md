### **Using Conditional Statements in Helm Templates**  

Helm templates support conditional logic, allowing the inclusion or exclusion of YAML sections based on user-defined values. This is useful for optional configurations like labels or resource creation.  



### **Adding Conditional Labels**  
Consider a `service.yaml` template file that includes an optional `orglabel`:  
```yaml
metadata:
  labels:
    app: my-app
    {{- if .Values.orglabel }}
    org: {{ .Values.orglabel }}
    {{- end }}
```  
- If `orglabel` is **defined** in `values.yaml`, it is included in the output manifest.  
- If `orglabel` is **not defined**, the `org` label is omitted entirely.  



### **Handling Whitespace in Helm Templates**  
Helm’s templating engine may leave extra spaces or blank lines when conditions are not met. This can be avoided by **trimming whitespace** using `-` after the curly braces:  
```yaml
metadata:
  labels:
    app: my-app
    {{- if .Values.orglabel }}  
    org: {{ .Values.orglabel }}  
    {{- end }}
```  
- The **dash (`-`)** ensures extra spaces and blank lines are removed.  
- Correct placement: `{{- if ... }}` and `{{- end }}` (no spaces before them).  



### **Using `if`, `else if`, and `else` Statements**  
Helm supports full conditional logic similar to programming languages. Instead of operators like `==`, Helm uses functions like `eq`:  
```yaml
{{- if eq .Values.orglabel "hr" }}
org: HR Department
{{- else if eq .Values.orglabel "finance" }}
org: Finance Department
{{- else }}
org: General
{{- end }}
```  
- `eq` (equal to) checks if `.Values.orglabel` matches `"hr"`.  
- `else if` allows multiple conditions.  
- `else` provides a fallback.  

### **Other Comparison Functions**  
| Function | Meaning | Example |
|-|||
| `eq` | Equal to | `eq .Values.value "test"` |
| `ne` | Not equal to | `ne .Values.value "test"` |
| `lt` | Less than | `lt .Values.count 10` |
| `le` | Less than or equal | `le .Values.count 10` |
| `gt` | Greater than | `gt .Values.count 5` |
| `ge` | Greater than or equal | `ge .Values.count 5` |
| `not` | Negation | `not .Values.enabled` |
| `empty` | Checks if empty | `empty .Values.list` |



### **Conditionally Creating Resources**  
A common use case is enabling or disabling a Kubernetes object based on user input. For example, a **ServiceAccount** should only be created if `serviceAccount.create` is `true`:  

```yaml
{{- if .Values.serviceAccount.create }}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service-account
{{- end }}
```  
- If `.Values.serviceAccount.create` is `true`, the ServiceAccount is included.  
- If `.Values.serviceAccount.create` is `false` or absent, the entire block is skipped.  



### **Summary**  
- Use `if` statements to include/exclude sections based on values.  
- Use `eq`, `ne`, `gt`, etc., for comparisons.  
- Trim whitespace with `{{- ... -}}` to avoid empty lines.  
- Apply conditionals to entire resources when optional.  

Helm’s conditional templating makes charts flexible and adaptable to various configurations.