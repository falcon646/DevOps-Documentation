### Yaml Syntax

1. For simple key pair value
```yaml
Key1: value
key2: value
```
2. List (sequence of values):

A key can contain multiple values and they are referesneted with a "-" in a new line.
the "-" can be placed with/without any space before it, but all values should be indented the same 
```yaml
key1:
- ashwin
- somnath

key2:
    - value1
    - value2
    - value3
```
Here, key1 is a list (or sequence) containing two values (ashwin and somnath). 
Lists in YAML are represented by using a hyphen (-) followed by the value. 
Lists are ordered, and each item in the list is identified by its position.

3. Dictionary (collection of key-value pairs):

Dictionary Mappings are collections of key-value pairs.
```yaml
name:
  firstname: ashwin
  lastname: somnath
```
In this case, name is a dictionary with two key-value pairs (firstname and lastname). It is a structured way of organizing data where each key is associated with a corresponding value.  
```yaml
person:
  name: John
  age: 30
  city: Anytown
```

4. Objects 
In YAML, you can represent objects using a combination of mappings (dictionaries) and sequences (lists). Here's an example illustrating how to represent an object:
```yaml
person:
  name:
    first_name: John
    last_name: Doe
  age: 30
  address:
    street: 123 Main St
    city: Anytown
    country: USA
  hobbies:
    - reading
    - hiking
    - coding
```
In this example:

person is a dictionary with multiple key-value pairs.
name is a nested dictionary within the person dictionary, representing the person's name with first_name and last_name.
age is a simple key-value pair representing the person's age.
address is another nested dictionary with details about the person's address.
hobbies is a list containing multiple items.<p>

To represent multiple objects in YAML, you can use a list (sequence) where each item in the list is an object. 
Here's an example with two objects:
```yaml
- person:
    name:
      first_name: John
      last_name: Doe
    age: 30
    address:
      street: 123 Main St
      city: Anytown
      country: USA
    hobbies:
      - reading
      - hiking
      - coding

- person:
    name:
      first_name: Jane
      last_name: Smith
    age: 25
    address:
      street: 456 Oak St
      city: Anothercity
      country: Canada
    hobbies:
      - painting
      - traveling
```


