#!/bin/bash

CONFIG_FILE='moondex.conf'
CONFIGFOLDER='/root/.moondexcore'
CONFIGFOLDER2='/root/.moondexcore2'
CONFIGFOLDER3='/root/.moondexcore3'
COIN_DAEMON='/root/mdex-ip-install/moondexd'
COIN_CLI='/root/mdex-ip-install/moondex-cli'
COIN_DAEMON2='moondexd'
COIN_CLI2='moondex-cli'
COIN_PATH='/usr/local/bin/'
COIN_TGZ='https://github.com/Moondex/MoonDEXCoin/releases/download/v2.0.1.1/linux-no-gui-v2.0.1.1.tar.gz'
COIN_ZIP='/root/medx-ip-install/linux-no-gui-v2.0.1.1.tar.gz'
COIN_NAME='mdex'
COIN_NAME2='mdex2'
COIN_NAME3='mdex3'
COIN_PORT=8906
RPC_PORT=8960
RPC_PORT2=8961
RPC_PORT3=8962

NODEIP=$(curl -s4 api.ipify.org)
NODEIP2=$(curl -s4 api.ipify.org)
NODEIP3=$(curl -s4 api.ipify.org)


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'


function download_node() {
  echo -e "Preparing to download ${GREEN}$COIN_NAME${NC}."
  wget -q $COIN_TGZ
  compile_error
  tar -zxvf $COIN_ZIP
  chmod +x $COIN_DAEMON $COIN_CLI
  chown root: $COIN_DAEMON $COIN_CLI
  cp $COIN_DAEMON $COIN_PATH
  cp $COIN_CLI $COIN_PATH
  cd /root/mdex-ip-install/
  chmod 740 mnchecker
  chmod 740 mnchecker2
  chmod 740 mnchecker3
  clear
}


