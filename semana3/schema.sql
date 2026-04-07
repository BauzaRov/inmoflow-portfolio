-- ================================================
-- InmoFlow · Script SQL · PostgreSQL
-- Semana 3 del portfolio de Analista de Sistemas
-- ================================================

-- 1. AGENTE
CREATE TABLE agente (
    id_agente    SERIAL        PRIMARY KEY,
    nombre       VARCHAR(100)  NOT NULL,
    apellido     VARCHAR(100)  NOT NULL,
    email        VARCHAR(150)  NOT NULL UNIQUE,
    telefono     VARCHAR(20),
    activo       BOOLEAN       DEFAULT TRUE,
    created_at   TIMESTAMP     DEFAULT NOW()
);

-- 2. PROPIEDAD
CREATE TABLE propiedad (
    id_propiedad      SERIAL          PRIMARY KEY,
    direccion         VARCHAR(200)    NOT NULL,
    barrio            VARCHAR(100),
    tipo              VARCHAR(50)     NOT NULL, -- departamento, PH, casa
    ambientes         SMALLINT,
    superficie_m2     DECIMAL(8,2),
    precio_alquiler   DECIMAL(12,2)   NOT NULL,
    estado            VARCHAR(30)     DEFAULT 'disponible', -- disponible, reservada, alquilada
    descripcion       TEXT,
    id_agente         INT             REFERENCES agente(id_agente),
    created_at        TIMESTAMP       DEFAULT NOW()
);

-- 3. INQUILINO
CREATE TABLE inquilino (
    id_inquilino   SERIAL        PRIMARY KEY,
    nombre         VARCHAR(100)  NOT NULL,
    apellido       VARCHAR(100)  NOT NULL,
    dni            VARCHAR(15)   NOT NULL UNIQUE,
    email          VARCHAR(150)  UNIQUE,
    telefono       VARCHAR(20),
    ocupacion      VARCHAR(100),
    created_at     TIMESTAMP     DEFAULT NOW()
);

-- 4. SCORING_INQUILINO
CREATE TABLE scoring_inquilino (
    id_scoring        SERIAL       PRIMARY KEY,
    id_inquilino      INT          NOT NULL UNIQUE REFERENCES inquilino(id_inquilino),
    puntaje           SMALLINT     NOT NULL CHECK (puntaje BETWEEN 0 AND 100),
    nivel             VARCHAR(20)  DEFAULT 'sin evaluar', -- bajo, medio, alto
    tiene_garantia    BOOLEAN      DEFAULT FALSE,
    tiene_recibo      BOOLEAN      DEFAULT FALSE,
    observaciones     TEXT,
    fecha_evaluacion  DATE         NOT NULL,
    id_agente         INT          REFERENCES agente(id_agente)
);

-- 5. VISITA
CREATE TABLE visita (
    id_visita      SERIAL       PRIMARY KEY,
    id_propiedad   INT          NOT NULL REFERENCES propiedad(id_propiedad),
    id_inquilino   INT          NOT NULL REFERENCES inquilino(id_inquilino),
    fecha_hora     TIMESTAMP    NOT NULL,
    estado         VARCHAR(30)  DEFAULT 'pendiente', -- pendiente, confirmada, cancelada, realizada
    notas          TEXT,
    created_at     TIMESTAMP    DEFAULT NOW()
);

-- 6. CONTRATO
CREATE TABLE contrato (
    id_contrato      SERIAL         PRIMARY KEY,
    id_propiedad     INT            NOT NULL REFERENCES propiedad(id_propiedad),
    id_inquilino     INT            NOT NULL REFERENCES inquilino(id_inquilino),
    fecha_inicio     DATE           NOT NULL,
    fecha_fin        DATE           NOT NULL,
    monto_mensual    DECIMAL(12,2)  NOT NULL,
    estado           VARCHAR(30)    DEFAULT 'activo', -- activo, vencido, rescindido
    archivo_url      TEXT,          -- link al PDF del contrato
    created_at       TIMESTAMP      DEFAULT NOW()
);

-- 7. PAGO
CREATE TABLE pago (
    id_pago            SERIAL         PRIMARY KEY,
    id_contrato        INT            NOT NULL REFERENCES contrato(id_contrato),
    fecha_vencimiento  DATE           NOT NULL,
    fecha_pago         DATE,          -- NULL = aún no pagado
    monto              DECIMAL(12,2)  NOT NULL,
    estado             VARCHAR(30)    DEFAULT 'pendiente', -- pendiente, pagado, vencido
    metodo_pago        VARCHAR(50),
    comprobante_url    TEXT
);