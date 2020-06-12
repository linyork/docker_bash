#!/bin/bash
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
clear

# 版本號
_VERSION="v0.1.0"

while :
do
    echo -e "\033[32m__   __            _\033[0m"
    echo -e "\033[32m\ \ / /___   _ __ | | __ ___  _ __\033[0m"
    echo -e "\033[32m \ V // _ \ | '__|| |/ // _ \| '__|\033[0m"
    echo -e "\033[32m  | || (_) || |   |   <|  __/| |\033[0m"
    echo -e "\033[32m  |_| \___/ |_|   |_|\_\\___||_|\033[0m   \033[33m${_VERSION}\033[0m"
    echo -e "\033[32m----------------------------------------\033[0m"
    echo -e "a.\t\t開啟所有 container"
    echo -e "r.\t\t重開所有 container"
    echo -e "l.\t\t顯示所有 container"
    echo -e "c.\t\t關閉所有 container"
    echo -e "n.\t\t查看所有 container 網路"
    echo -e "i.\t\t進入 container"
    echo -e "q.\t\t跳出"
    echo -e "\033[32m----------------------------------------\033[0m"
    read -p "請輸入:" input

    clear

    case $input in
        a)
            # 啟動
            docker-compose up -d
            ;;
        r)
            # 重啟
            docker rm -f $(docker ps -a -q) | awk '{print "移除 \""$1"\" Container"}'
            docker-compose up -d
            ;;
        l)
            # 查看目前的 container
            docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.ID}}"
            ;;
        c)
            # 關閉 container
            docker rm -f $(docker ps -a -q) | awk '{print "移除 \""$1"\" Container"}'
            ;;
        n)
            # 查看所有 container 的網路狀況
            docker ps -q | xargs docker inspect --format="容器名稱{{.Name}}......{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}"
            ;;
        i)
            # 進入 container
            docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.ID}}"
            echo "請輸入 container name"
            read -p "Name:" containerName
            clear
            if [[ ${containerName} ]]; then
                docker exec -it ${containerName} bash
            fi
            ;;
        *)
            # 離開程序
            exit
            ;;
    esac
done
