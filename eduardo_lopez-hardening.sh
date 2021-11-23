#!/usr/bin/bash 
#Autor: Eduardo Lopez Solis 1865221

listado=$(yum list installed | grep '^clamav')
version=$(grep 'VERSION_ID' /etc/os-release)

#1. Script will identify the version of the operating system and EPEL will be installed only on Centos v7 servers 

echo '******************************PROCEEDING TO IDENTIFY THE VERSION OF OS**********************************'
if [[ $version = 'VERSION_ID="8"' ]];
then
  echo '*********************************************************************************************************'
  echo '*************************************YOUR OS IS CentOS v8************************************************'
  echo '*********************************************************************************************************'
  echo '*********************************************************************************************************'
  echo '************************EPEL WILL NOT BE INSTALLED DUE TO THE CENTOS VERSION*****************************'
  echo '*********************************************************************************************************'
  
  #2. Clamav antivirus will be installed or reinstalled if it is already installed 
  
  if [[ $listado = "" ]];
  then
    echo '*********************************************************************************************************'
    echo '**********************************CLAMAV IS NOT INSTALLED************************************************'
    echo '***********************************PROCEEDING TO INSTALL*************************************************'
    echo '*********************************************************************************************************'
    yum -y install https://www.clamav.net/downloads/production/clamav-0.104.1.linux.x86_64.rpm
    echo '*********************************************************************************************************'
    echo '***************************************SUCCESSFULLY INSTALLED********************************************'
    echo '*********************************************************************************************************'
  else
    echo '*********************************************************************************************************'
    echo '**************************CLAMAV IS ALREADY INSTALLED, PROCEEDING TO UNINSTALL***************************'
    echo '*********************************************************************************************************'
    yum -y erase clamav*
    echo '*********************************************************************************************************'
    echo '*************************************PROCEEDING TO INSTALL***********************************************'
    echo '*********************************************************************************************************'
    yum -y install https://www.clamav.net/downloads/production/clamav-0.104.1.linux.x86_64.rpm
    echo '*********************************************************************************************************'
    echo '***************************************SUCCESSFULLY INSTALLED********************************************'
    echo '*********************************************************************************************************'
  fi
elif [[ $version = 'VERSION_ID="7"' ]];
then
  echo '*********************************************************************************************************'
  echo '*************************************YOUR OS IS CentOS v7************************************************'
  echo '*********************************************************************************************************'
  echo '*********************************************************************************************************'
  echo '****************************CENTOS v7 DETECTED, EPEL WILL BE INSTALLED***********************************'
  echo '*********************************************************************************************************'
  yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 
  if [[ $listado = "" ]];
  then
    echo '*********************************************************************************************************'
    echo '**********************************CLAMAV IS NOT INSTALLED************************************************'
    echo '***********************************PROCEEDING TO INSTALL*************************************************'
    echo '*********************************************************************************************************'
    yum -y install clamav
    echo '*********************************************************************************************************'
    echo '***************************************SUCCESSFULLY INSTALLED********************************************'
    echo '*********************************************************************************************************'
  else
    echo '*********************************************************************************************************'
    echo '**************************CLAMAV IS ALREADY INSTALLED, PROCEEDING TO UNINSTALL***************************'
    echo '*********************************************************************************************************'
    yum -y erase clamav*
    echo '*********************************************************************************************************'
    echo '*************************************PROCEEDING TO INSTALL***********************************************'
    echo '*********************************************************************************************************'
    yum -y install clamav
    echo '*********************************************************************************************************'
    echo '***************************************SUCCESSFULLY INSTALLED********************************************'
    echo '*********************************************************************************************************'
  fi
fi

#4. Packages with available updates will be updated 

if [[ $(yum check-update -q | awk '{print $1}') = "" ]];
then
  echo '*******************************************************************************************************'
  echo '**********************************NO PACKAGE NEEDS TO UPDATE*******************************************' 
  echo '*******************************************************************************************************'
else
  echo '******************************THE PACKAGES WITH UPDATES AVAILABLE ARE THESE******************************' 
  echo '*********************************************************************************************************'
  yum check-update -q | awk '{print $1}'
  echo '*********************************************************************************************************'
  echo '*******************************PACKAGES WILL BE UPDATED**************************************************'
  echo '*********************************************************************************************************'
  for line in $(yum check-update -q | awk '{print $1}');
  do
    yum -y update $line
    echo '*********************************************************************************************************'
    echo '****************************THE PACKAGE WAS SUCCESSFULLY UPDATED*****************************************'
    echo '*********************************************************************************************************'
done

exit 0
fi
