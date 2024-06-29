# 🍀 Clody
> ### 사용자의 감사일기에 AI 캐릭터가 칭찬으로 답장해주는 서비스
#### ‘클로디'는
사용자의 감사일기에 AI 캐릭터가 칭찬으로 답장해주는 서비스입니다,

## 🍎 역할 분담 및 주요 기능
| 김선우 | 김나연 | 오서영 |
| :--------: | :--------: | :--------: |
| <img src="https://github.com/33th-SOPKATHON-TEAM-APP3/SISTAR23-iOS/assets/102219161/fc955987-9966-4ef5-850e-b3d709cc9186" width="200px"/>  | <img src="https://github.com/33th-SOPKATHON-TEAM-APP3/SISTAR23-iOS/assets/102219161/fc955987-9966-4ef5-850e-b3d709cc9186" width="200px"/> | <img src="https://github.com/33th-SOPKATHON-TEAM-APP3/SISTAR23-iOS/assets/102219161/fc955987-9966-4ef5-850e-b3d709cc9186" width="200px"/> | 
| Main | Onboarding & Login | MyPage | 
| 캘린더 & 일기 작성 & 푸시 알림 | 온보딩 & 로그인 & 일기응답 | 마이페이지 & 과거 일기 |

## 💻 프로젝트 기술 스택
### 개발스택 (Development Stack)
<img src="https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/iOS-000000?style=flat-square&logo=ios&logoColor=white"/> <img src="https://img.shields.io/badge/RxSwift-228822?style=flat-square&logo=reactiveX&logoColor=white"/> <img src="https://img.shields.io/badge/MVVM-ff1111?style=flat-square&logo=ios&logoColor=white"/>

### Develop Enviroment 
<img src="https://img.shields.io/badge/xcode 15.1-147EFB?style=flat-square&logo=Xcode&logoColor=white"/> <img src="https://img.shields.io/badge/iOS 15.0-000000?style=flat-square&logo=ios&logoColor=white"/>

### Library
1. Moya
    - 서버 통신을 위한 관련 라이브러리
    
2. KakaoOpenSDK
    - 카카오 소셜 로그인을 위한 라이브러리
    
3. Lottie
    - 애니메이션 효과를 가진 뷰를 구현하기 위한 라이브러리
    
4. SnapKit
    - Code base 개발을 원활하게 도와주는 라이브러리

5. RxSwift
    - 반응형 프로그래밍을 위한 라이브러리로, 비동기 및 이벤트 기반 프로그램을 더 쉽게 작성할 수 있게 도와줌
  
6. FScalendar
   - 손쉬운 캘린더 구현을 도와줌

## 📌 Git Convention
[🚀 git convention 바로가기](https://github.com/Team-Clody/Clody_iOS/wiki/Clody_iOS_git-Convention)

### 브랜치 전략
```swift
main - release 관리 
develop - 머지용
feat - 각자 사용하는 브랜치
```
### 브랜치 네이밍 규칙
`prefix` /`#issueNumber`/ `작업한 view`
#### 폴더링(prefix)
    - `feat` : 기능 구현
    - `network` : 네트워크
    - `fix` : 간단한 수정
    - `set` : 프로젝트 세팅과 같은 기초 세팅
### 커밋 규칙
#### 커밋 메시지
- `[prefix/#issueNumber] description` 형식으로 작성한다.
#### Prefix
|Prefix|Role|
|:---:|:---:|
|Set| 환경 세팅 |
|Feat| 새로운 기능 구현|
|Add| 파일 추가 |
|Delete| 파일 삭제 |
|Fix| 버그 해결 |
|Chore| 기타 |

## 🖥️ Coding Convention
[🚀 coding convention 바로가기](https://github.com/Team-Clody/Clody_iOS/wiki/Clody_iOS_Coding-Convention)
[🚀 coding template 바로가기](https://github.com/Team-Clody/Clody_iOS/wiki/Clody_iOS_Coding-Template)
## 🍀 Foldering

```
├── Application
│   ├── Appdelegate
│   ├── SceneDelegate
├── Global
│   ├── Extensions
│   ├── Literals
│   │   ├── Literal
│   │   ├── String
│   ├── Protocols
│   ├── Resources
│   │   ├── Font
│   │   ├── Assets
│   ├── SupportingFiles
│   │   ├── Base
├───├───├───── LaunchScreen
├── Network
│   ├── Base
│   │   ├── BaseTargetType.swift
│   │   ├── GeneralResponse.swift
│   │   ├── ... (기본 네트워크 세팅 파일)
│   ├── Environment
│   │   ├── Config
│   ├── MoyaTarget
│   ├── Service
├── Presentation 
│   ├── Base
│   ├── Common
│   │   ├── Component
│   ├── Home
│   │   ├── ViewControllers
│   │   ├── Views
│   │   ├── Models
├───├───├── ViewModels
├───├───├── Cells
├── Info.plist
```
