#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE api;

    CREATE ROLE web_anon NOLOGIN;

    GRANT usage ON SCHEMA PUBLIC TO web_anon;

    \c api;

    -- Sequence and defined type
    CREATE SEQUENCE IF NOT EXISTS order_id_seq;

    -- Table Definition
    CREATE TABLE "public"."orders" (
        "id" int4 NOT NULL DEFAULT nextval('order_id_seq'::regclass),
        "orderNumber" varchar NOT NULL,
        "status" varchar NOT NULL,
        "updatedAt" timestamptz NOT NULL,
        "createdAt" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY ("id")
    );

    GRANT SELECT, INSERT, UPDATE, DELETE ON PUBLIC.orders to web_anon;

    INSERT INTO "public"."orders" ("id", "orderNumber", "status", "updatedAt", "createdAt") VALUES
        (1, '1', 'Placed', '2024-02-11 16:56:07.810486+00', '2024-02-11 16:56:07.810486+00'),
        (2, '2', 'Delivered', '2024-02-11 16:56:23.915413+00', '2024-02-11 16:56:23.915413+00');
EOSQL
