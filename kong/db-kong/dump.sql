--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7
-- Dumped by pg_dump version 14.6

-- Started on 2023-04-06 14:36:04 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 239 (class 1255 OID 16385)
-- Name: sync_tags(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sync_tags() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          IF (TG_OP = 'TRUNCATE') THEN
            DELETE FROM tags WHERE entity_name = TG_TABLE_NAME;
            RETURN NULL;
          ELSIF (TG_OP = 'DELETE') THEN
            DELETE FROM tags WHERE entity_id = OLD.id;
            RETURN OLD;
          ELSE

          -- Triggered by INSERT/UPDATE
          -- Do an upsert on the tags table
          -- So we don't need to migrate pre 1.1 entities
          INSERT INTO tags VALUES (NEW.id, TG_TABLE_NAME, NEW.tags)
          ON CONFLICT (entity_id) DO UPDATE
                  SET tags=EXCLUDED.tags;
          END IF;
          RETURN NEW;
        END;
      $$;


ALTER FUNCTION public.sync_tags() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16386)
-- Name: acls; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acls (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    "group" text,
    cache_key text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.acls OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16392)
-- Name: acme_storage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acme_storage (
    id uuid NOT NULL,
    key text,
    value text,
    created_at timestamp with time zone,
    ttl timestamp with time zone
);


ALTER TABLE public.acme_storage OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16397)
-- Name: basicauth_credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.basicauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    username text,
    password text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.basicauth_credentials OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16403)
-- Name: ca_certificates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ca_certificates (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    cert text NOT NULL,
    tags text[],
    cert_digest text NOT NULL
);


ALTER TABLE public.ca_certificates OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16409)
-- Name: certificates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.certificates (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    cert text,
    key text,
    tags text[],
    ws_id uuid,
    cert_alt text,
    key_alt text
);


ALTER TABLE public.certificates OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16415)
-- Name: cluster_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cluster_events (
    id uuid NOT NULL,
    node_id uuid NOT NULL,
    at timestamp with time zone NOT NULL,
    nbf timestamp with time zone,
    expire_at timestamp with time zone NOT NULL,
    channel text,
    data text
);


ALTER TABLE public.cluster_events OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16420)
-- Name: clustering_data_planes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clustering_data_planes (
    id uuid NOT NULL,
    hostname text NOT NULL,
    ip text NOT NULL,
    last_seen timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    config_hash text NOT NULL,
    ttl timestamp with time zone,
    version text,
    sync_status text DEFAULT 'unknown'::text NOT NULL
);


ALTER TABLE public.clustering_data_planes OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16427)
-- Name: consumers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consumers (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    username text,
    custom_id text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.consumers OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16433)
-- Name: hmacauth_credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hmacauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    username text,
    secret text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.hmacauth_credentials OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16439)
-- Name: jwt_secrets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jwt_secrets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    key text,
    secret text,
    algorithm text,
    rsa_public_key text,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.jwt_secrets OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16445)
-- Name: keyauth_credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keyauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    key text,
    tags text[],
    ttl timestamp with time zone,
    ws_id uuid
);


ALTER TABLE public.keyauth_credentials OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16451)
-- Name: locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locks (
    key text NOT NULL,
    owner text,
    ttl timestamp with time zone
);


ALTER TABLE public.locks OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16456)
-- Name: oauth2_authorization_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth2_authorization_codes (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    credential_id uuid,
    service_id uuid,
    code text,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone,
    challenge text,
    challenge_method text,
    ws_id uuid
);


ALTER TABLE public.oauth2_authorization_codes OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16462)
-- Name: oauth2_credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth2_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text,
    consumer_id uuid,
    client_id text,
    client_secret text,
    redirect_uris text[],
    tags text[],
    client_type text,
    hash_secret boolean,
    ws_id uuid
);


ALTER TABLE public.oauth2_credentials OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16468)
-- Name: oauth2_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oauth2_tokens (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    credential_id uuid,
    service_id uuid,
    access_token text,
    refresh_token text,
    token_type text,
    expires_in integer,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone,
    ws_id uuid
);


ALTER TABLE public.oauth2_tokens OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16474)
-- Name: parameters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parameters (
    key text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone
);


ALTER TABLE public.parameters OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16479)
-- Name: plugins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plugins (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text NOT NULL,
    consumer_id uuid,
    service_id uuid,
    route_id uuid,
    config jsonb NOT NULL,
    enabled boolean NOT NULL,
    cache_key text,
    protocols text[],
    tags text[],
    ws_id uuid
);


ALTER TABLE public.plugins OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16485)
-- Name: ratelimiting_metrics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer,
    ttl timestamp with time zone
);


ALTER TABLE public.ratelimiting_metrics OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16492)
-- Name: response_ratelimiting_metrics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.response_ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer
);


ALTER TABLE public.response_ratelimiting_metrics OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16499)
-- Name: routes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.routes (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    service_id uuid,
    protocols text[],
    methods text[],
    hosts text[],
    paths text[],
    snis text[],
    sources jsonb[],
    destinations jsonb[],
    regex_priority bigint,
    strip_path boolean,
    preserve_host boolean,
    tags text[],
    https_redirect_status_code integer,
    headers jsonb,
    path_handling text DEFAULT 'v0'::text,
    ws_id uuid,
    request_buffering boolean,
    response_buffering boolean
);


ALTER TABLE public.routes OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16505)
-- Name: schema_meta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_meta (
    key text NOT NULL,
    subsystem text NOT NULL,
    last_executed text,
    executed text[],
    pending text[]
);


ALTER TABLE public.schema_meta OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16510)
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    retries bigint,
    protocol text,
    host text,
    port bigint,
    path text,
    connect_timeout bigint,
    write_timeout bigint,
    read_timeout bigint,
    tags text[],
    client_certificate_id uuid,
    tls_verify boolean,
    tls_verify_depth smallint,
    ca_certificates uuid[],
    ws_id uuid,
    enabled boolean DEFAULT true
);


ALTER TABLE public.services OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16516)
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id uuid NOT NULL,
    session_id text,
    expires integer,
    data text,
    created_at timestamp with time zone,
    ttl timestamp with time zone
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16521)
-- Name: snis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.snis (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text NOT NULL,
    certificate_id uuid,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.snis OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16527)
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    entity_id uuid NOT NULL,
    entity_name text,
    tags text[]
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16532)
-- Name: targets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.targets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(3) with time zone),
    upstream_id uuid,
    target text NOT NULL,
    weight integer NOT NULL,
    tags text[],
    ws_id uuid
);


ALTER TABLE public.targets OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16538)
-- Name: ttls; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ttls (
    primary_key_value text NOT NULL,
    primary_uuid_value uuid,
    table_name text NOT NULL,
    primary_key_name text NOT NULL,
    expire_at timestamp without time zone NOT NULL
);


ALTER TABLE public.ttls OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16543)
-- Name: upstreams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.upstreams (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(3) with time zone),
    name text,
    hash_on text,
    hash_fallback text,
    hash_on_header text,
    hash_fallback_header text,
    hash_on_cookie text,
    hash_on_cookie_path text,
    slots integer NOT NULL,
    healthchecks jsonb,
    tags text[],
    algorithm text,
    host_header text,
    client_certificate_id uuid,
    ws_id uuid
);


