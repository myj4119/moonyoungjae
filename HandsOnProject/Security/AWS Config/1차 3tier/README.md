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

## SG 구성
| Name | Type | Port | Source |
|:---------:|:---------:|:---------:|:---------:|
| bastion-SG  | SSH   | 22  | 0.0.0.0/0  |
| WEB-SG  | SSH, HTTP   | 22, 80  | bastion  |
| WAS-SG  | SSH, HTTP   | 22,8080  | bastion, private subnet  |
| DB-SG  | MySQL   | 3306  | was, bastion  |
| ALB-SG  | HTTP   | 80  | 0.0.0.0/0  |

**AWS Config에 대한 내용이므로 인프라 구성에 대한 설명은 다른 항목에서 진행 예정**


| 왼쪽 정렬 | 가운데 정렬 | 오른쪽 정렬 |
|:--------|:--------:|--------:|
| 데이터1  | 데이터2  | 데이터3  |
| 데이터4  | 데이터5  | 데이터6  |
