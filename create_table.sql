CREATE TABLE User (
    id SERIAL PRIMARY KEY,
    type_id INT REFERENCES UserType (id),
    name VARCHAR,
    email VARCHAR,
    password VARCHAR,
    is_valid TINYINT,
    mypage_last_login TIMESTAMP,
    created TIMESTAMP,
    create_user_id INT,
    updated TIMESTAMP,
    update_user_id INT
);

COMMENT ON TABLE User IS 'ユーザ';

COMMENT ON COLUMN User.id IS 'ID';
COMMENT ON COLUMN User.type_id IS 'ユーザ種別ID';
COMMENT ON COLUMN User.name IS '名前';
COMMENT ON COLUMN User.email IS 'Eメール';
COMMENT ON COLUMN User.password IS 'パスワード';
COMMENT ON COLUMN User.is_valid IS '1:有効 0:無効';
COMMENT ON COLUMN User.mypage_last_login IS '最終ログイン日時';
COMMENT ON COLUMN User.created IS '作成日時';
COMMENT ON COLUMN User.create_user_id IS '作成者ID';
COMMENT ON COLUMN User.updated IS '更新日時';
COMMENT ON COLUMN User.update_user_id IS '更新者ID';

CREATE TABLE UserType (
    id SERIAL PRIMARY KEY,
    name VARCHAR,
    is_valid TINYINT,
    created TIMESTAMP
);

COMMENT ON TABLE UserType IS 'ユーザ種別';

COMMENT ON COLUMN UserType.id IS 'ID';
COMMENT ON COLUMN UserType.name IS 'ユーザ種別名';
COMMENT ON COLUMN UserType.is_valid IS '1:有効 0:無効';
COMMENT ON COLUMN UserType.created IS '作成日時';

CREATE TABLE Stylist (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES User (id),
    is_valid TINYINT,
    created TIMESTAMP,
    create_user_id INT,
    updated TIMESTAMP,
    update_user_id INT
);

COMMENT ON TABLE Stylist IS 'スタイリスト';

COMMENT ON COLUMN Stylist.id IS 'ID';
COMMENT ON COLUMN Stylist.user_id IS 'ユーザID';
COMMENT ON COLUMN Stylist.is_valid IS '1:有効 0:無効';
COMMENT ON COLUMN Stylist.created IS '作成日時';
COMMENT ON COLUMN Stylist.create_user_id IS '作成者ID';
COMMENT ON COLUMN Stylist.updated IS '更新日時';
COMMENT ON COLUMN Stylist.update_user_id IS '更新者ID';

CREATE TABLE Seat (
    id SERIAL PRIMARY KEY,
    name VARCHAR,
    is_valid TINYINT,
    created TIMESTAMP,
    create_user_id INT,
    updated TIMESTAMP,
    update_user_id INT
)

COMMENT ON TABLE Seat IS '席';

COMMENT ON COLUMN Seat.id IS 'ID';
COMMENT ON COLUMN Seat.name IS '席名';
COMMENT ON COLUMN Seat.is_valid IS '1:有効 0:無効';
COMMENT ON COLUMN Seat.created IS '作成日時';
COMMENT ON COLUMN Seat.create_user_id IS '作成者ID';
COMMENT ON COLUMN Seat.updated IS '更新日時';
COMMENT ON COLUMN Seat.update_user_id IS '更新者ID';

CREATE TABLE Reservation (
    id SERIAL PRIMARY KEY,
    customer_user_id INT REFERENCES User (id),
    stylist_user_id INT REFERENCES User (id),
    visit_id INT REFERENCES Visit (id),
    start INT,
    period_min INT,
    price_out_tax INT,
    price_in_tax INT,
    status TINYINT,
    created TIMESTAMP,
    create_user_id INT,
    updated TIMESTAMP,
    update_user_id INT
);

COMMENT ON TABLE Reservation IS '予約';