ALTER TABLE public.upstreams OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16549)
-- Name: vaults_beta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vaults_beta (
    id uuid NOT NULL,
    ws_id uuid,
    prefix text,
    name text NOT NULL,
    description text,
    config jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    updated_at timestamp with time zone,
    tags text[]
);


ALTER TABLE public.vaults_beta OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16555)
-- Name: workspaces; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspaces (
    id uuid NOT NULL,
    name text,
    comment text,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    meta jsonb,
    config jsonb
);


ALTER TABLE public.workspaces OWNER TO postgres;

--
-- TOC entry 3712 (class 0 OID 16386)
-- Dependencies: 209
-- Data for Name: acls; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3713 (class 0 OID 16392)
-- Dependencies: 210
-- Data for Name: acme_storage; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3714 (class 0 OID 16397)
-- Dependencies: 211
-- Data for Name: basicauth_credentials; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3715 (class 0 OID 16403)
-- Dependencies: 212
-- Data for Name: ca_certificates; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3716 (class 0 OID 16409)
-- Dependencies: 213
-- Data for Name: certificates; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3717 (class 0 OID 16415)
-- Dependencies: 214
-- Data for Name: cluster_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('0df160ec-39c0-4ce7-8eef-e35bffdc2147', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:01:03.286+00', NULL, '2023-04-06 15:01:03.286+00', 'invalidations', 'routes:949fe85b-9441-41fc-b0b4-d0da52212aa1:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('c3488dc5-6881-466c-ad7b-4c13041a33fa', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:01:03.289+00', NULL, '2023-04-06 15:01:03.289+00', 'invalidations', 'router:version');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('5288f580-e2a4-438f-ad96-a7ddc245b34b', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:01:04.691+00', NULL, '2023-04-06 15:01:04.691+00', 'invalidations', 'routes:bc0ac981-5c8a-4f30-8bf7-9fb2dd08bbbb:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('970fc5bc-8b30-448a-ba32-eb5f1ed6f3dc', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:01:04.694+00', NULL, '2023-04-06 15:01:04.694+00', 'invalidations', 'router:version');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('15d60da3-abaf-4fc6-bd2e-7a33693e9c12', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:01:06.238+00', NULL, '2023-04-06 15:01:06.238+00', 'invalidations', 'routes:e9983164-53a6-49d7-b366-8107c983bdb9:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('d7dcf7d8-a361-44a3-a5fc-0354a7591ee5', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:01:06.24+00', NULL, '2023-04-06 15:01:06.24+00', 'invalidations', 'router:version');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('a63ecb8a-eed7-412a-b8d0-cf81e094095d', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:01:10.049+00', NULL, '2023-04-06 15:01:10.049+00', 'invalidations', 'services:2c52c70a-19ba-4b4f-a341-a4df59747166:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('43f98986-feaa-46e1-8e14-c50f8d384bfd', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:01:11.542+00', NULL, '2023-04-06 15:01:11.542+00', 'invalidations', 'services:96c9ce21-c989-4d3b-aec3-1a130d676dd3:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('faa883d5-1f46-40b6-b687-cc10cd0216c7', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:01:12.984+00', NULL, '2023-04-06 15:01:12.984+00', 'invalidations', 'services:dfe23b03-4d0f-4a2a-9f63-9cc5efa2aedc:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('b157c399-5472-49c6-96a0-d7812e25b2b5', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:01:35.873+00', NULL, '2023-04-06 15:01:35.873+00', 'invalidations', 'services:f24c4b14-3fa4-496d-a17c-2e3bcb341dbf:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('c8d402fb-298b-43b6-8758-ffae8106ea0c', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:01:51.65+00', NULL, '2023-04-06 15:01:51.65+00', 'invalidations', 'services:e50711d2-24b7-42a2-8cc4-b71eeba37641:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('ff3dce87-cda9-4a3f-a7ca-33064a8c0a47', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:02:33.647+00', NULL, '2023-04-06 15:02:33.647+00', 'invalidations', 'routes:9227870a-83fb-4a38-9afe-30f3b64bb51a:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('075a443e-61b7-4ff6-8a6b-be6e29a9b561', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:02:33.648+00', NULL, '2023-04-06 15:02:33.648+00', 'invalidations', 'router:version');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('792eb1a3-67dc-4008-b34d-5d3eb8716863', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:02:50.699+00', NULL, '2023-04-06 15:02:50.699+00', 'invalidations', 'routes:ab12aae4-663a-401d-a95b-7f68aa3c3cea:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('3e3afb5e-b1a6-404b-9f06-14b66b7a23ba', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:02:50.701+00', NULL, '2023-04-06 15:02:50.701+00', 'invalidations', 'router:version');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('3b0f3b78-2bed-4cca-87f9-9dcd945bf7c9', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:03:35.395+00', NULL, '2023-04-06 15:03:35.395+00', 'invalidations', 'upstreams:ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('961dbbdf-140f-4969-a67b-3ead2c2a2309', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:03:35.416+00', NULL, '2023-04-06 15:03:35.416+00', 'balancer:upstreams', 'create:fe582d58-6e0a-49a3-a709-e33bb257dbc2:ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f:loggers_upstream');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('82978879-9f8b-4b0b-b5f0-91ee16edee93', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:03:58.569+00', NULL, '2023-04-06 15:03:58.569+00', 'invalidations', 'targets:9552d98e-d9fe-4404-ac21-1e9ef28bd3e5:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('ae1ca804-e504-4247-bdbd-490e5b2abf0b', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:03:58.627+00', NULL, '2023-04-06 15:03:58.627+00', 'balancer:targets', 'create:ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('25acd515-b7f6-440f-9be8-1e5b4d11eea3', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:04:06.849+00', NULL, '2023-04-06 15:04:06.849+00', 'invalidations', 'targets:b2d8de03-5868-4372-a577-c159094653c8:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('d32f4b2e-8bae-42fd-9ec2-0b05b1885656', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:04:06.886+00', NULL, '2023-04-06 15:04:06.886+00', 'balancer:targets', 'create:ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('ebac6066-665c-4381-a480-c743b0b5648a', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:04:48.226+00', NULL, '2023-04-06 15:04:48.226+00', 'invalidations', 'upstreams:05fed3d3-32aa-44b9-9427-df41280cbc66:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('a9a41033-a054-400b-8c65-d3b70e4f56bb', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:04:48.234+00', NULL, '2023-04-06 15:04:48.234+00', 'balancer:upstreams', 'create:fe582d58-6e0a-49a3-a709-e33bb257dbc2:05fed3d3-32aa-44b9-9427-df41280cbc66:users_upstream');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('d1c9d312-c143-4c91-800a-eeae471f75f3', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:05:05.41+00', NULL, '2023-04-06 15:05:05.41+00', 'invalidations', 'targets:55c73fa9-e371-4249-82fb-6b5b623794c1:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('b096914a-4524-4a49-a7a6-f7d3636938ef', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:05:05.442+00', NULL, '2023-04-06 15:05:05.442+00', 'balancer:targets', 'create:05fed3d3-32aa-44b9-9427-df41280cbc66');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('c42a1385-aea9-48ea-ad38-b875b34bb5f2', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:05:12.244+00', NULL, '2023-04-06 15:05:12.244+00', 'invalidations', 'targets:756c90ef-36d8-4050-ba4d-fb377865bad7:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('9715995c-5e32-44d3-9370-758b29936ddf', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:05:12.279+00', NULL, '2023-04-06 15:05:12.279+00', 'balancer:targets', 'create:05fed3d3-32aa-44b9-9427-df41280cbc66');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('dc6247e4-f1a5-4a45-b7ce-8a214184682d', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:06:50.439+00', NULL, '2023-04-06 15:06:50.439+00', 'invalidations', 'upstreams:ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('f210782c-68ec-4f1b-8341-5abdba5f3e29', '914dcf1c-6b66-4f1c-bc41-cea2ec6fac7a', '2023-04-06 14:06:50.451+00', NULL, '2023-04-06 15:06:50.451+00', 'balancer:upstreams', 'update:fe582d58-6e0a-49a3-a709-e33bb257dbc2:ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f:loggers_upstream');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('0aa89958-da5f-440c-a7d5-91c8d79896a3', 'b1bee30f-1d2a-4dce-b5bf-a0f3ab07845a', '2023-04-06 14:29:54.719+00', NULL, '2023-04-06 15:29:54.719+00', 'balancer:post_health', 'users2||3001|1|05fed3d3-32aa-44b9-9427-df41280cbc66|users_upstream');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('a954e87e-7557-4336-bccb-2c419c958959', 'b1bee30f-1d2a-4dce-b5bf-a0f3ab07845a', '2023-04-06 14:32:20.487+00', NULL, '2023-04-06 15:32:20.487+00', 'invalidations', 'targets:9552d98e-d9fe-4404-ac21-1e9ef28bd3e5:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('4273076a-6c20-4be0-bf23-14c5628ec641', 'b1bee30f-1d2a-4dce-b5bf-a0f3ab07845a', '2023-04-06 14:32:20.491+00', NULL, '2023-04-06 15:32:20.491+00', 'balancer:targets', 'delete:ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('1544bc6b-8395-4aec-8a1b-f3fc8b8bff33', 'b1bee30f-1d2a-4dce-b5bf-a0f3ab07845a', '2023-04-06 14:32:22.739+00', NULL, '2023-04-06 15:32:22.739+00', 'invalidations', 'targets:b2d8de03-5868-4372-a577-c159094653c8:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('f0dfad72-ce83-4239-ab76-d3ad216dbc05', 'b1bee30f-1d2a-4dce-b5bf-a0f3ab07845a', '2023-04-06 14:32:22.745+00', NULL, '2023-04-06 15:32:22.745+00', 'balancer:targets', 'delete:ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('282d5a7d-d490-4c4b-91d7-2c0429c1f7d4', 'b1bee30f-1d2a-4dce-b5bf-a0f3ab07845a', '2023-04-06 14:32:32.034+00', NULL, '2023-04-06 15:32:32.034+00', 'invalidations', 'targets:6abe8526-a9bf-44b7-96d0-267e5feda015:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('453f2ee7-9cd7-4b1d-8e4d-00b242e0074d', 'b1bee30f-1d2a-4dce-b5bf-a0f3ab07845a', '2023-04-06 14:32:32.043+00', NULL, '2023-04-06 15:32:32.043+00', 'balancer:targets', 'create:ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('d819e4fa-3b51-4f2c-b304-576857f6ceb0', 'b1bee30f-1d2a-4dce-b5bf-a0f3ab07845a', '2023-04-06 14:32:38.65+00', NULL, '2023-04-06 15:32:38.65+00', 'invalidations', 'targets:14ada35f-d8a2-4967-b31f-77d6a447bcf0:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.cluster_events (id, node_id, at, nbf, expire_at, channel, data) VALUES ('a6722ef2-a3a5-4e75-a931-c8c28edcfd52', 'b1bee30f-1d2a-4dce-b5bf-a0f3ab07845a', '2023-04-06 14:32:38.66+00', NULL, '2023-04-06 15:32:38.66+00', 'balancer:targets', 'create:ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f');


--
-- TOC entry 3718 (class 0 OID 16420)
-- Dependencies: 215
-- Data for Name: clustering_data_planes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3719 (class 0 OID 16427)
-- Dependencies: 216
-- Data for Name: consumers; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3720 (class 0 OID 16433)
-- Dependencies: 217
-- Data for Name: hmacauth_credentials; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3721 (class 0 OID 16439)
-- Dependencies: 218
-- Data for Name: jwt_secrets; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3722 (class 0 OID 16445)
-- Dependencies: 219
-- Data for Name: keyauth_credentials; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3723 (class 0 OID 16451)
-- Dependencies: 220
-- Data for Name: locks; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3724 (class 0 OID 16456)
-- Dependencies: 221
-- Data for Name: oauth2_authorization_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3725 (class 0 OID 16462)
-- Dependencies: 222
-- Data for Name: oauth2_credentials; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3726 (class 0 OID 16468)
-- Dependencies: 223
-- Data for Name: oauth2_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3727 (class 0 OID 16474)
-- Dependencies: 224
-- Data for Name: parameters; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.parameters (key, value, created_at) VALUES ('cluster_id', '2c1247ba-d0c4-4cbe-931f-b2e9834691e9', NULL);


--
-- TOC entry 3728 (class 0 OID 16479)
-- Dependencies: 225
-- Data for Name: plugins; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.plugins (id, created_at, name, consumer_id, service_id, route_id, config, enabled, cache_key, protocols, tags, ws_id) VALUES ('f84ee6ba-354c-43d5-bd8b-6b52e90e741f', '2022-08-26 13:39:19+00', 'cors', NULL, NULL, NULL, '{"headers": null, "max_age": null, "methods": ["OPTIONS", "PUT", "GET", "POST", "HEAD", "DELETE", "PATCH"], "origins": ["*"], "credentials": true, "exposed_headers": null, "preflight_continue": false}', true, 'plugins:cors:::::fe582d58-6e0a-49a3-a709-e33bb257dbc2', '{grpc,grpcs,http,https}', NULL, 'fe582d58-6e0a-49a3-a709-e33bb257dbc2');


--
-- TOC entry 3729 (class 0 OID 16485)
-- Dependencies: 226
-- Data for Name: ratelimiting_metrics; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3730 (class 0 OID 16492)
-- Dependencies: 227
-- Data for Name: response_ratelimiting_metrics; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3731 (class 0 OID 16499)
-- Dependencies: 228
-- Data for Name: routes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.routes (id, created_at, updated_at, name, service_id, protocols, methods, hosts, paths, snis, sources, destinations, regex_priority, strip_path, preserve_host, tags, https_redirect_status_code, headers, path_handling, ws_id, request_buffering, response_buffering) VALUES ('9227870a-83fb-4a38-9afe-30f3b64bb51a', '2023-04-06 14:02:33+00', '2023-04-06 14:02:33+00', 'logger-route', 'e50711d2-24b7-42a2-8cc4-b71eeba37641', '{http,https}', NULL, NULL, '{/loggers}', NULL, NULL, NULL, 0, true, false, NULL, 426, NULL, 'v1', 'fe582d58-6e0a-49a3-a709-e33bb257dbc2', true, true);
INSERT INTO public.routes (id, created_at, updated_at, name, service_id, protocols, methods, hosts, paths, snis, sources, destinations, regex_priority, strip_path, preserve_host, tags, https_redirect_status_code, headers, path_handling, ws_id, request_buffering, response_buffering) VALUES ('ab12aae4-663a-401d-a95b-7f68aa3c3cea', '2023-04-06 14:02:50+00', '2023-04-06 14:02:50+00', 'users-route', 'f24c4b14-3fa4-496d-a17c-2e3bcb341dbf', '{http,https}', NULL, NULL, '{/users}', NULL, NULL, NULL, 0, true, false, NULL, 426, NULL, 'v1', 'fe582d58-6e0a-49a3-a709-e33bb257dbc2', true, true);


--
-- TOC entry 3732 (class 0 OID 16505)
-- Dependencies: 229
-- Data for Name: schema_meta; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'jwt', '003_200_to_210', '{000_base_jwt,002_130_to_140,003_200_to_210}', '{}');
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'key-auth', '003_200_to_210', '{000_base_key_auth,002_130_to_140,003_200_to_210}', '{}');
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'oauth2', '005_210_to_211', '{000_base_oauth2,003_130_to_140,004_200_to_210,005_210_to_211}', '{}');
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'rate-limiting', '004_200_to_210', '{000_base_rate_limiting,003_10_to_112,004_200_to_210}', NULL);
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'response-ratelimiting', '000_base_response_rate_limiting', '{000_base_response_rate_limiting}', NULL);
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'session', '001_add_ttl_index', '{000_base_session,001_add_ttl_index}', NULL);
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'core', '015_270_to_280', '{000_base,003_100_to_110,004_110_to_120,005_120_to_130,006_130_to_140,007_140_to_150,008_150_to_200,009_200_to_210,010_210_to_211,011_212_to_213,012_213_to_220,013_220_to_230,014_230_to_270,015_270_to_280}', '{}');
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'acl', '004_212_to_213', '{000_base_acl,002_130_to_140,003_200_to_210,004_212_to_213}', '{}');
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'acme', '000_base_acme', '{000_base_acme}', NULL);
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'basic-auth', '003_200_to_210', '{000_base_basic_auth,002_130_to_140,003_200_to_210}', '{}');
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'bot-detection', '001_200_to_210', '{001_200_to_210}', '{}');
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'hmac-auth', '003_200_to_210', '{000_base_hmac_auth,002_130_to_140,003_200_to_210}', '{}');
INSERT INTO public.schema_meta (key, subsystem, last_executed, executed, pending) VALUES ('schema_meta', 'ip-restriction', '001_200_to_210', '{001_200_to_210}', '{}');


--
-- TOC entry 3733 (class 0 OID 16510)
-- Dependencies: 230
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.services (id, created_at, updated_at, name, retries, protocol, host, port, path, connect_timeout, write_timeout, read_timeout, tags, client_certificate_id, tls_verify, tls_verify_depth, ca_certificates, ws_id, enabled) VALUES ('f24c4b14-3fa4-496d-a17c-2e3bcb341dbf', '2023-04-06 14:01:35+00', '2023-04-06 14:01:35+00', 'users', 5, 'http', 'users_upstream', 8000, NULL, 60000, 60000, 60000, '{}', NULL, NULL, NULL, NULL, 'fe582d58-6e0a-49a3-a709-e33bb257dbc2', true);
INSERT INTO public.services (id, created_at, updated_at, name, retries, protocol, host, port, path, connect_timeout, write_timeout, read_timeout, tags, client_certificate_id, tls_verify, tls_verify_depth, ca_certificates, ws_id, enabled) VALUES ('e50711d2-24b7-42a2-8cc4-b71eeba37641', '2023-04-06 14:01:51+00', '2023-04-06 14:01:51+00', 'loggers', 5, 'http', 'loggers_upstream', 8000, NULL, 60000, 60000, 60000, '{}', NULL, NULL, NULL, NULL, 'fe582d58-6e0a-49a3-a709-e33bb257dbc2', true);


--
-- TOC entry 3734 (class 0 OID 16516)
-- Dependencies: 231
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3735 (class 0 OID 16521)
-- Dependencies: 232
-- Data for Name: snis; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3736 (class 0 OID 16527)
-- Dependencies: 233
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tags (entity_id, entity_name, tags) VALUES ('f84ee6ba-354c-43d5-bd8b-6b52e90e741f', 'plugins', NULL);
INSERT INTO public.tags (entity_id, entity_name, tags) VALUES ('f24c4b14-3fa4-496d-a17c-2e3bcb341dbf', 'services', '{}');
INSERT INTO public.tags (entity_id, entity_name, tags) VALUES ('e50711d2-24b7-42a2-8cc4-b71eeba37641', 'services', '{}');
INSERT INTO public.tags (entity_id, entity_name, tags) VALUES ('9227870a-83fb-4a38-9afe-30f3b64bb51a', 'routes', NULL);
INSERT INTO public.tags (entity_id, entity_name, tags) VALUES ('ab12aae4-663a-401d-a95b-7f68aa3c3cea', 'routes', NULL);
INSERT INTO public.tags (entity_id, entity_name, tags) VALUES ('05fed3d3-32aa-44b9-9427-df41280cbc66', 'upstreams', NULL);
INSERT INTO public.tags (entity_id, entity_name, tags) VALUES ('55c73fa9-e371-4249-82fb-6b5b623794c1', 'targets', NULL);
INSERT INTO public.tags (entity_id, entity_name, tags) VALUES ('756c90ef-36d8-4050-ba4d-fb377865bad7', 'targets', NULL);
INSERT INTO public.tags (entity_id, entity_name, tags) VALUES ('ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f', 'upstreams', NULL);
INSERT INTO public.tags (entity_id, entity_name, tags) VALUES ('6abe8526-a9bf-44b7-96d0-267e5feda015', 'targets', NULL);
INSERT INTO public.tags (entity_id, entity_name, tags) VALUES ('14ada35f-d8a2-4967-b31f-77d6a447bcf0', 'targets', NULL);


--
-- TOC entry 3737 (class 0 OID 16532)
-- Dependencies: 234
-- Data for Name: targets; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.targets (id, created_at, upstream_id, target, weight, tags, ws_id) VALUES ('55c73fa9-e371-4249-82fb-6b5b623794c1', '2023-04-06 14:05:05.403+00', '05fed3d3-32aa-44b9-9427-df41280cbc66', 'users1:3000', 100, NULL, 'fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.targets (id, created_at, upstream_id, target, weight, tags, ws_id) VALUES ('756c90ef-36d8-4050-ba4d-fb377865bad7', '2023-04-06 14:05:12.238+00', '05fed3d3-32aa-44b9-9427-df41280cbc66', 'users2:3001', 100, NULL, 'fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.targets (id, created_at, upstream_id, target, weight, tags, ws_id) VALUES ('6abe8526-a9bf-44b7-96d0-267e5feda015', '2023-04-06 14:32:32.025+00', 'ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f', 'logger1:3002', 100, NULL, 'fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.targets (id, created_at, upstream_id, target, weight, tags, ws_id) VALUES ('14ada35f-d8a2-4967-b31f-77d6a447bcf0', '2023-04-06 14:32:38.643+00', 'ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f', 'logger2:3003', 100, NULL, 'fe582d58-6e0a-49a3-a709-e33bb257dbc2');


--
-- TOC entry 3738 (class 0 OID 16538)
-- Dependencies: 235
-- Data for Name: ttls; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3739 (class 0 OID 16543)
-- Dependencies: 236
-- Data for Name: upstreams; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.upstreams (id, created_at, name, hash_on, hash_fallback, hash_on_header, hash_fallback_header, hash_on_cookie, hash_on_cookie_path, slots, healthchecks, tags, algorithm, host_header, client_certificate_id, ws_id) VALUES ('05fed3d3-32aa-44b9-9427-df41280cbc66', '2023-04-06 14:04:48+00', 'users_upstream', 'none', 'none', NULL, NULL, NULL, '/', 1000, '{"active": {"type": "http", "healthy": {"interval": 5, "successes": 1, "http_statuses": [200, 302]}, "timeout": 1, "http_path": "/", "https_sni": null, "unhealthy": {"interval": 5, "timeouts": 1, "tcp_failures": 0, "http_failures": 0, "http_statuses": [429, 404, 500, 501, 502, 503, 504, 505]}, "concurrency": 10, "https_verify_certificate": false}, "passive": {"type": "http", "healthy": {"successes": 0, "http_statuses": [200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 306, 307, 308]}, "unhealthy": {"timeouts": 0, "tcp_failures": 0, "http_failures": 0, "http_statuses": [429, 500, 503]}}, "threshold": 0}', NULL, 'round-robin', NULL, NULL, 'fe582d58-6e0a-49a3-a709-e33bb257dbc2');
INSERT INTO public.upstreams (id, created_at, name, hash_on, hash_fallback, hash_on_header, hash_fallback_header, hash_on_cookie, hash_on_cookie_path, slots, healthchecks, tags, algorithm, host_header, client_certificate_id, ws_id) VALUES ('ec2ba4a2-9ba8-4a47-b2cd-bc0b6ebecf7f', '2023-04-06 14:03:35+00', 'loggers_upstream', 'none', 'none', NULL, NULL, NULL, '/', 1000, '{"active": {"type": "http", "healthy": {"interval": 5, "successes": 1, "http_statuses": [200, 302]}, "timeout": 1, "http_path": "/", "https_sni": null, "unhealthy": {"interval": 5, "timeouts": 1, "tcp_failures": 0, "http_failures": 0, "http_statuses": [429, 404, 500, 501, 502, 503, 504, 505]}, "concurrency": 10, "https_verify_certificate": false}, "passive": {"type": "http", "healthy": {"successes": 0, "http_statuses": [200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 306, 307, 308]}, "unhealthy": {"timeouts": 0, "tcp_failures": 0, "http_failures": 0, "http_statuses": [429, 500, 503]}}, "threshold": 0}', NULL, 'round-robin', NULL, NULL, 'fe582d58-6e0a-49a3-a709-e33bb257dbc2');


--
-- TOC entry 3740 (class 0 OID 16549)
-- Dependencies: 237
-- Data for Name: vaults_beta; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3741 (class 0 OID 16555)
-- Dependencies: 238
-- Data for Name: workspaces; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.workspaces (id, name, comment, created_at, meta, config) VALUES ('fe582d58-6e0a-49a3-a709-e33bb257dbc2', 'default', NULL, '2022-03-10 14:19:37+00', NULL, NULL);


--
-- TOC entry 3329 (class 2606 OID 16562)
-- Name: acls acls_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_cache_key_key UNIQUE (cache_key);


--
-- TOC entry 3333 (class 2606 OID 16564)
-- Name: acls acls_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3335 (class 2606 OID 16566)
-- Name: acls acls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_pkey PRIMARY KEY (id);


--
-- TOC entry 3338 (class 2606 OID 16568)
-- Name: acme_storage acme_storage_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acme_storage
    ADD CONSTRAINT acme_storage_key_key UNIQUE (key);


--
-- TOC entry 3340 (class 2606 OID 16570)
-- Name: acme_storage acme_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acme_storage
    ADD CONSTRAINT acme_storage_pkey PRIMARY KEY (id);


--
-- TOC entry 3343 (class 2606 OID 16572)
-- Name: basicauth_credentials basicauth_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3345 (class 2606 OID 16574)
-- Name: basicauth_credentials basicauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 3347 (class 2606 OID 16576)
-- Name: basicauth_credentials basicauth_credentials_ws_id_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_ws_id_username_unique UNIQUE (ws_id, username);


--
-- TOC entry 3350 (class 2606 OID 16578)
-- Name: ca_certificates ca_certificates_cert_digest_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ca_certificates
    ADD CONSTRAINT ca_certificates_cert_digest_key UNIQUE (cert_digest);


--
-- TOC entry 3352 (class 2606 OID 16580)
-- Name: ca_certificates ca_certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ca_certificates
    ADD CONSTRAINT ca_certificates_pkey PRIMARY KEY (id);


--
-- TOC entry 3354 (class 2606 OID 16582)
-- Name: certificates certificates_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3356 (class 2606 OID 16584)
-- Name: certificates certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);


--
-- TOC entry 3362 (class 2606 OID 16586)
-- Name: cluster_events cluster_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cluster_events
    ADD CONSTRAINT cluster_events_pkey PRIMARY KEY (id);


--
-- TOC entry 3364 (class 2606 OID 16588)
-- Name: clustering_data_planes clustering_data_planes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clustering_data_planes
    ADD CONSTRAINT clustering_data_planes_pkey PRIMARY KEY (id);


--
-- TOC entry 3367 (class 2606 OID 16590)
-- Name: consumers consumers_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3369 (class 2606 OID 16592)
-- Name: consumers consumers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_pkey PRIMARY KEY (id);


--
-- TOC entry 3373 (class 2606 OID 16594)
-- Name: consumers consumers_ws_id_custom_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_custom_id_unique UNIQUE (ws_id, custom_id);


--
-- TOC entry 3375 (class 2606 OID 16596)
-- Name: consumers consumers_ws_id_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_username_unique UNIQUE (ws_id, username);


--
-- TOC entry 3378 (class 2606 OID 16598)
-- Name: hmacauth_credentials hmacauth_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3380 (class 2606 OID 16600)
-- Name: hmacauth_credentials hmacauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 3382 (class 2606 OID 16602)
-- Name: hmacauth_credentials hmacauth_credentials_ws_id_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_ws_id_username_unique UNIQUE (ws_id, username);


--
-- TOC entry 3386 (class 2606 OID 16604)
-- Name: jwt_secrets jwt_secrets_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3388 (class 2606 OID 16606)
-- Name: jwt_secrets jwt_secrets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_pkey PRIMARY KEY (id);


--
-- TOC entry 3391 (class 2606 OID 16608)
-- Name: jwt_secrets jwt_secrets_ws_id_key_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_ws_id_key_unique UNIQUE (ws_id, key);


--
-- TOC entry 3395 (class 2606 OID 16610)
-- Name: keyauth_credentials keyauth_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3397 (class 2606 OID 16612)
-- Name: keyauth_credentials keyauth_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 3400 (class 2606 OID 16614)
-- Name: keyauth_credentials keyauth_credentials_ws_id_key_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_ws_id_key_unique UNIQUE (ws_id, key);


--
-- TOC entry 3403 (class 2606 OID 16616)
-- Name: locks locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locks
    ADD CONSTRAINT locks_pkey PRIMARY KEY (key);


--
-- TOC entry 3407 (class 2606 OID 16618)
-- Name: oauth2_authorization_codes oauth2_authorization_codes_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3409 (class 2606 OID 16620)
-- Name: oauth2_authorization_codes oauth2_authorization_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_pkey PRIMARY KEY (id);


--
-- TOC entry 3412 (class 2606 OID 16622)
-- Name: oauth2_authorization_codes oauth2_authorization_codes_ws_id_code_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_ws_id_code_unique UNIQUE (ws_id, code);


--
-- TOC entry 3417 (class 2606 OID 16624)
-- Name: oauth2_credentials oauth2_credentials_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3419 (class 2606 OID 16626)
-- Name: oauth2_credentials oauth2_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 3423 (class 2606 OID 16628)
-- Name: oauth2_credentials oauth2_credentials_ws_id_client_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_ws_id_client_id_unique UNIQUE (ws_id, client_id);


--
-- TOC entry 3427 (class 2606 OID 16630)
-- Name: oauth2_tokens oauth2_tokens_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3429 (class 2606 OID 16632)
-- Name: oauth2_tokens oauth2_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3433 (class 2606 OID 16634)
-- Name: oauth2_tokens oauth2_tokens_ws_id_access_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_access_token_unique UNIQUE (ws_id, access_token);


--
-- TOC entry 3435 (class 2606 OID 16636)
-- Name: oauth2_tokens oauth2_tokens_ws_id_refresh_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_refresh_token_unique UNIQUE (ws_id, refresh_token);


--
-- TOC entry 3437 (class 2606 OID 16638)
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (key);


--
-- TOC entry 3439 (class 2606 OID 16640)
-- Name: plugins plugins_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_cache_key_key UNIQUE (cache_key);


--
-- TOC entry 3442 (class 2606 OID 16642)
-- Name: plugins plugins_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3445 (class 2606 OID 16644)
-- Name: plugins plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_pkey PRIMARY KEY (id);


--
-- TOC entry 3451 (class 2606 OID 16646)
-- Name: ratelimiting_metrics ratelimiting_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ratelimiting_metrics
    ADD CONSTRAINT ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);


--
-- TOC entry 3454 (class 2606 OID 16648)
-- Name: response_ratelimiting_metrics response_ratelimiting_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.response_ratelimiting_metrics
    ADD CONSTRAINT response_ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);


