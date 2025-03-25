# 단순 3tier 구성에 대한 AWS Config 진행
<br>

![1](https://github.com/user-attachments/assets/5c583ca6-56fd-44cf-b860-bcd615446df7)

<br>

- AWS에서 구성한 3tier 아키텍처를 기반으로 AWS Config 서비스를 활용하여 클라우드 보안 취약점 확인 및 조치 진행

<br><br>
## 구성 스펙
Instance
 - 종류 : WEB1, WEB2, WAS1, WAS2
 - OS : 4대 전부 Amazon Linux 2 
 - Type : 4대 전부 t2.small
 - Disk : 20GB
<br>

ALB 
 - WEB 이중화
<br>

NLB
 - WAS 이중화

RDS
 - MYSQL
