```bash
# find the name of package bases on a string
yum whatprovides <name>
yum whatprovides java

# exract tar into specific location
tar -xvzf <name.tar> -C /<destination-path>
# x = extract , v = verbose , z = zip alogorihm , f = file

# to find file (whooes name you have some idea off) in a dirctory
find /dir-name -name "part-of-file-name*"
find /opt/tomcat -name "server*"
find /opt/tomcat -name "part1*part2*"

# flags to specify destination for different binaries
wget : -P /destination
tar  : -C /destination
unzip: -d /destination
```