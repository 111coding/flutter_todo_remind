# 투두리스트
- 다음에 파이어베이스 연동하는게 구글로그인한다음에 저메모내용 불러오는것을 하는걸까요~?
    - 로그인 없이 CRUD 하고 구글로그인 진행하겠습니다!



# Firebase 연동하기

https://firebase.google.com/docs/flutter/setup?hl=ko&platform=ios

1. Firebase 콘솔에서 프로젝트 생성
2. flutterfire configure
    - firebase CLI 설치 필수
    - command not found 뜰 때 => `dart pub global activate flutterfire_cli`
    - 설치된 파일 리스트
        - firebase.json
        - lib/firebase_options.dart
        - ios/Runner/GoogleService-Info.plist
        - android/app/google-services.json
3. 플러터 프로젝트 구성
    - flutter pub add firebase_core
    - main.dart
        ```dart
        void main() async {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
        );
        runApp(const MyApp());
        }
        ```
    - 파이어베이스 파이어스토어 데이터베이스 사용을 하기 위한 패키지 추가 : flutter pub add cloud_firestore