--
-- TOC entry 3456 (class 2606 OID 16650)
-- Name: routes routes_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3458 (class 2606 OID 16652)
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- TOC entry 3462 (class 2606 OID 16654)
-- Name: routes routes_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_ws_id_name_unique UNIQUE (ws_id, name);


--
-- TOC entry 3464 (class 2606 OID 16656)
-- Name: schema_meta schema_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_meta
    ADD CONSTRAINT schema_meta_pkey PRIMARY KEY (key, subsystem);


--
-- TOC entry 3467 (class 2606 OID 16658)
-- Name: services services_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3469 (class 2606 OID 16660)
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- TOC entry 3472 (class 2606 OID 16662)
-- Name: services services_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_ws_id_name_unique UNIQUE (ws_id, name);


--
-- TOC entry 3475 (class 2606 OID 16664)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 3477 (class 2606 OID 16666)
-- Name: sessions sessions_session_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_session_id_key UNIQUE (session_id);


--
-- TOC entry 3481 (class 2606 OID 16668)
-- Name: snis snis_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3483 (class 2606 OID 16670)
-- Name: snis snis_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_name_key UNIQUE (name);


--
-- TOC entry 3485 (class 2606 OID 16672)
-- Name: snis snis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_pkey PRIMARY KEY (id);


