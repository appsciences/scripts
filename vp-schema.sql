CREATE TYPE event_artist_settlement_type_enum AS ENUM (
    'ticket_sales_events',
    'manual_gbor'
);


--
-- TOC entry 752 (class 1247 OID 16606178)
-- Name: payment_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE payment_type_enum AS ENUM (
    'cash',
    'wire_transfer',
    'credit_card',
    'check'
);


--
-- TOC entry 755 (class 1247 OID 16606188)
-- Name: tax_withholding_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE tax_withholding_type_enum AS ENUM (
    'percentage',
    'fixed'
);




--
-- TOC entry 199 (class 1259 OID 16606195)
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts (
    id bigint NOT NULL,
    website text,
    payment_id text,
    payment_key text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    stripe_api_key text,
    stripe_publishable_key text,
    cardflight_account_token text,
    stripe_user_id text,
    name text,
    gcalendar_access_token character varying,
    gcalendar_refresh_token character varying,
    fee_structure_id integer,
    gcalendar_user_id integer,
    power_bi_access_token character varying,
    power_bi_dataset_id character varying,
    power_bi_refresh_token character varying,
    eventbrite_access_token character varying,
    eventbrite_user_id character varying,
    box_office_processor integer DEFAULT 0 NOT NULL,
    gcalendar_access_token_expiration bigint,
    square_access_token character varying,
    square_access_token_expiration timestamp without time zone,
    eventbrite_organization_id character varying,
    fb_pixel character varying,
    seats_io_account_id integer,
    seats_io_secret_key character varying,
    seats_io_designer_key character varying,
    seats_io_public_key character varying,
    seats_io_active character varying
);

CREATE TABLE active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


CREATE TABLE addresses (
    id bigint NOT NULL,
    street1 text,
    street2 text,
    city text,
    state text,
    postal_code text,
    country text,
    latitude numeric(15,10),
    longitude numeric(15,10),
    owner_id bigint,
    owner_type text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);



CREATE TABLE announce_details (
    id bigint NOT NULL,
    event_id bigint,
    promoter character varying,
    event_name character varying,
    support character varying,
    description character varying,
    website_url character varying,
    facebook_url character varying,
    twitter_url character varying,
    instagram_url character varying,
    tickets_url character varying,
    images character varying[] DEFAULT '{}'::character varying[],
    announce_at timestamp without time zone,
    triggered_at timestamp without time zone,
    on_sale_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    highlighted_image_idx integer,
    status text,
    tags character varying[] DEFAULT '{}'::character varying[]
);



CREATE TABLE artists (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bio text,
    instagram character varying,
    website character varying,
    facebook character varying,
    youtube character varying,
    apple_music character varying,
    spotify character varying,
    twitter character varying,
    lastfm character varying,
    wikipedia character varying,
    songkick character varying,
    spotify_popularity integer,
    spotify_followers integer,
    twitter_followers integer,
    youtube_total_channel_views bigint,
    bands_in_town_tracker integer,
    upcoming_event integer
);


--
-- TOC entry 210 (class 1259 OID 16606243)
-- Name: event_artists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_artists (
    id integer NOT NULL,
    event_group_id integer,
    artist_id integer,
    marquee_position integer,
    performance_time time without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    stage_curfew time without time zone,
    dressing_room_curfew time without time zone,
    deleted boolean DEFAULT false
);


--
-- TOC entry 211 (class 1259 OID 16606247)
-- Name: event_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_groups (
    id integer NOT NULL,
    name character varying,
    notes text,
    venue_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    venue_room character varying,
    locked_person_id integer,
    is_duplicate boolean DEFAULT false NOT NULL,
    ticket_bucket_id bigint,
    list_id bigint
);


--
-- TOC entry 212 (class 1259 OID 16606254)
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events (
    id bigint NOT NULL,
    name text NOT NULL,
    date date,
    start_time time without time zone,
    door_time time without time zone,
    minimum_age bigint,
    email_text text,
    account_id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    venue_id bigint,
    ticket_limit bigint,
    use_ticket_locking boolean DEFAULT false,
    footer_content text,
    mail_pdf_tickets boolean DEFAULT false,
    state integer DEFAULT 0 NOT NULL,
    event_group_id integer,
    hold_preference integer,
    repeat_type integer,
    repeat_random_date date,
    repeat_last_date date,
    end_time time without time zone,
    gcalendar_id character varying,
    locked boolean DEFAULT false,
    venue_room_id integer NOT NULL,
    notes text,
    billing character varying,
    external_url character varying,
    description text,
    confirmed_by_user_id integer,
    created_by_user_id integer,
    eventbrite_event_id bigint,
    available_for_donation boolean DEFAULT false,
    onsale_triggered_at timestamp without time zone,
    available_for_sales_tax boolean DEFAULT false,
    available_for_processing_fee boolean DEFAULT false,
    seating_chart_id bigint,
    seating_chart_selected_at timestamp without time zone,
    reschedule_info jsonb
);


--
-- TOC entry 213 (class 1259 OID 16606267)
-- Name: venues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE venues (
    id bigint NOT NULL,
    account_id bigint,
    name text,
    url text,
    timezone text DEFAULT 'Eastern Time (US & Canada)'::text,
    locale text DEFAULT 'en'::text,
    address_id bigint,
    logo_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sales_tax numeric(6,4) DEFAULT 0 NOT NULL,
    processing_fee numeric(10,2) DEFAULT 0 NOT NULL,
    processing_fee_percentage numeric(10,2) DEFAULT 0 NOT NULL
);


--
-- TOC entry 334 (class 1259 OID 16828636)
-- Name: announced_events_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW announced_events_view AS
 SELECT e.id,
    e.name,
    e.date,
    e.start_time,
    e.end_time,
    e.door_time,
    e.minimum_age,
    e.account_id,
    e.venue_id,
        CASE e.state
            WHEN 0 THEN 'hold'::text
            WHEN 1 THEN 'confirmed'::text
            WHEN 2 THEN 'canceled'::text
            WHEN 3 THEN 'deleted'::text
            ELSE 'unknown'::text
        END AS state,
    e.event_group_id,
    e.venue_room_id,
    e.footer_content,
    ad.announce_at,
    ad.event_name AS announce_name,
    ad.promoter,
    ad.support,
    ad.description,
    ad.website_url,
    ad.facebook_url,
    ad.twitter_url,
    ad.instagram_url,
    ad.tickets_url,
    ad.images,
    ad.triggered_at,
    ad.on_sale_at,
    ad.status,
    COALESCE(a.name, ''::character varying) AS artist_name,
    COALESCE(ad.images[(COALESCE(ad.highlighted_image_idx, 0) + 1)], (
        CASE
            WHEN (asa.id IS NULL) THEN NULL::text
            ELSE ('active_storage_attachment_id_'::text || (asa.id)::text)
        END)::character varying, venues.logo_url) AS highlighted_image,
    ad.tags
   FROM ((((((events e
     JOIN announce_details ad ON ((e.id = ad.event_id)))
     LEFT JOIN event_groups eg ON ((e.event_group_id = eg.id)))
     LEFT JOIN LATERAL ( SELECT ea2.id,
            ea2.artist_id
           FROM event_artists ea2
          WHERE ((ea2.marquee_position = 0) AND (NOT ea2.deleted) AND (ea2.event_group_id = eg.id))
          ORDER BY ea2.artist_id
         LIMIT 1) ea ON ((1 = 1)))
     LEFT JOIN artists a ON ((ea.artist_id = a.id)))
     LEFT JOIN LATERAL ( SELECT asa2.id
           FROM active_storage_attachments asa2
          WHERE (((asa2.record_type)::text = 'VenueApp::Artist'::text) AND (asa2.record_id = a.id))
          ORDER BY asa2.blob_id
         LIMIT 1) asa ON ((1 = 1)))
     JOIN venues ON ((e.venue_id = venues.id)))
  WHERE (ad.triggered_at < now());