function configure_systemd() {
  cat << EOF > /etc/systemd/system/$COIN_NAME.service
[Unit]
Description=$COIN_NAME service
After=network.target

[Service]
User=root
Group=root

Type=forking
#PIDFile=$CONFIGFOLDER/$COIN_NAME.pid

ExecStart=$COIN_PATH$COIN_DAEMON2 -daemon -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER
ExecStop=-$COIN_PATH$COIN_CLI2 -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_NAME.service
  systemctl enable $COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME.service"
    echo -e "systemctl status $COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}

function configure_systemd2() {
  cat << EOF > /etc/systemd/system/$COIN_NAME2.service
[Unit]
Description=$COIN_NAME2 service
After=network.target

[Service]
User=root
Group=root

Type=forking
#PIDFile=$CONFIGFOLDER2/$COIN_NAME2.pid

ExecStart=$COIN_PATH$COIN_DAEMON2 -daemon -conf=$CONFIGFOLDER2/$CONFIG_FILE -datadir=$CONFIGFOLDER2
ExecStop=-$COIN_PATH$COIN_CLI2 -conf=$CONFIGFOLDER2/$CONFIG_FILE -datadir=$CONFIGFOLDER2 stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_NAME2.service
  systemctl enable $COIN_NAME2.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME2 is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME2.service"
    echo -e "systemctl status $COIN_NAME2.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}

function configure_systemd3() {
  cat << EOF > /etc/systemd/system/$COIN_NAME3.service
[Unit]
Description=$COIN_NAME3 service
After=network.target

[Service]
User=root
Group=root

Type=forking
#PIDFile=$CONFIGFOLDER3/$COIN_NAME3.pid

ExecStart=$COIN_PATH$COIN_DAEMON2 -daemon -conf=$CONFIGFOLDER3/$CONFIG_FILE -datadir=$CONFIGFOLDER3
ExecStop=-$COIN_PATH$COIN_CLI2 -conf=$CONFIGFOLDER3/$CONFIG_FILE -datadir=$CONFIGFOLDER3 stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_NAME3.service
  systemctl enable $COIN_NAME3.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME3 is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME.service"
    echo -e "systemctl status $COIN_NAME3.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}


function create_config2() {
  mkdir $CONFIGFOLDER2 >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER2/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT2
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
port=$COIN_PORT
addnode=140.82.48.96:8906
addnode=207.148.102.250:8906
addnode=139.162.238.190:8906
addnode=104.236.208.223:8906
addnode=207.154.252.125:8906
addnode=79.137.56.119:8906
addnode=91.134.232.237:8906
addnode=87.98.233.148:8906
addnode=147.135.201.197:8906
addnode=217.182.36.218:8906
addnode=209.250.227.90:8906
addnode=176.31.214.147:8906
addnode=188.165.10.239:8906
addnode=54.36.5.66:8906
addnode=178.32.52.45:8906
addnode=145.239.109.60:8906
addnode=54.38.165.182:8906
addnode=46.105.62.116:8906
addnode=136.144.179.195:8906
addnode=188.166.158.183:8906
addnode=164.132.88.93:8906
addnode=80.240.20.72:8906
addnode=217.69.0.232:8906
addnode=189.27.85.75:8906
addnode=95.179.133.241:8906
addnode=144.202.86.130:8906
addnode=207.148.104.192:8906
EOF
}

function create_config3() {
  mkdir $CONFIGFOLDER3 >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER3/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT3
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
port=$COIN_PORT
addnode=140.82.48.96:8906
addnode=207.148.102.250:8906
addnode=139.162.238.190:8906
addnode=104.236.208.223:8906
addnode=207.154.252.125:8906
addnode=79.137.56.119:8906
addnode=91.134.232.237:8906
addnode=87.98.233.148:8906
addnode=147.135.201.197:8906
addnode=217.182.36.218:8906
addnode=209.250.227.90:8906
addnode=176.31.214.147:8906
addnode=188.165.10.239:8906
addnode=54.36.5.66:8906
addnode=178.32.52.45:8906
addnode=145.239.109.60:8906
addnode=54.38.165.182:8906
addnode=46.105.62.116:8906
addnode=136.144.179.195:8906
addnode=188.166.158.183:8906
addnode=164.132.88.93:8906
addnode=80.240.20.72:8906
addnode=217.69.0.232:8906
addnode=189.27.85.75:8906
addnode=95.179.133.241:8906
addnode=144.202.86.130:8906
addnode=207.148.104.192:8906
EOF
}

function create_config() {
  mkdir $CONFIGFOLDER >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
port=$COIN_PORT
addnode=140.82.48.96:8906
addnode=207.148.102.250:8906
addnode=139.162.238.190:8906
addnode=104.236.208.223:8906
addnode=207.154.252.125:8906
addnode=79.137.56.119:8906
addnode=91.134.232.237:8906
addnode=87.98.233.148:8906
addnode=147.135.201.197:8906
addnode=217.182.36.218:8906
addnode=209.250.227.90:8906
addnode=176.31.214.147:8906
addnode=188.165.10.239:8906
addnode=54.36.5.66:8906
addnode=178.32.52.45:8906
addnode=145.239.109.60:8906
addnode=54.38.165.182:8906
addnode=46.105.62.116:8906
addnode=136.144.179.195:8906
addnode=188.166.158.183:8906
addnode=164.132.88.93:8906
addnode=80.240.20.72:8906
addnode=217.69.0.232:8906
addnode=189.27.85.75:8906
addnode=95.179.133.241:8906
addnode=144.202.86.130:8906
addnode=207.148.104.192:8906
EOF
}

function installsentinel() {
echo "Installing sentinel..."
cd /root/.moondexcore
sudo apt-get install -y git python-virtualenv

wget https://github.com/Moondex/moondex_sentinel/archive/master.zip
unzip master.zip
mv moondex_sentinel-master moondex_sentinel

cd moondex_sentinel

export LC_ALL=C
sudo apt-get install -y virtualenv

virtualenv ./venv
./venv/bin/pip install -r requirements.txt

echo "moondex_conf=/root/.moondexcore/moondex.conf" >> /root/.moondexcore/moondex_sentinel/sentinel.conf

cd /root/.moondexcore2
sudo apt-get install -y git python-virtualenv

wget https://github.com/Moondex/moondex_sentinel/archive/master.zip
unzip master.zip
mv moondex_sentinel-master moondex_sentinel

cd moondex_sentinel

export LC_ALL=C
sudo apt-get install -y virtualenv

virtualenv ./venv
./venv/bin/pip install -r requirements.txt

echo "moondex_conf=/root/.moondexcore2/moondex.conf" >> /root/.moondexcore2/moondex_sentinel/sentinel.conf

cd /root/.moondexcore3
sudo apt-get install -y git python-virtualenv

wget https://github.com/Moondex/moondex_sentinel/archive/master.zip
unzip master.zip
mv moondex_sentinel-master moondex_sentinel

cd moondex_sentinel

export LC_ALL=C
sudo apt-get install -y virtualenv

virtualenv ./venv
./venv/bin/pip install -r requirements.txt

echo "moondex_conf=/root/.moondexcore3/moondex.conf" >> /root/.moondexcore3/moondex_sentinel/sentinel.conf

echo "Adding crontab jobs..."
crontab -l > tempcron
#echo new cron into cron file
echo "* * * * * cd /root/.moondexcore/moondex_sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> tempcron
echo "@reboot /bin/sleep 20 ; /root/moondex/moondexd -daemon &" >> tempcron
echo "*/15 * * * * /root/mdex-ip-install/mnchecker >> /root/mdex-ip-install/checker.log 2>&1" >> tempcron
echo "* * * * * cd /root/.moondexcore2/moondex_sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> tempcron
echo "@reboot /bin/sleep 20 ; /usr/local/bin/moondex/moondexd -datadir=/root/.moondexcore2 -daemon &" >> tempcron
echo "*/15 * * * * /root/mdex-ip-install/mnchecker2 >> /root/mdex-ip-install/checker2.log 2>&1" >> tempcron
echo "* * * * * cd /root/.moondexcore3/moondex_sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> tempcron
echo "@reboot /bin/sleep 20 ; /usr/local/bin/moondex/moondexd -datadir=/root/.moondexcore3 -daemon &" >> tempcron
echo "*/15 * * * * /root/mdex-ip-install/mnchecker3 >> /root/mdex-ip-install/checker3.log 2>&1" >> tempcron
}

#install new cron file
crontab tempcron
rm tempcron


function create_key2() {
  echo -e "Enter your ${RED}$COIN_NAME2 Masternode Private Key${NC}. Leave it blank to generate a new ${RED}Masternode Private Key${NC} for you:"
  read -e COINKEY2
  if [[ -z "$COINKEY2" ]]; then
  $COIN_PATH$COIN_DAEMON2 -daemon
  sleep 30
  if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON2)" ]; then
   echo -e "${RED}$COIN_NAME2 server couldn not start. Check /var/log/syslog for errors.{$NC}"
   exit 1
  fi
  COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  if [ "$?" -gt "0" ];
    then
    echo -e "${RED}Wallet not fully loaded. Let us wait and try again to generate the Private Key${NC}"
    sleep 30
    COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  fi
  $COIN_PATH$COIN_CLI2 stop
fi
clear
}

function create_key3() {
  echo -e "Enter your ${RED}$COIN_NAME3 Masternode Private Key${NC}. Leave it blank to generate a new ${RED}Masternode Private Key${NC} for you:"
  read -e COINKEY3
  if [[ -z "$COINKEY3" ]]; then
  $COIN_PATH$COIN_DAEMON2 -daemon
  sleep 30
  if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON2)" ]; then
   echo -e "${RED}$COIN_NAME3 server couldn not start. Check /var/log/syslog for errors.{$NC}"
   exit 1
  fi
  COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  if [ "$?" -gt "0" ];
    then
    echo -e "${RED}Wallet not fully loaded. Let us wait and try again to generate the Private Key${NC}"
    sleep 30
    COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  fi
  $COIN_PATH$COIN_CLI2 stop
fi
clear
}

function create_key() {
  echo -e "Enter your ${RED}$COIN_NAME Masternode Private Key${NC}. Leave it blank to generate a new ${RED}Masternode Private Key${NC} for you:"
  read -e COINKEY
  if [[ -z "$COINKEY" ]]; then
  $COIN_PATH$COIN_DAEMON2 -daemon
  sleep 30
  if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON2)" ]; then
   echo -e "${RED}$COIN_NAME server couldn not start. Check /var/log/syslog for errors.{$NC}"
   exit 1
  fi
  COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  if [ "$?" -gt "0" ];
    then
    echo -e "${RED}Wallet not fully loaded. Let us wait and try again to generate the Private Key${NC}"
    sleep 30
    COINKEY=$($COIN_PATH$COIN_CLI2 masternode genkey)
  fi
  $COIN_PATH$COIN_CLI2 stop
fi
clear
}