--
-- TOC entry 3489 (class 2606 OID 16674)
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (entity_id);


--
-- TOC entry 3492 (class 2606 OID 16676)
-- Name: targets targets_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3494 (class 2606 OID 16678)
-- Name: targets targets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_pkey PRIMARY KEY (id);


--
-- TOC entry 3499 (class 2606 OID 16680)
-- Name: ttls ttls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ttls
    ADD CONSTRAINT ttls_pkey PRIMARY KEY (primary_key_value, table_name);


--
-- TOC entry 3503 (class 2606 OID 16682)
-- Name: upstreams upstreams_id_ws_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_id_ws_id_unique UNIQUE (id, ws_id);


--
-- TOC entry 3505 (class 2606 OID 16684)
-- Name: upstreams upstreams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_pkey PRIMARY KEY (id);


--
-- TOC entry 3508 (class 2606 OID 16686)
-- Name: upstreams upstreams_ws_id_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_ws_id_name_unique UNIQUE (ws_id, name);


--
-- TOC entry 3510 (class 2606 OID 16688)
-- Name: vaults_beta vaults_beta_id_ws_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_id_ws_id_key UNIQUE (id, ws_id);


--
-- TOC entry 3512 (class 2606 OID 16690)
-- Name: vaults_beta vaults_beta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_pkey PRIMARY KEY (id);


