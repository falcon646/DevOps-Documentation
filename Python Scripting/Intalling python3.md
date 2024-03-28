## Installing python 3 from source on Linux alongside python 2

```bash
# download the source
wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz

# extract to /opt
sudo tar -xvzf Python-3.10.14.tgz -C /opt/
sudo mv /opt/Python-3.10.14/ /opt/python

# install other dependenies
sudo yum update
sudo yum install gcc openssl-devel bzip2-devel libffi-devel

# run the python configure file to configure the build
cd /opt/python
./configure
# you can provide custom installtion path with flag `--prefix=/usr/bin`. if you dont provide the path , default installation path is /usr/local/bin/

# complile the build
make

# install the compliled program
# if you do not have any other python version
make install
# if you have other python version aleady installed
make altinstall
```
- python will be installed at `/usr/local/bin`
- check python version `python3 --version`
- check pip vserion `pip --version`
