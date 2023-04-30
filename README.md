# Computer Organization Docker


## Table of Contents
- [Host 檔案架構](#host-檔案架構)
- [Container 檔案架構](#container-檔案架構)
- [環境設定參數](#環境設定參數)
- [Python Module List](#python-module-list)
- [一般環境](#一般環境)



## Host 檔案架構
```bash
Computer-Organization-Docker
    ├── env_setup.sh            # environment variables
    ├── run.sh                  # environment setup script
    ├── run-docker.sh           # docker run script without nginx
    ├── Docker/
    │   ├── docker-compose.yml
    │   ├── Dockerfile
    │   ├── requirements.txt    # python module list
    │   ├── uWSGI.ini
    │   ├── nginx.conf
    │   └── start.sh            # container entrypoint
    ├── projects/               # projects repos without flask
```


## Container 檔案架構
```bash
workspace/
    ├── projects/       # ALL repos without flask
```




## Python Module List
```bash
# /Docker/requirements.txt

Flask==2.0.1
uWSGI==2.0.19
```

- 建議指定安裝版本，避免未來更新造成的相容性問題
- 查詢已安裝的套件清單 & 版本
    ```bash
    $ pip list
    ```


## 一般環境
- 在 [環境設定參數](#環境設定參數) 內設定 `RUN_FLASK=false`
- 宿主機 `./projects` 掛載於 `/workspace/projects`
- 可在 bash 使用 `ngrok` 直接呼叫預裝載的 ngrok
- 透過 `PORT_MAPPING` 指定宿主機與 container 相互映射的 port，並可透過分隔符號 `,` 同時指定多組映射

