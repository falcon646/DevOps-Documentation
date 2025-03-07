# Variables

- Variable can be assigned values in 4  ways
    - Explicit `NAME="ashwin somnath"` , `AGE=28`
    - User input `read PHONE`
    - Command susbsitution `TIMESTAMP=$(date)`
    - Using Environment Variables `export PATH="/usr/local/bin:$PATH"`

- Accessing Variables
    - Once a variable is assigned a value, it can be accessed using
        - `$VAR_NAME`
        - `${VAR_NAME}` : Using curly braces helps avoid confusion when the variable is followed by other characters: