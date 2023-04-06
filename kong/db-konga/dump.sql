--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.24
-- Dumped by pg_dump version 15.1

-- Started on 2023-04-06 14:36:54 UTC

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
-- TOC entry 7 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

--
-- TOC entry 186 (class 1259 OID 16522)
-- Name: konga_api_health_checks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.konga_api_health_checks (
    id integer NOT NULL,
    api_id text,
    api json,
    health_check_endpoint text,
    notification_endpoint text,
    active boolean,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_api_health_checks OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 16520)
-- Name: konga_api_health_checks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.konga_api_health_checks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_api_health_checks_id_seq OWNER TO postgres;

--
-- TOC entry 2268 (class 0 OID 0)
-- Dependencies: 185
-- Name: konga_api_health_checks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.konga_api_health_checks_id_seq OWNED BY public.konga_api_health_checks.id;


--
-- TOC entry 188 (class 1259 OID 16535)
-- Name: konga_email_transports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.konga_email_transports (
    id integer NOT NULL,
    name text,
    description text,
    schema json,
    settings json,
    active boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_email_transports OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 16533)
-- Name: konga_email_transports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.konga_email_transports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_email_transports_id_seq OWNER TO postgres;

--
-- TOC entry 2269 (class 0 OID 0)
-- Dependencies: 187
-- Name: konga_email_transports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.konga_email_transports_id_seq OWNED BY public.konga_email_transports.id;


--
-- TOC entry 190 (class 1259 OID 16548)
-- Name: konga_kong_nodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.konga_kong_nodes (
    id integer NOT NULL,
    name text,
    type text,
    kong_admin_url text,
    netdata_url text,
    kong_api_key text,
    jwt_algorithm text,
    jwt_key text,
    jwt_secret text,
    username text,
    password text,
    kong_version text,
    health_checks boolean,
    health_check_details json,
    active boolean,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_nodes OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 16546)
-- Name: konga_kong_nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.konga_kong_nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_nodes_id_seq OWNER TO postgres;

--
-- TOC entry 2270 (class 0 OID 0)
-- Dependencies: 189
-- Name: konga_kong_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.konga_kong_nodes_id_seq OWNED BY public.konga_kong_nodes.id;


--
-- TOC entry 192 (class 1259 OID 16559)
-- Name: konga_kong_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.konga_kong_services (
    id integer NOT NULL,
    service_id text,
    kong_node_id text,
    description text,
    tags json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_services OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 16557)
-- Name: konga_kong_services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.konga_kong_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_services_id_seq OWNER TO postgres;

--
-- TOC entry 2271 (class 0 OID 0)
-- Dependencies: 191
-- Name: konga_kong_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.konga_kong_services_id_seq OWNED BY public.konga_kong_services.id;


--
-- TOC entry 202 (class 1259 OID 16618)
-- Name: konga_kong_snapshot_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.konga_kong_snapshot_schedules (
    id integer NOT NULL,
    connection integer,
    active boolean,
    cron text,
    "lastRunAt" date,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_snapshot_schedules OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 16616)
-- Name: konga_kong_snapshot_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.konga_kong_snapshot_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_snapshot_schedules_id_seq OWNER TO postgres;

--
-- TOC entry 2272 (class 0 OID 0)
-- Dependencies: 201
-- Name: konga_kong_snapshot_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.konga_kong_snapshot_schedules_id_seq OWNED BY public.konga_kong_snapshot_schedules.id;


--
-- TOC entry 200 (class 1259 OID 16605)
-- Name: konga_kong_snapshots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.konga_kong_snapshots (
    id integer NOT NULL,
    name text,
    kong_node_name text,
    kong_node_url text,
    kong_version text,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_snapshots OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 16603)
-- Name: konga_kong_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.konga_kong_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_snapshots_id_seq OWNER TO postgres;

--
-- TOC entry 2273 (class 0 OID 0)
-- Dependencies: 199
-- Name: konga_kong_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.konga_kong_snapshots_id_seq OWNED BY public.konga_kong_snapshots.id;


--
-- TOC entry 204 (class 1259 OID 16629)
-- Name: konga_kong_upstream_alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.konga_kong_upstream_alerts (
    id integer NOT NULL,
    upstream_id text,
    connection integer,
    email boolean,
    slack boolean,
    cron text,
    active boolean,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_kong_upstream_alerts OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16627)
-- Name: konga_kong_upstream_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.konga_kong_upstream_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_kong_upstream_alerts_id_seq OWNER TO postgres;

--
-- TOC entry 2274 (class 0 OID 0)
-- Dependencies: 203
-- Name: konga_kong_upstream_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.konga_kong_upstream_alerts_id_seq OWNED BY public.konga_kong_upstream_alerts.id;


--
-- TOC entry 194 (class 1259 OID 16572)
-- Name: konga_netdata_connections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.konga_netdata_connections (
    id integer NOT NULL,
    "apiId" text,
    url text,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_netdata_connections OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 16570)
-- Name: konga_netdata_connections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.konga_netdata_connections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_netdata_connections_id_seq OWNER TO postgres;

--
-- TOC entry 2275 (class 0 OID 0)
-- Dependencies: 193
-- Name: konga_netdata_connections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.konga_netdata_connections_id_seq OWNED BY public.konga_netdata_connections.id;


--
-- TOC entry 196 (class 1259 OID 16583)
-- Name: konga_passports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.konga_passports (
    id integer NOT NULL,
    protocol text,
    password text,
    provider text,
    identifier text,
    tokens json,
    "user" integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone
);


ALTER TABLE public.konga_passports OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 16581)
-- Name: konga_passports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.konga_passports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_passports_id_seq OWNER TO postgres;

--
-- TOC entry 2276 (class 0 OID 0)
-- Dependencies: 195
-- Name: konga_passports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.konga_passports_id_seq OWNED BY public.konga_passports.id;


--
-- TOC entry 198 (class 1259 OID 16594)
-- Name: konga_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.konga_settings (
    id integer NOT NULL,
    data json,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_settings OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 16592)
-- Name: konga_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.konga_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_settings_id_seq OWNER TO postgres;

--
-- TOC entry 2277 (class 0 OID 0)
-- Dependencies: 197
-- Name: konga_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.konga_settings_id_seq OWNED BY public.konga_settings.id;


--
-- TOC entry 206 (class 1259 OID 16642)
-- Name: konga_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.konga_users (
    id integer NOT NULL,
    username text,
    email text,
    "firstName" text,
    "lastName" text,
    admin boolean,
    node_id text,
    active boolean,
    "activationToken" text,
    node integer,
    "createdAt" timestamp with time zone,
    "updatedAt" timestamp with time zone,
    "createdUserId" integer,
    "updatedUserId" integer
);


ALTER TABLE public.konga_users OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 16640)
-- Name: konga_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.konga_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.konga_users_id_seq OWNER TO postgres;

--
-- TOC entry 2278 (class 0 OID 0)
-- Dependencies: 205
-- Name: konga_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.konga_users_id_seq OWNED BY public.konga_users.id;


--
-- TOC entry 2076 (class 2604 OID 16525)
-- Name: konga_api_health_checks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_api_health_checks ALTER COLUMN id SET DEFAULT nextval('public.konga_api_health_checks_id_seq'::regclass);


--
-- TOC entry 2077 (class 2604 OID 16538)
-- Name: konga_email_transports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_email_transports ALTER COLUMN id SET DEFAULT nextval('public.konga_email_transports_id_seq'::regclass);


--
-- TOC entry 2078 (class 2604 OID 16551)
-- Name: konga_kong_nodes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_nodes ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_nodes_id_seq'::regclass);


--
-- TOC entry 2079 (class 2604 OID 16562)
-- Name: konga_kong_services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_services ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_services_id_seq'::regclass);


--
-- TOC entry 2084 (class 2604 OID 16621)
-- Name: konga_kong_snapshot_schedules id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_snapshot_schedules ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_snapshot_schedules_id_seq'::regclass);


--
-- TOC entry 2083 (class 2604 OID 16608)
-- Name: konga_kong_snapshots id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_snapshots ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_snapshots_id_seq'::regclass);


--
-- TOC entry 2085 (class 2604 OID 16632)
-- Name: konga_kong_upstream_alerts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_upstream_alerts ALTER COLUMN id SET DEFAULT nextval('public.konga_kong_upstream_alerts_id_seq'::regclass);


--
-- TOC entry 2080 (class 2604 OID 16575)
-- Name: konga_netdata_connections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_netdata_connections ALTER COLUMN id SET DEFAULT nextval('public.konga_netdata_connections_id_seq'::regclass);


--
-- TOC entry 2081 (class 2604 OID 16586)
-- Name: konga_passports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_passports ALTER COLUMN id SET DEFAULT nextval('public.konga_passports_id_seq'::regclass);


--
-- TOC entry 2082 (class 2604 OID 16597)
-- Name: konga_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_settings ALTER COLUMN id SET DEFAULT nextval('public.konga_settings_id_seq'::regclass);


--
-- TOC entry 2086 (class 2604 OID 16645)
-- Name: konga_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_users ALTER COLUMN id SET DEFAULT nextval('public.konga_users_id_seq'::regclass);


--
-- TOC entry 2241 (class 0 OID 16522)
-- Dependencies: 186
-- Data for Name: konga_api_health_checks; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2243 (class 0 OID 16535)
-- Dependencies: 188
-- Data for Name: konga_email_transports; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.konga_email_transports (id, name, description, schema, settings, active, "createdAt", "updatedAt", "createdUserId", "updatedUserId") VALUES (1, 'smtp', 'Send emails using the SMTP protocol', '[{"name":"host","description":"The SMTP host","type":"text","required":true},{"name":"port","description":"The SMTP port","type":"text","required":true},{"name":"username","model":"auth.user","description":"The SMTP user username","type":"text","required":true},{"name":"password","model":"auth.pass","description":"The SMTP user password","type":"text","required":true},{"name":"secure","model":"secure","description":"Use secure connection","type":"boolean"}]', '{"host":"","port":"","auth":{"user":"","pass":""},"secure":false}', true, '2022-03-10 14:20:32+00', '2023-04-06 14:25:58+00', NULL, NULL);
INSERT INTO public.konga_email_transports (id, name, description, schema, settings, active, "createdAt", "updatedAt", "createdUserId", "updatedUserId") VALUES (2, 'sendmail', 'Pipe messages to the sendmail command', NULL, '{"sendmail":true}', false, '2022-03-10 14:20:32+00', '2023-04-06 14:25:58+00', NULL, NULL);
INSERT INTO public.konga_email_transports (id, name, description, schema, settings, active, "createdAt", "updatedAt", "createdUserId", "updatedUserId") VALUES (3, 'mailgun', 'Send emails through Mailgun’s Web API', '[{"name":"api_key","model":"auth.api_key","description":"The API key that you got from www.mailgun.com/cp","type":"text","required":true},{"name":"domain","model":"auth.domain","description":"One of your domain names listed at your https://mailgun.com/app/domains","type":"text","required":true}]', '{"auth":{"api_key":"","domain":""}}', false, '2022-03-10 14:20:32+00', '2023-04-06 14:25:58+00', NULL, NULL);


--
-- TOC entry 2245 (class 0 OID 16548)
-- Dependencies: 190
-- Data for Name: konga_kong_nodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.konga_kong_nodes (id, name, type, kong_admin_url, netdata_url, kong_api_key, jwt_algorithm, jwt_key, jwt_secret, username, password, kong_version, health_checks, health_check_details, active, "createdAt", "updatedAt", "createdUserId", "updatedUserId") VALUES (1, 'kong', 'default', 'http://kong:8001', NULL, '', 'HS256', NULL, NULL, '', '', '2.8.0', false, NULL, false, '2022-03-10 14:21:41+00', '2022-03-10 14:21:41+00', 1, 1);


--
-- TOC entry 2247 (class 0 OID 16559)
-- Dependencies: 192
-- Data for Name: konga_kong_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.konga_kong_services (id, service_id, kong_node_id, description, tags, "createdAt", "updatedAt", "createdUserId", "updatedUserId") VALUES (4, 'f24c4b14-3fa4-496d-a17c-2e3bcb341dbf', '1', NULL, NULL, '2023-04-06 14:01:35+00', '2023-04-06 14:01:35+00', NULL, NULL);
INSERT INTO public.konga_kong_services (id, service_id, kong_node_id, description, tags, "createdAt", "updatedAt", "createdUserId", "updatedUserId") VALUES (5, 'e50711d2-24b7-42a2-8cc4-b71eeba37641', '1', NULL, NULL, '2023-04-06 14:01:51+00', '2023-04-06 14:01:51+00', NULL, NULL);


--
-- TOC entry 2257 (class 0 OID 16618)
-- Dependencies: 202
-- Data for Name: konga_kong_snapshot_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2255 (class 0 OID 16605)
-- Dependencies: 200
-- Data for Name: konga_kong_snapshots; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2259 (class 0 OID 16629)
-- Dependencies: 204
-- Data for Name: konga_kong_upstream_alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2249 (class 0 OID 16572)
-- Dependencies: 194
-- Data for Name: konga_netdata_connections; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2251 (class 0 OID 16583)
-- Dependencies: 196
-- Data for Name: konga_passports; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.konga_passports (id, protocol, password, provider, identifier, tokens, "user", "createdAt", "updatedAt") VALUES (1, 'local', '$2a$10$0.HeCQBaVDlF9cBpacUPOeJSQTDT7ztUWddSocdezgKx4o/cf6vWe', NULL, NULL, NULL, 1, '2022-03-10 14:21:04+00', '2022-03-10 14:21:04+00');


--
-- TOC entry 2253 (class 0 OID 16594)
-- Dependencies: 198
-- Data for Name: konga_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.konga_settings (id, data, "createdAt", "updatedAt", "createdUserId", "updatedUserId") VALUES (1, '{"signup_enable":false,"signup_require_activation":false,"info_polling_interval":5000,"email_default_sender_name":"KONGA","email_default_sender":"konga@konga.test","email_notifications":false,"default_transport":"sendmail","notify_when":{"node_down":{"title":"A node is down or unresponsive","description":"Health checks must be enabled for the nodes that need to be monitored.","active":false},"api_down":{"title":"An API is down or unresponsive","description":"Health checks must be enabled for the APIs that need to be monitored.","active":false}},"integrations":[{"id":"slack","name":"Slack","image":"slack_rgb.png","config":{"enabled":false,"fields":[{"id":"slack_webhook_url","name":"Slack Webhook URL","type":"text","required":true,"value":""}],"slack_webhook_url":""}}],"user_permissions":{"apis":{"create":false,"read":true,"update":false,"delete":false},"services":{"create":false,"read":true,"update":false,"delete":false},"routes":{"create":false,"read":true,"update":false,"delete":false},"consumers":{"create":false,"read":true,"update":false,"delete":false},"plugins":{"create":false,"read":true,"update":false,"delete":false},"upstreams":{"create":false,"read":true,"update":false,"delete":false},"certificates":{"create":false,"read":true,"update":false,"delete":false},"connections":{"create":false,"read":true,"update":false,"delete":false},"users":{"create":false,"read":true,"update":false,"delete":false}}}', '2022-03-10 14:20:32+00', '2023-04-06 14:25:58+00', NULL, NULL);


--
-- TOC entry 2261 (class 0 OID 16642)
-- Dependencies: 206
-- Data for Name: konga_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.konga_users (id, username, email, "firstName", "lastName", admin, node_id, active, "activationToken", node, "createdAt", "updatedAt", "createdUserId", "updatedUserId") VALUES (1, 'admin', 'admin@admin.com.br', NULL, NULL, true, '', true, '4a98223e-eb1a-46b0-a74d-4ab791160510', 1, '2022-03-10 14:21:04+00', '2022-03-10 14:21:41+00', NULL, 1);


--
-- TOC entry 2279 (class 0 OID 0)
-- Dependencies: 185
-- Name: konga_api_health_checks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.konga_api_health_checks_id_seq', 1, false);


--
-- TOC entry 2280 (class 0 OID 0)
-- Dependencies: 187
-- Name: konga_email_transports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.konga_email_transports_id_seq', 3, true);


--
-- TOC entry 2281 (class 0 OID 0)
-- Dependencies: 189
-- Name: konga_kong_nodes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.konga_kong_nodes_id_seq', 1, true);


--
-- TOC entry 2282 (class 0 OID 0)
-- Dependencies: 191
-- Name: konga_kong_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.konga_kong_services_id_seq', 5, true);


--
-- TOC entry 2283 (class 0 OID 0)
-- Dependencies: 201
-- Name: konga_kong_snapshot_schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.konga_kong_snapshot_schedules_id_seq', 1, false);


--
-- TOC entry 2284 (class 0 OID 0)
-- Dependencies: 199
-- Name: konga_kong_snapshots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.konga_kong_snapshots_id_seq', 1, false);


--
-- TOC entry 2285 (class 0 OID 0)
-- Dependencies: 203
-- Name: konga_kong_upstream_alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.konga_kong_upstream_alerts_id_seq', 1, false);


--
-- TOC entry 2286 (class 0 OID 0)
-- Dependencies: 193
-- Name: konga_netdata_connections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.konga_netdata_connections_id_seq', 1, false);


--
-- TOC entry 2287 (class 0 OID 0)
-- Dependencies: 195
-- Name: konga_passports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.konga_passports_id_seq', 1, true);


