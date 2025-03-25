g![image](https://github.com/user-attachments/assets/9dadd1c2-a1bf-4cb0-9dc1-f66fb5e6a2ec)

Graylog를 통한 CloudTrail 로그 관리

AWS Cloud Trail → AWS Cloud Watch → AWS Kinesis Data Stream → Graylog

Graylog는 Private 환경으로 구성하였고 같은 Private Subnet에 Windows 서버를 생성하여 Windows 서버에서 웹페이지에 접속 가능하게 설정하였습니다.

만약 외부에서 사용을 원한다면 인프라 구성 앞단에 방화벽 장비와 ALB를 두어 보안적인 부분을 구성하여 사용하면 되지만 이번 내용에서는 Private Subnet에 구성하였습니다.

Graylog 서버 스펙
- OS : Amazon Linux 2023
- Type : m5.large
- Disk : 50GB
  
Graylog 서버 구성 방법
- Docker-compose를 통한 구성


1. Docker 설치
Docker 패키지 설치
$ sudo yum install -y docker

Docker 서비스 시작
$ sudo systemctl start docker

Docker 서비스 부팅 시 자동 시작 설정
$ sudo systemctl enable docker

현재 사용자에게 Docker 실행 권한 부여
$ sudo usermod -aG docker $USER


2. Dcoekr-compose 설치
최신 Docker Compose 버전 가져오기
$ LATEST_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)

Docker Compose 바이너리 다운로드
$ sudo curl -L "https://github.com/docker/compose/releases/download/${LATEST_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

실행 권한 부여
$ sudo chmod +x /usr/local/bin/docker-compose

3. docker-compose.yml 구성
$ sudo vi docker-compose.yml

4. .env 구성
$ sudo vi .env

5. 암호 발급
pwgen 설치
$ sudo yum install -y pwgen

1개의 보안성이 높은 96자리 랜덤 패스워드 생성
$ sudo pwgen -N 1 -s 96

패스워드를 sha-256 해시 함수로 변환
$ sudo echo -n [사용자 패스워드] | sha256sum

.env에 패스워드 입력

6. Graylog 설정 확인
Linux 커널 파라미터 변경 (Datanode는 많은 메모리 매핑을 필요로 함)
$ echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
$ sudo sysctl -p

Graylog 실행 확인
$ sudo docker-compose logs graylog

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

7. Graylog 웹페이지 접속


8. Graylog와 AWS Cloud Watch 연동