COMMENT ON COLUMN Reservation.id IS 'ID';
COMMENT ON COLUMN Reservation.customer_user_id IS '予約客ID';
COMMENT ON COLUMN Reservation.stylist_user_id IS '指名スタイリスト';
COMMENT ON COLUMN Reservation.visit_id IS '来店履歴ID';
COMMENT ON COLUMN Reservation.start IS '開始時刻';
COMMENT ON COLUMN Reservation.period_min IS '利用予定時間(分)';
COMMENT ON COLUMN Reservation.price_out_tax IS '税別料金';
COMMENT ON COLUMN Reservation.price_in_tax IS '税込料金';
COMMENT ON COLUMN Reservation.status IS '0:予約確定前,10:予約確定,20:来店,99:キャンセル';
COMMENT ON COLUMN Reservation.created IS '作成日時';
COMMENT ON COLUMN Reservation.create_user_id IS '作成者ID';
COMMENT ON COLUMN Reservation.updated IS '更新日時';
COMMENT ON COLUMN Reservation.update_user_id IS '更新者ID';

CREATE TABLE ReservationService (
    id SERIAL PRIMARY KEY,
    reservation_id INT REFERENCES Reservation (id),
    price_out_tax INT,
    price_in_tax INT,
    created TIMESTAMP,
    create_user_id INT,
    updated TIMESTAMP,
    update_user_id INT
);

COMMENT ON TABLE ReservationService IS '予約サービス';

COMMENT ON COLUMN ReservationService.id IS 'ID';
COMMENT ON COLUMN ReservationService.reservation_id IS '予約ID';
COMMENT ON COLUMN ReservationService.price_out_tax IS '税別料金';
COMMENT ON COLUMN ReservationService.price_in_tax IS '税込料金';
COMMENT ON COLUMN ReservationService.created IS '作成日時';
COMMENT ON COLUMN ReservationService.create_user_id IS '作成者ID';
COMMENT ON COLUMN ReservationService.updated IS '更新日時';
COMMENT ON COLUMN ReservationService.update_user_id IS '更新者ID';

CREATE TABLE ReservationOption (
    id SERIAL PRIMARY KEY,
    reservation_id INT REFERENCES Reservation (id),
    reservation_service_id INT REFERENCES ReservationService (id),
    price_out_tax INT,
    price_in_tax INT,
    created TIMESTAMP,
    create_user_id INT,
    updated TIMESTAMP,
    update_user_id INT
);

COMMENT ON TABLE ReservationOption IS '予約オプション';

COMMENT ON COLUMN ReservationOption.id IS 'ID';
COMMENT ON COLUMN ReservationOption.reservation_id IS '予約ID';
COMMENT ON COLUMN ReservationOption.reservation_service_id IS '予約サービスID';
COMMENT ON COLUMN ReservationOption.price_out_tax IS '税別料金';
COMMENT ON COLUMN ReservationOption.price_in_tax IS '税込料金';
COMMENT ON COLUMN ReservationOption.created IS '作成日時';
COMMENT ON COLUMN ReservationOption.create_user_id IS '作成者ID';
COMMENT ON COLUMN ReservationOption.updated IS '更新日時';
COMMENT ON COLUMN ReservationOption.update_user_id IS '更新者ID';

CREATE TABLE Service (
    id SERIAL PRIMARY KEY,
    price_out_tax INT,
    minute INT,
    is_valid TINYINT,
    created TIMESTAMP,
    create_user_id INT,
    updated TIMESTAMP,
    update_user_id INT
);

COMMENT ON TABLE Service IS 'サービス';

COMMENT ON COLUMN Service.id IS 'ID';
COMMENT ON COLUMN Service.price_out_tax IS '税別料金';
COMMENT ON COLUMN Service.minute IS '施術時間(分)';
COMMENT ON COLUMN Service.is_valid IS '1:有効 0:無効';
COMMENT ON COLUMN Service.created IS '作成日時';
COMMENT ON COLUMN Service.create_user_id IS '作成者ID';
COMMENT ON COLUMN Service.updated IS '更新日時';
COMMENT ON COLUMN Service.update_user_id IS '更新者ID';

CREATE TABLE Option (
    id SERIAL PRIMARY KEY,
    price_out_tax INT,
    minute INT,
    is_valid TINYINT,
    created TIMESTAMP,
    create_user_id INT,
    updated TIMESTAMP,
    update_user_id INT
);

COMMENT ON TABLE Option IS 'オプション';

