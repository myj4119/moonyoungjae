# 단순 3tier 구성에 대한 AWS Config 진행
<br>

![1](https://github.com/user-attachments/assets/5c583ca6-56fd-44cf-b860-bcd615446df7)

<br>

- AWS에서 구성한 3tier 아키텍처를 기반으로 AWS Config 서비스를 활용하여 클라우드 보안 취약점 확인 및 조치 진행
- 2022년 작성
<br>

**AWS Config에 대한 내용이므로 인프라 구성에 대한 상세 설명은 다른 항목에서 진행 예정**

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

<br><br><br>

## AWS Config 
- 템플릿은 KISMS 샘플 템플릿을 사용하여 진행
#### AWS Config 서비스 시작
AWS → AWS Config → 시작하기 진행
![2](https://github.com/user-attachments/assets/e3de1c82-f1db-4421-8966-726cce70d0e8)
<br><br>

### 1. 옵션값 적용
![3](https://github.com/user-attachments/assets/bebebc1c-e45b-413a-abe0-d07529d05496)
<br><br>

### 2. 생성된 대시보드 확인 및 규정 준수 팩 설정
![4](https://github.com/user-attachments/assets/ebc576be-1369-42b9-8033-ef5683b8d7a9)
<br><br>
![5](https://github.com/user-attachments/assets/b242d9e6-082b-47de-9cbe-108710267049)
<br><br>

### 3. 템플릿 지정
![6](https://github.com/user-attachments/assets/8aefbd00-db30-4b5f-94a3-8fe01f7cd3e6)
KISMS의 샘플 템플릿을 사용
<br><br>
![7](https://github.com/user-attachments/assets/25e4fd23-3feb-4f58-b9a9-da96cff0b192)
<br><br>
### 4. 미준수 규칙 확인
![8](https://github.com/user-attachments/assets/d7b07a93-d5af-493c-aaf0-e9952bfab06f)