--
-- TOC entry 214 (class 1259 OID 16606283)
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 336 (class 1259 OID 16965866)
-- Name: artist_genres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE artist_genres (
    id bigint NOT NULL,
    name character varying,
    artist_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 335 (class 1259 OID 16965864)
-- Name: artist_genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artist_genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4722 (class 0 OID 0)
-- Dependencies: 335
-- Name: artist_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artist_genres_id_seq OWNED BY artist_genres.id;


--
-- TOC entry 215 (class 1259 OID 16606289)
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4723 (class 0 OID 0)
-- Dependencies: 215
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artists_id_seq OWNED BY artists.id;


--
-- TOC entry 216 (class 1259 OID 16606291)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE audit_logs (
    id bigint NOT NULL,
    auditable_type character varying NOT NULL,
    auditable_id bigint NOT NULL,
    user_id bigint,
    object integer NOT NULL,
    verb integer NOT NULL,
    updates jsonb DEFAULT '{}'::jsonb NOT NULL,
    extras jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 16606299)
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4724 (class 0 OID 0)
-- Dependencies: 217
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE audit_logs_id_seq OWNED BY audit_logs.id;


--
-- TOC entry 218 (class 1259 OID 16606301)
-- Name: black_listed_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE black_listed_people (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    first_name text,
    last_name text,
    cc_fingerprint text,
    last_four_digits text,
    email text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- TOC entry 219 (class 1259 OID 16606307)
-- Name: black_listed_people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE black_listed_people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4725 (class 0 OID 0)
-- Dependencies: 219
-- Name: black_listed_people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE black_listed_people_id_seq OWNED BY black_listed_people.id;


--
-- TOC entry 220 (class 1259 OID 16606309)
-- Name: budget_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE budget_plans (
    id bigint NOT NULL,
    event_group_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    budget_template_id bigint
);


--
-- TOC entry 221 (class 1259 OID 16606312)
-- Name: budget_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE budget_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4726 (class 0 OID 0)
-- Dependencies: 221
-- Name: budget_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE budget_plans_id_seq OWNED BY budget_plans.id;


--
-- TOC entry 338 (class 1259 OID 17568362)
-- Name: budget_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE budget_templates (
    id bigint NOT NULL,
    data json,
    budget_plan_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    venue_id bigint
);


--
-- TOC entry 337 (class 1259 OID 17568360)
-- Name: budget_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE budget_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 337
-- Name: budget_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE budget_templates_id_seq OWNED BY budget_templates.id;


--
-- TOC entry 222 (class 1259 OID 16606314)
-- Name: canceled_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE canceled_events (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    email_message text,
    refunds_and_emails_complete boolean DEFAULT false,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    failed_refunds text
);


--
-- TOC entry 223 (class 1259 OID 16606321)
-- Name: canceled_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE canceled_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4728 (class 0 OID 0)
-- Dependencies: 223
-- Name: canceled_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE canceled_events_id_seq OWNED BY canceled_events.id;


--
-- TOC entry 224 (class 1259 OID 16606323)
-- Name: canned_ticket_blueprint_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE canned_ticket_blueprint_sets (
    id bigint NOT NULL,
    account_id bigint,
    name character varying,
    template jsonb DEFAULT '{"ticket_buckets": [], "ticket_blueprints": {"bucket_ticket_blueprints": [], "standalone_ticket_blueprints": []}}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 16606330)
-- Name: canned_ticket_blueprint_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE canned_ticket_blueprint_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4729 (class 0 OID 0)
-- Dependencies: 225
-- Name: canned_ticket_blueprint_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE canned_ticket_blueprint_sets_id_seq OWNED BY canned_ticket_blueprint_sets.id;


--
-- TOC entry 340 (class 1259 OID 17816291)
-- Name: credit_option_refunds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE credit_option_refunds (
    id bigint NOT NULL,
    order_id bigint,
    user_id bigint,
    refundable_type character varying,
    refundable_id bigint,
    reason text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 339 (class 1259 OID 17816289)
-- Name: credit_option_refunds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE credit_option_refunds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4730 (class 0 OID 0)
-- Dependencies: 339
-- Name: credit_option_refunds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE credit_option_refunds_id_seq OWNED BY credit_option_refunds.id;


--
-- TOC entry 342 (class 1259 OID 17816315)
-- Name: customer_credits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE customer_credits (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    account_id bigint NOT NULL,
    amount numeric(10,2),
    order_id bigint,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 344 (class 1259 OID 17823232)
-- Name: customer_credits_caches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE customer_credits_caches (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    balance numeric(10,2) DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 343 (class 1259 OID 17823230)
-- Name: customer_credits_caches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customer_credits_caches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4731 (class 0 OID 0)
-- Dependencies: 343
-- Name: customer_credits_caches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customer_credits_caches_id_seq OWNED BY customer_credits_caches.id;


--
-- TOC entry 341 (class 1259 OID 17816313)
-- Name: customer_credits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customer_credits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4732 (class 0 OID 0)
-- Dependencies: 341
-- Name: customer_credits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customer_credits_id_seq OWNED BY customer_credits.id;


--
-- TOC entry 226 (class 1259 OID 16606332)
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE customers (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    email text,
    first_name text,
    last_name text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- TOC entry 227 (class 1259 OID 16606338)
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4733 (class 0 OID 0)
-- Dependencies: 227
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_id_seq OWNED BY customers.id;


--
-- TOC entry 228 (class 1259 OID 16606340)
-- Name: daily_expenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE daily_expenses (
    id integer NOT NULL,
    daily_report_id integer,
    name character varying,
    amount numeric(10,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 16606346)
-- Name: daily_expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE daily_expenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4734 (class 0 OID 0)
-- Dependencies: 229
-- Name: daily_expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE daily_expenses_id_seq OWNED BY daily_expenses.id;


--
-- TOC entry 230 (class 1259 OID 16606348)
-- Name: daily_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE daily_reports (
    id integer NOT NULL,
    venue_id integer,
    event_id integer,
    day date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 16606351)
-- Name: daily_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE daily_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4735 (class 0 OID 0)
-- Dependencies: 231
-- Name: daily_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE daily_reports_id_seq OWNED BY daily_reports.id;


--
-- TOC entry 232 (class 1259 OID 16606353)
-- Name: deals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE deals (
    id integer NOT NULL,
    name character varying,
    comment text,
    calculation character varying,
    deal_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 233 (class 1259 OID 16606359)
-- Name: deals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4736 (class 0 OID 0)
-- Dependencies: 233
-- Name: deals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deals_id_seq OWNED BY deals.id;


--
-- TOC entry 234 (class 1259 OID 16606361)
-- Name: discounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE discounts (
    id bigint NOT NULL,
    event_id bigint,
    amount text,
    code text,
    "limit" bigint,
    expiration timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    membership_level_id bigint
);


--
-- TOC entry 235 (class 1259 OID 16606367)
-- Name: discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE discounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4737 (class 0 OID 0)
-- Dependencies: 235
-- Name: discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE discounts_id_seq OWNED BY discounts.id;


--
-- TOC entry 236 (class 1259 OID 16606369)
-- Name: discounts_ticket_blueprints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE discounts_ticket_blueprints (
    discount_id bigint,
    ticket_blueprint_id bigint
);


--
-- TOC entry 237 (class 1259 OID 16606372)
-- Name: event_artist_custom_expenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_artist_custom_expenses (
    id integer NOT NULL,
    event_artist_detail_id integer,
    description text,
    amount numeric(10,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    due integer,
    deducted_type integer,
    deleted boolean DEFAULT false
);


--
-- TOC entry 238 (class 1259 OID 16606379)
-- Name: event_artist_custom_expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_artist_custom_expenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4738 (class 0 OID 0)
-- Dependencies: 238
-- Name: event_artist_custom_expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_artist_custom_expenses_id_seq OWNED BY event_artist_custom_expenses.id;


--
-- TOC entry 239 (class 1259 OID 16606381)
-- Name: event_artist_deals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_artist_deals (
    id integer NOT NULL,
    deal_id integer,
    event_artist_detail_id integer,
    amount numeric(10,2),
    percent numeric(10,2),
    expense_amount numeric(10,2),
    hit_amount numeric(10,2),
    first_amount numeric(10,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false,
    show_ticket_sales boolean DEFAULT false,
    attachments character varying[] DEFAULT '{}'::character varying[]
);


--
-- TOC entry 240 (class 1259 OID 16606390)
-- Name: event_artist_deals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_artist_deals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4739 (class 0 OID 0)
-- Dependencies: 240
-- Name: event_artist_deals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_artist_deals_id_seq OWNED BY event_artist_deals.id;


--
-- TOC entry 241 (class 1259 OID 16606392)
-- Name: event_artist_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_artist_details (
    id integer NOT NULL,
    event_artist_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    signed_contracts character varying[] DEFAULT '{}'::character varying[],
    settlement_type event_artist_settlement_type_enum DEFAULT 'ticket_sales_events'::event_artist_settlement_type_enum,
    business_name character varying,
    tax_id character varying,
    tax_withholding_amount numeric(10,2),
    tax_withholding_type tax_withholding_type_enum DEFAULT 'percentage'::tax_withholding_type_enum,
    tax_attachments character varying[] DEFAULT '{}'::character varying[]
);


--
-- TOC entry 242 (class 1259 OID 16606402)
-- Name: event_artist_details_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_artist_details_events (
    event_id integer,
    event_artist_detail_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 243 (class 1259 OID 16606405)
-- Name: event_artist_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_artist_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4740 (class 0 OID 0)
-- Dependencies: 243
-- Name: event_artist_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_artist_details_id_seq OWNED BY event_artist_details.id;


--
-- TOC entry 244 (class 1259 OID 16606407)
-- Name: event_artist_payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_artist_payments (
    id bigint NOT NULL,
    event_artist_detail_id integer,
    amount numeric(10,2),
    date_due date,
    date_paid date,
    payment_type payment_type_enum NOT NULL,
    payee text,
    check_wire_nr text,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    attachments character varying[] DEFAULT '{}'::character varying[]
);


--
-- TOC entry 245 (class 1259 OID 16606414)
-- Name: event_artist_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_artist_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4741 (class 0 OID 0)
-- Dependencies: 245
-- Name: event_artist_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_artist_payments_id_seq OWNED BY event_artist_payments.id;


--
-- TOC entry 246 (class 1259 OID 16606416)
-- Name: event_artist_rider_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_artist_rider_documents (
    id bigint NOT NULL,
    event_artist_rider_id bigint,
    document character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 247 (class 1259 OID 16606422)
-- Name: event_artist_rider_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_artist_rider_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4742 (class 0 OID 0)
-- Dependencies: 247
-- Name: event_artist_rider_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_artist_rider_documents_id_seq OWNED BY event_artist_rider_documents.id;


--
-- TOC entry 248 (class 1259 OID 16606424)
-- Name: event_artist_riders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_artist_riders (
    id integer NOT NULL,
    notes text,
    rider_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    artist_arrival_time time without time zone,
    artist_load_in_time time without time zone,
    stage_setup_time time without time zone,
    stage_sound_check_time time without time zone,
    stage_line_check_time time without time zone,
    full_sound_check boolean,
    stage_performers_number integer,
    backstage_passes_number integer,
    instrument_performer_name text,
    own_equipment boolean,
    documents character varying[] DEFAULT '{}'::character varying[],
    sound_check_type character varying,
    event_id integer,
    event_artist_id integer
);


--
-- TOC entry 249 (class 1259 OID 16606431)
-- Name: event_artist_riders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_artist_riders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4743 (class 0 OID 0)
-- Dependencies: 249
-- Name: event_artist_riders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_artist_riders_id_seq OWNED BY event_artist_riders.id;


--
-- TOC entry 250 (class 1259 OID 16606433)
-- Name: event_artist_settlements_manual_gbors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_artist_settlements_manual_gbors (
    id bigint NOT NULL,
    description text,
    tickets_sold integer,
    price numeric(10,2),
    event_artist_detail_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 251 (class 1259 OID 16606439)
-- Name: event_artist_settlements_manual_gbors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_artist_settlements_manual_gbors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4744 (class 0 OID 0)
-- Dependencies: 251
-- Name: event_artist_settlements_manual_gbors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_artist_settlements_manual_gbors_id_seq OWNED BY event_artist_settlements_manual_gbors.id;


--
-- TOC entry 252 (class 1259 OID 16606441)
-- Name: event_artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4745 (class 0 OID 0)
-- Dependencies: 252
-- Name: event_artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_artists_id_seq OWNED BY event_artists.id;


--
-- TOC entry 253 (class 1259 OID 16606443)
-- Name: event_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4746 (class 0 OID 0)
-- Dependencies: 253
-- Name: event_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_groups_id_seq OWNED BY event_groups.id;


--
-- TOC entry 254 (class 1259 OID 16606445)
-- Name: event_projections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_projections (
    id integer NOT NULL,
    estimation character varying,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    event_group_id integer,
    ticket_sales numeric,
    f_b_head numeric,
    ticket_price numeric,
    rental_fee numeric
);


--
-- TOC entry 255 (class 1259 OID 16606451)
-- Name: event_projections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_projections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4747 (class 0 OID 0)
-- Dependencies: 255
-- Name: event_projections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_projections_id_seq OWNED BY event_projections.id;


--
-- TOC entry 256 (class 1259 OID 16606453)
-- Name: event_venue_room_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_venue_room_options (
    id integer NOT NULL,
    event_group_id integer,
    venue_id integer,
    venue_room_setup_id integer,
    venue_room character varying,
    capacity integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 257 (class 1259 OID 16606459)
-- Name: event_venue_room_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_venue_room_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4748 (class 0 OID 0)
-- Dependencies: 257
-- Name: event_venue_room_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_venue_room_options_id_seq OWNED BY event_venue_room_options.id;


--
-- TOC entry 258 (class 1259 OID 16606461)
-- Name: eventbrite_ticket_classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE eventbrite_ticket_classes (
    id integer NOT NULL,
    event_id integer,
    remote_id bigint NOT NULL,
    actual_cost numeric(10,2) DEFAULT 0.0 NOT NULL,
    actual_fee numeric(10,2) DEFAULT 0.0 NOT NULL,
    cost numeric(10,2) DEFAULT 0.0 NOT NULL,
    fee numeric(10,2) DEFAULT 0.0 NOT NULL,
    free boolean,
    donation boolean,
    total integer,
    sold integer DEFAULT 0 NOT NULL,
    sales_start timestamp without time zone,
    sales_end timestamp without time zone,
    name text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    net_sales numeric(10,2) DEFAULT 0.0 NOT NULL,
    net_fees numeric(10,2) DEFAULT 0.0 NOT NULL
);


--
-- TOC entry 259 (class 1259 OID 16606474)
-- Name: eventbrite_ticket_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE eventbrite_ticket_classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4749 (class 0 OID 0)
-- Dependencies: 259
-- Name: eventbrite_ticket_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE eventbrite_ticket_classes_id_seq OWNED BY eventbrite_ticket_classes.id;


--
-- TOC entry 260 (class 1259 OID 16606476)
-- Name: eventbrite_ticket_sales_dates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE eventbrite_ticket_sales_dates (
    id integer NOT NULL,
    eventbrite_ticket_class_id integer,
    topic_id integer,
    date date NOT NULL,
    sold integer DEFAULT 0 NOT NULL,
    gross_sales numeric(10,2) DEFAULT 0.0 NOT NULL,
    net_sales numeric(10,2) DEFAULT 0.0 NOT NULL,
    net_fees numeric(10,2) DEFAULT 0.0 NOT NULL
);


--
-- TOC entry 261 (class 1259 OID 16606483)
-- Name: eventbrite_ticket_sales_dates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE eventbrite_ticket_sales_dates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4750 (class 0 OID 0)
-- Dependencies: 261
-- Name: eventbrite_ticket_sales_dates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE eventbrite_ticket_sales_dates_id_seq OWNED BY eventbrite_ticket_sales_dates.id;


--
-- TOC entry 262 (class 1259 OID 16606485)
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4751 (class 0 OID 0)
-- Dependencies: 262
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- TOC entry 263 (class 1259 OID 16606487)
-- Name: events_mailing_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events_mailing_lists (
    event_id bigint NOT NULL,
    mailing_list_id bigint NOT NULL
);


--
-- TOC entry 264 (class 1259 OID 16606490)
-- Name: expenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE expenses (
    id bigint NOT NULL,
    budget_plan_id bigint,
    expense_type integer,
    name character varying,
    projected numeric,
    actual numeric,
    shared numeric,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 265 (class 1259 OID 16606496)
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE expenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4752 (class 0 OID 0)
-- Dependencies: 265
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE expenses_id_seq OWNED BY expenses.id;


--
-- TOC entry 266 (class 1259 OID 16606498)
-- Name: forecasts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE forecasts (
    id integer NOT NULL,
    event_id integer,
    summary character varying,
    temperature character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 267 (class 1259 OID 16606504)
-- Name: forecasts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forecasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4753 (class 0 OID 0)
-- Dependencies: 267
-- Name: forecasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forecasts_id_seq OWNED BY forecasts.id;


--
-- TOC entry 268 (class 1259 OID 16606506)
-- Name: hr_payloads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hr_payloads (
    id integer NOT NULL,
    staff_report_id integer,
    server numeric(10,2),
    bartenders numeric(10,2),
    sound numeric(10,2),
    kitchen numeric(10,2),
    lightning numeric(10,2),
    maintenance numeric(10,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 269 (class 1259 OID 16606509)
-- Name: hr_payloads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hr_payloads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4754 (class 0 OID 0)
-- Dependencies: 269
-- Name: hr_payloads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hr_payloads_id_seq OWNED BY hr_payloads.id;


--
-- TOC entry 270 (class 1259 OID 16606511)
-- Name: incomes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE incomes (
    id bigint NOT NULL,
    budget_plan_id bigint,
    income_type integer,
    name character varying,
    projected numeric(10,2),
    actual numeric(10,2),
    price numeric(10,2),
    quantity integer,
    fee numeric(10,2) DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    event_id bigint,
    ticket_bucket_id bigint,
    ticket_blueprint_id bigint
);


--
-- TOC entry 271 (class 1259 OID 16606518)
-- Name: incomes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE incomes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4755 (class 0 OID 0)
-- Dependencies: 271
-- Name: incomes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE incomes_id_seq OWNED BY incomes.id;


--
-- TOC entry 272 (class 1259 OID 16606520)
-- Name: list_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE list_entries (
    id integer NOT NULL,
    list_id integer,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    quantity integer NOT NULL,
    number_claimed integer DEFAULT 0,
    checked_in_by_user_id integer,
    CONSTRAINT check_claimed_is_not_more_than_quantity CHECK ((quantity >= number_claimed))
);


--
-- TOC entry 273 (class 1259 OID 16606528)
-- Name: list_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE list_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4756 (class 0 OID 0)
-- Dependencies: 273
-- Name: list_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE list_entries_id_seq OWNED BY list_entries.id;


--
-- TOC entry 274 (class 1259 OID 16606530)
-- Name: lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE lists (
    id integer NOT NULL,
    name character varying,
    event_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 275 (class 1259 OID 16606536)
-- Name: lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4757 (class 0 OID 0)
-- Dependencies: 275
-- Name: lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lists_id_seq OWNED BY lists.id;


--
-- TOC entry 276 (class 1259 OID 16606538)
-- Name: membership_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE membership_levels (
    id bigint NOT NULL,
    name text,
    description text,
    price numeric(10,2),
    account_id bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    venue_id bigint,
    active boolean DEFAULT true
);


--
-- TOC entry 277 (class 1259 OID 16606545)
-- Name: membership_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE membership_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4758 (class 0 OID 0)
-- Dependencies: 277
-- Name: membership_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE membership_levels_id_seq OWNED BY membership_levels.id;


--
-- TOC entry 278 (class 1259 OID 16606547)
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE memberships (
    id bigint NOT NULL,
    customer_id bigint,
    membership_level_id bigint,
    price numeric(10,2),
    cc_type text,
    last_four_digits text,
    fingerprint text NOT NULL,
    origin text DEFAULT 'online'::text,
    payment_method text DEFAULT 'credit'::text,
    transaction_id bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    applied_discount_id bigint
);


--
-- TOC entry 279 (class 1259 OID 16606555)
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4759 (class 0 OID 0)
-- Dependencies: 279
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE memberships_id_seq OWNED BY memberships.id;


--
-- TOC entry 280 (class 1259 OID 16606557)
-- Name: operations_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE operations_reports (
    id integer NOT NULL,
    venue_id integer,
    event_id integer,
    day date,
    bar_sales numeric(10,2),
    food_sales numeric(10,2),
    door_click integer,
    merch_sales numeric(10,2),
    comps_house integer,
    comps_artist integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    food_cost numeric(10,2),
    liquor_cost numeric(10,2),
    venue_merch_sales_due numeric(10,2),
    venue_room_id integer
);


--
-- TOC entry 281 (class 1259 OID 16606560)
-- Name: operations_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE operations_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4760 (class 0 OID 0)
-- Dependencies: 281
-- Name: operations_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE operations_reports_id_seq OWNED BY operations_reports.id;


--
-- TOC entry 282 (class 1259 OID 16606562)
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE orders (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    event_id bigint NOT NULL,
    customer_id bigint,
    applied_discount_id bigint,
    price numeric(10,2) DEFAULT 0 NOT NULL,
    fee numeric(10,2) DEFAULT 0 NOT NULL,
    last_four_digits text,
    fingerprint text NOT NULL,
    delivery_method text NOT NULL,
    cc_type text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    transaction_id bigint,
    origin text DEFAULT 'online'::text,
    payment_method text DEFAULT 'credit'::text,
    platform_fee numeric(10,2) DEFAULT 0 NOT NULL,
    donation numeric(10,2) DEFAULT 0 NOT NULL,
    processing_fee numeric(10,2) DEFAULT 0 NOT NULL,
    sales_tax numeric(10,2) DEFAULT 0 NOT NULL,
    applied_credit numeric(10,2)
);


--
-- TOC entry 283 (class 1259 OID 16606576)
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4761 (class 0 OID 0)
-- Dependencies: 283
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- TOC entry 284 (class 1259 OID 16606578)
-- Name: pay_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pay_rates (
    id integer NOT NULL,
    staff_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role_id integer
);


--
-- TOC entry 285 (class 1259 OID 16606581)
-- Name: pay_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pay_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4762 (class 0 OID 0)
-- Dependencies: 285
-- Name: pay_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pay_rates_id_seq OWNED BY pay_rates.id;


--
-- TOC entry 286 (class 1259 OID 16606583)
-- Name: pay_time_intervals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pay_time_intervals (
    id integer NOT NULL,
    time_interval_id integer,
    pay_rate_id integer,
    money numeric(10,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 287 (class 1259 OID 16606586)
-- Name: pay_time_intervals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pay_time_intervals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4763 (class 0 OID 0)
-- Dependencies: 287
-- Name: pay_time_intervals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pay_time_intervals_id_seq OWNED BY pay_time_intervals.id;


--
-- TOC entry 288 (class 1259 OID 16606588)
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE permissions (
    id bigint NOT NULL,
    settings__venues integer DEFAULT 0,
    settings__team integer DEFAULT 0,
    settings__integrations integer DEFAULT 0,
    settings__privileges integer DEFAULT 0,
    sales_info__fees integer DEFAULT 0,
    sales_info__number_sold integer DEFAULT 0,
    sales_info__gbor integer DEFAULT 0,
    event_details__confirmed_dates integer DEFAULT 0,
    event_details__announce integer DEFAULT 0,
    event_details__notes integer DEFAULT 0,
    event_details__audit_log integer DEFAULT 0,
    ticketing__tickets integer DEFAULT 0,
    ticketing__will_call integer DEFAULT 0,
    ticketing__guest_list integer DEFAULT 0,
    artists__financials integer DEFAULT 0,
    artists__stats_sheet integer DEFAULT 0,
    artists__tech_rider integer DEFAULT 0,
    artists__hospitality_rider integer DEFAULT 0,
    closeout_sheet__access integer DEFAULT 0,
    closeout_sheet__manual_tickets integer DEFAULT 0,
    other__projections integer DEFAULT 0,
    other__event_notes integer DEFAULT 0,
    other__orders integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    download_will_call boolean,
    cancel_event boolean,
    box_office_app boolean,
    other__artists integer DEFAULT 0,
    reports__by_day integer DEFAULT 0,
    reports__by_payment integer DEFAULT 0,
    confirm_date boolean,
    add_hold boolean,
    add_artist boolean,
    event_details__hold_dates integer DEFAULT 0,
    event_details__name integer DEFAULT 0,
    budget__projected_incomes integer DEFAULT 0 NOT NULL,
    budget__actual_incomes integer DEFAULT 0 NOT NULL,
    budget__projected_expenses integer DEFAULT 0 NOT NULL,
    budget__actual_expenses integer DEFAULT 0 NOT NULL,
    budget__projected_concessions integer DEFAULT 0 NOT NULL,
    budget__actual_concessions integer DEFAULT 0 NOT NULL,
    budget__shared_expenses integer DEFAULT 0 NOT NULL,
    budget__summary integer DEFAULT 0 NOT NULL,
    budget__template integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 289 (class 1259 OID 16606619)
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4764 (class 0 OID 0)
-- Dependencies: 289
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE permissions_id_seq OWNED BY permissions.id;


--
-- TOC entry 290 (class 1259 OID 16606621)
-- Name: presales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE presales (
    id bigint NOT NULL,
    event_id bigint,
    password text,
    sell_start timestamp with time zone,
    sell_end timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- TOC entry 291 (class 1259 OID 16606627)
-- Name: presales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE presales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4765 (class 0 OID 0)
-- Dependencies: 291
-- Name: presales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE presales_id_seq OWNED BY presales.id;


--
-- TOC entry 292 (class 1259 OID 16606629)
-- Name: refunds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE refunds (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    reason text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    user_id integer,
    type character varying,
    sales_tax numeric(6,4) DEFAULT 0 NOT NULL,
    donation numeric(10,2) DEFAULT 0 NOT NULL,
    processing_fee numeric(10,2) DEFAULT 0 NOT NULL
);


--
-- TOC entry 293 (class 1259 OID 16606638)
-- Name: refunds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE refunds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4766 (class 0 OID 0)
-- Dependencies: 293
-- Name: refunds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE refunds_id_seq OWNED BY refunds.id;


--
-- TOC entry 294 (class 1259 OID 16606640)
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 295 (class 1259 OID 16606646)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4767 (class 0 OID 0)
-- Dependencies: 295
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- TOC entry 296 (class 1259 OID 16606648)
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rooms (
    id integer NOT NULL,
    name character varying,
    venue_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 297 (class 1259 OID 16606654)
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4768 (class 0 OID 0)
-- Dependencies: 297
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rooms_id_seq OWNED BY rooms.id;


--
-- TOC entry 298 (class 1259 OID 16606656)
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version text NOT NULL
);


--
-- TOC entry 299 (class 1259 OID 16606662)
-- Name: seating_charts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE seating_charts (
    id bigint NOT NULL,
    canned_ticket_blueprint_set_id bigint,
    key character varying,
    status character varying,
    published_thumbnail_url character varying,
    has_draft boolean,
    draft_thumbnail_url character varying,
    published_valid boolean,
    draft_valid boolean,
    categories jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tables jsonb DEFAULT '{}'::jsonb
);


--
-- TOC entry 300 (class 1259 OID 16606669)
-- Name: seating_charts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE seating_charts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4769 (class 0 OID 0)
-- Dependencies: 300
-- Name: seating_charts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE seating_charts_id_seq OWNED BY seating_charts.id;


--
-- TOC entry 301 (class 1259 OID 16606671)
-- Name: sold_tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sold_tickets (
    id integer NOT NULL,
    venue_id integer,
    event_id integer,
    description character varying,
    number integer,
    cost numeric(10,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    day date,
    venue_room_id integer
);


--
-- TOC entry 302 (class 1259 OID 16606677)
-- Name: sold_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sold_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4770 (class 0 OID 0)
-- Dependencies: 302
-- Name: sold_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sold_tickets_id_seq OWNED BY sold_tickets.id;


--
-- TOC entry 303 (class 1259 OID 16606679)
-- Name: staff_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE staff_reports (
    id integer NOT NULL,
    venue_id integer,
    day date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    staff_id integer,
    role_id integer,
    cost numeric(10,2),
    head boolean,
    hour_number integer,
    shift_type character varying,
    party_pay numeric(10,2),
    tips numeric(10,2)
);


--
-- TOC entry 304 (class 1259 OID 16606685)
-- Name: staff_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE staff_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4771 (class 0 OID 0)
-- Dependencies: 304
-- Name: staff_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE staff_reports_id_seq OWNED BY staff_reports.id;


--
-- TOC entry 305 (class 1259 OID 16606687)
-- Name: staffs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE staffs (
    id integer NOT NULL,
    name character varying,
    roles_ids text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notes text,
    deleted boolean DEFAULT false
);


--
-- TOC entry 306 (class 1259 OID 16606694)
-- Name: staffs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE staffs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4772 (class 0 OID 0)
-- Dependencies: 306
-- Name: staffs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE staffs_id_seq OWNED BY staffs.id;


--
-- TOC entry 307 (class 1259 OID 16606696)
-- Name: team_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE team_roles (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    permission_id bigint,
    account_id bigint
);


--
-- TOC entry 308 (class 1259 OID 16606702)
-- Name: team_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE team_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4773 (class 0 OID 0)
-- Dependencies: 308
-- Name: team_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE team_roles_id_seq OWNED BY team_roles.id;


--
-- TOC entry 309 (class 1259 OID 16606704)
-- Name: ticket_blueprint_locks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ticket_blueprint_locks (
    id bigint NOT NULL,
    ticket_blueprint_id bigint NOT NULL,
    expires_at timestamp with time zone,
    quantity bigint NOT NULL,
    order_id bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- TOC entry 310 (class 1259 OID 16606707)
-- Name: ticket_blueprint_locks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_blueprint_locks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4774 (class 0 OID 0)
-- Dependencies: 310
-- Name: ticket_blueprint_locks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_blueprint_locks_id_seq OWNED BY ticket_blueprint_locks.id;


--
-- TOC entry 311 (class 1259 OID 16606709)
-- Name: ticket_blueprints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ticket_blueprints (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    ticket_bucket_id bigint,
    name text,
    quantity bigint,
    price numeric(10,2) DEFAULT 0,
    fee numeric(10,2) DEFAULT 0.00,
    type text,
    sell_start timestamp with time zone,
    sell_end timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    available_on_presale boolean DEFAULT false NOT NULL,
    sellable_through integer
);


--
-- TOC entry 312 (class 1259 OID 16606718)
-- Name: ticket_blueprints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_blueprints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4775 (class 0 OID 0)
-- Dependencies: 312
-- Name: ticket_blueprints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_blueprints_id_seq OWNED BY ticket_blueprints.id;


--
-- TOC entry 313 (class 1259 OID 16606720)
-- Name: ticket_buckets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ticket_buckets (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    quantity bigint,
    color text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name character varying
);


--
-- TOC entry 314 (class 1259 OID 16606726)
-- Name: ticket_buckets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_buckets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4776 (class 0 OID 0)
-- Dependencies: 314
-- Name: ticket_buckets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_buckets_id_seq OWNED BY ticket_buckets.id;


--
-- TOC entry 315 (class 1259 OID 16606728)
-- Name: ticket_refunds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ticket_refunds (
    refund_id bigint,
    ticket_id bigint,
    invalidate_ticket boolean DEFAULT true NOT NULL,
    id bigint NOT NULL,
    created_at timestamp with time zone,
    amount numeric NOT NULL,
    refunded_platform_fee boolean DEFAULT false
);


--
-- TOC entry 316 (class 1259 OID 16606736)
-- Name: ticket_refunds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ticket_refunds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4777 (class 0 OID 0)
-- Dependencies: 316
-- Name: ticket_refunds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ticket_refunds_id_seq OWNED BY ticket_refunds.id;


--
-- TOC entry 317 (class 1259 OID 16606738)
-- Name: tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tickets (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    order_id bigint,
    blueprint_id bigint NOT NULL,
    previous_ticket_id bigint,
    price numeric(10,2) DEFAULT 0 NOT NULL,
    fee numeric(10,2) DEFAULT 0 NOT NULL,
    claimable boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    account_id bigint,
    first_name text,
    last_name text,
    claimed boolean DEFAULT false NOT NULL,
    platform_fee numeric(10,2) DEFAULT 0 NOT NULL,
    balance numeric(10,2) DEFAULT 0 NOT NULL,
    checked_in_by_user_id integer,
    seat character varying,
    "table" character varying
);


--
-- TOC entry 318 (class 1259 OID 16606750)
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4778 (class 0 OID 0)
-- Dependencies: 318
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tickets_id_seq OWNED BY tickets.id;


--
-- TOC entry 319 (class 1259 OID 16606752)
-- Name: time_intervals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE time_intervals (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 320 (class 1259 OID 16606758)
-- Name: time_intervals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE time_intervals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4779 (class 0 OID 0)
-- Dependencies: 320
-- Name: time_intervals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE time_intervals_id_seq OWNED BY time_intervals.id;


--
-- TOC entry 321 (class 1259 OID 16606760)
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transactions (
    id bigint NOT NULL,
    transaction_id text,
    successful boolean,
    response text,
    buyable_type text,
    buyable_id bigint,
    account_id bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    type text NOT NULL
);


--
-- TOC entry 322 (class 1259 OID 16606766)
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4780 (class 0 OID 0)
-- Dependencies: 322
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- TOC entry 323 (class 1259 OID 16606768)
-- Name: transfers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transfers (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    source_event_id bigint NOT NULL,
    target_event_id bigint NOT NULL,
    order_id bigint
);


--
-- TOC entry 324 (class 1259 OID 16606771)
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4781 (class 0 OID 0)
-- Dependencies: 324
-- Name: transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transfers_id_seq OWNED BY transfers.id;


--
-- TOC entry 325 (class 1259 OID 16606773)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id bigint NOT NULL,
    email text NOT NULL,
    encrypted_password text DEFAULT ''::text NOT NULL,
    account_id bigint,
    reset_password_token text,
    reset_password_sent_at timestamp with time zone,
    remember_created_at timestamp with time zone,
    authentication_token text,
    sign_in_count bigint DEFAULT '0'::bigint,
    current_sign_in_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    current_sign_in_ip text,
    last_sign_in_ip text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    roles bigint,
    name character varying,
    gcal_support boolean DEFAULT false,
    deleted_at timestamp without time zone,
    team_role_id bigint,
    login_token text,
    login_token_expires_at timestamp without time zone
);


--
-- TOC entry 326 (class 1259 OID 16606782)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4782 (class 0 OID 0)
-- Dependencies: 326
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- TOC entry 327 (class 1259 OID 16606784)
-- Name: venue_room_setups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE venue_room_setups (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- TOC entry 328 (class 1259 OID 16606790)
-- Name: venue_room_setups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE venue_room_setups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4783 (class 0 OID 0)
-- Dependencies: 328
-- Name: venue_room_setups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE venue_room_setups_id_seq OWNED BY venue_room_setups.id;


--
-- TOC entry 329 (class 1259 OID 16606792)
-- Name: venues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE venues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4784 (class 0 OID 0)
-- Dependencies: 329
-- Name: venues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE venues_id_seq OWNED BY venues.id;


--
-- TOC entry 330 (class 1259 OID 16606794)
-- Name: zapier_hooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE zapier_hooks (
    id integer NOT NULL,
    user_id integer NOT NULL,
    event character varying NOT NULL,
    url character varying NOT NULL
);


--
-- TOC entry 331 (class 1259 OID 16606800)
-- Name: zapier_hooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE zapier_hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4785 (class 0 OID 0)
-- Dependencies: 331
-- Name: zapier_hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE zapier_hooks_id_seq OWNED BY zapier_hooks.id;


--
-- TOC entry 4079 (class 2604 OID 16606802)
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- TOC entry 4080 (class 2604 OID 16606803)
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('active_storage_attachments_id_seq'::regclass);


--
-- TOC entry 4081 (class 2604 OID 16606804)
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('active_storage_blobs_id_seq'::regclass);


--
-- TOC entry 4082 (class 2604 OID 16606805)
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- TOC entry 4085 (class 2604 OID 16606806)
-- Name: announce_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY announce_details ALTER COLUMN id SET DEFAULT nextval('announce_details_id_seq'::regclass);


--
-- TOC entry 4254 (class 2604 OID 16965869)
-- Name: artist_genres id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY artist_genres ALTER COLUMN id SET DEFAULT nextval('artist_genres_id_seq'::regclass);


--
-- TOC entry 4086 (class 2604 OID 16606807)
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY artists ALTER COLUMN id SET DEFAULT nextval('artists_id_seq'::regclass);


--
-- TOC entry 4107 (class 2604 OID 16606808)
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY audit_logs ALTER COLUMN id SET DEFAULT nextval('audit_logs_id_seq'::regclass);


--
-- TOC entry 4108 (class 2604 OID 16606809)
-- Name: black_listed_people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY black_listed_people ALTER COLUMN id SET DEFAULT nextval('black_listed_people_id_seq'::regclass);


--
-- TOC entry 4109 (class 2604 OID 16606810)
-- Name: budget_plans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY budget_plans ALTER COLUMN id SET DEFAULT nextval('budget_plans_id_seq'::regclass);


--
-- TOC entry 4255 (class 2604 OID 17568365)
-- Name: budget_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY budget_templates ALTER COLUMN id SET DEFAULT nextval('budget_templates_id_seq'::regclass);


--
-- TOC entry 4111 (class 2604 OID 16606811)
-- Name: canceled_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY canceled_events ALTER COLUMN id SET DEFAULT nextval('canceled_events_id_seq'::regclass);


--
-- TOC entry 4113 (class 2604 OID 16606812)
-- Name: canned_ticket_blueprint_sets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY canned_ticket_blueprint_sets ALTER COLUMN id SET DEFAULT nextval('canned_ticket_blueprint_sets_id_seq'::regclass);


--
-- TOC entry 4256 (class 2604 OID 17816294)
-- Name: credit_option_refunds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY credit_option_refunds ALTER COLUMN id SET DEFAULT nextval('credit_option_refunds_id_seq'::regclass);


--
-- TOC entry 4257 (class 2604 OID 17816318)
-- Name: customer_credits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_credits ALTER COLUMN id SET DEFAULT nextval('customer_credits_id_seq'::regclass);


--
-- TOC entry 4258 (class 2604 OID 17823235)
-- Name: customer_credits_caches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_credits_caches ALTER COLUMN id SET DEFAULT nextval('customer_credits_caches_id_seq'::regclass);


--
-- TOC entry 4114 (class 2604 OID 16606813)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);


--
-- TOC entry 4115 (class 2604 OID 16606814)
-- Name: daily_expenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY daily_expenses ALTER COLUMN id SET DEFAULT nextval('daily_expenses_id_seq'::regclass);


--
-- TOC entry 4116 (class 2604 OID 16606815)
-- Name: daily_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY daily_reports ALTER COLUMN id SET DEFAULT nextval('daily_reports_id_seq'::regclass);


--
-- TOC entry 4117 (class 2604 OID 16606816)
-- Name: deals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deals ALTER COLUMN id SET DEFAULT nextval('deals_id_seq'::regclass);


--
-- TOC entry 4118 (class 2604 OID 16606817)
-- Name: discounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY discounts ALTER COLUMN id SET DEFAULT nextval('discounts_id_seq'::regclass);


--
-- TOC entry 4120 (class 2604 OID 16606818)
-- Name: event_artist_custom_expenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_custom_expenses ALTER COLUMN id SET DEFAULT nextval('event_artist_custom_expenses_id_seq'::regclass);


--
-- TOC entry 4124 (class 2604 OID 16606819)
-- Name: event_artist_deals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_deals ALTER COLUMN id SET DEFAULT nextval('event_artist_deals_id_seq'::regclass);


--
-- TOC entry 4129 (class 2604 OID 16606820)
-- Name: event_artist_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_details ALTER COLUMN id SET DEFAULT nextval('event_artist_details_id_seq'::regclass);


--
-- TOC entry 4131 (class 2604 OID 16606821)
-- Name: event_artist_payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_payments ALTER COLUMN id SET DEFAULT nextval('event_artist_payments_id_seq'::regclass);


--
-- TOC entry 4132 (class 2604 OID 16606822)
-- Name: event_artist_rider_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_rider_documents ALTER COLUMN id SET DEFAULT nextval('event_artist_rider_documents_id_seq'::regclass);


--
-- TOC entry 4134 (class 2604 OID 16606823)
-- Name: event_artist_riders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_riders ALTER COLUMN id SET DEFAULT nextval('event_artist_riders_id_seq'::regclass);


--
-- TOC entry 4135 (class 2604 OID 16606824)
-- Name: event_artist_settlements_manual_gbors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_settlements_manual_gbors ALTER COLUMN id SET DEFAULT nextval('event_artist_settlements_manual_gbors_id_seq'::regclass);


--
-- TOC entry 4088 (class 2604 OID 16606825)
-- Name: event_artists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artists ALTER COLUMN id SET DEFAULT nextval('event_artists_id_seq'::regclass);


--
-- TOC entry 4090 (class 2604 OID 16606826)
-- Name: event_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_groups ALTER COLUMN id SET DEFAULT nextval('event_groups_id_seq'::regclass);


--
-- TOC entry 4136 (class 2604 OID 16606827)
-- Name: event_projections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_projections ALTER COLUMN id SET DEFAULT nextval('event_projections_id_seq'::regclass);


--
-- TOC entry 4137 (class 2604 OID 16606828)
-- Name: event_venue_room_options id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_venue_room_options ALTER COLUMN id SET DEFAULT nextval('event_venue_room_options_id_seq'::regclass);


--
-- TOC entry 4145 (class 2604 OID 16606829)
-- Name: eventbrite_ticket_classes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY eventbrite_ticket_classes ALTER COLUMN id SET DEFAULT nextval('eventbrite_ticket_classes_id_seq'::regclass);


--
-- TOC entry 4150 (class 2604 OID 16606830)
-- Name: eventbrite_ticket_sales_dates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY eventbrite_ticket_sales_dates ALTER COLUMN id SET DEFAULT nextval('eventbrite_ticket_sales_dates_id_seq'::regclass);


--
-- TOC entry 4098 (class 2604 OID 16606831)
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- TOC entry 4151 (class 2604 OID 16606832)
-- Name: expenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY expenses ALTER COLUMN id SET DEFAULT nextval('expenses_id_seq'::regclass);


--
-- TOC entry 4152 (class 2604 OID 16606833)
-- Name: forecasts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forecasts ALTER COLUMN id SET DEFAULT nextval('forecasts_id_seq'::regclass);


--
-- TOC entry 4153 (class 2604 OID 16606834)
-- Name: hr_payloads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hr_payloads ALTER COLUMN id SET DEFAULT nextval('hr_payloads_id_seq'::regclass);


--
-- TOC entry 4155 (class 2604 OID 16606835)
-- Name: incomes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY incomes ALTER COLUMN id SET DEFAULT nextval('incomes_id_seq'::regclass);


--
-- TOC entry 4157 (class 2604 OID 16606836)
-- Name: list_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY list_entries ALTER COLUMN id SET DEFAULT nextval('list_entries_id_seq'::regclass);


--
-- TOC entry 4159 (class 2604 OID 16606837)
-- Name: lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY lists ALTER COLUMN id SET DEFAULT nextval('lists_id_seq'::regclass);


--
-- TOC entry 4161 (class 2604 OID 16606838)
-- Name: membership_levels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY membership_levels ALTER COLUMN id SET DEFAULT nextval('membership_levels_id_seq'::regclass);


--
-- TOC entry 4164 (class 2604 OID 16606839)
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships ALTER COLUMN id SET DEFAULT nextval('memberships_id_seq'::regclass);


--
-- TOC entry 4165 (class 2604 OID 16606840)
-- Name: operations_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY operations_reports ALTER COLUMN id SET DEFAULT nextval('operations_reports_id_seq'::regclass);


--
-- TOC entry 4174 (class 2604 OID 16606841)
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- TOC entry 4175 (class 2604 OID 16606842)
-- Name: pay_rates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pay_rates ALTER COLUMN id SET DEFAULT nextval('pay_rates_id_seq'::regclass);


--
-- TOC entry 4176 (class 2604 OID 16606843)
-- Name: pay_time_intervals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pay_time_intervals ALTER COLUMN id SET DEFAULT nextval('pay_time_intervals_id_seq'::regclass);


--
-- TOC entry 4214 (class 2604 OID 16606844)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY permissions ALTER COLUMN id SET DEFAULT nextval('permissions_id_seq'::regclass);


--
-- TOC entry 4215 (class 2604 OID 16606845)
-- Name: presales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY presales ALTER COLUMN id SET DEFAULT nextval('presales_id_seq'::regclass);


--
-- TOC entry 4216 (class 2604 OID 16606846)
-- Name: refunds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY refunds ALTER COLUMN id SET DEFAULT nextval('refunds_id_seq'::regclass);


--
-- TOC entry 4220 (class 2604 OID 16606847)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- TOC entry 4221 (class 2604 OID 16606848)
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rooms ALTER COLUMN id SET DEFAULT nextval('rooms_id_seq'::regclass);


--
-- TOC entry 4223 (class 2604 OID 16606849)
-- Name: seating_charts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY seating_charts ALTER COLUMN id SET DEFAULT nextval('seating_charts_id_seq'::regclass);


--
-- TOC entry 4224 (class 2604 OID 16606850)
-- Name: sold_tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sold_tickets ALTER COLUMN id SET DEFAULT nextval('sold_tickets_id_seq'::regclass);


--
-- TOC entry 4225 (class 2604 OID 16606851)
-- Name: staff_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_reports ALTER COLUMN id SET DEFAULT nextval('staff_reports_id_seq'::regclass);


--
-- TOC entry 4227 (class 2604 OID 16606852)
-- Name: staffs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY staffs ALTER COLUMN id SET DEFAULT nextval('staffs_id_seq'::regclass);


--
-- TOC entry 4228 (class 2604 OID 16606853)
-- Name: team_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_roles ALTER COLUMN id SET DEFAULT nextval('team_roles_id_seq'::regclass);


--
-- TOC entry 4229 (class 2604 OID 16606854)
-- Name: ticket_blueprint_locks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_blueprint_locks ALTER COLUMN id SET DEFAULT nextval('ticket_blueprint_locks_id_seq'::regclass);


--
-- TOC entry 4233 (class 2604 OID 16606855)
-- Name: ticket_blueprints id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_blueprints ALTER COLUMN id SET DEFAULT nextval('ticket_blueprints_id_seq'::regclass);


--
-- TOC entry 4234 (class 2604 OID 16606856)
-- Name: ticket_buckets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_buckets ALTER COLUMN id SET DEFAULT nextval('ticket_buckets_id_seq'::regclass);


--
-- TOC entry 4237 (class 2604 OID 16606857)
-- Name: ticket_refunds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_refunds ALTER COLUMN id SET DEFAULT nextval('ticket_refunds_id_seq'::regclass);


--
-- TOC entry 4244 (class 2604 OID 16606858)
-- Name: tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tickets ALTER COLUMN id SET DEFAULT nextval('tickets_id_seq'::regclass);


--
-- TOC entry 4245 (class 2604 OID 16606859)
-- Name: time_intervals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY time_intervals ALTER COLUMN id SET DEFAULT nextval('time_intervals_id_seq'::regclass);


--
-- TOC entry 4246 (class 2604 OID 16606860)
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- TOC entry 4247 (class 2604 OID 16606861)
-- Name: transfers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfers ALTER COLUMN id SET DEFAULT nextval('transfers_id_seq'::regclass);


--
-- TOC entry 4251 (class 2604 OID 16606862)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- TOC entry 4252 (class 2604 OID 16606863)
-- Name: venue_room_setups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY venue_room_setups ALTER COLUMN id SET DEFAULT nextval('venue_room_setups_id_seq'::regclass);


--
-- TOC entry 4104 (class 2604 OID 16606864)
-- Name: venues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY venues ALTER COLUMN id SET DEFAULT nextval('venues_id_seq'::regclass);


--
-- TOC entry 4253 (class 2604 OID 16606865)
-- Name: zapier_hooks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY zapier_hooks ALTER COLUMN id SET DEFAULT nextval('zapier_hooks_id_seq'::regclass);


--
-- TOC entry 4355 (class 2606 OID 16610059)
-- Name: event_projections event_projections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_projections
    ADD CONSTRAINT event_projections_pkey PRIMARY KEY (id);


--
-- TOC entry 4286 (class 2606 OID 16610061)
-- Name: events idx_16501_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT idx_16501_primary PRIMARY KEY (id);


--
-- TOC entry 332 (class 1259 OID 16610062)
-- Name: mv_event_sales; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW mv_event_sales AS
 SELECT derivedtable.date,
    derivedtable.door_time,
    derivedtable.curfew,
    derivedtable.gross_bar_sales,
    derivedtable.event_id,
    derivedtable.billing,
    derivedtable.door_click,
    derivedtable.location,
    derivedtable.capacity,
    derivedtable.status,
    derivedtable.room_setup,
    derivedtable.notes,
    derivedtable.online_number_sold,
    derivedtable.online_sales,
    derivedtable.venue_fee,
    derivedtable.manual_sales,
    (derivedtable.online_sales + derivedtable.manual_sales) AS total_sales,
    GREATEST(((derivedtable.online_sales - derivedtable.venue_fee) + derivedtable.manual_sales), (0)::numeric) AS net_sales,
    derivedtable.year,
    derivedtable.quarter,
    derivedtable.month,
    derivedtable.name_of_month,
    derivedtable.week,
    derivedtable.day_of_week,
    derivedtable.weekend,
    derivedtable.date_created,
    derivedtable.show_on_sale,
    derivedtable.account_id,
    derivedtable.ead_ids_dates,
    derivedtable.confirmed_by_user_name,
    derivedtable.projected_attendance,
    derivedtable.projected_f_b_head,
    derivedtable.projected_ticket_price,
    derivedtable.projected_rental_fee,
    derivedtable.projection_notes,
    derivedtable.eventbrite_number_sold,
    derivedtable.eventbrite_net_sales,
    derivedtable.eventbrite_venue_fees
   FROM ( SELECT events.date,
            events.door_time,
            ( SELECT max(event_artists_1.stage_curfew) AS max
                   FROM event_artists event_artists_1
                  WHERE (event_artists_1.event_group_id = events.event_group_id)
                  GROUP BY events.event_group_id) AS curfew,
            operations_reports.bar_sales AS gross_bar_sales,
            events.id AS event_id,
            events.name AS billing,
            operations_reports.door_click,
            rooms.name AS location,
            ((COALESCE(sum(ticket_buckets.quantity), (0)::numeric) + COALESCE(( SELECT sum(ticket_blueprints.quantity) AS sum
                   FROM ticket_blueprints
                  WHERE ((ticket_blueprints.event_id = events.id) AND (ticket_blueprints.type = 'StandaloneTicketBlueprint'::text))
                  GROUP BY events.id), (0)::numeric)))::integer AS capacity,
                CASE
                    WHEN (events.state = 0) THEN 'hold'::text
                    WHEN (events.state = 1) THEN 'confirmed'::text
                    WHEN (events.state = 2) THEN 'canceled'::text
                    WHEN (events.state = 3) THEN 'deleted'::text
                    ELSE NULL::text
                END AS status,
            ( SELECT DISTINCT venue_room_setups.name
                   FROM (venue_room_setups
                     LEFT JOIN event_venue_room_options ON ((event_venue_room_options.venue_room_setup_id = venue_room_setups.id)))
                  WHERE (event_venue_room_options.event_group_id = events.event_group_id)) AS room_setup,
            events.notes,
            COALESCE(( SELECT count(tickets.id) AS count
                   FROM tickets
                  WHERE ((tickets.event_id = events.id) AND (tickets.claimable = true))
                  GROUP BY events.id), (0)::bigint) AS online_number_sold,
            COALESCE(( SELECT sum(tickets.balance) AS sum
                   FROM tickets
                  WHERE ((tickets.event_id = events.id) AND (tickets.claimable = true))
                  GROUP BY events.id), (0)::numeric) AS online_sales,
            COALESCE(( SELECT sum(tickets.fee) AS sum
                   FROM tickets
                  WHERE ((tickets.event_id = events.id) AND (tickets.claimable = true))
                  GROUP BY events.id), (0)::numeric) AS venue_fee,
            COALESCE(( SELECT sum(((sold_tickets.number)::numeric * sold_tickets.cost)) AS sum
                   FROM sold_tickets
                  WHERE ((sold_tickets.event_id = events.id) AND (sold_tickets.venue_room_id = events.venue_room_id))
                  GROUP BY events.id), (0)::numeric) AS manual_sales,
            date_part('year'::text, events.date) AS year,
            date_part('quarter'::text, events.date) AS quarter,
            date_part('month'::text, events.date) AS month,
            btrim(to_char((events.date)::timestamp with time zone, 'Month'::text)) AS name_of_month,
            date_part('week'::text, events.date) AS week,
            btrim(to_char((events.date)::timestamp with time zone, 'Day'::text)) AS day_of_week,
            (date_part('isodow'::text, events.date) = ANY (ARRAY[(6)::double precision, (7)::double precision])) AS weekend,
                CASE
                    WHEN (events.state = 0) THEN to_char(events.created_at, 'YYYY-MM-DD'::text)
                    ELSE ''::text
                END AS date_created,
            ( SELECT to_char(min(ticket_blueprints.sell_start), 'YYYY-MM-DD'::text) AS to_char
                   FROM ticket_blueprints
                  WHERE (ticket_blueprints.event_id = events.id)
                  GROUP BY events.id) AS show_on_sale,
            events.account_id,
            event_projections.ticket_sales AS projected_attendance,
            event_projections.f_b_head AS projected_f_b_head,
            event_projections.ticket_price AS projected_ticket_price,
            event_projections.rental_fee AS projected_rental_fee,
            event_projections.notes AS projection_notes,
            COALESCE(( SELECT sum(eventbrite_ticket_classes.sold) AS sum
                   FROM eventbrite_ticket_classes
                  WHERE (eventbrite_ticket_classes.event_id = events.id)
                  GROUP BY events.id), (0)::bigint) AS eventbrite_number_sold,
            COALESCE(( SELECT sum(eventbrite_ticket_classes.net_sales) AS sum
                   FROM eventbrite_ticket_classes
                  WHERE (eventbrite_ticket_classes.event_id = events.id)
                  GROUP BY events.id), (0)::numeric) AS eventbrite_net_sales,
            COALESCE(( SELECT sum(eventbrite_ticket_classes.net_fees) AS sum
                   FROM eventbrite_ticket_classes
                  WHERE (eventbrite_ticket_classes.event_id = events.id)
                  GROUP BY events.id), (0)::numeric) AS eventbrite_venue_fees,
            (('['::text || string_agg((((((('['::text || ((event_artist_details.id)::character varying)::text) || ','::text) || '"'::text) || ((events.date)::character varying)::text) || '"'::text) || ']'::text), ','::text)) || ']'::text) AS ead_ids_dates,
            confirmed_by_user.name AS confirmed_by_user_name
           FROM (((((((events
             LEFT JOIN operations_reports ON ((operations_reports.event_id = events.id)))
             LEFT JOIN rooms ON ((rooms.id = events.venue_room_id)))
             LEFT JOIN ticket_buckets ON ((ticket_buckets.event_id = events.id)))
             LEFT JOIN event_artists ON ((event_artists.event_group_id = events.event_group_id)))
             LEFT JOIN event_artist_details ON ((event_artist_details.event_artist_id = event_artists.id)))
             LEFT JOIN event_projections ON ((event_projections.event_group_id = events.event_group_id)))
             LEFT JOIN users confirmed_by_user ON ((events.confirmed_by_user_id = confirmed_by_user.id)))
          WHERE (events.state = 1)
          GROUP BY events.date, events.door_time, ( SELECT max(event_artists_1.stage_curfew) AS max
                   FROM event_artists event_artists_1
                  WHERE (event_artists_1.event_group_id = events.event_group_id)
                  GROUP BY events.event_group_id), operations_reports.bar_sales, events.id, operations_reports.door_click, rooms.name, confirmed_by_user.name, event_projections.id
          ORDER BY events.id) derivedtable
  WITH NO DATA;


--
-- TOC entry 4401 (class 2606 OID 16610071)
-- Name: orders idx_16545_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT idx_16545_primary PRIMARY KEY (id);


--
-- TOC entry 333 (class 1259 OID 16610072)
-- Name: mv_orders; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW mv_orders AS
 SELECT orders.id,
    orders.account_id,
    customers.first_name,
    customers.last_name,
    customers.email,
    addresses.city,
    addresses.state,
    addresses.country,
    addresses.postal_code,
    addresses.street1,
    orders.last_four_digits,
    orders.event_id,
    orders.price,
    orders.sales_tax,
    orders.donation,
    orders.processing_fee,
    orders.platform_fee,
    orders.fee,
    count(*) AS num_tickets,
    ''::text AS ticket_names,
    (((((orders.price + orders.fee) + orders.platform_fee) + orders.sales_tax) + orders.donation) + orders.processing_fee) AS total_amount_paid,
    ''::text AS stripe_id,
    ''::text AS stripe_fee,
    to_char(orders.created_at, 'YYYY-MM-DD'::text) AS date,
    orders.transaction_id
   FROM (((orders
     JOIN customers ON ((customers.id = orders.customer_id)))
     JOIN tickets ON ((tickets.order_id = orders.id)))
     LEFT JOIN addresses ON ((addresses.owner_id = orders.id)))
  GROUP BY orders.id, orders.account_id, customers.first_name, customers.last_name, customers.email, addresses.city, addresses.state, addresses.country, addresses.postal_code, addresses.street1, orders.last_four_digits, orders.event_id, orders.created_at
  WITH NO DATA;


--
-- TOC entry 4263 (class 2606 OID 16610081)
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 4267 (class 2606 OID 16610083)
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- TOC entry 4272 (class 2606 OID 16610085)
-- Name: announce_details announce_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY announce_details
    ADD CONSTRAINT announce_details_pkey PRIMARY KEY (id);


--
-- TOC entry 4298 (class 2606 OID 16610087)
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- TOC entry 4484 (class 2606 OID 16965874)
-- Name: artist_genres artist_genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY artist_genres
    ADD CONSTRAINT artist_genres_pkey PRIMARY KEY (id);


--
-- TOC entry 4275 (class 2606 OID 16610089)
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- TOC entry 4300 (class 2606 OID 16610091)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4307 (class 2606 OID 16610093)
-- Name: budget_plans budget_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY budget_plans
    ADD CONSTRAINT budget_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 4487 (class 2606 OID 17568370)
-- Name: budget_templates budget_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY budget_templates
    ADD CONSTRAINT budget_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 4313 (class 2606 OID 16610095)
-- Name: canned_ticket_blueprint_sets canned_ticket_blueprint_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY canned_ticket_blueprint_sets
    ADD CONSTRAINT canned_ticket_blueprint_sets_pkey PRIMARY KEY (id);


--
-- TOC entry 4491 (class 2606 OID 17816299)
-- Name: credit_option_refunds credit_option_refunds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credit_option_refunds
    ADD CONSTRAINT credit_option_refunds_pkey PRIMARY KEY (id);


--
-- TOC entry 4502 (class 2606 OID 17823238)
-- Name: customer_credits_caches customer_credits_caches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_credits_caches
    ADD CONSTRAINT customer_credits_caches_pkey PRIMARY KEY (id);


--
-- TOC entry 4496 (class 2606 OID 17816323)
-- Name: customer_credits customer_credits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_credits
    ADD CONSTRAINT customer_credits_pkey PRIMARY KEY (id);


--
-- TOC entry 4319 (class 2606 OID 16610097)
-- Name: daily_expenses daily_expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY daily_expenses
    ADD CONSTRAINT daily_expenses_pkey PRIMARY KEY (id);


--
-- TOC entry 4322 (class 2606 OID 16610099)
-- Name: daily_reports daily_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY daily_reports
    ADD CONSTRAINT daily_reports_pkey PRIMARY KEY (id);


--
-- TOC entry 4326 (class 2606 OID 16610101)
-- Name: deals deals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deals
    ADD CONSTRAINT deals_pkey PRIMARY KEY (id);


--
-- TOC entry 4334 (class 2606 OID 16610103)
-- Name: event_artist_custom_expenses event_artist_custom_expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_custom_expenses
    ADD CONSTRAINT event_artist_custom_expenses_pkey PRIMARY KEY (id);


--
-- TOC entry 4337 (class 2606 OID 16610105)
-- Name: event_artist_deals event_artist_deals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_deals
    ADD CONSTRAINT event_artist_deals_pkey PRIMARY KEY (id);


--
-- TOC entry 4341 (class 2606 OID 16610107)
-- Name: event_artist_details event_artist_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_details
    ADD CONSTRAINT event_artist_details_pkey PRIMARY KEY (id);


--
-- TOC entry 4345 (class 2606 OID 16610109)
-- Name: event_artist_payments event_artist_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_payments
    ADD CONSTRAINT event_artist_payments_pkey PRIMARY KEY (id);


--
-- TOC entry 4347 (class 2606 OID 16610111)
-- Name: event_artist_rider_documents event_artist_rider_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_rider_documents
    ADD CONSTRAINT event_artist_rider_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4350 (class 2606 OID 16610113)
-- Name: event_artist_riders event_artist_riders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_riders
    ADD CONSTRAINT event_artist_riders_pkey PRIMARY KEY (id);


--
-- TOC entry 4352 (class 2606 OID 16610115)
-- Name: event_artist_settlements_manual_gbors event_artist_settlements_manual_gbors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_settlements_manual_gbors
    ADD CONSTRAINT event_artist_settlements_manual_gbors_pkey PRIMARY KEY (id);


--
-- TOC entry 4277 (class 2606 OID 16610117)
-- Name: event_artists event_artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artists
    ADD CONSTRAINT event_artists_pkey PRIMARY KEY (id);


--
-- TOC entry 4281 (class 2606 OID 16610119)
-- Name: event_groups event_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_groups
    ADD CONSTRAINT event_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4358 (class 2606 OID 16610121)
-- Name: event_venue_room_options event_venue_room_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_venue_room_options
    ADD CONSTRAINT event_venue_room_options_pkey PRIMARY KEY (id);


--
-- TOC entry 4363 (class 2606 OID 16610123)
-- Name: eventbrite_ticket_classes eventbrite_ticket_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY eventbrite_ticket_classes
    ADD CONSTRAINT eventbrite_ticket_classes_pkey PRIMARY KEY (id);


--
-- TOC entry 4366 (class 2606 OID 16610125)
-- Name: eventbrite_ticket_sales_dates eventbrite_ticket_sales_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY eventbrite_ticket_sales_dates
    ADD CONSTRAINT eventbrite_ticket_sales_dates_pkey PRIMARY KEY (id);


--
-- TOC entry 4370 (class 2606 OID 16610127)
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- TOC entry 4373 (class 2606 OID 16610129)
-- Name: forecasts forecasts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forecasts
    ADD CONSTRAINT forecasts_pkey PRIMARY KEY (id);


--
-- TOC entry 4376 (class 2606 OID 16610131)
-- Name: hr_payloads hr_payloads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hr_payloads
    ADD CONSTRAINT hr_payloads_pkey PRIMARY KEY (id);


--
-- TOC entry 4261 (class 2606 OID 16610133)
-- Name: accounts idx_16410_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT idx_16410_primary PRIMARY KEY (id);


--
-- TOC entry 4270 (class 2606 OID 16610135)
-- Name: addresses idx_16420_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT idx_16420_primary PRIMARY KEY (id);


--
-- TOC entry 4305 (class 2606 OID 16610137)
-- Name: black_listed_people idx_16429_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY black_listed_people
    ADD CONSTRAINT idx_16429_primary PRIMARY KEY (id);


--
-- TOC entry 4311 (class 2606 OID 16610139)
-- Name: canceled_events idx_16456_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY canceled_events
    ADD CONSTRAINT idx_16456_primary PRIMARY KEY (id);


--
-- TOC entry 4317 (class 2606 OID 16610141)
-- Name: customers idx_16466_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT idx_16466_primary PRIMARY KEY (id);


--
-- TOC entry 4330 (class 2606 OID 16610143)
-- Name: discounts idx_16489_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY discounts
    ADD CONSTRAINT idx_16489_primary PRIMARY KEY (id);


--
-- TOC entry 4390 (class 2606 OID 16610145)
-- Name: memberships idx_16524_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT idx_16524_primary PRIMARY KEY (id);


--
-- TOC entry 4388 (class 2606 OID 16610147)
-- Name: membership_levels idx_16535_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY membership_levels
    ADD CONSTRAINT idx_16535_primary PRIMARY KEY (id);


--
-- TOC entry 4413 (class 2606 OID 16610149)
-- Name: presales idx_16556_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY presales
    ADD CONSTRAINT idx_16556_primary PRIMARY KEY (id);


--
-- TOC entry 4416 (class 2606 OID 16610151)
-- Name: refunds idx_16584_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY refunds
    ADD CONSTRAINT idx_16584_primary PRIMARY KEY (id);


--
-- TOC entry 4459 (class 2606 OID 16610153)
-- Name: tickets idx_16599_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tickets
    ADD CONSTRAINT idx_16599_primary PRIMARY KEY (id);


--
-- TOC entry 4446 (class 2606 OID 16610155)
-- Name: ticket_blueprints idx_16610_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_blueprints
    ADD CONSTRAINT idx_16610_primary PRIMARY KEY (id);


--
-- TOC entry 4442 (class 2606 OID 16610157)
-- Name: ticket_blueprint_locks idx_16620_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_blueprint_locks
    ADD CONSTRAINT idx_16620_primary PRIMARY KEY (id);


--
-- TOC entry 4449 (class 2606 OID 16610159)
-- Name: ticket_buckets idx_16626_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_buckets
    ADD CONSTRAINT idx_16626_primary PRIMARY KEY (id);


--
-- TOC entry 4453 (class 2606 OID 16610161)
-- Name: ticket_refunds idx_16635_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_refunds
    ADD CONSTRAINT idx_16635_primary PRIMARY KEY (id);


--
-- TOC entry 4464 (class 2606 OID 16610163)
-- Name: transactions idx_16644_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT idx_16644_primary PRIMARY KEY (id);


--
-- TOC entry 4468 (class 2606 OID 16610165)
-- Name: transfers idx_16653_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transfers
    ADD CONSTRAINT idx_16653_primary PRIMARY KEY (id);


--
-- TOC entry 4470 (class 2606 OID 16610167)
-- Name: users idx_16659_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT idx_16659_primary PRIMARY KEY (id);


--
-- TOC entry 4296 (class 2606 OID 16610169)
-- Name: venues idx_16670_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY venues
    ADD CONSTRAINT idx_16670_primary PRIMARY KEY (id);


--
-- TOC entry 4379 (class 2606 OID 16610171)
-- Name: incomes incomes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY incomes
    ADD CONSTRAINT incomes_pkey PRIMARY KEY (id);


--
-- TOC entry 4383 (class 2606 OID 16610173)
-- Name: list_entries list_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY list_entries
    ADD CONSTRAINT list_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4386 (class 2606 OID 16610175)
-- Name: lists lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);


--
-- TOC entry 4394 (class 2606 OID 16610177)
-- Name: operations_reports operations_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY operations_reports
    ADD CONSTRAINT operations_reports_pkey PRIMARY KEY (id);


--
-- TOC entry 4405 (class 2606 OID 16610179)
-- Name: pay_rates pay_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pay_rates
    ADD CONSTRAINT pay_rates_pkey PRIMARY KEY (id);


--
-- TOC entry 4409 (class 2606 OID 16610181)
-- Name: pay_time_intervals pay_time_intervals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pay_time_intervals
    ADD CONSTRAINT pay_time_intervals_pkey PRIMARY KEY (id);


--
-- TOC entry 4411 (class 2606 OID 16610183)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4418 (class 2606 OID 16610185)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4421 (class 2606 OID 16610187)
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- TOC entry 4425 (class 2606 OID 16610189)
-- Name: seating_charts seating_charts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY seating_charts
    ADD CONSTRAINT seating_charts_pkey PRIMARY KEY (id);


--
-- TOC entry 4429 (class 2606 OID 16610191)
-- Name: sold_tickets sold_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sold_tickets
    ADD CONSTRAINT sold_tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 4434 (class 2606 OID 16610193)
-- Name: staff_reports staff_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_reports
    ADD CONSTRAINT staff_reports_pkey PRIMARY KEY (id);


--
-- TOC entry 4436 (class 2606 OID 16610195)
-- Name: staffs staffs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staffs
    ADD CONSTRAINT staffs_pkey PRIMARY KEY (id);


--
-- TOC entry 4440 (class 2606 OID 16610197)
-- Name: team_roles team_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_roles
    ADD CONSTRAINT team_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4461 (class 2606 OID 16610199)
-- Name: time_intervals time_intervals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY time_intervals
    ADD CONSTRAINT time_intervals_pkey PRIMARY KEY (id);


--
-- TOC entry 4474 (class 2606 OID 16610201)
-- Name: venue_room_setups venue_room_setups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY venue_room_setups
    ADD CONSTRAINT venue_room_setups_pkey PRIMARY KEY (id);


--
-- TOC entry 4477 (class 2606 OID 16610203)
-- Name: zapier_hooks zapier_hooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY zapier_hooks
    ADD CONSTRAINT zapier_hooks_pkey PRIMARY KEY (id);


--
-- TOC entry 4500 (class 1259 OID 17823251)
-- Name: customer_credits_cache_uniq_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX customer_credits_cache_uniq_idx ON customer_credits_caches USING btree (account_id, customer_id);


--
-- TOC entry 4367 (class 1259 OID 16610204)
-- Name: eventbrite_ticket_sales_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX eventbrite_ticket_sales_idx ON eventbrite_ticket_sales_dates USING btree (eventbrite_ticket_class_id);


--
-- TOC entry 4368 (class 1259 OID 16610205)
-- Name: eventbrite_ticket_sales_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX eventbrite_ticket_sales_uniqueness ON eventbrite_ticket_sales_dates USING btree (eventbrite_ticket_class_id, topic_id, date);


--
-- TOC entry 4353 (class 1259 OID 16610206)
-- Name: fk_ea_settlements_gbors_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_ea_settlements_gbors_idx ON event_artist_settlements_manual_gbors USING btree (event_artist_detail_id);


--
-- TOC entry 4303 (class 1259 OID 16610207)
-- Name: idx_16429_index_black_listed_people_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16429_index_black_listed_people_on_account_id ON black_listed_people USING btree (account_id);


--
-- TOC entry 4315 (class 1259 OID 16610208)
-- Name: idx_16466_index_people_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16466_index_people_on_account_id ON customers USING btree (account_id);


--
-- TOC entry 4327 (class 1259 OID 16610209)
-- Name: idx_16489_index_discounts_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16489_index_discounts_on_event_id ON discounts USING btree (event_id);


--
-- TOC entry 4328 (class 1259 OID 16610210)
-- Name: idx_16489_index_discounts_on_membership_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16489_index_discounts_on_membership_level_id ON discounts USING btree (membership_level_id);


--
-- TOC entry 4331 (class 1259 OID 16610211)
-- Name: idx_16496_index_discounts_ticket_blueprints_on_discount_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16496_index_discounts_ticket_blueprints_on_discount_id ON discounts_ticket_blueprints USING btree (discount_id);


--
-- TOC entry 4332 (class 1259 OID 16610212)
-- Name: idx_16496_index_discounts_ticket_blueprints_on_ticket_blueprint; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16496_index_discounts_ticket_blueprints_on_ticket_blueprint ON discounts_ticket_blueprints USING btree (ticket_blueprint_id);


--
-- TOC entry 4395 (class 1259 OID 16610213)
-- Name: idx_16545_index_orders_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16545_index_orders_on_account_id ON orders USING btree (account_id);


--
-- TOC entry 4396 (class 1259 OID 16610214)
-- Name: idx_16545_index_orders_on_applied_discount_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16545_index_orders_on_applied_discount_id ON orders USING btree (applied_discount_id);


--
-- TOC entry 4397 (class 1259 OID 16610215)
-- Name: idx_16545_index_orders_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16545_index_orders_on_customer_id ON orders USING btree (customer_id);


--
-- TOC entry 4398 (class 1259 OID 16610216)
-- Name: idx_16545_index_orders_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16545_index_orders_on_event_id ON orders USING btree (event_id);


--
-- TOC entry 4399 (class 1259 OID 16610217)
-- Name: idx_16545_index_orders_on_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16545_index_orders_on_transaction_id ON orders USING btree (transaction_id);


--
-- TOC entry 4414 (class 1259 OID 16610218)
-- Name: idx_16584_index_refunds_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16584_index_refunds_on_order_id ON refunds USING btree (order_id);


--
-- TOC entry 4422 (class 1259 OID 16610219)
-- Name: idx_16591_unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16591_unique_schema_migrations ON schema_migrations USING btree (version);


--
-- TOC entry 4454 (class 1259 OID 16610220)
-- Name: idx_16599_index_tickets_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16599_index_tickets_on_account_id ON tickets USING btree (account_id);


--
-- TOC entry 4455 (class 1259 OID 16610221)
-- Name: idx_16599_index_tickets_on_blueprint_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16599_index_tickets_on_blueprint_id ON tickets USING btree (blueprint_id);


--
-- TOC entry 4456 (class 1259 OID 16610222)
-- Name: idx_16599_index_tickets_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16599_index_tickets_on_event_id ON tickets USING btree (event_id);


--
-- TOC entry 4457 (class 1259 OID 16610223)
-- Name: idx_16599_index_tickets_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16599_index_tickets_on_order_id ON tickets USING btree (order_id);


--
-- TOC entry 4443 (class 1259 OID 16610224)
-- Name: idx_16610_index_ticket_blueprints_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16610_index_ticket_blueprints_on_event_id ON ticket_blueprints USING btree (event_id);


--
-- TOC entry 4444 (class 1259 OID 16610225)
-- Name: idx_16610_index_ticket_blueprints_on_ticket_bucket_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16610_index_ticket_blueprints_on_ticket_bucket_id ON ticket_blueprints USING btree (ticket_bucket_id);


--
-- TOC entry 4447 (class 1259 OID 16610226)
-- Name: idx_16626_index_ticket_buckets_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16626_index_ticket_buckets_on_event_id ON ticket_buckets USING btree (event_id);


--
-- TOC entry 4450 (class 1259 OID 16610227)
-- Name: idx_16635_index_ticket_refunds_on_refund_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16635_index_ticket_refunds_on_refund_id ON ticket_refunds USING btree (refund_id);


--
-- TOC entry 4451 (class 1259 OID 16610228)
-- Name: idx_16635_index_ticket_refunds_on_ticket_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16635_index_ticket_refunds_on_ticket_id ON ticket_refunds USING btree (ticket_id);


--
-- TOC entry 4462 (class 1259 OID 16610229)
-- Name: idx_16644_index_transactions_on_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16644_index_transactions_on_transaction_id ON transactions USING btree (transaction_id);


--
-- TOC entry 4465 (class 1259 OID 16610230)
-- Name: idx_16653_index_transfers_on_source_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16653_index_transfers_on_source_event_id ON transfers USING btree (source_event_id);


--
-- TOC entry 4466 (class 1259 OID 16610231)
-- Name: idx_16653_index_transfers_on_target_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16653_index_transfers_on_target_event_id ON transfers USING btree (target_event_id);


--
-- TOC entry 4492 (class 1259 OID 17816312)
-- Name: idx_credit_option_refunds_refundable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_credit_option_refunds_refundable ON credit_option_refunds USING btree (refundable_type, refundable_id);


--
-- TOC entry 4343 (class 1259 OID 16610232)
-- Name: idx_unique_event_event_artist_details; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_unique_event_event_artist_details ON event_artist_details_events USING btree (event_id, event_artist_detail_id);


--
-- TOC entry 4264 (class 1259 OID 16610233)
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON active_storage_attachments USING btree (blob_id);


--
-- TOC entry 4265 (class 1259 OID 16610234)
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- TOC entry 4268 (class 1259 OID 16610235)
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON active_storage_blobs USING btree (key);


--
-- TOC entry 4273 (class 1259 OID 16610236)
-- Name: index_announce_details_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_announce_details_on_event_id ON announce_details USING btree (event_id);


--
-- TOC entry 4485 (class 1259 OID 16965880)
-- Name: index_artist_genres_on_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_artist_genres_on_artist_id ON artist_genres USING btree (artist_id);


--
-- TOC entry 4301 (class 1259 OID 16610237)
-- Name: index_audit_logs_on_auditable_type_and_auditable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audit_logs_on_auditable_type_and_auditable_id ON audit_logs USING btree (auditable_type, auditable_id);


--
-- TOC entry 4302 (class 1259 OID 16610238)
-- Name: index_audit_logs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audit_logs_on_user_id ON audit_logs USING btree (user_id);


--
-- TOC entry 4308 (class 1259 OID 17822932)
-- Name: index_budget_plans_on_budget_template_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budget_plans_on_budget_template_id ON budget_plans USING btree (budget_template_id);


--
-- TOC entry 4309 (class 1259 OID 16610239)
-- Name: index_budget_plans_on_event_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budget_plans_on_event_group_id ON budget_plans USING btree (event_group_id);


--
-- TOC entry 4488 (class 1259 OID 17568376)
-- Name: index_budget_templates_on_budget_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budget_templates_on_budget_plan_id ON budget_templates USING btree (budget_plan_id);


--
-- TOC entry 4489 (class 1259 OID 17822931)
-- Name: index_budget_templates_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budget_templates_on_venue_id ON budget_templates USING btree (venue_id);


--
-- TOC entry 4314 (class 1259 OID 16610240)
-- Name: index_canned_ticket_blueprint_sets_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_canned_ticket_blueprint_sets_on_account_id ON canned_ticket_blueprint_sets USING btree (account_id);


--
-- TOC entry 4493 (class 1259 OID 17816310)
-- Name: index_credit_option_refunds_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_credit_option_refunds_on_order_id ON credit_option_refunds USING btree (order_id);


--
-- TOC entry 4494 (class 1259 OID 17816311)
-- Name: index_credit_option_refunds_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_credit_option_refunds_on_user_id ON credit_option_refunds USING btree (user_id);


--
-- TOC entry 4503 (class 1259 OID 17823249)
-- Name: index_customer_credits_caches_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customer_credits_caches_on_account_id ON customer_credits_caches USING btree (account_id);


--
-- TOC entry 4504 (class 1259 OID 17823250)
-- Name: index_customer_credits_caches_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customer_credits_caches_on_customer_id ON customer_credits_caches USING btree (customer_id);


--
-- TOC entry 4497 (class 1259 OID 17816340)
-- Name: index_customer_credits_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customer_credits_on_account_id ON customer_credits USING btree (account_id);


--
-- TOC entry 4498 (class 1259 OID 17816339)
-- Name: index_customer_credits_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customer_credits_on_customer_id ON customer_credits USING btree (customer_id);


--
-- TOC entry 4499 (class 1259 OID 17816341)
-- Name: index_customer_credits_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customer_credits_on_order_id ON customer_credits USING btree (order_id);


--
-- TOC entry 4320 (class 1259 OID 16610241)
-- Name: index_daily_expenses_on_daily_report_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_daily_expenses_on_daily_report_id ON daily_expenses USING btree (daily_report_id);


--
-- TOC entry 4323 (class 1259 OID 16610242)
-- Name: index_daily_reports_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_daily_reports_on_event_id ON daily_reports USING btree (event_id);


--
-- TOC entry 4324 (class 1259 OID 16610243)
-- Name: index_daily_reports_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_daily_reports_on_venue_id ON daily_reports USING btree (venue_id);


--
-- TOC entry 4335 (class 1259 OID 16610244)
-- Name: index_event_artist_custom_expenses_on_event_artist_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_artist_custom_expenses_on_event_artist_detail_id ON event_artist_custom_expenses USING btree (event_artist_detail_id);


--
-- TOC entry 4338 (class 1259 OID 16610245)
-- Name: index_event_artist_deals_on_deal_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_artist_deals_on_deal_id ON event_artist_deals USING btree (deal_id);


--
-- TOC entry 4339 (class 1259 OID 16610246)
-- Name: index_event_artist_deals_on_event_artist_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_artist_deals_on_event_artist_detail_id ON event_artist_deals USING btree (event_artist_detail_id);


--
-- TOC entry 4342 (class 1259 OID 16610247)
-- Name: index_event_artist_details_on_event_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_artist_details_on_event_artist_id ON event_artist_details USING btree (event_artist_id);


--
-- TOC entry 4278 (class 1259 OID 16610248)
-- Name: index_event_artists_on_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_artists_on_artist_id ON event_artists USING btree (artist_id);


--
-- TOC entry 4279 (class 1259 OID 16610249)
-- Name: index_event_artists_on_event_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_artists_on_event_group_id ON event_artists USING btree (event_group_id);


--
-- TOC entry 4282 (class 1259 OID 16610250)
-- Name: index_event_groups_on_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_groups_on_list_id ON event_groups USING btree (list_id);


--
-- TOC entry 4283 (class 1259 OID 16610251)
-- Name: index_event_groups_on_ticket_bucket_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_groups_on_ticket_bucket_id ON event_groups USING btree (ticket_bucket_id);


--
-- TOC entry 4284 (class 1259 OID 16610252)
-- Name: index_event_groups_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_groups_on_venue_id ON event_groups USING btree (venue_id);


--
-- TOC entry 4356 (class 1259 OID 16610253)
-- Name: index_event_projections_on_event_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_projections_on_event_group_id ON event_projections USING btree (event_group_id);


--
-- TOC entry 4359 (class 1259 OID 16610254)
-- Name: index_event_venue_room_options_on_event_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_venue_room_options_on_event_group_id ON event_venue_room_options USING btree (event_group_id);


--
-- TOC entry 4360 (class 1259 OID 16610255)
-- Name: index_event_venue_room_options_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_venue_room_options_on_venue_id ON event_venue_room_options USING btree (venue_id);


--
-- TOC entry 4361 (class 1259 OID 16610256)
-- Name: index_event_venue_room_options_on_venue_room_setup_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_venue_room_options_on_venue_room_setup_id ON event_venue_room_options USING btree (venue_room_setup_id);


--
-- TOC entry 4364 (class 1259 OID 16610257)
-- Name: index_eventbrite_ticket_classes_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_eventbrite_ticket_classes_on_event_id ON eventbrite_ticket_classes USING btree (event_id);


--
-- TOC entry 4287 (class 1259 OID 16610258)
-- Name: index_events_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_account_id ON events USING btree (account_id);


--
-- TOC entry 4288 (class 1259 OID 16610259)
-- Name: index_events_on_confirmed_by_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_confirmed_by_user_id ON events USING btree (confirmed_by_user_id);


--
-- TOC entry 4289 (class 1259 OID 16610260)
-- Name: index_events_on_created_by_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_created_by_user_id ON events USING btree (created_by_user_id);


--
-- TOC entry 4290 (class 1259 OID 16610261)
-- Name: index_events_on_event_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_event_group_id ON events USING btree (event_group_id);


--
-- TOC entry 4291 (class 1259 OID 16610262)
-- Name: index_events_on_seating_chart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_seating_chart_id ON events USING btree (seating_chart_id);


--
-- TOC entry 4292 (class 1259 OID 16610263)
-- Name: index_events_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_state ON events USING btree (state);


--
-- TOC entry 4293 (class 1259 OID 16610264)
-- Name: index_events_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_venue_id ON events USING btree (venue_id);


--
-- TOC entry 4294 (class 1259 OID 16610265)
-- Name: index_events_on_venue_room_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_venue_room_id ON events USING btree (venue_room_id);


--
-- TOC entry 4371 (class 1259 OID 16610266)
-- Name: index_expenses_on_budget_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_expenses_on_budget_plan_id ON expenses USING btree (budget_plan_id);


--
-- TOC entry 4374 (class 1259 OID 16610267)
-- Name: index_forecasts_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_forecasts_on_event_id ON forecasts USING btree (event_id);


--
-- TOC entry 4377 (class 1259 OID 16610268)
-- Name: index_hr_payloads_on_staff_report_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hr_payloads_on_staff_report_id ON hr_payloads USING btree (staff_report_id);


--
-- TOC entry 4380 (class 1259 OID 16610269)
-- Name: index_incomes_on_budget_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_incomes_on_budget_plan_id ON incomes USING btree (budget_plan_id);


--
-- TOC entry 4381 (class 1259 OID 16610270)
-- Name: index_list_entries_on_list_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_list_entries_on_list_id ON list_entries USING btree (list_id);


--
-- TOC entry 4384 (class 1259 OID 16610271)
-- Name: index_lists_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lists_on_event_id ON lists USING btree (event_id);


--
-- TOC entry 4391 (class 1259 OID 16610272)
-- Name: index_operations_reports_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_operations_reports_on_event_id ON operations_reports USING btree (event_id);


--
-- TOC entry 4392 (class 1259 OID 16610273)
-- Name: index_operations_reports_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_operations_reports_on_venue_id ON operations_reports USING btree (venue_id);


--
-- TOC entry 4402 (class 1259 OID 16610274)
-- Name: index_pay_rates_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pay_rates_on_role_id ON pay_rates USING btree (role_id);


--
-- TOC entry 4403 (class 1259 OID 16610275)
-- Name: index_pay_rates_on_staff_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pay_rates_on_staff_id ON pay_rates USING btree (staff_id);


--
-- TOC entry 4406 (class 1259 OID 16610276)
-- Name: index_pay_time_intervals_on_pay_rate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pay_time_intervals_on_pay_rate_id ON pay_time_intervals USING btree (pay_rate_id);


--
-- TOC entry 4407 (class 1259 OID 16610277)
-- Name: index_pay_time_intervals_on_time_interval_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pay_time_intervals_on_time_interval_id ON pay_time_intervals USING btree (time_interval_id);


--
-- TOC entry 4419 (class 1259 OID 16610278)
-- Name: index_rooms_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rooms_on_venue_id ON rooms USING btree (venue_id);


--
-- TOC entry 4423 (class 1259 OID 16610279)
-- Name: index_seating_charts_on_canned_ticket_blueprint_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_seating_charts_on_canned_ticket_blueprint_set_id ON seating_charts USING btree (canned_ticket_blueprint_set_id);


--
-- TOC entry 4426 (class 1259 OID 16610280)
-- Name: index_sold_tickets_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sold_tickets_on_event_id ON sold_tickets USING btree (event_id);


--
-- TOC entry 4427 (class 1259 OID 16610281)
-- Name: index_sold_tickets_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sold_tickets_on_venue_id ON sold_tickets USING btree (venue_id);


--
-- TOC entry 4430 (class 1259 OID 16610282)
-- Name: index_staff_reports_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_staff_reports_on_role_id ON staff_reports USING btree (role_id);


--
-- TOC entry 4431 (class 1259 OID 16610283)
-- Name: index_staff_reports_on_staff_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_staff_reports_on_staff_id ON staff_reports USING btree (staff_id);


--
-- TOC entry 4432 (class 1259 OID 16610284)
-- Name: index_staff_reports_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_staff_reports_on_venue_id ON staff_reports USING btree (venue_id);


--
-- TOC entry 4437 (class 1259 OID 16610285)
-- Name: index_team_roles_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_team_roles_on_account_id ON team_roles USING btree (account_id);


--
-- TOC entry 4438 (class 1259 OID 16610286)
-- Name: index_team_roles_on_permission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_team_roles_on_permission_id ON team_roles USING btree (permission_id);


--
-- TOC entry 4471 (class 1259 OID 16610287)
-- Name: index_users_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_deleted_at ON users USING btree (deleted_at);


--
-- TOC entry 4472 (class 1259 OID 16610288)
-- Name: index_users_on_team_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_team_role_id ON users USING btree (team_role_id);


--
-- TOC entry 4475 (class 1259 OID 16610289)
-- Name: index_zapier_hooks_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_zapier_hooks_on_user_id ON zapier_hooks USING btree (user_id);


--
-- TOC entry 4478 (class 1259 OID 16610290)
-- Name: mv_event_sales_account_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mv_event_sales_account_id_idx ON mv_event_sales USING btree (account_id);


--
-- TOC entry 4479 (class 1259 OID 16610291)
-- Name: mv_event_sales_event_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mv_event_sales_event_id_idx ON mv_event_sales USING btree (event_id);


--
-- TOC entry 4480 (class 1259 OID 16610292)
-- Name: mv_orders_account_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mv_orders_account_id_idx ON mv_orders USING btree (account_id);


--
-- TOC entry 4481 (class 1259 OID 16610293)
-- Name: mv_orders_event_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mv_orders_event_id_idx ON mv_orders USING btree (event_id);


--
-- TOC entry 4482 (class 1259 OID 16610294)
-- Name: mv_orders_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mv_orders_id_idx ON mv_orders USING btree (id);


--
-- TOC entry 4348 (class 1259 OID 16610295)
-- Name: rider_document_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rider_document_index ON event_artist_rider_documents USING btree (event_artist_rider_id);


--
-- TOC entry 4581 (class 2620 OID 16610296)
-- Name: event_artist_details_events ensure_event_belongs_to_event_artist_event_group_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ensure_event_belongs_to_event_artist_event_group_trg BEFORE INSERT OR UPDATE ON event_artist_details_events FOR EACH ROW EXECUTE PROCEDURE check_event_artist_details_events_event_fk();


--
-- TOC entry 4582 (class 2620 OID 16610297)
-- Name: event_artist_details_events ensure_single_event_artist_event_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ensure_single_event_artist_event_trg BEFORE INSERT OR UPDATE ON event_artist_details_events FOR EACH ROW EXECUTE PROCEDURE check_single_event_artist_event();


--
-- TOC entry 4585 (class 2620 OID 17823258)
-- Name: customer_credits update_customer_credits_cache_before_delete_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_customer_credits_cache_before_delete_trg BEFORE DELETE ON customer_credits FOR EACH ROW EXECUTE PROCEDURE customer_credits_before_delete();


--
-- TOC entry 4583 (class 2620 OID 17823256)
-- Name: customer_credits update_customer_credits_cache_before_insert_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_customer_credits_cache_before_insert_trg BEFORE INSERT ON customer_credits FOR EACH ROW EXECUTE PROCEDURE customer_credits_before_insert();


--
-- TOC entry 4584 (class 2620 OID 17823257)
-- Name: customer_credits update_customer_credits_cache_before_update_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_customer_credits_cache_before_update_trg BEFORE UPDATE ON customer_credits FOR EACH ROW EXECUTE PROCEDURE customer_credits_before_update();


--
-- TOC entry 4531 (class 2606 OID 16610298)
-- Name: event_artist_riders event_artists_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_riders
    ADD CONSTRAINT event_artists_fk FOREIGN KEY (event_artist_id) REFERENCES event_artists(id);


--
-- TOC entry 4532 (class 2606 OID 16610303)
-- Name: event_artist_riders events_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_riders
    ADD CONSTRAINT events_fk FOREIGN KEY (event_id) REFERENCES events(id);


--
-- TOC entry 4550 (class 2606 OID 16610308)
-- Name: pay_rates fk_rails_040cecaa75; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pay_rates
    ADD CONSTRAINT fk_rails_040cecaa75 FOREIGN KEY (staff_id) REFERENCES staffs(id);


--
-- TOC entry 4554 (class 2606 OID 16610313)
-- Name: refunds fk_rails_0585533fe2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY refunds
    ADD CONSTRAINT fk_rails_0585533fe2 FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- TOC entry 4577 (class 2606 OID 17816329)
-- Name: customer_credits fk_rails_0648787b06; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_credits
    ADD CONSTRAINT fk_rails_0648787b06 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- TOC entry 4541 (class 2606 OID 16610318)
-- Name: forecasts fk_rails_0c132559ea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY forecasts
    ADD CONSTRAINT fk_rails_0c132559ea FOREIGN KEY (event_id) REFERENCES events(id);


--
-- TOC entry 4506 (class 2606 OID 16610323)
-- Name: event_artists fk_rails_0e0ab84871; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artists
    ADD CONSTRAINT fk_rails_0e0ab84871 FOREIGN KEY (event_group_id) REFERENCES event_groups(id);


--
-- TOC entry 4556 (class 2606 OID 16610328)
-- Name: sold_tickets fk_rails_0e4626c249; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sold_tickets
    ADD CONSTRAINT fk_rails_0e4626c249 FOREIGN KEY (event_id) REFERENCES events(id);


--
-- TOC entry 4573 (class 2606 OID 17568371)
-- Name: budget_templates fk_rails_0ef5ca2a9d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY budget_templates
    ADD CONSTRAINT fk_rails_0ef5ca2a9d FOREIGN KEY (budget_plan_id) REFERENCES budget_plans(id);


--
-- TOC entry 4546 (class 2606 OID 16610333)
-- Name: orders fk_rails_144e25bef6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_144e25bef6 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- TOC entry 4539 (class 2606 OID 16610338)
-- Name: eventbrite_ticket_sales_dates fk_rails_145b4b79d9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY eventbrite_ticket_sales_dates
    ADD CONSTRAINT fk_rails_145b4b79d9 FOREIGN KEY (eventbrite_ticket_class_id) REFERENCES eventbrite_ticket_classes(id);


--
-- TOC entry 4542 (class 2606 OID 16610343)
-- Name: hr_payloads fk_rails_16e58e5411; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hr_payloads
    ADD CONSTRAINT fk_rails_16e58e5411 FOREIGN KEY (staff_report_id) REFERENCES staff_reports(id);


--
-- TOC entry 4511 (class 2606 OID 16610348)
-- Name: events fk_rails_17c5f28626; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_17c5f28626 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- TOC entry 4535 (class 2606 OID 16610353)
-- Name: event_venue_room_options fk_rails_1f8252bcc7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_venue_room_options
    ADD CONSTRAINT fk_rails_1f8252bcc7 FOREIGN KEY (event_group_id) REFERENCES event_groups(id);


--
-- TOC entry 4529 (class 2606 OID 16610358)
-- Name: event_artist_payments fk_rails_21c234ced6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_payments
    ADD CONSTRAINT fk_rails_21c234ced6 FOREIGN KEY (event_artist_detail_id) REFERENCES event_artist_details(id);


--
-- TOC entry 4521 (class 2606 OID 16610363)
-- Name: daily_reports fk_rails_2f5bd05f83; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY daily_reports
    ADD CONSTRAINT fk_rails_2f5bd05f83 FOREIGN KEY (event_id) REFERENCES events(id);


--
-- TOC entry 4552 (class 2606 OID 16610368)
-- Name: pay_time_intervals fk_rails_3222045b0a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pay_time_intervals
    ADD CONSTRAINT fk_rails_3222045b0a FOREIGN KEY (pay_rate_id) REFERENCES pay_rates(id);


--
-- TOC entry 4572 (class 2606 OID 16965875)
-- Name: artist_genres fk_rails_37ac7c9770; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY artist_genres
    ADD CONSTRAINT fk_rails_37ac7c9770 FOREIGN KEY (artist_id) REFERENCES artists(id);


--
-- TOC entry 4566 (class 2606 OID 16610373)
-- Name: tickets fk_rails_3a45de412c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tickets
    ADD CONSTRAINT fk_rails_3a45de412c FOREIGN KEY (blueprint_id) REFERENCES ticket_blueprints(id);


--
-- TOC entry 4547 (class 2606 OID 16610378)
-- Name: orders fk_rails_3a83fceb8e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_3a83fceb8e FOREIGN KEY (applied_discount_id) REFERENCES discounts(id);


--
-- TOC entry 4548 (class 2606 OID 16610383)
-- Name: orders fk_rails_3dad120da9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_3dad120da9 FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- TOC entry 4512 (class 2606 OID 16610388)
-- Name: events fk_rails_3fc63440d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_3fc63440d8 FOREIGN KEY (seating_chart_id) REFERENCES seating_charts(id);


--
-- TOC entry 4513 (class 2606 OID 16610393)
-- Name: events fk_rails_4065bbae6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_4065bbae6a FOREIGN KEY (event_group_id) REFERENCES event_groups(id);


--
-- TOC entry 4519 (class 2606 OID 16610398)
-- Name: canceled_events fk_rails_4187e26fab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY canceled_events
    ADD CONSTRAINT fk_rails_4187e26fab FOREIGN KEY (event_id) REFERENCES events(id);


--
-- TOC entry 4567 (class 2606 OID 16610403)
-- Name: tickets fk_rails_4206602c73; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tickets
    ADD CONSTRAINT fk_rails_4206602c73 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- TOC entry 4558 (class 2606 OID 16610408)
-- Name: staff_reports fk_rails_4ca78b8e09; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_reports
    ADD CONSTRAINT fk_rails_4ca78b8e09 FOREIGN KEY (role_id) REFERENCES roles(id);


--
-- TOC entry 4568 (class 2606 OID 16610413)
-- Name: tickets fk_rails_4def87ea62; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tickets
    ADD CONSTRAINT fk_rails_4def87ea62 FOREIGN KEY (event_id) REFERENCES events(id);


--
-- TOC entry 4574 (class 2606 OID 17816305)
-- Name: credit_option_refunds fk_rails_4e0b76b25d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credit_option_refunds
    ADD CONSTRAINT fk_rails_4e0b76b25d FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 4553 (class 2606 OID 16610418)
-- Name: pay_time_intervals fk_rails_52c0971c93; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pay_time_intervals
    ADD CONSTRAINT fk_rails_52c0971c93 FOREIGN KEY (time_interval_id) REFERENCES time_intervals(id);


--
-- TOC entry 4578 (class 2606 OID 17816324)
-- Name: customer_credits fk_rails_53321038b3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_credits
    ADD CONSTRAINT fk_rails_53321038b3 FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- TOC entry 4579 (class 2606 OID 17823244)
-- Name: customer_credits_caches fk_rails_56e3a5823b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_credits_caches
    ADD CONSTRAINT fk_rails_56e3a5823b FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- TOC entry 4508 (class 2606 OID 16610423)
-- Name: event_groups fk_rails_5d83614b35; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_groups
    ADD CONSTRAINT fk_rails_5d83614b35 FOREIGN KEY (venue_id) REFERENCES venues(id);


--
-- TOC entry 4570 (class 2606 OID 16610428)
-- Name: users fk_rails_61ac11da2b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_61ac11da2b FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- TOC entry 4549 (class 2606 OID 16610433)
-- Name: orders fk_rails_64bd9e45d4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_64bd9e45d4 FOREIGN KEY (event_id) REFERENCES events(id);


--
-- TOC entry 4555 (class 2606 OID 16610438)
-- Name: refunds fk_rails_7055819eb7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY refunds
    ADD CONSTRAINT fk_rails_7055819eb7 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 4564 (class 2606 OID 16610443)
-- Name: ticket_refunds fk_rails_76084fec0d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_refunds
    ADD CONSTRAINT fk_rails_76084fec0d FOREIGN KEY (refund_id) REFERENCES refunds(id);


--
-- TOC entry 4565 (class 2606 OID 16610448)
-- Name: ticket_refunds fk_rails_7b7e37ed8f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_refunds
    ADD CONSTRAINT fk_rails_7b7e37ed8f FOREIGN KEY (ticket_id) REFERENCES tickets(id);


--
-- TOC entry 4538 (class 2606 OID 16610453)
-- Name: eventbrite_ticket_classes fk_rails_7c38b94597; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY eventbrite_ticket_classes
    ADD CONSTRAINT fk_rails_7c38b94597 FOREIGN KEY (event_id) REFERENCES events(id);


--
-- TOC entry 4509 (class 2606 OID 16610458)
-- Name: event_groups fk_rails_7df011f03a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_groups
    ADD CONSTRAINT fk_rails_7df011f03a FOREIGN KEY (list_id) REFERENCES lists(id);


--
-- TOC entry 4543 (class 2606 OID 16610463)
-- Name: incomes fk_rails_7ff7cc5c13; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY incomes
    ADD CONSTRAINT fk_rails_7ff7cc5c13 FOREIGN KEY (budget_plan_id) REFERENCES budget_plans(id);


--
-- TOC entry 4536 (class 2606 OID 16610468)
-- Name: event_venue_room_options fk_rails_8956a637ed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_venue_room_options
    ADD CONSTRAINT fk_rails_8956a637ed FOREIGN KEY (venue_id) REFERENCES venues(id);


--
-- TOC entry 4580 (class 2606 OID 17823239)
-- Name: customer_credits_caches fk_rails_8b687bfeef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_credits_caches
    ADD CONSTRAINT fk_rails_8b687bfeef FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- TOC entry 4520 (class 2606 OID 16610473)
-- Name: daily_expenses fk_rails_90e2c80e71; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY daily_expenses
    ADD CONSTRAINT fk_rails_90e2c80e71 FOREIGN KEY (daily_report_id) REFERENCES daily_reports(id);


--
-- TOC entry 4576 (class 2606 OID 17816334)
-- Name: customer_credits fk_rails_916fa0b203; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer_credits
    ADD CONSTRAINT fk_rails_916fa0b203 FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- TOC entry 4523 (class 2606 OID 16610478)
-- Name: event_artist_custom_expenses fk_rails_96dd12a6a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_custom_expenses
    ADD CONSTRAINT fk_rails_96dd12a6a9 FOREIGN KEY (event_artist_detail_id) REFERENCES event_artist_details(id);


--
-- TOC entry 4530 (class 2606 OID 16610483)
-- Name: event_artist_rider_documents fk_rails_9ab4dd10cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_rider_documents
    ADD CONSTRAINT fk_rails_9ab4dd10cf FOREIGN KEY (event_artist_rider_id) REFERENCES event_artist_riders(id);


--
-- TOC entry 4561 (class 2606 OID 16610488)
-- Name: team_roles fk_rails_a07fcba2b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_roles
    ADD CONSTRAINT fk_rails_a07fcba2b7 FOREIGN KEY (permission_id) REFERENCES permissions(id);


--
-- TOC entry 4514 (class 2606 OID 16610493)
-- Name: events fk_rails_ab99904e95; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_ab99904e95 FOREIGN KEY (confirmed_by_user_id) REFERENCES users(id);


--
-- TOC entry 4533 (class 2606 OID 16610498)
-- Name: event_artist_settlements_manual_gbors fk_rails_acc876c3c5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_settlements_manual_gbors
    ADD CONSTRAINT fk_rails_acc876c3c5 FOREIGN KEY (event_artist_detail_id) REFERENCES event_artist_details(id);


--
-- TOC entry 4559 (class 2606 OID 16610503)
-- Name: staff_reports fk_rails_ae64b30fb8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_reports
    ADD CONSTRAINT fk_rails_ae64b30fb8 FOREIGN KEY (staff_id) REFERENCES staffs(id);


--
-- TOC entry 4524 (class 2606 OID 16610508)
-- Name: event_artist_deals fk_rails_af48fad471; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_deals
    ADD CONSTRAINT fk_rails_af48fad471 FOREIGN KEY (deal_id) REFERENCES deals(id);


--
-- TOC entry 4515 (class 2606 OID 16610513)
-- Name: events fk_rails_b365a6d282; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_b365a6d282 FOREIGN KEY (created_by_user_id) REFERENCES users(id);


--
-- TOC entry 4544 (class 2606 OID 16610518)
-- Name: operations_reports fk_rails_b8ac653b00; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY operations_reports
    ADD CONSTRAINT fk_rails_b8ac653b00 FOREIGN KEY (venue_id) REFERENCES venues(id);


--
-- TOC entry 4526 (class 2606 OID 16610523)
-- Name: event_artist_details fk_rails_bc86dd5190; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_details
    ADD CONSTRAINT fk_rails_bc86dd5190 FOREIGN KEY (event_artist_id) REFERENCES event_artists(id);


--
-- TOC entry 4505 (class 2606 OID 16610528)
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES active_storage_blobs(id);


--
-- TOC entry 4522 (class 2606 OID 16610533)
-- Name: daily_reports fk_rails_c493ebfa16; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY daily_reports
    ADD CONSTRAINT fk_rails_c493ebfa16 FOREIGN KEY (venue_id) REFERENCES venues(id);


--
-- TOC entry 4569 (class 2606 OID 16610538)
-- Name: tickets fk_rails_c6410ba81d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tickets
    ADD CONSTRAINT fk_rails_c6410ba81d FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- TOC entry 4540 (class 2606 OID 16610543)
-- Name: expenses fk_rails_c7ffd1fdd4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY expenses
    ADD CONSTRAINT fk_rails_c7ffd1fdd4 FOREIGN KEY (budget_plan_id) REFERENCES budget_plans(id);


--
-- TOC entry 4562 (class 2606 OID 16610548)
-- Name: team_roles fk_rails_cb9d19b38b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_roles
    ADD CONSTRAINT fk_rails_cb9d19b38b FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- TOC entry 4507 (class 2606 OID 16610553)
-- Name: event_artists fk_rails_cef8ad86b1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artists
    ADD CONSTRAINT fk_rails_cef8ad86b1 FOREIGN KEY (artist_id) REFERENCES artists(id);


--
-- TOC entry 4516 (class 2606 OID 16610558)
-- Name: events fk_rails_d066ea8a7f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_d066ea8a7f FOREIGN KEY (venue_room_id) REFERENCES rooms(id);


--
-- TOC entry 4563 (class 2606 OID 16610563)
-- Name: ticket_blueprints fk_rails_d62e8d269c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ticket_blueprints
    ADD CONSTRAINT fk_rails_d62e8d269c FOREIGN KEY (event_id) REFERENCES events(id);


--
-- TOC entry 4557 (class 2606 OID 16610568)
-- Name: sold_tickets fk_rails_d74dbd5abc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sold_tickets
    ADD CONSTRAINT fk_rails_d74dbd5abc FOREIGN KEY (venue_id) REFERENCES venues(id);


--
-- TOC entry 4534 (class 2606 OID 16610573)
-- Name: event_projections fk_rails_db1312f6fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_projections
    ADD CONSTRAINT fk_rails_db1312f6fd FOREIGN KEY (event_group_id) REFERENCES event_groups(id);


--
-- TOC entry 4560 (class 2606 OID 16610578)
-- Name: staff_reports fk_rails_dbf96a6622; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY staff_reports
    ADD CONSTRAINT fk_rails_dbf96a6622 FOREIGN KEY (venue_id) REFERENCES venues(id);


--
-- TOC entry 4545 (class 2606 OID 16610583)
-- Name: operations_reports fk_rails_dc4018484c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY operations_reports
    ADD CONSTRAINT fk_rails_dc4018484c FOREIGN KEY (event_id) REFERENCES events(id);


--
-- TOC entry 4575 (class 2606 OID 17816300)
-- Name: credit_option_refunds fk_rails_e03edd3446; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credit_option_refunds
    ADD CONSTRAINT fk_rails_e03edd3446 FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- TOC entry 4571 (class 2606 OID 16610588)
-- Name: users fk_rails_e0575672fb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_e0575672fb FOREIGN KEY (team_role_id) REFERENCES team_roles(id);


--
-- TOC entry 4518 (class 2606 OID 16610593)
-- Name: budget_plans fk_rails_e538607157; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY budget_plans
    ADD CONSTRAINT fk_rails_e538607157 FOREIGN KEY (event_group_id) REFERENCES event_groups(id);


--
-- TOC entry 4510 (class 2606 OID 16610598)
-- Name: event_groups fk_rails_ed0acd2af2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_groups
    ADD CONSTRAINT fk_rails_ed0acd2af2 FOREIGN KEY (ticket_bucket_id) REFERENCES ticket_buckets(id);


--
-- TOC entry 4537 (class 2606 OID 16610603)
-- Name: event_venue_room_options fk_rails_efb96ff56c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_venue_room_options
    ADD CONSTRAINT fk_rails_efb96ff56c FOREIGN KEY (venue_room_setup_id) REFERENCES venue_room_setups(id);


--
-- TOC entry 4517 (class 2606 OID 16610608)
-- Name: events fk_rails_f476266cf4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_f476266cf4 FOREIGN KEY (venue_id) REFERENCES venues(id);


--
-- TOC entry 4525 (class 2606 OID 16610613)
-- Name: event_artist_deals fk_rails_f4edc5bf82; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_deals
    ADD CONSTRAINT fk_rails_f4edc5bf82 FOREIGN KEY (event_artist_detail_id) REFERENCES event_artist_details(id);


--
-- TOC entry 4527 (class 2606 OID 16610618)
-- Name: event_artist_details_events fk_rails_f97211fa0e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_details_events
    ADD CONSTRAINT fk_rails_f97211fa0e FOREIGN KEY (event_artist_detail_id) REFERENCES event_artist_details(id);


--
-- TOC entry 4551 (class 2606 OID 16610623)
-- Name: pay_rates fk_rails_fc6ec98c51; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pay_rates
    ADD CONSTRAINT fk_rails_fc6ec98c51 FOREIGN KEY (role_id) REFERENCES roles(id);


--
-- TOC entry 4528 (class 2606 OID 16610628)
-- Name: event_artist_details_events fk_rails_fedf630227; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_artist_details_events
    ADD CONSTRAINT fk_rails_fedf630227 FOREIGN KEY (event_id) REFERENCES events(id);


-- Completed on 2020-12-04 15:47:38 CST

--
-- PostgreSQL database dump complete
--

