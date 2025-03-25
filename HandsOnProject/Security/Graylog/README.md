![image](https://github.com/user-attachments/assets/9dadd1c2-a1bf-4cb0-9dc1-f66fb5e6a2ec)

Graylog를 통한 CloudTrail 로그 관리

AWS Cloud Trail → AWS Cloud Watch → AWS Kinesis Data Stream → Graylog

Graylog는 Private 환경으로 구성하였고 같은 Private Subnet에 Windows 서버를 생성하여 Windows 서버에서 웹페이지에 접속 가능하게 설정하였습니다.

만약 외부에서 사용을 원한다면 인프라 구성 앞단에 방화벽 장비와 ALB를 두어 보안적인 부분을 구성하여 사용하면 되지만 이번 내용에서는 Private Subnet에 구성하였습니다.

Graylog 서버 구성 방법
- Docker-compose를 통한 구성

1. Docker 설치
2. Dcoekr-compose 설치
3. docker-compose.yml 구성
4. .env 구성
5. 암호 발급
6. Graylog 설정 확인
7. Graylog 웹페이지 접속
8. Graylog와 AWS Cloud Watch 연동
