#!/bin/bash  
#install  
  
command=$1  
username=$2  
host=$3  
  
  
  
function info(){  
    echo 'use ./deploy.sh command [username] [host]'  
    echo 'command:'  
    echo '0  -- exec all action,contains:install makeRpm upload'  
    echo '1  -- exec install'  
    echo '2  -- exec makeRpm'  
    echo '3  -- exec upload,the username and host only affect this action.'  
}  
  
function all(){  
    install   
    makeRpm  
    upload  
}  
  
function install(){  
    echo 'mvn install'  
    mvn clean install -Denv=release -Dmaven.test.skip=true >>/dev/null  
}  
  
function makeRpm(){  
    echo 'make-rpm,please make u rpm version is 4.4.x'  
    ./make-rpm.sh>>/dev/null  
}  
  
function upload(){  
    echo 'upload the rpm to server'  

    mvn deploy:deploy-file -DgroupId=ttlibs -DartifactId=ttlibs -Dversion=2.0 -Dpackaging=jar -Dfile=/Users/zhang333/MyWorks/Code/ttlibs/target/ttlibs-2.0.jar -Durl=http://localhost:8081/maven-zch-host -DrepositoryId=maven-zch-host


    if [ -z $username ];then  
        username='xxx'  
    fi  
    if [ -z $host ];then  
        host='xx.xx.xx.xx'  
    fi  
    scp ./target/rpm/RPMS/noarch/*.rpm $username@$host:/home/$username/ >>/dev/null  
}  
  
#start execute  
info  
echo 'deploy start'  
if [ -z $command -o $command = 0 ];then  #这里面-o是或的关系，-a是and关系  
        all  
    elif [ $command = 1 ];then  
        install  
    elif [ $command = 2 ];then  
        makeRpm   
    elif [ $command = 3 ];then  
        upload    
fi  
  
echo 'deploy success!'  