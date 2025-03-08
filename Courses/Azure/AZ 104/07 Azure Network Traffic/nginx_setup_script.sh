#!/bin/bash
sudo apt update -y
sudo apt install sshpass -y
for i in {0..1}
do
j=$(($i + 4))
k=$(($i + 1))
greenIp="10.0.1.$j"
sshpass -p "Ashwin@989" \
ssh -o StrictHostKeyChecking=no ashwin@$greenIp bash -c  \
"'export VAR=$i
printenv | grep VAR
echo "Setting up green VM"
sudo apt install apache2 -y
sudo chmod -R -v 777 /var/www/
sudo mkdir -v /var/www/html/green/
sudo curl -o /var/www/html/index.html "https://raw.githubusercontent.com/rithinskaria/kodekloud-az500/main/000-Code%20files/AppGateway/sample.html"
sed -i "s/PAGECOLOR/green/g" /var/www/html/index.html
sed -i "s/VMID/'"$k"'/g" /var/www/html/index.html
cd /var/www/html/
cat index.html > green/green.html
exit
'"
done

for i in {0..1}
do
j=$(($i + 4))
k=$(($i + 1))
redIp="10.0.2.$j"
sshpass -p "Ashwin@989" \
ssh -o StrictHostKeyChecking=no ashwin@$redIp bash -c  \
"'export VAR=$i
printenv | grep VAR
echo "Setting up red VM"
sudo apt install apache2 -y
sudo chmod -R -v 777 /var/www/
sudo mkdir -v /var/www/html/red/
sudo curl -o /var/www/html/index.html "https://raw.githubusercontent.com/rithinskaria/kodekloud-az500/main/000-Code%20files/AppGateway/sample.html"
sed -i 's/PAGECOLOR/red/g' /var/www/html/index.html
sed -i 's/VMID/'"$k"'/g' /var/www/html/index.html
cd /var/www/html/
cat index.html > red/red.html
exit
'"

done

for i in {0..1}
do
j=$(($i + 4))
k=$(($i + 1))
blueIp="10.0.3.$j"
sshpass -p "Ashwin@989" \
ssh -o StrictHostKeyChecking=no ashwin@$blueIp bash -c  \
"'export VAR=$i
printenv | grep VAR
echo "Setting up blue VM"
sudo apt install apache2 -y
sudo chmod -R -v 777 /var/www/
sudo mkdir -v /var/www/html/blue/
sudo curl -o /var/www/html/index.html "https://raw.githubusercontent.com/rithinskaria/kodekloud-az500/main/000-Code%20files/AppGateway/sample.html"
sed -i "s/PAGECOLOR/blue/g" /var/www/html/index.html
sed -i "s/VMID/'"$k"'/g" /var/www/html/index.html
cd /var/www/html/
cat index.html > blue/blue.html
exit
'"
done
