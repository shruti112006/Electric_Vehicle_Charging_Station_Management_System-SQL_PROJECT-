-- ==========================================================
-- EV CHARGING STATION MANAGEMENT SYSTEM
-- DATABASE : ORACLE 21c
-- ==========================================================

-- ==========================================================
-- 1. CUSTOMERS
-- ==========================================================

CREATE TABLE CUSTOMERS
(
    CUSTOMER_ID         VARCHAR2(10),
    FIRST_NAME          VARCHAR2(50) NOT NULL,
    LAST_NAME           VARCHAR2(50) NOT NULL,
    DOB                 DATE NOT NULL,
    EMAIL               VARCHAR2(100) UNIQUE,
    PHONE               VARCHAR2(15) UNIQUE NOT NULL,
    CITY                VARCHAR2(50),
    CUSTOMER_STATE      VARCHAR2(50),
    REGISTRATION_DATE   DATE,

    CONSTRAINT CUST_PK PRIMARY KEY (CUSTOMER_ID)
);

-- ==========================================================
-- 2. VEHICLES
-- ==========================================================

CREATE TABLE VEHICLES
(
    VEHICLE_ID          VARCHAR2(10),
    CUSTOMER_ID         VARCHAR2(10),
    VEHICLE_NUMBER      VARCHAR2(15) UNIQUE,
    VEHICLE_NAME        VARCHAR2(50) NOT NULL,
    BATTERY_CAPACITY    NUMBER(5,2),

    CONSTRAINT VEHICLE_PK PRIMARY KEY (VEHICLE_ID),

    CONSTRAINT VEHICLE_CUSTOMER_FK
        FOREIGN KEY (CUSTOMER_ID)
        REFERENCES CUSTOMERS(CUSTOMER_ID)
);

-- ==========================================================
-- 3. BOOKINGS
-- ==========================================================

CREATE TABLE BOOKINGS
(
    BOOKING_ID      VARCHAR2(10),
    CUSTOMER_ID     VARCHAR2(10),
    BOOKING_DATE    DATE NOT NULL,
    STATUS          VARCHAR2(20),
    SLOT            VARCHAR2(30),

    CONSTRAINT BOOKING_PK PRIMARY KEY (BOOKING_ID),

    CONSTRAINT BOOKING_CUSTOMER_FK
        FOREIGN KEY (CUSTOMER_ID)
        REFERENCES CUSTOMERS(CUSTOMER_ID),

    CONSTRAINT BOOKING_STATUS_CHK
        CHECK (STATUS IN
        ('CONFIRMED','COMPLETED','CANCELLED','NO SHOW'))
);

-- ==========================================================
-- 4. CHARGING_STATION
-- ==========================================================

CREATE TABLE CHARGING_STATION
(
    STATION_ID          VARCHAR2(10),
    STATION_NAME        VARCHAR2(100) NOT NULL,
    STATE_NAME          VARCHAR2(50),
    CITY                VARCHAR2(50),
    LOCATION            VARCHAR2(100),
    CONTACT_NUMBER      VARCHAR2(15),

    CONSTRAINT STATION_PK PRIMARY KEY (STATION_ID)
);

-- ==========================================================
-- 5. CHARGING_PORTS
-- ==========================================================

CREATE TABLE CHARGING_PORTS
(
    PORT_ID         VARCHAR2(10),
    STATION_ID      VARCHAR2(10),
    PORT_TYPE       VARCHAR2(20),
    POWER_RATING    NUMBER(5),
    STATUS          VARCHAR2(20),

    CONSTRAINT PORT_PK PRIMARY KEY (PORT_ID),

    CONSTRAINT PORT_STATION_FK
        FOREIGN KEY (STATION_ID)
        REFERENCES CHARGING_STATION(STATION_ID),

    CONSTRAINT PORT_STATUS_CHK
        CHECK (STATUS IN
        ('AVAILABLE','OCCUPIED','MAINTENANCE'))
);

-- ==========================================================
-- 6. CHARGING_SESSION
-- ==========================================================

CREATE TABLE CHARGING_SESSION
(
    SESSION_ID          VARCHAR2(10),
    VEHICLE_ID          VARCHAR2(10),
    PORT_ID             VARCHAR2(10),
    BOOKING_ID          VARCHAR2(10),
    ENERGY_CONSUMED     NUMBER(6,2),
    START_TIME          TIMESTAMP,
    END_TIME            TIMESTAMP,
    TOTAL_COST          NUMBER(10,2),
    SESSION_STATUS      VARCHAR2(11),

    CONSTRAINT SESSION_PK PRIMARY KEY (SESSION_ID),

    CONSTRAINT SESSION_VEHICLE_FK
        FOREIGN KEY (VEHICLE_ID)
        REFERENCES VEHICLES(VEHICLE_ID),

    CONSTRAINT SESSION_PORT_FK
        FOREIGN KEY (PORT_ID)
        REFERENCES CHARGING_PORTS(PORT_ID),

    CONSTRAINT SESSION_BOOKING_FK
        FOREIGN KEY (BOOKING_ID)
        REFERENCES BOOKINGS(BOOKING_ID)
);

-- ==========================================================
-- 7. PAYMENT_TABLE
-- ==========================================================

CREATE TABLE PAYMENT_TABLE
(
    PAYMENT_ID          VARCHAR2(10),
    SESSION_ID          VARCHAR2(10),
    TOTAL_AMOUNT        NUMBER(10,2),
    PAYMENT_MODE        VARCHAR2(20),
    PAYMENT_STATUS      VARCHAR2(20),
    PAYMENT_DATE        DATE,

    CONSTRAINT PAYMENT_PK PRIMARY KEY (PAYMENT_ID),

    CONSTRAINT PAYMENT_SESSION_FK
        FOREIGN KEY (SESSION_ID)
        REFERENCES CHARGING_SESSION(SESSION_ID),

    CONSTRAINT PAYMENT_MODE_CHK
        CHECK (PAYMENT_MODE IN
        ('UPI','CREDIT CARD','DEBIT CARD','WALLET','NET BANKING')),

    CONSTRAINT PAYMENT_STATUS_CHK
        CHECK (PAYMENT_STATUS IN
        ('SUCCESS','FAILED','REFUNDED'))
);

-- ==========================================================
-- 8. MAINTENANCE
-- ==========================================================

CREATE TABLE MAINTENANCE
(
    MAINTENANCE_ID      VARCHAR2(10),
    STATION_ID          VARCHAR2(10),
    ISSUE_TYPE          VARCHAR2(100),
    MAINTENANCE_DATE    DATE,
    REPORTED_DATE       DATE,
    RESOLVED_DATE       DATE,
    STATUS              VARCHAR2(20),

    CONSTRAINT MAINTENANCE_PK PRIMARY KEY (MAINTENANCE_ID),

    CONSTRAINT MAINTENANCE_STATION_FK
        FOREIGN KEY (STATION_ID)
        REFERENCES CHARGING_STATION(STATION_ID),

    CONSTRAINT MAINTENANCE_STATUS_CHK
        CHECK (STATUS IN
        ('OPEN','IN PROGRESS','RESOLVED'))
);