--
-- TOC entry 3514 (class 2606 OID 16692)
-- Name: vaults_beta vaults_beta_prefix_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_prefix_key UNIQUE (prefix);


--
-- TOC entry 3516 (class 2606 OID 16694)
-- Name: vaults_beta vaults_beta_prefix_ws_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_prefix_ws_id_key UNIQUE (prefix, ws_id);


--
-- TOC entry 3519 (class 2606 OID 16696)
-- Name: workspaces workspaces_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_name_key UNIQUE (name);


--
-- TOC entry 3521 (class 2606 OID 16698)
-- Name: workspaces workspaces_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_pkey PRIMARY KEY (id);


--
-- TOC entry 3330 (class 1259 OID 16699)
-- Name: acls_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX acls_consumer_id_idx ON public.acls USING btree (consumer_id);


--
-- TOC entry 3331 (class 1259 OID 16700)
-- Name: acls_group_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX acls_group_idx ON public.acls USING btree ("group");


--
-- TOC entry 3336 (class 1259 OID 16701)
-- Name: acls_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX acls_tags_idex_tags_idx ON public.acls USING gin (tags);


--
-- TOC entry 3341 (class 1259 OID 16702)
-- Name: basicauth_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX basicauth_consumer_id_idx ON public.basicauth_credentials USING btree (consumer_id);


