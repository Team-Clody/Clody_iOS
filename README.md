# 🍀 Clody
> ### AI 로디가 행운을 전하는 감사일기
#### ‘클로디'는
감사하는 마음을 통해 우리는 삶에서 더 많은 긍정적인 순간들을 발견하고,
이를 통해 더 행복하고 행운이 따르는 삶을 살 수 있게 됩니다.

클로디가 행운의 친구가 되어 감사한 마음을 응원해드릴게요!

## 🍎 역할 분담 및 주요 기능
| 김선우 | 김나연 | 오서영 |
| :--------: | :--------: | :--------: |
| <img src="https://github.com/user-attachments/assets/16bbe76f-981f-4961-a21b-92468a7edc75" width="200px"/>  | <img src="https://github.com/user-attachments/assets/3b8a3767-8085-4743-945a-52806f412c1b" width="200px"/> | <img src="https://github.com/user-attachments/assets/ea6c4236-a1f0-42cb-adc7-22040cb7ab9d" width="200px"/> | 
| Main | Onboarding & Login | MyPage | 
| 캘린더 & 일기 작성 & 푸시 알림 | 온보딩 & 로그인 & 일기응답 | 마이페이지 |

## 💻 프로젝트 기술 스택
### 개발스택 (Development Stack)
<img src="https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/iOS-000000?style=flat-square&logo=ios&logoColor=white"/> <img src="https://img.shields.io/badge/RxSwift-228822?style=flat-square&logo=reactiveX&logoColor=white"/> <img src="https://img.shields.io/badge/MVVM-ff1111?style=flat-square&logo=ios&logoColor=white"/>

### Develop Environment 
<img src="https://img.shields.io/badge/xcode 15.1-147EFB?style=flat-square&logo=Xcode&logoColor=white"/> <img src="https://img.shields.io/badge/iOS 15.0-000000?style=flat-square&logo=ios&logoColor=white"/>

### Library
|라이브러리|채택 이유|
|:---:|:---:|
| Moya |	서버 통신을 위한 관련 라이브러리 |
| KakaoOpenSDK |	카카오 소셜 로그인을 위한 라이브러리 |
| Lottie |	애니메이션 효과를 가진 뷰를 구현하기 위한 라이브러리 |
| SnapKit |	Code base 개발을 원활하게 도와주는 라이브러리 |
| Then |	UI Component를 선언한 후 속성, 스타일을 지정할 때 가독성을 높여주기 위함 |
| RxSwift |	반응형 프로그래밍을 위한 라이브러리로, 비동기 및 이벤트 기반 프로그램을 더 쉽게 작성할 수 있게 도와줌 |
| FSCalendar |	손쉬운 캘린더 구현을 도와줌 |
| RxDataSource |	CollectionViewCell의 동적 업데이트를 용이하게 도와줌 |
| RxKeyboard |	키보드 관련 반응형 이벤트를 용이하게 도와줌 |
| Firebase-Message |	원격 푸시 알림 이벤트 처리를 도와줌 |

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

## 🔥 Trouble Shooting

## 🍀 Foldering

```
├── 📁 Application
│   ├── AppDelegate
│   └── SceneDelegate
├── 📁 Global
│   ├── Manager
│   │   └── UserManager
│   ├── Utils
│   │   └── ScreenUtils
│   ├── Extensions
│   ├── Literals
│   │   └── String
│   ├── Protocols
│   ├── Resources
│   │   ├── Font
│   │   ├── Assets
│   │   └── Info.plist
│   └── SupportingFiles
│       └── Base
│           └── LaunchScreen
├── 📁 Network
│   ├── Base
│   │   ├── BaseTargetType.swift
│   │   ├── AuthIntercepter.swift
│   │   ├── NetworkProvider.swift
|   |   └── BaseModel.swift
│   ├── Environment
│   │   ├── APIConstant.swift
│   │   ├── NetworkHelper.swift
│   │   ├── MoyaPluggin.swift
│   │   ├── NetworkResult.swift
│   │   ├── NetworkRequest.swift
│   │   └── Config
│   ├── MoyaTarget
|   |   ├── Provider.swift
|   |   └── EmptyResponseDTO.swift
│   └── Service
|       ├── DTO
|       └── Router
|           ├── CalendarRouter.swift
|           ├── AuthRouter.swift
|           ├── ReplyRouter.swift
|           └── MyPageRouter.swift
└── 📁 Presentation 
    ├── Common
    │   ├── Base
    │   └── Component
    ├── Auth
    │   ├── ViewControllers
    │   ├── Views
    │   ├── Models
    │   └── ViewModels
    ├── Calendar
    │   ├── ViewControllers
    │   ├── Views
    │   ├── Models
    │   ├── ViewModels
    │   └── Cells
    ├── MyPage
    │   ├── ViewControllers
    │   ├── Views
    │   ├── Models
    │   ├── ViewModels
    │   └── Cells
    ├── List
    │   ├── ViewControllers
    │   ├── Views
    │   ├── Models
    │   ├── ViewModels
    │   └── Cells
    ├── Reply
    │   ├── ViewControllers
    │   ├── Views
    │   ├── Models
    │   ├── ViewModels
    │   └── Cells
    └── WritingDiary
        ├── ViewControllers
        ├── Views
        ├── Models
        ├── ViewModels
        └── Cells
```
