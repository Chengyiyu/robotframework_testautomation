SH_PATH=$(dirname $(readlink -f $0))

chmod +x /$SH_PATH/geckodriver
chmod 777 /$SH_PATH/run.sh
mv geckodriver /usr/local/bin/
apt-get install ipmitool
pip3 install -r /$SH_PATH/requirements.txt
