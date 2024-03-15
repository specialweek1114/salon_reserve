# Laravelポートフォリオ 美容室予約管理システム

## 要求分析（要件定義）
### [要求分析書（要件定義書）](/docs/要件定義書.md)

## 基本設計（外部設計）	
### 業務フロー
#### 新規顧客予約申込
```mermaid
sequenceDiagram
    actor 顧客
    participant システム
    participant Slack
    actor 美容室
    顧客->>+システム: 予約申込URLにアクセス
    システム-->>-顧客: 予約申込画面を表示
    顧客->>+システム: 予約情報を入力して送信ボタンクリック
    システム-->>顧客: 予約申込完了画面表示
    システム--)顧客: 予約受付メール送信
    システム-)-Slack: 予約申込情報をチャンネルに書き込む
    activate Slack
    Slack-)美容室: 予約申込チャンネルから通知
    deactivate Slack
    美容室-->>システム: 管理URLにアクセス
    activate システム
    システム->>美容室: ログイン要求
    美容室-->>システム: ログイン情報入力
    deactivate システム
    Note left of システム: ログイン成功
    システム->>美容室: 予約管理画面ダッシュボード表示
    activate 美容室
    美容室-->>システム: 未受付予約一覧から<br>受付確定したい予約の詳細ボタンをクリック
    deactivate 美容室
    システム->>美容室: 予約詳細画面表示
    activate 美容室
    美容室-->>システム: 予約詳細を確認して受付確定
    deactivate 美容室
    activate システム
    システム--)顧客: 予約受付確定メール送信
    deactivate システム
    Note over 顧客,システム: マイページ登録URL誘導
```
#### マイページ利用登録フロー
```mermaid
sequenceDiagram
    actor 顧客
    participant システム
    participant Slack
    actor 美容室
    システム--)顧客: 予約受付確定メール送信
    Note over 顧客,システム: マイページ利用登録URL誘導
    顧客->>システム: マイページ利用登録URLをクリック
    システム-->>顧客: マイページ利用登録画面を表示
    顧客->>システム: マイページ登録情報を入力
    activate システム
    システム->>顧客: マイページ利用登録完了メッセージを表示
    システム->>Slack: マイページ利用登録完了を<br>利用登録完了チャンネルに書き込む
    deactivate システム
    Slack-->>美容室: 利用登録チャンネルから<br>マイページ利用登録完了情報を通知
```
#### 顧客来店～退店までのフロー
```mermaid
sequenceDiagram
    actor 顧客
    participant システム
    actor 美容室

    alt 来店3日前
        システム->>顧客: 予約リマインダーメール送信 
    end
    顧客->>美容室: 来店
    システム->>美容室: 当日予約一覧表示(時間帯順)
    美容室->>システム: 該当予約タップ
    activate システム
    システム-->>美容室: 予約詳細画面表示
    deactivate システム
    美容室->>顧客: 予約内容の確認
    美容室->>システム: システム上の予約ステータスを来店済に変更 
    alt 施術前後写真撮影OKの場合
        美容室->>顧客: 施術前写真撮影
        美容室-->>システム: 施術前写真preアップロード
    end
    美容室->>顧客: 施術開始
    美容室->>顧客: 施術終了
    alt 施術前後写真撮影OKの場合
        美容室->>顧客: 施術後写真撮影
        美容室-->>システム: 施術後写真preアップロード
    end    
    顧客->>美容室: 精算
    Note left of 顧客: 退店
    alt マイページ利用未登録　かつ<br>写真撮影OKの場合
        美容室->>システム: 施術前後写真の確定
    else マイページ利用登録済み　かつ<br>写真撮影OKの場合
        美容室->>システム: 施術前後写真の確認と公開<br>+来店感謝メール送信ボタンクリック
        activate システム
        システム-->>顧客: 来店感謝メール 兼<br>施術前後写真アップロード通知メール
        deactivate システム
    else マイページ利用登録済み　かつ<br>写真撮影NGの場合
        美容室->>システム: 来店感謝メール送信ボタンクリック
        activate システム
        システム-->>顧客: 来店感謝メール送信
        deactivate システム
    end
```
### システム構成図
```mermaid
flowchart BT
    subgraph Heroku
        subgraph Laravel
            API
        end
    end
    subgraph Supabase
        postgres[(postgres)]
    end
    Cloudflare[Cloudflare R2]
    Laravel --- postgres
    Laravel --- Cloudflare
    Laravel --> Slack
    subgraph Vercel
        subgraph Next[Next.js]
            subgraph マイページ
                予約申込画面
            end
            予約管理画面
        end
    end
    Next --- API
```