--
-- TOC entry 3348 (class 1259 OID 16703)
-- Name: basicauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX basicauth_tags_idex_tags_idx ON public.basicauth_credentials USING gin (tags);


--
-- TOC entry 3357 (class 1259 OID 16704)
-- Name: certificates_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX certificates_tags_idx ON public.certificates USING gin (tags);


--
-- TOC entry 3358 (class 1259 OID 16705)
-- Name: cluster_events_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cluster_events_at_idx ON public.cluster_events USING btree (at);


--
-- TOC entry 3359 (class 1259 OID 16706)
-- Name: cluster_events_channel_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cluster_events_channel_idx ON public.cluster_events USING btree (channel);


--
-- TOC entry 3360 (class 1259 OID 16707)
-- Name: cluster_events_expire_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cluster_events_expire_at_idx ON public.cluster_events USING btree (expire_at);


--
-- TOC entry 3365 (class 1259 OID 16708)
-- Name: clustering_data_planes_ttl_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX clustering_data_planes_ttl_idx ON public.clustering_data_planes USING btree (ttl);


--
-- TOC entry 3370 (class 1259 OID 16709)
-- Name: consumers_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX consumers_tags_idx ON public.consumers USING gin (tags);


--
-- TOC entry 3371 (class 1259 OID 16710)
-- Name: consumers_username_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX consumers_username_idx ON public.consumers USING btree (lower(username));