--
-- TOC entry 2288 (class 0 OID 0)
-- Dependencies: 197
-- Name: konga_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.konga_settings_id_seq', 1, true);


--
-- TOC entry 2289 (class 0 OID 0)
-- Dependencies: 205
-- Name: konga_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.konga_users_id_seq', 1, true);


--
-- TOC entry 2088 (class 2606 OID 16532)
-- Name: konga_api_health_checks konga_api_health_checks_api_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_api_health_checks
    ADD CONSTRAINT konga_api_health_checks_api_id_key UNIQUE (api_id);


--
-- TOC entry 2090 (class 2606 OID 16530)
-- Name: konga_api_health_checks konga_api_health_checks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_api_health_checks
    ADD CONSTRAINT konga_api_health_checks_pkey PRIMARY KEY (id);


--
-- TOC entry 2092 (class 2606 OID 16545)
-- Name: konga_email_transports konga_email_transports_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_email_transports
    ADD CONSTRAINT konga_email_transports_name_key UNIQUE (name);


--
-- TOC entry 2094 (class 2606 OID 16543)
-- Name: konga_email_transports konga_email_transports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_email_transports
    ADD CONSTRAINT konga_email_transports_pkey PRIMARY KEY (id);


--
-- TOC entry 2096 (class 2606 OID 16556)
-- Name: konga_kong_nodes konga_kong_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_nodes
    ADD CONSTRAINT konga_kong_nodes_pkey PRIMARY KEY (id);


--
-- TOC entry 2098 (class 2606 OID 16567)
-- Name: konga_kong_services konga_kong_services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_services
    ADD CONSTRAINT konga_kong_services_pkey PRIMARY KEY (id);


--
-- TOC entry 2100 (class 2606 OID 16569)
-- Name: konga_kong_services konga_kong_services_service_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_services
    ADD CONSTRAINT konga_kong_services_service_id_key UNIQUE (service_id);


--
-- TOC entry 2112 (class 2606 OID 16626)
-- Name: konga_kong_snapshot_schedules konga_kong_snapshot_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_snapshot_schedules
    ADD CONSTRAINT konga_kong_snapshot_schedules_pkey PRIMARY KEY (id);


--
-- TOC entry 2108 (class 2606 OID 16615)
-- Name: konga_kong_snapshots konga_kong_snapshots_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_snapshots
    ADD CONSTRAINT konga_kong_snapshots_name_key UNIQUE (name);


--
-- TOC entry 2110 (class 2606 OID 16613)
-- Name: konga_kong_snapshots konga_kong_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_snapshots
    ADD CONSTRAINT konga_kong_snapshots_pkey PRIMARY KEY (id);


--
-- TOC entry 2114 (class 2606 OID 16637)
-- Name: konga_kong_upstream_alerts konga_kong_upstream_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_upstream_alerts
    ADD CONSTRAINT konga_kong_upstream_alerts_pkey PRIMARY KEY (id);


--
-- TOC entry 2116 (class 2606 OID 16639)
-- Name: konga_kong_upstream_alerts konga_kong_upstream_alerts_upstream_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_kong_upstream_alerts
    ADD CONSTRAINT konga_kong_upstream_alerts_upstream_id_key UNIQUE (upstream_id);


--
-- TOC entry 2102 (class 2606 OID 16580)
-- Name: konga_netdata_connections konga_netdata_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_netdata_connections
    ADD CONSTRAINT konga_netdata_connections_pkey PRIMARY KEY (id);


--
-- TOC entry 2104 (class 2606 OID 16591)
-- Name: konga_passports konga_passports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_passports
    ADD CONSTRAINT konga_passports_pkey PRIMARY KEY (id);


--
-- TOC entry 2106 (class 2606 OID 16602)
-- Name: konga_settings konga_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_settings
    ADD CONSTRAINT konga_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 2118 (class 2606 OID 16654)
-- Name: konga_users konga_users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_users
    ADD CONSTRAINT konga_users_email_key UNIQUE (email);


--
-- TOC entry 2120 (class 2606 OID 16650)
-- Name: konga_users konga_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_users
    ADD CONSTRAINT konga_users_pkey PRIMARY KEY (id);


--
-- TOC entry 2122 (class 2606 OID 16652)
-- Name: konga_users konga_users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.konga_users
    ADD CONSTRAINT konga_users_username_key UNIQUE (username);


--
-- TOC entry 2267 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-04-06 14:36:54 UTC

--
-- PostgreSQL database dump complete
--