### ER図
```mermaid
erDiagram
    User ||--o{ Reservation : "客は0以上の予約を持つ"
    Reservation ||--o{ User : "予約は0以上の指名スタイリストを持つ"
    Reservation ||--|{ ReservationService : "予約は1つ以上の予約サービスを持つ"
    Reservation ||--o{ ReservationOption : "予約は0以上の予約オプションを持つ"
    Reservation ||--o| Visit : "予約は0か1の来店履歴を持つ"
    User ||--o{ Visit : "客は0以上の来店履歴を持つ"
    Visit ||--|{ User : "来店履歴は1以上の担当スタイリストを持つ"
    Visit ||--|{ UtilizedService : "来店履歴は1つ以上の利用サービスを持つ"
    Visit ||--o{ UtilizedOption : "来店履歴は0以上の利用オプションを持つ"
    Service ||--o{ ReservationService : "予約サービスはサービスに紐づく"
    Option ||--o{ ReservationOption : "予約オプションはオプションに紐づく"
    Service ||--o{ UtilizedService : "利用サービスはサービスに紐づく"
    Option ||--o{ UtilizedOption : "利用オプションはオプションに紐づく"
    User ||--|| UserType : "ユーザは１つのユーザ種別をもつ"
    User ||--o| Stylist : "店側ユーザはスタイリストにすることが可能"

    User {
        int id PK
        int type_id FK "ユーザ種別ID"
        string name "名前"
        string email "Eメール"
        string password "パスワード"
        tinyint is_valid "1:有効 0:無効"
        datetime mypage_last_login "最終ログイン日時"
        datetime created "作成日時"
        int create_user_id "作成者ID"
        datetime updated "更新日時"
        int update_user_id "更新者ID"
    }

    UserType {
        int id PK
        string name "ユーザ種別名"
        tinyint is_valid "1:有効 0:無効"
        datetime created "作成日時"
    }

    Stylist {
        int id PK
        int user_id FK "ユーザID"
        tinyint is_valid "1:有効 0:無効"
        datetime created "作成日時"
        int create_user_id "作成者ID"
        datetime updated "更新日時"
        int update_user_id "更新者ID"
    }
    
    Reservation {
        int id PK   
        int customer_user_id FK "予約客ID"
        int stylist_user_id FK "指名スタイリスト"
        int visit_id FK "来店履歴ID"
        int start "開始時刻"
        int period_min "利用予定時間(分)"
        int price_out_tax "税別料金"
        int price_in_tax "税込料金"
        tinyint status "0:予約確定前,10:予約確定,20:来店,99:キャンセル"
        datetime created "作成日時"
        int create_user_id "作成者ID"
        datetime updated "更新日時"
        int update_user_id "更新者ID"
    }

    ReservationService {
        int id PK
        int reservation_id FK "予約ID"
        int price_out_tax "税別料金"
        int price_in_tax "税込料金"
        datetime created "作成日時"
        int create_user_id "作成者ID"
        datetime updated "更新日時"
        int update_user_id "更新者ID"
    }
    ReservationOption {
        int id PK
        int reservation_id FK "予約ID"
        int reservation_service_id FK "予約サービスID"
        int price_out_tax "税別料金"
        int price_in_tax "税込料金"
        datetime created "作成日時"
        int create_user_id "作成者ID"
        datetime updated "更新日時"
        int update_user_id "更新者ID"
    }

    Service {
        int id PK
        int price_out_tax "税別料金"
        int minute "施術時間(分)"
        tinyint is_valid "1:有効 0:無効"
        datetime created "作成日時"
        int create_user_id "作成者ID"
        datetime updated "更新日時"
        int update_user_id "更新者ID"
    }

    Option {
        int id PK
        int price_out_tax "税別料金"
        int minute "施術時間(分)"
        tinyint is_valid "1:有効 0:無効"
        datetime created "作成日時"
        int create_user_id "作成者ID"
        datetime updated "更新日時"
        int update_user_id "更新者ID"
    }

    Visit {
        int id PK
        int customer_id FK "来店客ID"
        int stylist_store_user_id FK "担当スタイリスト"
        int start "来店時刻"
        int end "退店時刻"
        int period_min "利用時間(分)"
        int price_out_tax "税別料金"
        int price_in_tax "税込料金"
        tinyint status "20:来店,30:退店"
        datetime created "作成日時"
        int create_user_id "作成者ID"
        datetime updated "更新日時"
        int update_user_id "更新者ID"
    }

    UtilizedService {
        int id PK
        int visit_id FK "来店ID"
        int service_id FK "サービスID"
        int price_out_tax "税別料金"
        int price_in_tax "税込料金"
        datetime created "作成日時"
        int create_user_id "作成者ID"
        datetime updated "更新日時"
        int update_user_id "更新者ID"
    }

    UtilizedOption {
        int id PK
        int visit_id FK "来店ID"
        int option_id FK "オプションID"
        int price_out_tax "税別料金"
        int price_in_tax "税込料金"
        datetime created "作成日時"
        int create_user_id "作成者ID"
        datetime updated "更新日時"
        int update_user_id "更新者ID"
    }
```