--
-- TOC entry 3376 (class 1259 OID 16711)
-- Name: hmacauth_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hmacauth_credentials_consumer_id_idx ON public.hmacauth_credentials USING btree (consumer_id);


--
-- TOC entry 3383 (class 1259 OID 16712)
-- Name: hmacauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hmacauth_tags_idex_tags_idx ON public.hmacauth_credentials USING gin (tags);


--
-- TOC entry 3384 (class 1259 OID 16713)
-- Name: jwt_secrets_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jwt_secrets_consumer_id_idx ON public.jwt_secrets USING btree (consumer_id);


--
-- TOC entry 3389 (class 1259 OID 16714)
-- Name: jwt_secrets_secret_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jwt_secrets_secret_idx ON public.jwt_secrets USING btree (secret);


--
-- TOC entry 3392 (class 1259 OID 16715)
-- Name: jwtsecrets_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jwtsecrets_tags_idex_tags_idx ON public.jwt_secrets USING gin (tags);


--
-- TOC entry 3393 (class 1259 OID 16716)
-- Name: keyauth_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX keyauth_credentials_consumer_id_idx ON public.keyauth_credentials USING btree (consumer_id);


--
-- TOC entry 3398 (class 1259 OID 16717)
-- Name: keyauth_credentials_ttl_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX keyauth_credentials_ttl_idx ON public.keyauth_credentials USING btree (ttl);


--
-- TOC entry 3401 (class 1259 OID 16718)
-- Name: keyauth_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX keyauth_tags_idex_tags_idx ON public.keyauth_credentials USING gin (tags);


--
-- TOC entry 3404 (class 1259 OID 16719)
-- Name: locks_ttl_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX locks_ttl_idx ON public.locks USING btree (ttl);


--
-- TOC entry 3405 (class 1259 OID 16720)
-- Name: oauth2_authorization_codes_authenticated_userid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_authorization_codes_authenticated_userid_idx ON public.oauth2_authorization_codes USING btree (authenticated_userid);


--
-- TOC entry 3410 (class 1259 OID 16721)
-- Name: oauth2_authorization_codes_ttl_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_authorization_codes_ttl_idx ON public.oauth2_authorization_codes USING btree (ttl);


--
-- TOC entry 3413 (class 1259 OID 16722)
-- Name: oauth2_authorization_credential_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_authorization_credential_id_idx ON public.oauth2_authorization_codes USING btree (credential_id);


--
-- TOC entry 3414 (class 1259 OID 16723)
-- Name: oauth2_authorization_service_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_authorization_service_id_idx ON public.oauth2_authorization_codes USING btree (service_id);


--
-- TOC entry 3415 (class 1259 OID 16724)
-- Name: oauth2_credentials_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_credentials_consumer_id_idx ON public.oauth2_credentials USING btree (consumer_id);


--
-- TOC entry 3420 (class 1259 OID 16725)
-- Name: oauth2_credentials_secret_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_credentials_secret_idx ON public.oauth2_credentials USING btree (client_secret);


--
-- TOC entry 3421 (class 1259 OID 16726)
-- Name: oauth2_credentials_tags_idex_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_credentials_tags_idex_tags_idx ON public.oauth2_credentials USING gin (tags);


--
-- TOC entry 3424 (class 1259 OID 16727)
-- Name: oauth2_tokens_authenticated_userid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_tokens_authenticated_userid_idx ON public.oauth2_tokens USING btree (authenticated_userid);


--
-- TOC entry 3425 (class 1259 OID 16728)
-- Name: oauth2_tokens_credential_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_tokens_credential_id_idx ON public.oauth2_tokens USING btree (credential_id);


--
-- TOC entry 3430 (class 1259 OID 16729)
-- Name: oauth2_tokens_service_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_tokens_service_id_idx ON public.oauth2_tokens USING btree (service_id);


--
-- TOC entry 3431 (class 1259 OID 16730)
-- Name: oauth2_tokens_ttl_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oauth2_tokens_ttl_idx ON public.oauth2_tokens USING btree (ttl);


--
-- TOC entry 3440 (class 1259 OID 16731)
-- Name: plugins_consumer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX plugins_consumer_id_idx ON public.plugins USING btree (consumer_id);


--
-- TOC entry 3443 (class 1259 OID 16732)
-- Name: plugins_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX plugins_name_idx ON public.plugins USING btree (name);


--
-- TOC entry 3446 (class 1259 OID 16733)
-- Name: plugins_route_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX plugins_route_id_idx ON public.plugins USING btree (route_id);


--
-- TOC entry 3447 (class 1259 OID 16734)
-- Name: plugins_service_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX plugins_service_id_idx ON public.plugins USING btree (service_id);


--
-- TOC entry 3448 (class 1259 OID 16735)
-- Name: plugins_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX plugins_tags_idx ON public.plugins USING gin (tags);


--
-- TOC entry 3449 (class 1259 OID 16736)
-- Name: ratelimiting_metrics_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ratelimiting_metrics_idx ON public.ratelimiting_metrics USING btree (service_id, route_id, period_date, period);


--
-- TOC entry 3452 (class 1259 OID 16737)
-- Name: ratelimiting_metrics_ttl_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ratelimiting_metrics_ttl_idx ON public.ratelimiting_metrics USING btree (ttl);


--
-- TOC entry 3459 (class 1259 OID 16738)
-- Name: routes_service_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX routes_service_id_idx ON public.routes USING btree (service_id);


--
-- TOC entry 3460 (class 1259 OID 16739)
-- Name: routes_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX routes_tags_idx ON public.routes USING gin (tags);


--
-- TOC entry 3465 (class 1259 OID 16740)
-- Name: services_fkey_client_certificate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_fkey_client_certificate ON public.services USING btree (client_certificate_id);


--
-- TOC entry 3470 (class 1259 OID 16741)
-- Name: services_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX services_tags_idx ON public.services USING gin (tags);


--
-- TOC entry 3473 (class 1259 OID 16742)
-- Name: session_sessions_expires_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX session_sessions_expires_idx ON public.sessions USING btree (expires);


--
-- TOC entry 3478 (class 1259 OID 16743)
-- Name: sessions_ttl_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_ttl_idx ON public.sessions USING btree (ttl);


--
-- TOC entry 3479 (class 1259 OID 16744)
-- Name: snis_certificate_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX snis_certificate_id_idx ON public.snis USING btree (certificate_id);


--
-- TOC entry 3486 (class 1259 OID 16745)
-- Name: snis_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX snis_tags_idx ON public.snis USING gin (tags);


--
-- TOC entry 3487 (class 1259 OID 16746)
-- Name: tags_entity_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tags_entity_name_idx ON public.tags USING btree (entity_name);


--
-- TOC entry 3490 (class 1259 OID 16747)
-- Name: tags_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tags_tags_idx ON public.tags USING gin (tags);