COMMENT ON COLUMN Option.id IS 'ID';
COMMENT ON COLUMN Option.price_out_tax IS '税別料金';
COMMENT ON COLUMN Option.minute IS '施術時間(分)';
COMMENT ON COLUMN Option.is_valid IS '1:有効 0:無効';
COMMENT ON COLUMN Option.created IS '作成日時';
COMMENT ON COLUMN Option.create_user_id IS '作成者ID';
COMMENT ON COLUMN Option.updated IS '更新日時';
COMMENT ON COLUMN Option.update_user_id IS '更新者ID';

CREATE TABLE Visit (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES User (id),
    stylist_store_user_id INT REFERENCES Stylist (user_id),
    start INT,
    end INT,
    period_min INT,
    price_out_tax INT,
    price_in_tax INT,
    status TINYINT,
    created TIMESTAMP,
    create_user_id INT,
    updated TIMESTAMP,
    update_user_id INT
);

COMMENT ON TABLE Visit IS '来店';

COMMENT ON COLUMN Visit.id IS 'ID';
COMMENT ON COLUMN Visit.customer_id IS '来店客ID';
COMMENT ON COLUMN Visit.stylist_store_user_id IS '担当スタイリスト';
COMMENT ON COLUMN Visit.start IS '来店時刻';
COMMENT ON COLUMN Visit.end IS '退店時刻';
COMMENT ON COLUMN Visit.period_min IS '利用時間(分)';
COMMENT ON COLUMN Visit.price_out_tax IS '税別料金';
COMMENT ON COLUMN Visit.price_in_tax IS '税込料金';
COMMENT ON COLUMN Visit.status IS '20:来店,30:退店';
COMMENT ON COLUMN Visit.created IS '作成日時';
COMMENT ON COLUMN Visit.create_user_id IS '作成者ID';
COMMENT ON COLUMN Visit.updated IS '更新日時';
COMMENT ON COLUMN Visit.update_user_id IS '更新者ID';

CREATE TABLE UtilizedService (
    id SERIAL PRIMARY KEY,
    visit_id INT REFERENCES Visit (id),
    service_id INT REFERENCES Service (id),
    price_out_tax INT,
    price_in_tax INT,
    created TIMESTAMP,
    create_user_id INT,
    updated TIMESTAMP,
    update_user_id INT
);

COMMENT ON TABLE UtilizedService IS '利用サービス';

COMMENT ON COLUMN UtilizedService.id IS 'ID';
COMMENT ON COLUMN UtilizedService.visit_id IS '来店ID';
COMMENT ON COLUMN UtilizedService.service_id IS 'サービスID';
COMMENT ON COLUMN UtilizedService.price_out_tax IS '税別料金';
COMMENT ON COLUMN UtilizedService.price_in_tax IS '税込料金';
COMMENT ON COLUMN UtilizedService.created IS '作成日時';
COMMENT ON COLUMN UtilizedService.create_user_id IS '作成者ID';
COMMENT ON COLUMN UtilizedService.updated IS '更新日時';
COMMENT ON COLUMN UtilizedService.update_user_id IS '更新者ID';

CREATE TABLE UtilizedOption (
    id SERIAL PRIMARY KEY,
    visit_id INT REFERENCES Visit (id),
    option_id INT REFERENCES Option (id),
    price_out_tax INT,
    price_in_tax INT,
    created TIMESTAMP,
    create_user_id INT,
    updated TIMESTAMP,
    update_user_id INT
);

COMMENT ON TABLE UtilizedOption IS '利用オプション';

COMMENT ON COLUMN UtilizedOption.id IS 'ID';
COMMENT ON COLUMN UtilizedOption.visit_id IS '来店ID';
COMMENT ON COLUMN UtilizedOption.option_id IS 'オプションID';
COMMENT ON COLUMN UtilizedOption.price_out_tax IS '税別料金';
COMMENT ON COLUMN UtilizedOption.price_in_tax IS '税込料金';
COMMENT ON COLUMN UtilizedOption.created IS '作成日時';
COMMENT ON COLUMN UtilizedOption.create_user_id IS '作成者ID';
COMMENT ON COLUMN UtilizedOption.updated IS '更新日時';
COMMENT ON COLUMN UtilizedOption.update_user_id IS '更新者ID';