function update_config() {
  sed -i 's/daemon=1/daemon=1/' $CONFIGFOLDER/$CONFIG_FILE
  cat << EOF >> $CONFIGFOLDER/$CONFIG_FILE
logintimestamps=1
maxconnections=256
bind=$IP
masternode=1
externalip=$IP:$COIN_PORT
masternodeprivkey=$COINKEY
EOF
}

function update_config2() {
  sed -i 's/daemon=1/daemon=1/' $CONFIGFOLDER2/$CONFIG_FILE
  cat << EOF >> $CONFIGFOLDER2/$CONFIG_FILE
logintimestamps=1
maxconnections=256
bind=$IP2
masternode=1
externalip=$IP2:$COIN_PORT
masternodeprivkey=$COINKEY2
EOF
}

function update_config3() {
  sed -i 's/daemon=1/daemon=1/' $CONFIGFOLDER3/$CONFIG_FILE
  cat << EOF >> $CONFIGFOLDER3/$CONFIG_FILE
logintimestamps=1
maxconnections=256
bind=$IP3
masternode=1
externalip=$IP3:$COIN_PORT
masternodeprivkey=$COINKEY3
EOF
}

function enable_firewall() {
  echo -e "Installing and setting up firewall to allow ingress on port ${GREEN}$COIN_PORT${NC}"
  ufw allow $COIN_PORT/tcp comment "$COIN_NAME MN port" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  ufw default allow outgoing >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
}