--
-- TOC entry 3495 (class 1259 OID 16748)
-- Name: targets_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX targets_tags_idx ON public.targets USING gin (tags);


--
-- TOC entry 3496 (class 1259 OID 16749)
-- Name: targets_target_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX targets_target_idx ON public.targets USING btree (target);


--
-- TOC entry 3497 (class 1259 OID 16750)
-- Name: targets_upstream_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX targets_upstream_id_idx ON public.targets USING btree (upstream_id);


--
-- TOC entry 3500 (class 1259 OID 16751)
-- Name: ttls_primary_uuid_value_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ttls_primary_uuid_value_idx ON public.ttls USING btree (primary_uuid_value);


--
-- TOC entry 3501 (class 1259 OID 16752)
-- Name: upstreams_fkey_client_certificate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX upstreams_fkey_client_certificate ON public.upstreams USING btree (client_certificate_id);


--
-- TOC entry 3506 (class 1259 OID 16753)
-- Name: upstreams_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX upstreams_tags_idx ON public.upstreams USING gin (tags);


--
-- TOC entry 3517 (class 1259 OID 16754)
-- Name: vaults_beta_tags_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vaults_beta_tags_idx ON public.vaults_beta USING gin (tags);


--
-- TOC entry 3557 (class 2620 OID 16755)
-- Name: acls acls_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER acls_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.acls FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3558 (class 2620 OID 16756)
-- Name: basicauth_credentials basicauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER basicauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.basicauth_credentials FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3559 (class 2620 OID 16757)
-- Name: ca_certificates ca_certificates_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ca_certificates_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.ca_certificates FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3560 (class 2620 OID 16758)
-- Name: certificates certificates_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER certificates_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.certificates FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3561 (class 2620 OID 16759)
-- Name: consumers consumers_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consumers_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.consumers FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3562 (class 2620 OID 16760)
-- Name: hmacauth_credentials hmacauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER hmacauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.hmacauth_credentials FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3563 (class 2620 OID 16761)
-- Name: jwt_secrets jwtsecrets_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER jwtsecrets_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.jwt_secrets FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3564 (class 2620 OID 16762)
-- Name: keyauth_credentials keyauth_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER keyauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.keyauth_credentials FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3565 (class 2620 OID 16763)
-- Name: oauth2_credentials oauth2_credentials_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER oauth2_credentials_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.oauth2_credentials FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3566 (class 2620 OID 16764)
-- Name: plugins plugins_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER plugins_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.plugins FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3567 (class 2620 OID 16765)
-- Name: routes routes_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER routes_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.routes FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3568 (class 2620 OID 16766)
-- Name: services services_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER services_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.services FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3569 (class 2620 OID 16767)
-- Name: snis snis_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER snis_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.snis FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3570 (class 2620 OID 16768)
-- Name: targets targets_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER targets_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.targets FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3571 (class 2620 OID 16769)
-- Name: upstreams upstreams_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER upstreams_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.upstreams FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3572 (class 2620 OID 16770)
-- Name: vaults_beta vaults_beta_sync_tags_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER vaults_beta_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.vaults_beta FOR EACH ROW EXECUTE FUNCTION public.sync_tags();


--
-- TOC entry 3522 (class 2606 OID 16771)
-- Name: acls acls_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3523 (class 2606 OID 16776)
-- Name: acls acls_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3524 (class 2606 OID 16781)
-- Name: basicauth_credentials basicauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3525 (class 2606 OID 16786)
-- Name: basicauth_credentials basicauth_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3526 (class 2606 OID 16791)
-- Name: certificates certificates_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3527 (class 2606 OID 16796)
-- Name: consumers consumers_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3528 (class 2606 OID 16801)
-- Name: hmacauth_credentials hmacauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3529 (class 2606 OID 16806)
-- Name: hmacauth_credentials hmacauth_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3530 (class 2606 OID 16811)
-- Name: jwt_secrets jwt_secrets_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3531 (class 2606 OID 16816)
-- Name: jwt_secrets jwt_secrets_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3532 (class 2606 OID 16821)
-- Name: keyauth_credentials keyauth_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3533 (class 2606 OID 16826)
-- Name: keyauth_credentials keyauth_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3534 (class 2606 OID 16831)
-- Name: oauth2_authorization_codes oauth2_authorization_codes_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_credential_id_fkey FOREIGN KEY (credential_id, ws_id) REFERENCES public.oauth2_credentials(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3535 (class 2606 OID 16836)
-- Name: oauth2_authorization_codes oauth2_authorization_codes_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3536 (class 2606 OID 16841)
-- Name: oauth2_authorization_codes oauth2_authorization_codes_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3537 (class 2606 OID 16846)
-- Name: oauth2_credentials oauth2_credentials_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3538 (class 2606 OID 16851)
-- Name: oauth2_credentials oauth2_credentials_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3539 (class 2606 OID 16856)
-- Name: oauth2_tokens oauth2_tokens_credential_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_credential_id_fkey FOREIGN KEY (credential_id, ws_id) REFERENCES public.oauth2_credentials(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3540 (class 2606 OID 16861)
-- Name: oauth2_tokens oauth2_tokens_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3541 (class 2606 OID 16866)
-- Name: oauth2_tokens oauth2_tokens_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3542 (class 2606 OID 16871)
-- Name: plugins plugins_consumer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3543 (class 2606 OID 16876)
-- Name: plugins plugins_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_route_id_fkey FOREIGN KEY (route_id, ws_id) REFERENCES public.routes(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3544 (class 2606 OID 16881)
-- Name: plugins plugins_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3545 (class 2606 OID 16886)
-- Name: plugins plugins_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3546 (class 2606 OID 16891)
-- Name: routes routes_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id);


--
-- TOC entry 3547 (class 2606 OID 16896)
-- Name: routes routes_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3548 (class 2606 OID 16901)
-- Name: services services_client_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_client_certificate_id_fkey FOREIGN KEY (client_certificate_id, ws_id) REFERENCES public.certificates(id, ws_id);


--
-- TOC entry 3549 (class 2606 OID 16906)
-- Name: services services_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3550 (class 2606 OID 16911)
-- Name: snis snis_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_certificate_id_fkey FOREIGN KEY (certificate_id, ws_id) REFERENCES public.certificates(id, ws_id);


--
-- TOC entry 3551 (class 2606 OID 16916)
-- Name: snis snis_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3552 (class 2606 OID 16921)
-- Name: targets targets_upstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_upstream_id_fkey FOREIGN KEY (upstream_id, ws_id) REFERENCES public.upstreams(id, ws_id) ON DELETE CASCADE;


--
-- TOC entry 3553 (class 2606 OID 16926)
-- Name: targets targets_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3554 (class 2606 OID 16931)
-- Name: upstreams upstreams_client_certificate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_client_certificate_id_fkey FOREIGN KEY (client_certificate_id) REFERENCES public.certificates(id);


--
-- TOC entry 3555 (class 2606 OID 16936)
-- Name: upstreams upstreams_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


--
-- TOC entry 3556 (class 2606 OID 16941)
-- Name: vaults_beta vaults_beta_ws_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaults_beta
    ADD CONSTRAINT vaults_beta_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);


-- Completed on 2023-04-06 14:36:04 UTC

--
-- PostgreSQL database dump complete
--