### テーブル定義書

### 機能一覧表
|サブシステム|機能分類|機能|入力|照会|帳票|バッチ|内容|
|:--------|:-----|:---|:--:|:--:|:--:|:--:|:---|
|マイページ|ログイン|サインアップ|○|○|-|-|顧客ユーザアカウント作成ができる|
|マイページ|ログイン|ログイン|○|○|-|-|顧客マイページにログインできる|
|マイページ|ログイン|ログアウト|-|-|-|-|顧客マイページからログアウトできる|
|マイページ|ユーザ|ユーザ情報閲覧|-|○|-|-|顧客情報の確認|
|マイページ|ユーザ|ユーザ情報編集|○|○|-|-|顧客情報の編集|
|マイページ|予約|予約申込|○|○|-|-|希望の日時、スタイリスト、サービス、オプションを選択して予約申込ができる|
|マイページ|予約|予約詳細|○|○|-|-|予約内容の確認、キャンセル|
|マイページ|利用履歴|利用履歴一覧|-|○|-|-|利用履歴の確認|
|マイページ|利用履歴|利用履歴詳細|-|○|-|-|利用履歴の確認|
|管理画面|ダッシュボード|月間カレンダー|-|○|-|-|月間カレンダーの各日ごとに予約件数を表示|
|管理画面|ダッシュボード|当日予約一覧|-|○|-|-|当日の予約と席をスケジュール帳形式で確認できる|
|管理画面|ダッシュボード|来店操作|○|-|-|-|当日予約・来店一覧から１つの予約を選択してステータスを来店に変更できる|
|管理画面|ダッシュボード|施術写真アップロード|○|-|-|-|施術前後の写真をアップロードできる|
|管理画面|予約|予約詳細|-|○|-|-|予約内容の確認|
|管理画面|予約|予約編集|○|○|-|-|予約内容の編集やキャンセルができる|
|管理画面|来店履歴|検索一覧|-|○|-|-|来店履歴の検索一覧|
|管理画面|来店履歴|詳細|-|○|-|-|来店履歴詳細確認|
|管理画面|来店履歴|編集|○|○|-|-|来店履歴編集、写真アップロード・更新・削除|
|管理画面|顧客|顧客CRUD|○|○|-|-|顧客検索一覧・閲覧・来店履歴・編集|
|管理画面|マスタ|席CRUD|○|○|-|-|席一覧・追加・閲覧・編集・削除|
|管理画面|マスタ|スタイリストCRUD|○|○|-|-|スタイリスト検索一覧・追加・閲覧・編集・削除|
|管理画面|マスタ|サービスCRUD|○|○|-|-|サービス検索一覧・追加・閲覧・編集・削除|
|管理画面|マスタ|オプションCRUD|○|○|-|-|オプション検索一覧・追加・閲覧・編集・削除|


### 設計書記述様式
### 基本設計書（外部設計書）	
#### 概要
#### I/O関連図
#### 画面／帳票レイアウト

## 詳細設計（内部設計）
### 画面遷移図
### 詳細設計書（内部設計書）	
#### 概要
#### I/O関連図
#### 画面／帳票レイアウト
#### 項目説明書
#### 更新仕様書
#### 補足説明
### API設計書
### プロジェクト共通ルール

## 単体テスト
### 単体テスト仕様書／報告書
## 結合テスト
### 結合テスト仕様書／報告書
## 総合テスト
### 総合テスト仕様書／報告書

## リリース