function get_ip() {
  echo -e "Enter the IP for ${RED}$COIN_NAME ${NC}:"
  read -e IP
  echo -e "Enter the IP for ${RED}$COIN_NAME2 ${NC}:"
  read -e IP2
  echo -e "Enter the IP for ${RED}$COIN_NAME3 ${NC}:"
  read -e IP3
clear
}



function checks() {
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi

if [ -n "$(pidof $COIN_DAEMON2)" ] || [ -e "$COIN_DAEMOM2" ] ; then
  echo -e "${RED}$COIN_NAME is already installed.${NC}"
  exit 1
fi
}

function prepare_system() {
echo -e "Preparing the system to install ${GREEN}$COIN_NAME${NC} master node."
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt install -y software-properties-common >/dev/null 2>&1
echo -e "${GREEN}Adding bitcoin PPA repository"
apt-add-repository -y ppa:bitcoin/bitcoin >/dev/null 2>&1
echo -e "Installing required packages, it may take some time to finish.${NC}"
apt-get update >/dev/null 2>&1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make libzmq3-dev zip unzip \
libminiupnpc-dev build-essential libssl-dev libminiupnpc-dev libevent-dev >/dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install software-properties-common"
    echo "apt-add-repository -y ppa:bitcoin/bitcoin"
    echo "apt-get update"
    echo "apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev libdb5.3++ unzip libzmq5"
 exit 1
fi
clear
}

function important_information() {
 echo -e "================================================================================================================================"
 echo -e "$COIN_NAME Masternode is up and running listening on port ${RED}$COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$CONFIGFOLDER/$CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $COIN_NAME.service${NC}"
 echo -e "VPS_IP:PORT ${RED}$NODEIP:$COIN_PORT${NC}"
 echo -e "MASTERNODE PRIVATEKEY is: ${RED}$COINKEY${NC}"
 echo -e "Please check ${RED}$COIN_NAME${NC} daemon is running with the following command: ${RED}systemctl status $COIN_NAME.service${NC}"
 echo -e "Use ${RED}$COIN_CLI2 masternode status${NC} to check your MN.${NC}"
 echo -e "JOIN CHT SHARED MN SERVICE LOCATED HERE: ${GREEN}http://mns.cryptohashtank.net"${NC}
 if [[ -n $SENTINEL_REPO  ]]; then
  echo -e "${RED}Sentinel${NC} is installed in ${RED}$CONFIGFOLDER/sentinel${NC}"
  echo -e "Sentinel logs is: ${RED}$CONFIGFOLDER/sentinel.log${NC}"
  echo -e "CHT SHARED MN SERVICE LOCATED HERE: ${GREEN}http://mns.cryptohashtank.net"${NC}
 fi
 echo -e "================================================================================================================================"
}

function setup_node() {
  get_ip
  create_config
  create_config2
  create_config3
  create_key
  create_key2
  create_key3
  update_config
  update_config2
  update_config3
  enable_firewall
  important_information
  configure_systemd
  configure_systemd2
  configure_systemd3
  installsentinel
}


##### Main #####
clear

checks
prepare_system
download_node
setup_node
