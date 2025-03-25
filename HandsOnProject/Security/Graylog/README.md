# Graylog를 통한 CloudTrail 로그 관리
<br>
![image](https://github.com/user-attachments/assets/9dadd1c2-a1bf-4cb0-9dc1-f66fb5e6a2ec)
<br>
- AWS Cloud Trail → AWS Cloud Watch → AWS Kinesis Data Stream → Graylog <br>

- Graylog는 Private 환경으로 구성하였고 같은 Private Subnet에 Windows 서버를 생성하여 Windows 서버에서 웹페이지에 접속 가능하게 설정하였습니다. <br>

- 만약 외부에서 사용을 원한다면 인프라 구성 앞단에 방화벽 장비와 ALB를 두어 보안적인 부분을 구성하여 사용하면 되지만 이번 내용에서는 Private Subnet에 구성하였습니다.  <br>
<br> <br>

## Graylog 서버 스펙
- OS : Amazon Linux 2023
- Type : m5.large
- Disk : 50GB
<br> <br> <br>
## Graylog 서버 구성 방법
- Docker-compose를 통한 구성
<br> <br> <br>

## 1. Docker 설치
Docker 패키지 설치
```bash
$ sudo yum install -y docker
```
<br> <br>

Docker 서비스 시작
``` bash
$ sudo systemctl start docker
```
<br> <br>

Docker 서비스 부팅 시 자동 시작 설정
``` bash
$ sudo systemctl enable docker
```
 <br> <br>

현재 사용자에게 Docker 실행 권한 부여
``` bash
$ sudo usermod -aG docker $USER
```
<br> <br> <br> <br>

## 2. Dcoekr-compose 설치
최신 Docker Compose 버전 가져오기
``` bash
$ LATEST_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)
```
<br><br>

Docker Compose 바이너리 다운로드
``` bash
$ sudo curl -L "https://github.com/docker/compose/releases/download/${LATEST_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
<br> <br>

실행 권한 부여
``` bash
$ sudo chmod +x /usr/local/bin/docker-compose
```
<br> <br> <br> <br>
## 3. docker-compose.yml 구성
``` bash
$ sudo vi docker-compose.yml
```
자세한 내용은 docker-compose.yml 참조
<br> <br> <br> <br>
## 4. .env 구성
``` bash
$ sudo vi .env
```
자세한 내용은 .env.example 참조
<br> <br> <br> <br>
## 5. 암호 발급
pwgen 설치
``` bash
$ sudo yum install -y pwgen
```
<br><br>

1개의 보안성이 높은 96자리 랜덤 패스워드 생성
``` bash
$ sudo pwgen -N 1 -s 96
```
<br> <br>

패스워드를 sha-256 해시 함수로 변환
``` bash
$ sudo echo -n [사용자 패스워드] | sha256sum
```
<br> <br>

.env에 패스워드 입력
``` bash
# You MUST set a secret to secure/pepper the stored user passwords here. Use at least 64 characters.
# Generate one by using for example: pwgen -N 1 -s 96
# ATTENTION: This value must be the same on all Graylog nodes in the cluster.
# Changing this value after installation will render all user sessions and encrypted values in the database invalid. (e.g. encrypted access tokens)
GRAYLOG_PASSWORD_SECRET="[pwgen으로 생성한 패스워드 입력]"

# You MUST specify a hash password for the root user (which you only need to initially set up the
# system and in case you lose connectivity to your authentication backend)
# This password cannot be changed using the API or via the web interface. If you need to change it,
# modify it in this file.
# Create one by using for example: echo -n yourpassword | shasum -a 256
# and put the resulting hash value into the following line
# CHANGE THIS!
GRAYLOG_ROOT_PASSWORD_SHA2="[sha-256 해시 함수로 변환한 패스워드 입력]"
```
<br> <br> <br>


## 6. Graylog 설정 확인
Linux 커널 파라미터 변경 (Datanode는 많은 메모리 매핑을 필요로 함)
``` bash
$ echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
$ sudo sysctl -p
```
<br> <br>

Graylog 실행 확인
``` bash
$ sudo docker-compose logs graylog
```
<br>

``` bash
...
graylog-1  | 2025-03-23 07:44:50,940 INFO : org.glassfish.grizzly.http.server.NetworkListener - Started listener bound to [0.0.0.0:9000]
graylog-1  | 2025-03-23 07:44:50,942 INFO : org.glassfish.grizzly.http.server.HttpServer - [HttpServer] Started.
graylog-1  | 2025-03-23 07:44:50,945 INFO : org.graylog2.bootstrap.preflight.PreflightJerseyService - 
graylog-1  |                                                              ---
graylog-1  |                                                              ---
graylog-1  |                                                              ---
graylog-1  |     ########  ###   ######### ##########   ####         #### ---         .----               ----
graylog-1  |   ###############   ###################### #####       ####  ---      ------------       .----------- --
graylog-1  |  #####     ######   #####              #### ####      ####   ---     ---        ---     ---        -----
graylog-1  | ####         ####   ####       ############  ####     ####   ---    --           ---   ---           ---
graylog-1  | ###           ###   ####     ##############   ####   ####    ---   ---            --   --             --
graylog-1  | ####         ####   ####    ####       ####    #### ####     ---   ---            --   --            .--
graylog-1  | #####       #####   ####    ####       ####     #######      ---    ---          ---   ---           ---
graylog-1  |  ################   ####     ##############     ######-       --     ----      ----      ---       -----
graylog-1  |    ##############   ####      #############      #####        -----   -----------         ----------  --
graylog-1  |              ####                                ####                                                ---
graylog-1  | #####       ####                                ####                                     -          .--
graylog-1  |   #############                                ####                                     -----     ----
graylog-1  |      ######                                   ####                                          -------
graylog-1  | 
graylog-1  | ========================================================================================================
graylog-1  | 
graylog-1  | It seems you are starting Graylog for the first time. To set up a fresh install, a setup interface has
graylog-1  | been started. You must log in to it to perform the initial configuration and continue.
graylog-1  | 
graylog-1  | Initial configuration is accessible at 0.0.0.0:9000, with username 'admin' and password '########'.
graylog-1  | Try clicking on http://admin:#########@0.0.0.0:9000
graylog-1  | 
graylog-1  | ========================================================================================================
graylog-1  | 
...
```
<br> <br> <br>
## 7. Graylog 웹페이지 접속
Graylog 웹페이지 접속 (http://[graylog_serverip:포트])
![image](https://github.com/user-attachments/assets/ff07bf1a-2749-4d0c-be49-9d7333d33196)
<br>

웹페이지 초기 세팅 진행
![2](https://github.com/user-attachments/assets/e9dcbe82-2b41-4563-8b15-f6a0d9ba8f11)
<br>

<br> <br> <br>
## 8. Graylog와 AWS Cloud Watch 연동
![77](https://github.com/user-attachments/assets/c8381ccd-58e7-4880-8e86-170861af4c09)

![88](https://github.com/user-attachments/assets/b61b9387-53e9-46b6-aa4c-a9537e49e4b1)

![99](https://github.com/user-attachments/assets/99f42805-b441-4c85-a652-5e4c04251750)

![8899](https://github.com/user-attachments/assets/e8c0c74d-22c8-444b-bda6-cb6503dde596)

![9900](https://github.com/user-attachments/assets/f87a1156-20b1-4675-817b-cf44067f1430)

![13](https://github.com/user-attachments/assets/6766adb7-4f98-4df0-9108-53a7d38165f2)

![44](https://github.com/user-attachments/assets/53ef0b3a-115e-4914-86d3-3d88e18faa4b)

