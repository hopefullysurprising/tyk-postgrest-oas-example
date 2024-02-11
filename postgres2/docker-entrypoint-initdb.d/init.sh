#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE api;

    CREATE ROLE web_anon NOLOGIN;

    GRANT usage ON SCHEMA PUBLIC TO web_anon;

    \c api;

    -- Sequence and defined type
    CREATE SEQUENCE IF NOT EXISTS company_id_seq;

    -- Table Definition
    CREATE TABLE "public"."companies" (
        "id" int4 NOT NULL DEFAULT nextval('company_id_seq'::regclass),
        "updatedAt" timestamptz NOT NULL,
        "createdAt" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "name" varchar NOT NULL,
        PRIMARY KEY ("id")
    );

    INSERT INTO "public"."companies" ("id", "updatedAt", "createdAt", "name") VALUES
        (1, '2024-02-11 16:59:11.327297+00', '2024-02-11 16:59:11.327297+00', 'Company A'),
        (2, '2024-02-11 16:59:11.327297+00', '2024-02-11 16:59:11.327297+00', 'Company B');
EOSQL
