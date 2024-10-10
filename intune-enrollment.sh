#!/bin/bash

# Check Ubuntu version
ubuntu_version=$(lsb_release -rs)

if [ "$ubuntu_version" == "22.04" ]; then
  # Edge Intune (Ubuntu 22.04)
  apt-get update && apt-get install -y software-properties-common apt-transport-https wget curl gpg
  wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
  add-apt-repository 'deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main'
  apt-get update && apt-get install -y microsoft-edge-dev
  apt-get upgrade -y
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main' > /etc/apt/sources.list.d/microsoft-ubuntu-jammy-prod.list
  rm microsoft.gpg
  apt-get update && apt-get install -y intune-portal

elif [ "$ubuntu_version" == "24.04" ]; then
  # Edge Intune (Ubuntu 24.04)
  echo 'Types: deb
URIs: http://archive.ubuntu.com/ubuntu
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://nl.archive.ubuntu.com/ubuntu/
Suites: mantic
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: mantic-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg' > /etc/apt/sources.list.d/ubuntu.sources
  apt-get update && apt-get install -y curl gpg sudo
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main' > /etc/apt/sources.list.d/microsoft-ubuntu-jammy-prod.list
  rm microsoft.gpg
  apt-get update
  apt-get install -y openjdk-11-jre libicu72 libjavascriptcoregtk-4.0-18 libwebkit2gtk-4.0-37
  apt-get install -y intune-portal
  sed -i 's|JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64|JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64|' /lib/systemd/user/microsoft-identity-broker.service
  sed -i 's|JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64|JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64|' /lib/systemd/system/microsoft-identity-device-broker.service
  apt-get install -y equivs
  echo 'Section: misc
Priority: optional
Standards-Version: 3.9.2

Package: default-jre-dummy
Maintainer: Dummy Nobody
Provides: default-jre
Description: Dummy package to satisfy default-jre dependency' > default-jre-dummy
  equivs-build default-jre-dummy
  dpkg -i default-jre-dummy_1.0_all.deb

else
  echo "Unsupported Ubuntu version: $ubuntu_version"
  exit 1
fi
