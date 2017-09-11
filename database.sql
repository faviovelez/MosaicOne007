--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.8
-- Dumped by pg_dump version 9.5.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: additional_discounts; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE additional_discounts (
    id integer NOT NULL,
    type_of_discount character varying,
    percentage double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE additional_discounts OWNER TO faviovelez;

--
-- Name: additional_discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE additional_discounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE additional_discounts_id_seq OWNER TO faviovelez;

--
-- Name: additional_discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE additional_discounts_id_seq OWNED BY additional_discounts.id;


--
-- Name: bill_receiveds; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE bill_receiveds (
    id integer NOT NULL,
    folio character varying,
    date_of_bill date,
    subtotal double precision,
    taxes_rate double precision,
    taxes double precision,
    total_amount double precision,
    supplier_id integer,
    product_id integer,
    payment_day date,
    payment_complete boolean,
    payment_on_time boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    business_unit_id integer,
    store_id integer
);


ALTER TABLE bill_receiveds OWNER TO faviovelez;

--
-- Name: bill_receiveds_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE bill_receiveds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bill_receiveds_id_seq OWNER TO faviovelez;

--
-- Name: bill_receiveds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE bill_receiveds_id_seq OWNED BY bill_receiveds.id;


--
-- Name: billing_addresses; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE billing_addresses (
    id integer NOT NULL,
    type_of_person character varying,
    business_name character varying,
    rfc character varying,
    street character varying,
    exterior_number character varying,
    interior_number character varying,
    zipcode integer,
    neighborhood character varying,
    city character varying,
    state character varying,
    country character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE billing_addresses OWNER TO faviovelez;

--
-- Name: billing_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE billing_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE billing_addresses_id_seq OWNER TO faviovelez;

--
-- Name: billing_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE billing_addresses_id_seq OWNED BY billing_addresses.id;


--
-- Name: bills; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE bills (
    id integer NOT NULL,
    status character varying,
    order_id integer,
    initial_price double precision,
    discount_applied double precision,
    additional_discount_applied double precision,
    price_before_taxes double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type_of_bill character varying,
    prospect_id integer,
    classification character varying,
    amount double precision,
    quantity integer,
    pdf character varying,
    xml character varying,
    issuing_company_id integer,
    receiving_company_id integer,
    business_unit_id integer,
    store_id integer
);


ALTER TABLE bills OWNER TO faviovelez;

--
-- Name: bills_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE bills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bills_id_seq OWNER TO faviovelez;

--
-- Name: bills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE bills_id_seq OWNED BY bills.id;


--
-- Name: business_group_sales; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE business_group_sales (
    id integer NOT NULL,
    business_group_id integer,
    month integer,
    year integer,
    sales_amount double precision,
    sales_quantity character varying,
    "integer" character varying,
    cost double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE business_group_sales OWNER TO faviovelez;

--
-- Name: business_group_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE business_group_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE business_group_sales_id_seq OWNER TO faviovelez;

--
-- Name: business_group_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE business_group_sales_id_seq OWNED BY business_group_sales.id;


--
-- Name: business_groups; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE business_groups (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    business_group_type character varying
);


ALTER TABLE business_groups OWNER TO faviovelez;

--
-- Name: business_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE business_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE business_groups_id_seq OWNER TO faviovelez;

--
-- Name: business_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE business_groups_id_seq OWNED BY business_groups.id;


--
-- Name: business_groups_suppliers; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE business_groups_suppliers (
    id integer NOT NULL,
    business_group_id integer,
    supplier_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE business_groups_suppliers OWNER TO faviovelez;

--
-- Name: business_groups_suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE business_groups_suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE business_groups_suppliers_id_seq OWNER TO faviovelez;

--
-- Name: business_groups_suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE business_groups_suppliers_id_seq OWNED BY business_groups_suppliers.id;


--
-- Name: business_unit_sales; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE business_unit_sales (
    id integer NOT NULL,
    business_unit_id integer,
    sales_amount double precision,
    sales_quantity integer,
    cost double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    month integer,
    year integer
);


ALTER TABLE business_unit_sales OWNER TO faviovelez;

--
-- Name: business_unit_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE business_unit_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE business_unit_sales_id_seq OWNER TO faviovelez;

--
-- Name: business_unit_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE business_unit_sales_id_seq OWNED BY business_unit_sales.id;


--
-- Name: business_units; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE business_units (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    business_group_id integer,
    billing_address_id integer
);


ALTER TABLE business_units OWNER TO faviovelez;

--
-- Name: business_units_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE business_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE business_units_id_seq OWNER TO faviovelez;

--
-- Name: business_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE business_units_id_seq OWNED BY business_units.id;


--
-- Name: carriers; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE carriers (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    delivery_address_id integer
);


ALTER TABLE carriers OWNER TO faviovelez;

--
-- Name: carriers_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE carriers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE carriers_id_seq OWNER TO faviovelez;

--
-- Name: carriers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE carriers_id_seq OWNED BY carriers.id;


--
-- Name: cost_types; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE cost_types (
    id integer NOT NULL,
    warehouse_cost_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying
);


ALTER TABLE cost_types OWNER TO faviovelez;

--
-- Name: cost_types_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE cost_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cost_types_id_seq OWNER TO faviovelez;

--
-- Name: cost_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE cost_types_id_seq OWNED BY cost_types.id;


--
-- Name: delivery_addresses; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE delivery_addresses (
    id integer NOT NULL,
    street character varying,
    exterior_number character varying,
    interior_number character varying,
    zipcode character varying,
    neighborhood character varying,
    city character varying,
    state character varying,
    country character varying,
    type_of_address character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional_references text,
    name character varying
);


ALTER TABLE delivery_addresses OWNER TO faviovelez;

--
-- Name: delivery_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE delivery_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE delivery_addresses_id_seq OWNER TO faviovelez;

--
-- Name: delivery_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE delivery_addresses_id_seq OWNED BY delivery_addresses.id;


--
-- Name: delivery_attempts; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE delivery_attempts (
    id integer NOT NULL,
    product_request_id integer,
    order_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    movement_id integer
);


ALTER TABLE delivery_attempts OWNER TO faviovelez;

--
-- Name: delivery_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE delivery_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE delivery_attempts_id_seq OWNER TO faviovelez;

--
-- Name: delivery_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE delivery_attempts_id_seq OWNED BY delivery_attempts.id;


--
-- Name: delivery_packages; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE delivery_packages (
    id integer NOT NULL,
    length double precision,
    width double precision,
    height double precision,
    weight double precision,
    order_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    delivery_attempt_id integer
);


ALTER TABLE delivery_packages OWNER TO faviovelez;

--
-- Name: delivery_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE delivery_packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE delivery_packages_id_seq OWNER TO faviovelez;

--
-- Name: delivery_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE delivery_packages_id_seq OWNED BY delivery_packages.id;


--
-- Name: design_costs; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE design_costs (
    id integer NOT NULL,
    complexity character varying,
    cost double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE design_costs OWNER TO faviovelez;

--
-- Name: design_costs_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE design_costs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE design_costs_id_seq OWNER TO faviovelez;

--
-- Name: design_costs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE design_costs_id_seq OWNED BY design_costs.id;


--
-- Name: design_request_users; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE design_request_users (
    id integer NOT NULL,
    design_request_id integer,
    user_id integer
);


ALTER TABLE design_request_users OWNER TO faviovelez;

--
-- Name: design_request_users_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE design_request_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE design_request_users_id_seq OWNER TO faviovelez;

--
-- Name: design_request_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE design_request_users_id_seq OWNED BY design_request_users.id;


--
-- Name: design_requests; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE design_requests (
    id integer NOT NULL,
    design_type character varying,
    cost double precision,
    status character varying,
    authorisation boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    request_id integer,
    description text,
    attachment character varying,
    notes text
);


ALTER TABLE design_requests OWNER TO faviovelez;

--
-- Name: design_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE design_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE design_requests_id_seq OWNER TO faviovelez;

--
-- Name: design_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE design_requests_id_seq OWNED BY design_requests.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE documents (
    id integer NOT NULL,
    request_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    document_type character varying,
    design_request_id integer,
    document character varying
);


ALTER TABLE documents OWNER TO faviovelez;

--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE documents_id_seq OWNER TO faviovelez;

--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE documents_id_seq OWNED BY documents.id;


--
-- Name: expenses; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE expenses (
    id integer NOT NULL,
    subtotal double precision,
    taxes_rate double precision,
    total double precision,
    store_id integer,
    business_unit_id integer,
    user_id integer,
    bill_received_id integer,
    month integer,
    year integer,
    expense_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE expenses OWNER TO faviovelez;

--
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE expenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE expenses_id_seq OWNER TO faviovelez;

--
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE expenses_id_seq OWNED BY expenses.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE images (
    id integer NOT NULL,
    image character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    product_id integer
);


ALTER TABLE images OWNER TO faviovelez;

--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE images_id_seq OWNER TO faviovelez;

--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE images_id_seq OWNED BY images.id;


--
-- Name: inventories; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE inventories (
    id integer NOT NULL,
    product_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    quantity integer DEFAULT 0,
    unique_code character varying,
    alert boolean
);


ALTER TABLE inventories OWNER TO faviovelez;

--
-- Name: inventories_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE inventories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventories_id_seq OWNER TO faviovelez;

--
-- Name: inventories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE inventories_id_seq OWNED BY inventories.id;


--
-- Name: inventory_configurations; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE inventory_configurations (
    id integer NOT NULL,
    business_unit_id integer,
    reorder_point double precision DEFAULT 0.5,
    critical_point double precision DEFAULT 0.25,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    months_in_inventory integer DEFAULT 3,
    store_id integer
);


ALTER TABLE inventory_configurations OWNER TO faviovelez;

--
-- Name: inventory_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE inventory_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inventory_configurations_id_seq OWNER TO faviovelez;

--
-- Name: inventory_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE inventory_configurations_id_seq OWNED BY inventory_configurations.id;


--
-- Name: movements; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE movements (
    id integer NOT NULL,
    product_id integer,
    quantity integer,
    movement_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    order_id integer,
    user_id integer,
    cost double precision,
    unique_code character varying,
    store_id integer,
    initial_price double precision,
    supplier_id integer,
    business_unit_id integer,
    prospect_id integer,
    bill_id integer,
    product_request_id integer,
    maximum_date date,
    delivery_package_id integer,
    confirm boolean DEFAULT false,
    discount_applied double precision,
    final_price double precision
);


ALTER TABLE movements OWNER TO faviovelez;

--
-- Name: movements_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE movements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE movements_id_seq OWNER TO faviovelez;

--
-- Name: movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE movements_id_seq OWNED BY movements.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE orders (
    id integer NOT NULL,
    status character varying,
    delivery_address_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    category character varying,
    prospect_id integer,
    request_id integer,
    billing_address_id integer,
    carrier_id integer,
    store_id integer,
    confirm boolean,
    delivery_notes text
);


ALTER TABLE orders OWNER TO faviovelez;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE orders_id_seq OWNER TO faviovelez;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- Name: orders_users; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE orders_users (
    id integer NOT NULL,
    order_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE orders_users OWNER TO faviovelez;

--
-- Name: orders_users_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE orders_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE orders_users_id_seq OWNER TO faviovelez;

--
-- Name: orders_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE orders_users_id_seq OWNED BY orders_users.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE payments (
    id integer NOT NULL,
    payment_date date,
    amount double precision,
    bill_received_id integer,
    supplier_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE payments OWNER TO faviovelez;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payments_id_seq OWNER TO faviovelez;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE payments_id_seq OWNED BY payments.id;


--
-- Name: pending_movements; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE pending_movements (
    id integer NOT NULL,
    product_id integer,
    quantity integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    order_id integer,
    cost double precision,
    unique_code character varying,
    store_id integer,
    initial_price double precision,
    supplier_id integer,
    movement_type character varying,
    user_id integer,
    business_unit_id integer,
    prospect_id integer,
    bill_id integer,
    product_request_id integer,
    maximum_date date,
    discount_applied double precision,
    final_price double precision
);


ALTER TABLE pending_movements OWNER TO faviovelez;

--
-- Name: pending_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE pending_movements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pending_movements_id_seq OWNER TO faviovelez;

--
-- Name: pending_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE pending_movements_id_seq OWNED BY pending_movements.id;


--
-- Name: product_requests; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE product_requests (
    id integer NOT NULL,
    product_id integer,
    quantity integer,
    status character varying,
    order_id integer,
    urgency_level character varying,
    maximum_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    delivery_package_id integer
);


ALTER TABLE product_requests OWNER TO faviovelez;

--
-- Name: product_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE product_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_requests_id_seq OWNER TO faviovelez;

--
-- Name: product_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE product_requests_id_seq OWNED BY product_requests.id;


--
-- Name: product_sales; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE product_sales (
    id integer NOT NULL,
    sales_amount double precision,
    sales_quantity integer,
    cost double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    product_id integer,
    month integer,
    year integer
);


ALTER TABLE product_sales OWNER TO faviovelez;

--
-- Name: product_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE product_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_sales_id_seq OWNER TO faviovelez;

--
-- Name: product_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE product_sales_id_seq OWNED BY product_sales.id;


--
-- Name: production_orders; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE production_orders (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status character varying
);


ALTER TABLE production_orders OWNER TO faviovelez;

--
-- Name: production_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE production_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production_orders_id_seq OWNER TO faviovelez;

--
-- Name: production_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE production_orders_id_seq OWNED BY production_orders.id;


--
-- Name: production_requests; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE production_requests (
    id integer NOT NULL,
    product_id integer,
    quantity integer,
    status character varying,
    production_order_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE production_requests OWNER TO faviovelez;

--
-- Name: production_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE production_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE production_requests_id_seq OWNER TO faviovelez;

--
-- Name: production_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE production_requests_id_seq OWNED BY production_requests.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE products (
    id integer NOT NULL,
    former_code character varying,
    unique_code character varying,
    description character varying,
    product_type character varying,
    exterior_material_color character varying,
    interior_material_color character varying,
    impression boolean,
    exterior_color_or_design character varying,
    main_material character varying,
    resistance_main_material character varying,
    inner_length double precision,
    inner_width double precision,
    inner_height double precision,
    outer_length double precision,
    outer_width double precision,
    outer_height double precision,
    design_type character varying,
    number_of_pieces integer DEFAULT 1,
    accesories_kit character varying DEFAULT 'ninguno'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    price double precision,
    bag_length double precision,
    bag_width double precision,
    bag_height double precision,
    exhibitor_height double precision,
    tray_quantity integer,
    tray_length double precision,
    tray_width double precision,
    tray_divisions integer,
    classification character varying,
    line character varying,
    image character varying,
    pieces_per_package integer DEFAULT 1,
    business_unit_id integer,
    warehouse_id integer,
    cost double precision,
    rack character varying,
    level character varying
);


ALTER TABLE products OWNER TO faviovelez;

--
-- Name: products_bills; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE products_bills (
    id integer NOT NULL,
    product_id integer,
    bill_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE products_bills OWNER TO faviovelez;

--
-- Name: products_bills_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE products_bills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE products_bills_id_seq OWNER TO faviovelez;

--
-- Name: products_bills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE products_bills_id_seq OWNED BY products_bills.id;


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE products_id_seq OWNER TO faviovelez;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: prospect_sales; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE prospect_sales (
    id integer NOT NULL,
    prospect_id integer,
    sales_amount double precision,
    sales_quantity integer,
    cost double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    month integer,
    year integer
);


ALTER TABLE prospect_sales OWNER TO faviovelez;

--
-- Name: prospect_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE prospect_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prospect_sales_id_seq OWNER TO faviovelez;

--
-- Name: prospect_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE prospect_sales_id_seq OWNED BY prospect_sales.id;


--
-- Name: prospects; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE prospects (
    id integer NOT NULL,
    store_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    prospect_type character varying,
    contact_first_name character varying,
    contact_middle_name character varying,
    contact_last_name character varying,
    contact_position character varying,
    direct_phone character varying,
    extension character varying,
    cell_phone character varying,
    business_type character varying,
    prospect_status character varying,
    legal_or_business_name character varying,
    billing_address_id integer,
    delivery_address_id integer,
    second_last_name character varying,
    business_unit_id integer,
    email character varying,
    business_group_id integer,
    store_code character varying
);


ALTER TABLE prospects OWNER TO faviovelez;

--
-- Name: prospects_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE prospects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prospects_id_seq OWNER TO faviovelez;

--
-- Name: prospects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE prospects_id_seq OWNED BY prospects.id;


--
-- Name: request_users; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE request_users (
    id integer NOT NULL,
    request_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE request_users OWNER TO faviovelez;

--
-- Name: request_users_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE request_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE request_users_id_seq OWNER TO faviovelez;

--
-- Name: request_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE request_users_id_seq OWNED BY request_users.id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE requests (
    id integer NOT NULL,
    product_type character varying,
    product_what character varying,
    product_length double precision,
    product_width double precision,
    product_height double precision,
    product_weight double precision,
    for_what character varying,
    quantity integer,
    inner_length double precision,
    inner_width double precision,
    inner_height character varying,
    outer_length double precision,
    outer_width double precision,
    outer_height double precision,
    bag_length double precision,
    bag_width double precision,
    bag_height double precision,
    main_material character varying,
    resistance_main_material character varying,
    secondary_material character varying,
    resistance_secondary_material character varying,
    third_material character varying,
    resistance_third_material character varying,
    impression character varying,
    inks integer,
    impression_finishing character varying,
    delivery_date date,
    maximum_sales_price double precision,
    observations text,
    notes text,
    prospect_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    final_quantity integer,
    payment_uploaded boolean,
    authorisation_signed boolean,
    date_finished date,
    internal_cost double precision,
    internal_price double precision,
    sales_price double precision,
    impression_where character varying,
    design_like character varying,
    resistance_like character varying,
    rigid_color character varying,
    paper_type_rigid character varying,
    store_id integer,
    require_design boolean,
    exterior_material_color character varying,
    interior_material_color character varying,
    status character varying,
    exhibitor_height double precision,
    tray_quantity integer,
    tray_length double precision,
    tray_width double precision,
    tray_divisions integer,
    name_type character varying,
    contraencolado boolean,
    authorised_without_doc boolean,
    how_many character varying,
    authorised_without_pay boolean,
    boxes_stow character varying,
    specification character varying,
    what_measures character varying,
    specification_document boolean,
    sensitive_fields_changed boolean,
    payment character varying,
    authorisation character varying,
    authorised boolean,
    last_status character varying,
    product_id integer
);


ALTER TABLE requests OWNER TO faviovelez;

--
-- Name: requests_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE requests_id_seq OWNER TO faviovelez;

--
-- Name: requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE requests_id_seq OWNED BY requests.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    translation character varying
);


ALTER TABLE roles OWNER TO faviovelez;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE roles_id_seq OWNER TO faviovelez;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE schema_migrations OWNER TO faviovelez;

--
-- Name: store_sales; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE store_sales (
    id integer NOT NULL,
    store_id integer,
    month character varying,
    year character varying,
    sales_amount double precision,
    sales_quantity integer,
    cost double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE store_sales OWNER TO faviovelez;

--
-- Name: store_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE store_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE store_sales_id_seq OWNER TO faviovelez;

--
-- Name: store_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE store_sales_id_seq OWNED BY store_sales.id;


--
-- Name: store_types; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE store_types (
    id integer NOT NULL,
    store_type character varying,
    business_unit_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE store_types OWNER TO faviovelez;

--
-- Name: store_types_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE store_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE store_types_id_seq OWNER TO faviovelez;

--
-- Name: store_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE store_types_id_seq OWNED BY store_types.id;


--
-- Name: stores; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE stores (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    store_code character varying,
    store_name character varying,
    discount double precision,
    delivery_address_id integer,
    business_unit_id integer,
    store_type_id integer,
    email character varying,
    cost_type_id integer,
    cost_type_selected_since date,
    months_in_inventory integer DEFAULT 3,
    reorder_point double precision DEFAULT 50.0,
    critical_point double precision DEFAULT 25.0,
    contact_first_name character varying,
    contact_middle_name character varying,
    contact_last_name character varying,
    direct_phone character varying,
    extension character varying,
    type_of_person character varying,
    prospect_status character varying,
    second_last_name character varying,
    business_group_id integer,
    cell_phone character varying,
    billing_address_id integer
);


ALTER TABLE stores OWNER TO faviovelez;

--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stores_id_seq OWNER TO faviovelez;

--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE stores_id_seq OWNED BY stores.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE suppliers (
    id integer NOT NULL,
    name character varying,
    business_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type_of_person character varying,
    contact_first_name character varying,
    contact_middle_name character varying,
    contact_last_name character varying,
    contact_position character varying,
    direct_phone character varying,
    extension character varying,
    cell_phone character varying,
    email character varying,
    supplier_status character varying,
    delivery_address_id integer,
    last_purchase_bill_date date,
    last_purhcase_folio character varying,
    store_id integer
);


ALTER TABLE suppliers OWNER TO faviovelez;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE suppliers_id_seq OWNER TO faviovelez;

--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE suppliers_id_seq OWNED BY suppliers.id;


--
-- Name: user_requests; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE user_requests (
    id integer NOT NULL,
    user_id integer,
    request_id integer
);


ALTER TABLE user_requests OWNER TO faviovelez;

--
-- Name: user_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE user_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_requests_id_seq OWNER TO faviovelez;

--
-- Name: user_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE user_requests_id_seq OWNED BY user_requests.id;


--
-- Name: user_sales; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE user_sales (
    id integer NOT NULL,
    user_id integer,
    month character varying,
    year character varying,
    sales_amount double precision,
    sales_quantity integer,
    cost double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE user_sales OWNER TO faviovelez;

--
-- Name: user_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE user_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_sales_id_seq OWNER TO faviovelez;

--
-- Name: user_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE user_sales_id_seq OWNED BY user_sales.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying,
    middle_name character varying,
    last_name character varying,
    store_id integer,
    role_id integer
);


ALTER TABLE users OWNER TO faviovelez;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO faviovelez;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: warehouse_entries; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE warehouse_entries (
    id integer NOT NULL,
    product_id integer,
    quantity integer,
    entry_number integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    movement_id integer
);


ALTER TABLE warehouse_entries OWNER TO faviovelez;

--
-- Name: warehouse_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE warehouse_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE warehouse_entries_id_seq OWNER TO faviovelez;

--
-- Name: warehouse_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE warehouse_entries_id_seq OWNED BY warehouse_entries.id;


--
-- Name: warehouses; Type: TABLE; Schema: public; Owner: faviovelez
--

CREATE TABLE warehouses (
    id integer NOT NULL,
    name character varying,
    delivery_address_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    business_unit_id integer,
    store_id integer,
    warehouse_code character varying,
    business_group_id integer
);


ALTER TABLE warehouses OWNER TO faviovelez;

--
-- Name: warehouses_id_seq; Type: SEQUENCE; Schema: public; Owner: faviovelez
--

CREATE SEQUENCE warehouses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE warehouses_id_seq OWNER TO faviovelez;

--
-- Name: warehouses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: faviovelez
--

ALTER SEQUENCE warehouses_id_seq OWNED BY warehouses.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY additional_discounts ALTER COLUMN id SET DEFAULT nextval('additional_discounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bill_receiveds ALTER COLUMN id SET DEFAULT nextval('bill_receiveds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY billing_addresses ALTER COLUMN id SET DEFAULT nextval('billing_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bills ALTER COLUMN id SET DEFAULT nextval('bills_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_group_sales ALTER COLUMN id SET DEFAULT nextval('business_group_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_groups ALTER COLUMN id SET DEFAULT nextval('business_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_groups_suppliers ALTER COLUMN id SET DEFAULT nextval('business_groups_suppliers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_unit_sales ALTER COLUMN id SET DEFAULT nextval('business_unit_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_units ALTER COLUMN id SET DEFAULT nextval('business_units_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY carriers ALTER COLUMN id SET DEFAULT nextval('carriers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY cost_types ALTER COLUMN id SET DEFAULT nextval('cost_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY delivery_addresses ALTER COLUMN id SET DEFAULT nextval('delivery_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY delivery_attempts ALTER COLUMN id SET DEFAULT nextval('delivery_attempts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY delivery_packages ALTER COLUMN id SET DEFAULT nextval('delivery_packages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY design_costs ALTER COLUMN id SET DEFAULT nextval('design_costs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY design_request_users ALTER COLUMN id SET DEFAULT nextval('design_request_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY design_requests ALTER COLUMN id SET DEFAULT nextval('design_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY documents ALTER COLUMN id SET DEFAULT nextval('documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY expenses ALTER COLUMN id SET DEFAULT nextval('expenses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY images ALTER COLUMN id SET DEFAULT nextval('images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY inventories ALTER COLUMN id SET DEFAULT nextval('inventories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY inventory_configurations ALTER COLUMN id SET DEFAULT nextval('inventory_configurations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements ALTER COLUMN id SET DEFAULT nextval('movements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders_users ALTER COLUMN id SET DEFAULT nextval('orders_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY payments ALTER COLUMN id SET DEFAULT nextval('payments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY pending_movements ALTER COLUMN id SET DEFAULT nextval('pending_movements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY product_requests ALTER COLUMN id SET DEFAULT nextval('product_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY product_sales ALTER COLUMN id SET DEFAULT nextval('product_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY production_orders ALTER COLUMN id SET DEFAULT nextval('production_orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY production_requests ALTER COLUMN id SET DEFAULT nextval('production_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY products_bills ALTER COLUMN id SET DEFAULT nextval('products_bills_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY prospect_sales ALTER COLUMN id SET DEFAULT nextval('prospect_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY prospects ALTER COLUMN id SET DEFAULT nextval('prospects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY request_users ALTER COLUMN id SET DEFAULT nextval('request_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY requests ALTER COLUMN id SET DEFAULT nextval('requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY store_sales ALTER COLUMN id SET DEFAULT nextval('store_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY store_types ALTER COLUMN id SET DEFAULT nextval('store_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY stores ALTER COLUMN id SET DEFAULT nextval('stores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY suppliers ALTER COLUMN id SET DEFAULT nextval('suppliers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY user_requests ALTER COLUMN id SET DEFAULT nextval('user_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY user_sales ALTER COLUMN id SET DEFAULT nextval('user_sales_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY warehouse_entries ALTER COLUMN id SET DEFAULT nextval('warehouse_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY warehouses ALTER COLUMN id SET DEFAULT nextval('warehouses_id_seq'::regclass);


--
-- Data for Name: additional_discounts; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY additional_discounts (id, type_of_discount, percentage, created_at, updated_at) FROM stdin;
\.


--
-- Name: additional_discounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('additional_discounts_id_seq', 1, true);


--
-- Data for Name: bill_receiveds; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY bill_receiveds (id, folio, date_of_bill, subtotal, taxes_rate, taxes, total_amount, supplier_id, product_id, payment_day, payment_complete, payment_on_time, created_at, updated_at, business_unit_id, store_id) FROM stdin;
1	2458	2017-08-02	789	16	126.240000000000009	915.239999999999895	100	1	\N	\N	\N	2017-08-11 16:29:19.310151	2017-08-11 16:29:19.310151	\N	\N
2	12345	2017-08-17	1000	16	160	1160	81	18	\N	\N	\N	2017-08-11 16:42:13.828474	2017-08-11 16:42:13.828474	\N	\N
3	150	2017-09-18	45.6799999999999997	16	7.30879999999999974	52.9887999999999977	81	3	\N	\N	\N	2017-08-12 16:43:28.753445	2017-08-12 16:43:28.753445	\N	\N
4	150	2017-10-20	500.199999999999989	16	80.0319999999999965	580.231999999999971	37	18	\N	\N	\N	2017-08-12 16:43:28.851138	2017-08-12 16:43:28.851138	\N	\N
\.


--
-- Name: bill_receiveds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('bill_receiveds_id_seq', 4, true);


--
-- Data for Name: billing_addresses; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY billing_addresses (id, type_of_person, business_name, rfc, street, exterior_number, interior_number, zipcode, neighborhood, city, state, country, created_at, updated_at) FROM stdin;
1	persona física	Diseños de Carton SA de CV	VEMF8310119M7	Tintoreros	40	2	45030	chapalita inn	zapopan	jalisco	mexico	2017-06-22 17:07:39.276048	2017-06-22 17:07:39.276048
2	persona física	Diseños de Carton SA de CV	VEMF8310119M7	Tintoreros	40	2	45030	chapalita inn	zapopan	jalisco	mexico	2017-06-22 17:16:38.673561	2017-06-22 17:16:38.673561
3	persona física	Diseños de Carton SA de CV	VEMF8310119M7	Tintoreros	40	2	45030	chapalita inn	zapopan	jalisco	México	2017-06-22 17:35:12.262598	2017-06-22 17:35:12.262598
4	persona física	Diseños de Carton SA de CV	VEMF8310119M7	Tintoreros	40	2	45030	chapalita inn	zapopan	jalisco	México	2017-06-22 17:37:34.221782	2017-06-22 17:37:34.221782
5	persona física	Diseños de Carton SA de CV	VEMF8310119M7	Tintoreros	40	2	45030	chapalita inn	zapopan	jalisco	México	2017-06-22 17:37:42.948369	2017-06-22 17:37:42.948369
6	persona física	Diseños de Carton SA de CV	VEMF8310119M7	Tintoreros	40	2	45030	chapalita inn	zapopan	jalisco	México	2017-06-22 17:38:04.751418	2017-06-22 17:38:04.751418
7	persona física	Diseños de Carton SA de CV	VEMF8310119M7	Tintoreros	40	2	45030	chapalita inn	zapopan	jalisco	México	2017-06-22 17:41:12.072463	2017-06-22 17:41:12.072463
8	persona física	diseños uno	VEMF8310119M7	Tintoreros 40, Chapalita Inn	40	2	45010	chapalita inn	Zapopan Jalisco	Jalisco	México	2017-06-22 17:52:03.686923	2017-06-22 17:52:03.686923
9	persona moral	Diseños de Carton SA de CV	VEMF8310119M7	Tintoreros 40, Chapalita Inn			45030		zapopan	jalisco	México	2017-06-22 17:55:13.684645	2017-06-22 17:55:13.684645
10	persona física	favio velez	VEMF8310119M7	aadadad, colonia	12	1	1234	colonia	zapopan	jalisco	México	2017-07-02 21:43:47.523596	2017-07-02 21:43:47.523596
11	persona física	juan perez	VEMF8310119M7	tintoreria	123	1	1234	colonia	zapopan	jalisco	mexico	2017-07-03 19:04:02.360983	2017-07-03 19:04:02.360983
12	persona física	FAVIO VELEZ MORALES	VEMF8310119M7	AV. UNIVERSIDAD	701	2	20130	FATIMA	AGUASCALIENTES	AGUASCALIENTES	MÉXICO	2017-08-04 02:49:32.336043	2017-08-04 02:49:32.336043
13	persona moral	Comercializadora Diseños de Cartón S.A. de C.V.	CODI890202123	Compresor	805	45	12345	El Álamo Industrial	Guadalajara	Jalisco	México	2017-08-12 18:39:25.347948	2017-08-12 18:39:25.347948
14	persona moral	Diseños de Carton SA de CV	DISE990609PRQ	Tintoreros 	50	2	45030	Chapalita Inn	zapopan	jalisco	México	2017-08-12 18:42:04.864395	2017-08-12 18:42:04.864395
15	persona física	FAVIO VELEZ MORALES	VEMF8310119M7	AV. UNIVERSIDAD	701	2	20130	FATIMA	AGUASCALIENTES	AGS	México	2017-08-12 19:52:41.572898	2017-08-19 17:44:38.211124
16	persona moral	diseños uno	CODI890202123	Tintoreros 40, Chapalita Inn	40	2	45010	FATIMA	Zapopan Jalisco	Jalisco	México	2017-08-19 18:06:34.395462	2017-08-19 18:06:34.395462
17	persona física	FAVIO VELEZ MORALES	VEMF8310119M7	AV. UNIVERSIDAD	40	2	20130	colonia	AGUASCALIENTES	AGUASCALIENTES	México	2017-08-19 18:09:19.46414	2017-08-19 18:09:19.46414
18	persona física	Queretaro Diseños	DISE990609PRQ	Av. Pablo Neruda	701	3	45060	tintoreria	Zapopan Jalisco	Jalisco	México	2017-08-19 18:11:14.323155	2017-08-19 18:11:14.323155
19	persona física	Querétaro Diseños Cartón SA DE CV	CODI890202123	AV. UNIVERSIDAD	123	45	45060	tintoreria	AGUASCALIENTES	AGUASCALIENTES	México	2017-08-19 18:12:24.047947	2017-08-19 18:12:24.047947
20	persona moral	Mi razon social SA de CV	CODI890202123	AV. UNIVERSIDAD	12	2	20130	tintoreria	AGUASCALIENTES	AGUASCALIENTES	México	2017-08-19 18:56:20.956211	2017-08-19 18:56:20.956211
\.


--
-- Name: billing_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('billing_addresses_id_seq', 20, true);


--
-- Data for Name: bills; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY bills (id, status, order_id, initial_price, discount_applied, additional_discount_applied, price_before_taxes, created_at, updated_at, type_of_bill, prospect_id, classification, amount, quantity, pdf, xml, issuing_company_id, receiving_company_id, business_unit_id, store_id) FROM stdin;
1	\N	23	100	20	\N	80	2017-09-01 02:20:29.745307	2017-09-01 02:20:29.745307	venta	\N	\N	92.7999999999999972	870	\N	\N	\N	\N	\N	\N
2	emitida	24	200	10	\N	180	2017-09-05 19:23:13.325315	2017-09-05 19:23:13.325315	venta	\N	\N	208.800000000000011	100	\N	\N	17	20	\N	\N
\.


--
-- Name: bills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('bills_id_seq', 2, true);


--
-- Data for Name: business_group_sales; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY business_group_sales (id, business_group_id, month, year, sales_amount, sales_quantity, "integer", cost, created_at, updated_at) FROM stdin;
1	2	8	2017	0	100	\N	0	2017-08-18 21:50:42.724124	2017-08-18 21:50:42.902569
2	2	9	2017	0	20	\N	0	2017-09-10 19:59:43.436295	2017-09-11 00:56:12.780055
\.


--
-- Name: business_group_sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('business_group_sales_id_seq', 2, true);


--
-- Data for Name: business_groups; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY business_groups (id, name, created_at, updated_at, business_group_type) FROM stdin;
2	Aguascalientes	2017-07-30 22:53:17.861286	2017-07-30 22:53:17.861286	\N
3	default terceros	2017-07-31 15:13:14.464555	2017-07-31 15:13:14.464555	\N
1	Diseños de Cartón	2017-07-30 22:53:11.319225	2017-08-12 20:30:40.499774	main
4	Nuevo Grupo	2017-08-19 18:46:24.547072	2017-08-19 18:46:24.547072	\N
5	Nueva franquicia	2017-08-26 18:47:09.138073	2017-08-26 18:47:09.138073	\N
\.


--
-- Name: business_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('business_groups_id_seq', 5, true);


--
-- Data for Name: business_groups_suppliers; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY business_groups_suppliers (id, business_group_id, supplier_id, created_at, updated_at) FROM stdin;
1	2	104	2017-08-17 15:49:08.194743	2017-08-17 15:49:08.194743
\.


--
-- Name: business_groups_suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('business_groups_suppliers_id_seq', 1, true);


--
-- Data for Name: business_unit_sales; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY business_unit_sales (id, business_unit_id, sales_amount, sales_quantity, cost, created_at, updated_at, month, year) FROM stdin;
1	2	0	100	0	2017-08-18 21:50:42.684146	2017-08-18 21:50:42.894675	8	2017
2	2	0	20	0	2017-09-10 19:59:43.355303	2017-09-11 00:56:12.684037	9	2017
\.


--
-- Name: business_unit_sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('business_unit_sales_id_seq', 2, true);


--
-- Data for Name: business_units; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY business_units (id, name, created_at, updated_at, business_group_id, billing_address_id) FROM stdin;
5	Comercializadora Diseños de Cartón	2017-07-30 22:54:24.352042	2017-08-12 18:39:25.497741	1	13
1	Diseños de Cartón	2017-07-26 18:09:10.389358	2017-08-12 18:42:04.868149	1	14
2	Aguascalientes	2017-07-26 18:09:21.638129	2017-08-12 19:52:41.577022	2	15
3	Querétaro	2017-07-26 18:09:31.709918	2017-08-13 21:00:01.463524	3	\N
4	Juan Perez	2017-07-26 18:09:44.081757	2017-08-13 21:00:17.62994	3	\N
6	default terceros	2017-07-31 15:14:17.769469	2017-08-19 18:12:42.324586	3	19
7	Nueva empresa	2017-08-19 18:26:23.097451	2017-08-19 18:26:23.097451	3	\N
8	Otra mas	2017-08-19 18:37:16.503587	2017-08-19 18:37:16.503587	2	\N
9	La unica del nuevo	2017-08-19 18:46:59.982263	2017-08-19 18:56:52.105238	4	20
10	Nueva franquicia	2017-08-26 18:47:21.009642	2017-08-26 18:47:21.009642	5	\N
\.


--
-- Name: business_units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('business_units_id_seq', 10, true);


--
-- Data for Name: carriers; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY carriers (id, name, created_at, updated_at, delivery_address_id) FROM stdin;
\.


--
-- Name: carriers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('carriers_id_seq', 1, false);


--
-- Data for Name: cost_types; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY cost_types (id, warehouse_cost_type, created_at, updated_at, description) FROM stdin;
1	PEPS	2017-07-26 00:28:13.845125	2017-08-16 00:52:58.327636	Primeras entradas, primeras salidas
2	UEPS	2017-07-31 00:46:06.528816	2017-08-16 00:53:18.281426	Últimas entradas, primeras salidas
\.


--
-- Name: cost_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('cost_types_id_seq', 2, true);


--
-- Data for Name: delivery_addresses; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY delivery_addresses (id, street, exterior_number, interior_number, zipcode, neighborhood, city, state, country, type_of_address, created_at, updated_at, additional_references, name) FROM stdin;
1	tintoreria	45	2	45030	chapalita	zapopan	jalisco	mexico	\N	2017-06-21 21:56:58.427203	2017-06-21 21:56:58.427203	ninguna	\N
2	tintoreria	45	2	45030	chapalita	zapopan	jalisco	México	\N	2017-06-21 22:04:31.407837	2017-06-21 22:04:31.407837	ninguna	\N
3	tintoreria	45	2	45030	chapalita	zapopan	jalisco	México	\N	2017-06-21 22:07:05.268583	2017-06-21 22:07:05.268583	ninguna	\N
4	tintoreria	45	2	45030	chapalita	zapopan	jalisco	México	\N	2017-06-21 22:07:37.185136	2017-06-21 22:07:37.185136	ninguna	\N
5	tintoreria	45	2	45030	chapalita	zapopan	jalisco	México	\N	2017-06-21 22:14:39.468608	2017-06-21 22:14:39.468608	ninguna	\N
6	calle 3	45	2	45030	chapalita	zapopan	jalisco	México	\N	2017-06-21 22:16:34.570653	2017-06-21 22:16:34.570653	ninguna	\N
7	calle 3	4	2	45030	chapalita	zapopan	jalisco	México	\N	2017-06-21 22:48:45.708851	2017-06-21 22:53:33.093256	ningunassss	\N
8	calle 3	4	2	45030	chapalita	zapopan	jalisco	México	\N	2017-06-21 22:53:33.097184	2017-06-22 16:14:03.98514	ningunassss	\N
9	la nueva	123	321	45010	cual colonia	cual ciudad	cual estado	cual pais	\N	2017-06-22 16:26:46.505539	2017-06-22 16:26:46.505539	ninguna	\N
10	la nueva	123	321	45010	cual colonia	cual ciudad	cual estado	cual pais	\N	2017-06-22 16:27:24.03108	2017-06-22 16:27:24.03108	ninguna	\N
11	una calle	1	2	1234	chapalita	zapopan	jalisco	mex	\N	2017-06-22 16:36:24.408485	2017-06-22 16:36:24.408485	dnaisodnaoi	\N
12	Tintoreros 40	45	2	45010	chapalita	Zapopan Jalisco	Jalisco	México	\N	2017-06-22 17:54:57.185173	2017-06-22 17:54:57.185173	dasdas	\N
13	AV. UNIVERSIDAD	701	2	20130	FATIMA	AGUASCALIENTES	AGUASCALIENTES	México	\N	2017-08-04 03:27:02.297006	2017-08-04 03:27:02.297006	AL LADO DE LA FARMACIA	\N
14	AV. UNIVERSIDAD	701	2	20130	FATIMA	AGUASCALIENTES	AGUASCALIENTES	México	\N	2017-08-04 03:30:43.95595	2017-08-04 03:30:43.95595	AL LADO DE LA FARMACIA	\N
15	AV. UNIVERSIDAD	701	2	20130	FATIMA	AGUASCALIENTES	AGUASCALIENTES	México	\N	2017-08-04 03:32:18.283336	2017-08-04 03:32:18.283336	AL LADO DE LA FARMACIA	\N
16	AV. UNIVERSIDAD	701	2	20130	FATIMA	AGUASCALIENTES	AGUASCALIENTES	México	\N	2017-08-04 03:34:45.065429	2017-08-05 00:05:50.181899	AL LADO DE LA FARMACIA GUADALAJARA	\N
17	AV. UNIVERSIDAD	701	2	20130	FATIMA	AGUASCALIENTES	AGUASCALIENTES	México	\N	2017-08-11 19:27:59.316845	2017-08-11 19:27:59.316845	AL LADO DE LA FARMACIA GUADALAJARA	\N
18	Av. Pablo Neruda	104	2	45060	Providencia	Zapopan	Jalisco	México	\N	2017-08-17 22:25:31.724906	2017-08-17 22:25:31.724906	Casa color blanco	\N
19	AV. UNIVERSIDAD	123	321	20130	chapalita	AGUASCALIENTES	AGUASCALIENTES	México	\N	2017-08-19 18:13:23.661697	2017-08-19 18:13:23.661697	HOla como estas	\N
20	Calle prueba	123	44prueba	45010	prueba	Zapopan Jalisco	Jalisco	México	\N	2017-08-19 18:21:01.662226	2017-08-19 18:21:01.662226	prueba	\N
21	Av. Siempre Viva	1234	1	45789	Barrio Nuevo	Springfield	Nuevo León	México	\N	2017-08-19 18:29:48.060071	2017-08-19 18:29:48.060071	Simpsons	\N
22	Av. Siempre Viva	123	2	45789	cual colonia	Springfield	Nuevo León	México	\N	2017-08-19 18:32:08.615216	2017-08-19 18:32:08.615216	Simpsons	\N
23	Av. Siempre Viva	123	2	45789	cual colonia	Springfield	Nuevo León	México	\N	2017-08-19 18:35:36.473641	2017-08-19 18:35:36.473641	Simpsons	\N
24	Calle Nueva	1234Nuevo	2Nuevo	45678	Nueva Colonia	Zapopan Jalisco	Jalisco	México	\N	2017-08-19 18:43:50.359131	2017-08-19 18:43:50.359131	HOLAAAAA	\N
25	La ultima	456	7	45612	Ocho	Zapopan Jalisco	Jalisco	México	\N	2017-08-19 18:54:58.029776	2017-08-19 18:54:58.029776	HOLAAAA COMO ESTAS	\N
\.


--
-- Name: delivery_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('delivery_addresses_id_seq', 25, true);


--
-- Data for Name: delivery_attempts; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY delivery_attempts (id, product_request_id, order_id, created_at, updated_at, movement_id) FROM stdin;
\.


--
-- Name: delivery_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('delivery_attempts_id_seq', 1, false);


--
-- Data for Name: delivery_packages; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY delivery_packages (id, length, width, height, weight, order_id, created_at, updated_at, delivery_attempt_id) FROM stdin;
\.


--
-- Name: delivery_packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('delivery_packages_id_seq', 1, false);


--
-- Data for Name: design_costs; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY design_costs (id, complexity, cost, created_at, updated_at) FROM stdin;
1	A1	350	2017-06-30 23:47:18.365876	2017-06-30 23:47:18.365876
2	A2	450	2017-06-30 23:47:23.628478	2017-06-30 23:47:23.628478
3	A3	500	2017-06-30 23:47:29.851484	2017-06-30 23:47:29.851484
4	B1	1000	2017-06-30 23:47:38.880139	2017-06-30 23:47:38.880139
\.


--
-- Name: design_costs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('design_costs_id_seq', 4, true);


--
-- Data for Name: design_request_users; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY design_request_users (id, design_request_id, user_id) FROM stdin;
1	24	9
2	23	3
3	38	9
4	39	9
5	40	9
6	41	9
7	41	3
8	40	3
9	39	3
10	42	9
11	42	3
12	38	3
13	1	3
14	43	1
15	44	1
\.


--
-- Name: design_request_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('design_request_users_id_seq', 15, true);


--
-- Data for Name: design_requests; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY design_requests (id, design_type, cost, status, authorisation, created_at, updated_at, request_id, description, attachment, notes) FROM stdin;
32	printcard	\N	solicitada	\N	2017-07-01 20:28:51.205139	2017-07-01 20:28:52.098393	19	como de que noooo	\N	\N
33	dummy	\N	solicitada	\N	2017-07-02 17:41:35.827448	2017-07-02 17:41:36.01259	20	Por favor hacer un diseño	\N	\N
34	diseño	\N	solicitada	\N	2017-07-02 18:35:46.244534	2017-07-02 18:35:46.267534	23	por favor haz el diseño	\N	\N
35	diseño	\N	solicitada	\N	2017-07-02 18:46:29.442025	2017-07-02 18:46:29.463789	23	hola	\N	\N
36	diseño	\N	solicitada	\N	2017-07-02 18:58:41.291763	2017-07-02 18:58:41.324609	23	hola hola	\N	\N
42	diseño	\N	en proceso	\N	2017-07-15 15:13:37.770152	2017-07-15 15:18:52.541607	94	por favor hagan un diseño	\N	\N
24	seleccione	\N	solicitada	\N	2017-06-30 22:33:02.040912	2017-07-12 19:25:38.415728	19	podrìas diseñar porfa?	\N	\N
37	printcard	350	solicitada	\N	2017-07-04 18:44:05.153272	2017-07-12 21:54:37.587085	25	Por favor hagan un printcard	\N	\N
23	dummy	350	diseño elaborado	\N	2017-06-30 22:27:11.562218	2017-07-12 22:14:27.162987	19	ya diseña	\N	hello
41	printcard	1000	diseño elaborado	\N	2017-07-12 22:23:03.939987	2017-07-12 22:32:19.809971	82	hola	\N	hola 
40	dummy	500	diseño elaborado	\N	2017-07-12 22:21:56.761008	2017-07-13 16:14:40.055326	82	hola yo otra vez	\N	hola, este es tu diseño
39	diseño	1000	diseño elaborado	\N	2017-07-12 22:17:19.245502	2017-07-13 16:51:51.123466	82	Cambialo a rojo	\N	estos son tus diseños 
38	diseño	500	aceptada	\N	2017-07-12 22:16:02.460793	2017-07-15 16:38:56.009272	82	Cambialo a rojo	\N	Quedaron ya los diseños
1	\N	\N	en proceso	\N	2017-06-29 18:46:11.780519	2017-07-29 03:35:37.623477	13	\N	\N	\N
31	dummy	\N	solicitada	\N	2017-06-30 23:42:40.656736	2017-07-01 17:29:34.287487	19	una mas pa los compas	\N	\N
2	\N	\N	solicitada	\N	2017-06-29 18:51:20.654632	2017-07-01 18:49:47.825023	14	\N	\N	\N
3	\N	\N	solicitada	\N	2017-06-29 18:54:04.459367	2017-07-01 18:49:47.836282	15	\N	\N	\N
4	\N	\N	solicitada	\N	2017-06-29 18:55:33.779048	2017-07-01 18:49:47.847993	16	\N	\N	\N
5	\N	\N	solicitada	\N	2017-06-29 19:08:09.631145	2017-07-01 18:49:47.858735	17	\N	\N	\N
6	diseño	\N	solicitada	\N	2017-06-30 18:59:38.33155	2017-07-01 18:49:47.869008	19	Necesito que quede en color azul, está en rojo.	\N	\N
7	diseño	\N	solicitada	\N	2017-06-30 19:02:54.813562	2017-07-01 18:49:47.880673	19	Necesito que quede en color azul, está en rojo.	\N	\N
8	diseño	\N	solicitada	\N	2017-06-30 19:03:13.028646	2017-07-01 18:49:47.891146	19	Ahora quiero que esté en amarillo.	\N	\N
9	printcard	\N	solicitada	\N	2017-06-30 19:18:30.214883	2017-07-01 18:49:47.902252	19	Ya nada, gracias. 	\N	\N
10	dummy	\N	solicitada	\N	2017-06-30 19:26:06.138296	2017-07-01 18:49:47.91418	19	Ya nada, gracias. o mejor sí...	\N	\N
11	dummy	\N	solicitada	\N	2017-06-30 20:05:52.424896	2017-07-01 18:49:47.924307	19	Ya no sé nada de nada	\N	\N
12	diseño	\N	solicitada	\N	2017-06-30 20:22:53.397587	2017-07-01 18:49:47.934846	19	los dos se subieron?	\N	\N
13	dummy	\N	solicitada	\N	2017-06-30 20:24:52.811938	2017-07-01 18:49:47.946802	19	en serio?	\N	\N
14	dummy	\N	solicitada	\N	2017-06-30 20:39:50.211948	2017-07-01 18:49:47.958142	19	Hola ke ase	\N	\N
15	diseño	\N	solicitada	\N	2017-06-30 20:53:11.44171	2017-07-01 18:49:47.969122	19	que que que quee	\N	\N
16	diseño	\N	solicitada	\N	2017-06-30 21:06:05.404572	2017-07-01 18:49:47.979736	19	que que que quee	\N	\N
17	dummy	\N	solicitada	\N	2017-06-30 21:15:25.456825	2017-07-01 18:49:47.990426	19	ultima prueba?	\N	\N
18	dummy	\N	solicitada	\N	2017-06-30 21:17:26.708703	2017-07-01 18:49:48.002291	19	una prueba mas?	\N	\N
19	dummy	\N	solicitada	\N	2017-06-30 21:36:30.240806	2017-07-01 18:49:48.012729	19	bla bla bla 	\N	\N
20	diseño	\N	solicitada	\N	2017-06-30 21:41:31.448688	2017-07-01 18:49:48.024003	19	como como	\N	\N
21	dummy	\N	solicitada	\N	2017-06-30 21:44:58.093738	2017-07-01 18:49:48.036106	19	haz un diseño porfa	\N	\N
22	dummy	\N	solicitada	\N	2017-06-30 22:26:35.954219	2017-07-01 18:49:48.046291	19	come on	\N	\N
43	dummy	\N	solicitada	\N	2017-08-01 01:10:05.600762	2017-08-01 01:10:06.634307	95	hola	\N	\N
25	printcard	\N	solicitada	\N	2017-06-30 22:35:05.949671	2017-07-01 18:49:48.079449	19	printcard	\N	\N
26	printcard	\N	solicitada	\N	2017-06-30 22:37:52.929159	2017-07-01 18:49:48.090525	19	otro por favor	\N	\N
27	dummy	\N	solicitada	\N	2017-06-30 22:38:37.56253	2017-07-01 18:49:48.102132	19	iohoihdosdad	\N	\N
28	diseño	\N	solicitada	\N	2017-06-30 22:43:37.522007	2017-07-01 18:49:48.113484	19	un diseño por favor	\N	\N
29	diseño	\N	solicitada	\N	2017-06-30 23:35:06.266488	2017-07-01 18:49:48.124214	19	un diseño por favor	\N	\N
30	dummy	\N	solicitada	\N	2017-06-30 23:38:37.721464	2017-07-01 18:49:48.134754	19	esta es la prueba final	\N	\N
44	diseño	\N	solicitada	\N	2017-08-05 17:33:03.731594	2017-08-05 17:33:04.912362	122	Cambialo a rojo	\N	\N
\.


--
-- Name: design_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('design_requests_id_seq', 44, true);


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY documents (id, request_id, created_at, updated_at, document_type, design_request_id, document) FROM stdin;
1	1	2017-06-19 17:54:21.721491	2017-06-19 17:54:21.721491	pago	\N	\N
2	2	2017-06-20 02:12:18.315104	2017-06-20 02:12:18.315104	pedido	\N	\N
3	3	2017-06-20 02:16:29.888371	2017-06-20 02:16:29.888371	pago	\N	\N
4	3	2017-06-20 02:16:30.70197	2017-06-20 02:16:30.70197	pedido	\N	\N
5	4	2017-06-20 02:21:35.968043	2017-06-20 02:21:35.968043	pago	\N	\N
6	5	2017-06-21 18:08:15.237343	2017-06-21 18:08:15.237343	pago	\N	\N
7	6	2017-06-21 18:13:19.262921	2017-06-21 18:13:19.262921	pago	\N	\N
8	6	2017-06-21 18:13:19.89558	2017-06-21 18:13:19.89558	pedido	\N	\N
9	7	2017-06-21 18:15:05.333554	2017-06-21 18:15:05.333554	pago	\N	\N
10	7	2017-06-21 18:15:05.997952	2017-06-21 18:15:05.997952	pedido	\N	\N
11	8	2017-06-21 18:18:58.326158	2017-06-21 18:18:58.326158	pago	\N	\N
12	8	2017-06-21 18:18:59.003077	2017-06-21 18:18:59.003077	pedido	\N	\N
13	9	2017-06-21 18:19:15.945104	2017-06-21 18:19:15.945104	pago	\N	\N
14	9	2017-06-21 18:19:16.637568	2017-06-21 18:19:16.637568	pedido	\N	\N
15	10	2017-06-21 18:43:20.210908	2017-06-21 18:43:20.210908	pago	\N	\N
16	\N	2017-06-30 19:18:30.217888	2017-06-30 19:18:30.217888	diseño adjunto	9	\N
17	\N	2017-06-30 19:26:06.141819	2017-06-30 19:26:06.141819	diseño adjunto	10	\N
18	\N	2017-06-30 20:05:52.427489	2017-06-30 20:05:52.427489	diseño adjunto	11	\N
19	\N	2017-06-30 20:22:53.401502	2017-06-30 20:22:53.401502	diseño adjunto	12	\N
20	\N	2017-06-30 20:24:52.815771	2017-06-30 20:24:52.815771	diseño adjunto	13	\N
21	\N	2017-06-30 20:39:50.243612	2017-06-30 20:39:50.243612	diseño adjunto	14	\N
34	\N	2017-06-30 22:37:52.932412	2017-06-30 22:37:52.932412	diseño adjunto	26	Transferencia_Comercializadora_Diseños_de_Carton_Facturas_34498_34556_junio_2017.pdf
35	\N	2017-06-30 22:37:53.590892	2017-06-30 22:37:53.590892	diseño adjunto	26	Transferencia_Comercializadora_Diseños_Factura_34564_Junio_2017.pdf
36	\N	2017-06-30 22:38:37.565906	2017-06-30 22:38:37.565906	diseño adjunto	27	Transferencia_Diseños_de_Carton_Facturas_11447_11514__junio_2017.pdf
37	\N	2017-06-30 22:39:29.755144	2017-06-30 22:39:29.755144	diseño adjunto	27	Transferencia_Diseños_de_Carton_Factura_11517_Junio_2017.pdf
38	\N	2017-06-30 22:43:37.52484	2017-06-30 22:43:37.52484	diseño adjunto	28	Recibo_de_nomina_2_quincena_mayo_2017_Claudia.pdf
39	\N	2017-06-30 22:43:45.57071	2017-06-30 22:43:45.57071	diseño adjunto	28	Formato_ISN_Mayo_2017.pdf
42	\N	2017-06-30 23:38:37.724645	2017-06-30 23:38:37.724645	diseño adjunto	30	Formato_ISN_Mayo_2017.pdf
43	\N	2017-06-30 23:38:37.86185	2017-06-30 23:38:37.86185	diseño adjunto	30	Deposito_factura_jovenes.jpg
45	\N	2017-07-01 20:28:51.260047	2017-07-01 20:28:51.260047	diseño adjunto	32	Transferencia_Diseños_de_Carton_Facturas_11447_11514__junio_2017.pdf
46	\N	2017-07-01 20:28:52.023968	2017-07-01 20:28:52.023968	diseño adjunto	32	Transferencia_Diseños_de_Carton_Factura_11517_Junio_2017.pdf
47	\N	2017-07-02 17:41:35.865686	2017-07-02 17:41:35.865686	diseño adjunto	33	Formato_ISN_Mayo_2017.pdf
48	\N	2017-07-04 18:44:05.212156	2017-07-04 18:44:05.212156	diseño adjunto	37	Transferencia_renta_julio_2017.pdf
49	25	2017-07-04 21:30:40.913524	2017-07-04 21:30:40.913524	pago	\N	Transferencia_renta_julio_2017.pdf
50	24	2017-07-04 21:51:24.359234	2017-07-04 21:51:24.359234	pago	\N	Transferencia_renta_julio_2017.pdf
51	24	2017-07-04 21:51:48.550553	2017-07-04 21:51:48.550553	pago	\N	Transferencia_renta_julio_2017.pdf
52	24	2017-07-04 21:52:26.469512	2017-07-04 21:52:26.469512	pago	\N	Transferencia_renta_julio_2017.pdf
53	24	2017-07-04 21:54:53.52801	2017-07-04 21:54:53.52801	pago	\N	Transferencia_renta_julio_2017.pdf
54	24	2017-07-04 21:55:38.031147	2017-07-04 21:55:38.031147	pago	\N	Transferencia_renta_julio_2017.pdf
55	24	2017-07-04 21:55:38.712759	2017-07-04 21:55:38.712759	pedido	\N	Pago_recibo_luz_negocio_junio_2017.pdf
56	21	2017-07-04 21:57:11.525545	2017-07-04 21:57:11.525545	pago	\N	Transferencia_renta_julio_2017.pdf
57	21	2017-07-04 21:57:12.185104	2017-07-04 21:57:12.185104	pedido	\N	Pago_recibo_luz_negocio_junio_2017.pdf
58	18	2017-07-04 23:36:51.885848	2017-07-04 23:36:51.885848	pago	\N	Pago_recibo_luz_negocio_junio_2017.pdf
59	18	2017-07-04 23:37:39.949824	2017-07-04 23:37:39.949824	pago	\N	Pago_recibo_luz_negocio_junio_2017.pdf
60	13	2017-07-05 01:24:34.179434	2017-07-05 01:24:34.179434	pago	\N	Formato_ISN_Mayo_2017.pdf
61	14	2017-07-05 01:27:41.914713	2017-07-05 01:27:41.914713	pago	\N	Transferencia_comercializadora_Facturas_34233_34243_y_NC_624_Junio_2017.pdf
62	15	2017-07-05 01:38:56.038877	2017-07-05 01:38:56.038877	pago	\N	Transferencia_renta_julio_2017.pdf
63	16	2017-07-05 01:45:36.458612	2017-07-05 01:45:36.458612	pago	\N	Pago_IMSS.jpg
64	11	2017-07-05 01:48:56.043178	2017-07-05 01:48:56.043178	pago	\N	Transferencia_renta_julio_2017.pdf
65	27	2017-07-05 02:01:03.611301	2017-07-05 02:01:03.611301	pago	\N	Transferencia_renta_julio_2017.pdf
66	28	2017-07-05 02:10:42.097266	2017-07-05 02:10:42.097266	pago	\N	Pago_recibo_luz_negocio_junio_2017.pdf
67	29	2017-07-05 02:24:22.520588	2017-07-05 02:24:22.520588	pago	\N	Transferencia_renta_julio_2017.pdf
68	29	2017-07-05 02:33:24.426871	2017-07-05 02:33:24.426871	pago	\N	Transferencia_renta_julio_2017.pdf
69	30	2017-07-05 02:39:17.121659	2017-07-05 02:39:17.121659	pago	\N	Transferencia_renta_julio_2017.pdf
70	32	2017-07-05 16:58:13.4341	2017-07-05 16:58:13.4341	pedido	\N	Transferencia_renta_julio_2017.pdf
71	33	2017-07-05 17:27:42.702562	2017-07-05 17:27:42.702562	pedido	\N	Transferencia_renta_julio_2017.pdf
72	33	2017-07-05 17:28:54.542274	2017-07-05 17:28:54.542274	pedido	\N	Transferencia_renta_julio_2017.pdf
73	33	2017-07-05 17:30:16.133921	2017-07-05 17:30:16.133921	pedido	\N	Transferencia_renta_julio_2017.pdf
74	36	2017-07-05 17:47:47.153488	2017-07-05 17:47:47.153488	pago	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
250	97	2017-08-03 14:45:34.986865	2017-08-03 14:45:34.986865	especificación	\N	business__2_.png
251	97	2017-08-03 14:45:36.734205	2017-08-03 14:45:36.734205	especificación	\N	business__1_.png
252	98	2017-08-03 14:46:36.029234	2017-08-03 14:46:36.029234	especificación	\N	desposit.png
253	99	2017-08-03 14:48:48.222704	2017-08-03 14:48:48.222704	especificación	\N	document__5_.png
254	99	2017-08-03 14:48:48.953213	2017-08-03 14:48:48.953213	especificación	\N	file__3_.png
269	124	2017-08-26 17:53:12.34055	2017-08-26 17:53:12.34055	especificación	\N	Microsoft2.jpg
270	124	2017-08-26 17:53:13.285535	2017-08-26 17:53:13.285535	especificación	\N	Microsoft1.jpg
75	37	2017-07-05 18:27:14.509236	2017-07-05 18:27:14.509236	pago	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
76	38	2017-07-05 19:56:43.613994	2017-07-05 19:56:43.613994	pedido	\N	Formato_ISN_Mayo_2017.pdf
77	39	2017-07-05 20:12:21.443171	2017-07-05 20:12:21.443171	pedido	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
78	40	2017-07-05 20:16:04.94272	2017-07-05 20:16:04.94272	pedido	\N	Transferencia_renta_julio_2017.pdf
79	40	2017-07-05 20:16:34.559606	2017-07-05 20:16:34.559606	pedido	\N	Transferencia_renta_julio_2017.pdf
80	40	2017-07-05 20:17:16.12432	2017-07-05 20:17:16.12432	pedido	\N	Transferencia_renta_julio_2017.pdf
81	41	2017-07-05 20:28:44.51888	2017-07-05 20:28:44.51888	pedido	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
82	42	2017-07-05 23:28:02.866852	2017-07-05 23:28:02.866852	pago	\N	Transferencia_renta_julio_2017.pdf
83	42	2017-07-05 23:28:03.540568	2017-07-05 23:28:03.540568	pedido	\N	Transferencia_Diseños_de_Carton_Factura_11517_Junio_2017.pdf
84	43	2017-07-05 23:50:50.772275	2017-07-05 23:50:50.772275	pedido	\N	Pago_recibo_luz_negocio_junio_2017.pdf
85	60	2017-07-07 22:53:14.060796	2017-07-07 22:53:14.060796	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
86	60	2017-07-07 22:53:14.791148	2017-07-07 22:53:14.791148	especificación	\N	Transferencia_renta_julio_2017.pdf
87	\N	2017-07-08 18:39:31.52671	2017-07-08 18:39:31.52671	especificación	\N	Deposito_factura_jovenes.jpg
88	\N	2017-07-08 18:39:33.405426	2017-07-08 18:39:33.405426	especificación	\N	Formato_ISN_Mayo_2017.pdf
89	\N	2017-07-08 19:14:10.487999	2017-07-08 19:14:10.487999	especificación	\N	Transferencia_facturas_34612_34625_34629_34682_34683_34693_34906_34937_34951_Comercializadora_Julio_2017.pdf
90	\N	2017-07-08 19:14:11.186818	2017-07-08 19:14:11.186818	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
91	\N	2017-07-08 19:36:58.940281	2017-07-08 19:36:58.940281	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
92	\N	2017-07-08 19:36:59.69647	2017-07-08 19:36:59.69647	especificación	\N	Transferencia_renta_julio_2017.pdf
93	\N	2017-07-08 19:37:00.640846	2017-07-08 19:37:00.640846	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
94	\N	2017-07-08 19:37:01.33582	2017-07-08 19:37:01.33582	especificación	\N	Transferencia_renta_julio_2017.pdf
95	61	2017-07-08 19:47:34.041713	2017-07-08 19:47:34.041713	especificación	\N	Transferencia_facturas_34612_34625_34629_34682_34683_34693_34906_34937_34951_Comercializadora_Julio_2017.pdf
96	61	2017-07-08 19:47:34.757332	2017-07-08 19:47:34.757332	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
97	62	2017-07-08 20:09:09.005934	2017-07-08 20:09:09.005934	especificación	\N	Transferencia_Diseños_de_Carton_Facturas_11447_11514__junio_2017.pdf
98	62	2017-07-08 20:09:09.708814	2017-07-08 20:09:09.708814	especificación	\N	Transferencia_Comercializadora_Diseños_de_Carton_Facturas_34498_34556_junio_2017.pdf
99	63	2017-07-08 20:17:22.213374	2017-07-08 20:17:22.213374	especificación	\N	Pago_ISN.jpg
100	63	2017-07-08 20:17:22.826094	2017-07-08 20:17:22.826094	especificación	\N	Formato_ISN_Mayo_2017.pdf
101	64	2017-07-08 20:20:34.32342	2017-07-08 20:20:34.32342	especificación	\N	Pago_ISN.jpg
102	64	2017-07-08 20:20:34.928835	2017-07-08 20:20:34.928835	especificación	\N	Formato_ISN_Mayo_2017.pdf
103	65	2017-07-08 20:21:59.568768	2017-07-08 20:21:59.568768	especificación	\N	Pago_ISN.jpg
104	65	2017-07-08 20:22:00.233597	2017-07-08 20:22:00.233597	especificación	\N	Formato_ISN_Mayo_2017.pdf
105	66	2017-07-08 20:30:48.429947	2017-07-08 20:30:48.429947	especificación	\N	Pago_ISN.jpg
106	66	2017-07-08 20:30:49.075203	2017-07-08 20:30:49.075203	especificación	\N	Formato_ISN_Mayo_2017.pdf
107	67	2017-07-08 22:14:04.355172	2017-07-08 22:14:04.355172	especificación	\N	Pago_IMSS.jpg
108	67	2017-07-08 22:14:04.645167	2017-07-08 22:14:04.645167	especificación	\N	Pago_ISN.jpg
109	68	2017-07-08 22:20:08.7292	2017-07-08 22:20:08.7292	especificación	\N	Pago_IMSS.jpg
111	69	2017-07-08 22:59:44.946509	2017-07-08 22:59:44.946509	especificación	\N	Transferencia_facturas_34612_34625_34629_34682_34683_34693_34906_34937_34951_Comercializadora_Julio_2017.pdf
113	71	2017-07-08 23:04:24.43418	2017-07-08 23:04:24.43418	especificación	\N	Transferencia_facturas_34612_34625_34629_34682_34683_34693_34906_34937_34951_Comercializadora_Julio_2017.pdf
115	\N	2017-07-09 16:31:55.356689	2017-07-09 16:31:55.356689	especificación	\N	Deposito_factura_jovenes.jpg
116	\N	2017-07-09 16:57:37.266052	2017-07-09 16:57:37.266052	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
117	73	2017-07-09 18:07:43.161379	2017-07-09 18:07:43.161379	especificación	\N	Transferencia_renta_julio_2017.pdf
118	74	2017-07-09 18:13:56.570219	2017-07-09 18:13:56.570219	especificación	\N	Transferencia_renta_julio_2017.pdf
119	75	2017-07-09 20:16:37.073342	2017-07-09 20:16:37.073342	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
125	76	2017-07-09 20:24:45.142935	2017-07-09 20:24:45.142935	especificación	\N	Comprobante_de_transferencia_en_Junio_2017_Estafeta_factura_marzo.pdf
126	72	2017-07-09 21:10:11.257694	2017-07-09 21:10:11.257694	pago	\N	Transferencia_renta_julio_2017.pdf
127	72	2017-07-09 21:10:11.942017	2017-07-09 21:10:11.942017	pedido	\N	Transferencia_facturas_34612_34625_34629_34682_34683_34693_34906_34937_34951_Comercializadora_Julio_2017.pdf
128	\N	2017-07-09 22:00:56.33739	2017-07-09 22:00:56.33739	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
129	\N	2017-07-09 22:00:57.007215	2017-07-09 22:00:57.007215	especificación	\N	Transferencia_renta_julio_2017.pdf
130	77	2017-07-09 22:03:40.88783	2017-07-09 22:03:40.88783	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
131	77	2017-07-09 22:03:41.567356	2017-07-09 22:03:41.567356	especificación	\N	Transferencia_renta_julio_2017.pdf
132	\N	2017-07-09 22:13:55.601662	2017-07-09 22:13:55.601662	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
133	\N	2017-07-09 22:14:13.659412	2017-07-09 22:14:13.659412	especificación	\N	Transferencia_renta_julio_2017.pdf
134	\N	2017-07-09 22:23:41.888367	2017-07-09 22:23:41.888367	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
135	\N	2017-07-09 22:23:42.599865	2017-07-09 22:23:42.599865	especificación	\N	Transferencia_renta_julio_2017.pdf
136	\N	2017-07-09 22:32:35.581628	2017-07-09 22:32:35.581628	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
137	\N	2017-07-09 22:32:36.250325	2017-07-09 22:32:36.250325	especificación	\N	Transferencia_renta_julio_2017.pdf
138	\N	2017-07-09 22:34:07.935085	2017-07-09 22:34:07.935085	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
139	\N	2017-07-09 22:34:08.773281	2017-07-09 22:34:08.773281	especificación	\N	Transferencia_renta_julio_2017.pdf
255	121	2017-08-04 19:09:41.536095	2017-08-04 19:09:41.536095	especificación	\N	notes__1_.png
256	121	2017-08-04 19:09:43.537598	2017-08-04 19:09:43.537598	especificación	\N	business__3_.png
257	121	2017-08-04 19:09:44.472186	2017-08-04 19:09:44.472186	especificación	\N	business__2_.png
258	121	2017-08-04 19:09:45.325261	2017-08-04 19:09:45.325261	especificación	\N	business__1_.png
259	121	2017-08-04 19:37:10.164508	2017-08-04 19:37:10.164508	pago	\N	\N
260	121	2017-08-04 19:37:10.247255	2017-08-04 19:37:10.247255	pedido	\N	\N
261	75	2017-08-05 17:01:58.150278	2017-08-05 17:01:58.150278	pago	\N	\N
262	75	2017-08-05 17:01:58.372057	2017-08-05 17:01:58.372057	pedido	\N	\N
263	122	2017-08-05 17:32:40.233657	2017-08-05 17:32:40.233657	especificación	\N	image__2_.png
264	122	2017-08-05 17:32:41.615979	2017-08-05 17:32:41.615979	especificación	\N	image__1_.png
265	\N	2017-08-05 17:33:03.756674	2017-08-05 17:33:03.756674	diseño adjunto	44	camera.png
266	122	2017-08-05 17:52:26.397544	2017-08-05 17:52:26.397544	pago	\N	product_small.png
267	122	2017-08-05 17:52:27.306636	2017-08-05 17:52:27.306636	pedido	\N	image.png
268	123	2017-08-26 16:59:44.566345	2017-08-26 16:59:44.566345	especificación	\N	Microsoft4.jpg
140	\N	2017-07-09 22:35:32.988894	2017-07-09 22:35:32.988894	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
141	78	2017-07-09 22:42:23.275058	2017-07-09 22:42:23.275058	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
142	78	2017-07-09 22:42:23.97181	2017-07-09 22:42:23.97181	especificación	\N	Transferencia_renta_julio_2017.pdf
143	78	2017-07-09 22:43:34.038996	2017-07-09 22:43:34.038996	especificación	\N	\N
144	79	2017-07-09 22:52:27.773063	2017-07-09 22:52:27.773063	especificación	\N	Transferencia_Factura_Estafeta_Julio_2017.pdf
145	79	2017-07-09 22:52:28.47869	2017-07-09 22:52:28.47869	especificación	\N	Transferencia_renta_julio_2017.pdf
146	80	2017-07-11 17:11:35.531946	2017-07-11 17:11:35.531946	especificación	\N	document__2_.png
147	80	2017-07-11 17:11:35.6549	2017-07-11 17:11:35.6549	especificación	\N	document__1_.png
152	81	2017-07-12 00:06:24.864441	2017-07-12 00:06:24.864441	pago	\N	interface.png
153	81	2017-07-12 00:06:24.996241	2017-07-12 00:06:24.996241	pedido	\N	file__5_.png
154	82	2017-07-12 15:32:46.894333	2017-07-12 15:32:46.894333	especificación	\N	folder__1_.png
156	82	2017-07-12 15:48:08.177533	2017-07-12 15:48:08.177533	pago	\N	document__1_.png
157	82	2017-07-12 15:48:08.285421	2017-07-12 15:48:08.285421	pedido	\N	archive.png
160	\N	2017-07-12 19:03:22.200711	2017-07-12 19:03:22.200711	diseño adjunto	24	interface.png
172	\N	2017-07-12 22:16:02.53311	2017-07-12 22:16:02.53311	diseño adjunto	38	folder__1_.png
173	\N	2017-07-12 22:16:02.78047	2017-07-12 22:16:02.78047	diseño adjunto	38	interface.png
174	\N	2017-07-12 22:17:19.24838	2017-07-12 22:17:19.24838	diseño adjunto	39	folder__1_.png
175	\N	2017-07-12 22:17:19.309104	2017-07-12 22:17:19.309104	diseño adjunto	39	interface.png
176	\N	2017-07-12 22:21:56.789423	2017-07-12 22:21:56.789423	diseño adjunto	40	file__3_.png
177	\N	2017-07-12 22:21:56.964727	2017-07-12 22:21:56.964727	diseño adjunto	40	folder__1_.png
178	\N	2017-07-12 22:23:03.943955	2017-07-12 22:23:03.943955	diseño adjunto	41	document__5_.png
179	\N	2017-07-12 22:23:04.037912	2017-07-12 22:23:04.037912	diseño adjunto	41	file__3_.png
180	\N	2017-07-12 22:23:04.153472	2017-07-12 22:23:04.153472	diseño adjunto	41	folder__1_.png
181	\N	2017-07-13 16:14:39.645549	2017-07-13 16:14:39.645549	diseño adjunto	40	Pago_IMSS.jpg
182	\N	2017-07-13 16:14:39.895488	2017-07-13 16:14:39.895488	diseño adjunto	40	Pago_ISN.jpg
183	\N	2017-07-13 16:14:40.017778	2017-07-13 16:14:40.017778	diseño adjunto	40	Deposito_factura_jovenes.jpg
184	\N	2017-07-13 16:51:50.417733	2017-07-13 16:51:50.417733	respuesta de diseño	39	Transferencia_Diseños_de_Carton_Facturas_11447_11514__junio_2017.pdf
185	\N	2017-07-13 16:51:51.076252	2017-07-13 16:51:51.076252	respuesta de diseño	39	Transferencia_Comercializadora_Diseños_de_Carton_Facturas_34498_34556_junio_2017.pdf
186	84	2017-07-14 16:44:02.136621	2017-07-14 16:44:02.136621	especificación	\N	Transferencia_Comercializadora_Diseños_de_Carton_Facturas_34498_34556_junio_2017.pdf
187	84	2017-07-14 16:44:02.365866	2017-07-14 16:44:02.365866	especificación	\N	Pago_IMSS.jpg
188	84	2017-07-14 16:53:15.185313	2017-07-14 16:53:15.185313	especificación	\N	Transferencia_renta_julio_2017.pdf
189	86	2017-07-14 17:36:54.442701	2017-07-14 17:36:54.442701	especificación	\N	business__3_.png
190	86	2017-07-14 17:36:54.526376	2017-07-14 17:36:54.526376	especificación	\N	business__2_.png
191	87	2017-07-14 17:37:25.150413	2017-07-14 17:37:25.150413	especificación	\N	file__6_.png
192	87	2017-07-14 17:37:25.224141	2017-07-14 17:37:25.224141	especificación	\N	file__5_.png
193	88	2017-07-14 17:52:40.565112	2017-07-14 17:52:40.565112	especificación	\N	file__6_.png
194	88	2017-07-14 17:52:40.654183	2017-07-14 17:52:40.654183	especificación	\N	file__5_.png
195	89	2017-07-14 17:52:50.917926	2017-07-14 17:52:50.917926	especificación	\N	file__6_.png
196	89	2017-07-14 17:52:50.996198	2017-07-14 17:52:50.996198	especificación	\N	file__5_.png
199	90	2017-07-14 18:57:06.280854	2017-07-14 18:57:06.280854	especificación	\N	specifications.png
200	90	2017-07-14 18:57:06.447183	2017-07-14 18:57:06.447183	especificación	\N	diseno.png
201	91	2017-07-14 18:57:49.026345	2017-07-14 18:57:49.026345	especificación	\N	document__1_.png
202	91	2017-07-14 18:57:49.098977	2017-07-14 18:57:49.098977	especificación	\N	multimedia.png
203	91	2017-07-14 18:57:49.171239	2017-07-14 18:57:49.171239	especificación	\N	document.png
208	92	2017-07-14 19:35:29.826338	2017-07-14 19:35:29.826338	especificación	\N	document__6_.png
209	92	2017-07-14 19:35:29.91856	2017-07-14 19:35:29.91856	especificación	\N	file__6_.png
212	93	2017-07-14 19:54:16.237114	2017-07-14 19:54:16.237114	especificación	\N	document__6_.png
213	93	2017-07-14 19:54:16.310185	2017-07-14 19:54:16.310185	especificación	\N	file__6_.png
216	93	2017-07-14 20:09:21.077622	2017-07-14 20:09:21.077622	pago	\N	\N
217	93	2017-07-14 20:09:21.107948	2017-07-14 20:09:21.107948	pedido	\N	\N
218	94	2017-07-14 22:52:54.248114	2017-07-14 22:52:54.248114	especificación	\N	file__5_.png
219	94	2017-07-14 22:52:54.370575	2017-07-14 22:52:54.370575	especificación	\N	file__4_.png
220	\N	2017-07-15 15:13:37.82632	2017-07-15 15:13:37.82632	diseño adjunto	42	document__6_.png
221	\N	2017-07-15 15:13:37.900278	2017-07-15 15:13:37.900278	diseño adjunto	42	file__6_.png
222	\N	2017-07-15 15:36:01.621435	2017-07-15 15:36:01.621435	respuesta de diseño	38	file__5_.png
223	\N	2017-07-15 15:36:01.705889	2017-07-15 15:36:01.705889	respuesta de diseño	38	file__4_.png
224	\N	2017-07-15 15:36:01.753076	2017-07-15 15:36:01.753076	respuesta de diseño	38	document__5_.png
225	95	2017-07-21 19:25:41.953847	2017-07-21 19:25:41.953847	especificación	\N	card__1_.png
226	95	2017-07-21 19:26:10.665139	2017-07-21 19:26:10.665139	especificación	\N	business__3_.png
227	95	2017-07-21 20:16:00.698955	2017-07-21 20:16:00.698955	pago	\N	\N
228	95	2017-07-21 20:16:00.778064	2017-07-21 20:16:00.778064	pedido	\N	\N
229	95	2017-07-21 20:17:02.125185	2017-07-21 20:17:02.125185	pago	\N	\N
230	95	2017-07-21 20:17:02.141181	2017-07-21 20:17:02.141181	pedido	\N	\N
231	95	2017-07-21 20:21:38.503105	2017-07-21 20:21:38.503105	pago	\N	\N
232	95	2017-07-21 20:21:38.524132	2017-07-21 20:21:38.524132	pedido	\N	\N
233	95	2017-07-21 20:22:08.617469	2017-07-21 20:22:08.617469	pago	\N	\N
234	95	2017-07-21 20:22:08.643116	2017-07-21 20:22:08.643116	pedido	\N	\N
235	94	2017-07-21 21:13:54.243069	2017-07-21 21:13:54.243069	pago	\N	\N
236	94	2017-07-21 21:13:54.296304	2017-07-21 21:13:54.296304	pedido	\N	\N
237	\N	2017-07-22 16:26:42.267633	2017-07-22 16:26:42.267633	especificación	\N	Transferencia_Diseños_de_Carton_julio_2017_Facturas_11567_11591_11607_11638_11656.pdf
238	96	2017-07-22 16:27:23.937428	2017-07-22 16:27:23.937428	especificación	\N	Transferencia_comercializadora_Facturas_34233_34243_y_NC_624_Junio_2017.pdf
239	96	2017-07-22 16:28:54.222343	2017-07-22 16:28:54.222343	especificación	\N	card.png
240	96	2017-07-22 16:37:25.003893	2017-07-22 16:37:25.003893	especificación	\N	business__3_.png
241	96	2017-07-22 16:39:48.652873	2017-07-22 16:39:48.652873	especificación	\N	business__2_.png
242	96	2017-07-22 16:46:02.325755	2017-07-22 16:46:02.325755	especificación	\N	desposit.png
243	96	2017-07-22 16:50:46.73789	2017-07-22 16:50:46.73789	especificación	\N	card.png
244	96	2017-07-22 16:53:41.695159	2017-07-22 16:53:41.695159	pago	\N	\N
245	96	2017-07-22 16:53:41.725077	2017-07-22 16:53:41.725077	pedido	\N	\N
246	95	2017-08-01 01:08:24.203516	2017-08-01 01:08:24.203516	especificación	\N	Mosaic-tech.png
247	95	2017-08-01 01:08:25.228601	2017-08-01 01:08:25.228601	especificación	\N	Mosaic-tech-fondo.png
248	\N	2017-08-01 01:10:05.658941	2017-08-01 01:10:05.658941	diseño adjunto	43	Mosaic-tech-fondo.png
249	97	2017-08-03 14:45:33.177988	2017-08-03 14:45:33.177988	especificación	\N	business__3_.png
\.


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('documents_id_seq', 270, true);


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY expenses (id, subtotal, taxes_rate, total, store_id, business_unit_id, user_id, bill_received_id, month, year, expense_date, created_at, updated_at) FROM stdin;
\.


--
-- Name: expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('expenses_id_seq', 1, false);


--
-- Data for Name: images; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY images (id, image, created_at, updated_at, product_id) FROM stdin;
1	card.png	2017-07-30 16:03:55.945517	2017-07-30 16:03:55.945517	13
2	notes__1_.png	2017-07-30 16:03:56.149793	2017-07-30 16:03:56.149793	13
3	business__3_.png	2017-07-30 16:03:56.325373	2017-07-30 16:03:56.325373	13
4	business__2_.png	2017-07-30 20:32:55.752689	2017-07-30 20:32:55.752689	14
5	business__1_.png	2017-07-30 20:32:56.002401	2017-07-30 20:32:56.002401	14
6	desposit.png	2017-07-30 20:32:56.18578	2017-07-30 20:32:56.18578	14
7	desposit.png	2017-07-30 21:34:49.525986	2017-07-30 21:34:49.525986	15
8	card.png	2017-07-30 21:44:09.348807	2017-07-30 21:44:09.348807	16
9	notes__1_.png	2017-07-30 21:44:09.526211	2017-07-30 21:44:09.526211	16
10	image__1_.png	2017-08-03 17:33:59.396871	2017-08-03 17:33:59.396871	17
11	image.png	2017-08-03 22:41:15.42587	2017-08-03 22:41:15.42587	18
12	camera.png	2017-08-03 22:41:17.499267	2017-08-03 22:41:17.499267	18
13	camera.png	2017-08-05 18:51:29.942812	2017-08-05 18:51:29.942812	6
14	notes__1_.png	2017-08-05 18:51:32.161108	2017-08-05 18:51:32.161108	6
15	business__3_.png	2017-08-05 18:51:34.081525	2017-08-05 18:51:34.081525	6
18	image__1_.png	2017-08-11 20:38:26.758849	2017-08-11 20:38:26.758849	21
19	4810.jpg	2017-08-17 17:49:10.6481	2017-08-17 17:49:10.6481	22
\.


--
-- Name: images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('images_id_seq', 19, true);


--
-- Data for Name: inventories; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY inventories (id, product_id, created_at, updated_at, quantity, unique_code, alert) FROM stdin;
1	4	2017-07-18 16:55:53.558244	2017-07-18 16:55:53.558244	\N	\N	\N
2	5	2017-07-18 17:02:22.075525	2017-07-18 17:02:22.075525	\N	\N	\N
4	7	2017-07-18 17:08:31.576058	2017-07-18 17:08:31.576058	\N	\N	\N
5	8	2017-07-18 17:12:41.61261	2017-07-18 17:12:41.61261	\N	\N	\N
6	9	2017-07-18 17:46:42.249925	2017-07-18 20:33:30.150174	0	\N	\N
8	11	2017-07-29 19:38:37.281507	2017-07-29 19:38:37.281507	0	\N	\N
9	12	2017-07-30 15:34:03.026182	2017-07-30 15:34:03.026182	0	\N	\N
10	14	2017-07-30 20:32:56.609511	2017-07-30 20:32:56.609511	0	\N	\N
3	6	2017-07-18 17:06:08.727479	2017-08-12 16:22:00.302892	0	\N	\N
16	16	2017-08-12 16:32:05.540623	2017-08-12 16:32:05.564986	100	\N	\N
12	2	2017-08-07 05:01:07.82352	2017-08-12 16:33:44.389534	600	\N	\N
17	3	2017-08-12 16:43:28.629951	2017-08-12 16:43:28.649109	300	\N	\N
11	18	2017-08-06 17:23:00.370988	2017-08-12 16:43:28.694817	1500	\N	\N
18	22	2017-08-17 17:49:13.405827	2017-08-17 17:49:13.405827	0	AG0001	\N
14	17	2017-08-11 16:47:41.32084	2017-09-07 19:08:31.354466	1200	\N	\N
13	1	2017-08-11 16:29:19.193384	2017-09-07 19:08:31.409596	2100	\N	\N
19	23	2017-08-26 18:42:29.158053	2017-09-11 00:54:25.017726	900	45678926	\N
7	10	2017-07-29 19:37:32.2262	2017-09-11 01:24:51.838689	100	\N	\N
21	25	2017-09-11 01:18:44.852737	2017-09-11 01:26:26.030085	750	238489024	\N
22	26	2017-09-11 01:20:29.784331	2017-09-11 01:26:26.369802	700	238944227	\N
15	21	2017-08-12 16:06:41.006153	2017-09-11 01:26:26.756026	1160	\N	\N
20	24	2017-09-11 01:16:30.100671	2017-09-11 01:26:27.04448	400	5969214	\N
\.


--
-- Name: inventories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('inventories_id_seq', 22, true);


--
-- Data for Name: inventory_configurations; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY inventory_configurations (id, business_unit_id, reorder_point, critical_point, created_at, updated_at, months_in_inventory, store_id) FROM stdin;
\.


--
-- Name: inventory_configurations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('inventory_configurations_id_seq', 1, false);


--
-- Data for Name: movements; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY movements (id, product_id, quantity, movement_type, created_at, updated_at, order_id, user_id, cost, unique_code, store_id, initial_price, supplier_id, business_unit_id, prospect_id, bill_id, product_request_id, maximum_date, delivery_package_id, confirm, discount_applied, final_price) FROM stdin;
4	15	400	alta	2017-07-31 02:29:57.812656	2017-07-31 02:55:53.385374	\N	\N	34.5	02456793	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
6	16	200	alta	2017-07-31 03:11:14.986167	2017-07-31 03:38:23.603106	\N	\N	15.4000000000000004	02456794	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
7	16	500	alta	2017-07-31 03:11:21.314156	2017-07-31 03:42:20.012014	\N	\N	\N	02456794	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
5	15	250	alta	2017-07-31 03:10:55.36638	2017-07-31 03:46:57.394138	\N	\N	19.8000000000000007	02456793	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
8	6	\N	alta	2017-08-06 01:57:35.762623	2017-08-06 01:57:35.762623	\N	12	\N	02456789	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
9	16	\N	alta	2017-08-06 01:57:36.133826	2017-08-06 01:57:36.133826	\N	12	\N	02456794	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
10	15	\N	alta	2017-08-06 01:57:36.178558	2017-08-06 01:57:36.178558	\N	12	\N	02456793	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
11	18	\N	alta	2017-08-06 01:57:36.232846	2017-08-06 01:57:36.232846	\N	12	\N	02456699	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
12	6	\N	alta	2017-08-06 01:57:39.20907	2017-08-06 01:57:39.20907	\N	12	\N	02456789	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
13	16	\N	alta	2017-08-06 01:57:39.276582	2017-08-06 01:57:39.276582	\N	12	\N	02456794	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
14	15	\N	alta	2017-08-06 01:57:39.309455	2017-08-06 01:57:39.309455	\N	12	\N	02456793	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
15	18	\N	alta	2017-08-06 01:57:39.342613	2017-08-06 01:57:39.342613	\N	12	\N	02456699	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
16	6	\N	alta	2017-08-06 01:57:39.694012	2017-08-06 01:57:39.694012	\N	12	\N	02456789	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
17	16	\N	alta	2017-08-06 01:57:39.763406	2017-08-06 01:57:39.763406	\N	12	\N	02456794	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
18	15	\N	alta	2017-08-06 01:57:39.796563	2017-08-06 01:57:39.796563	\N	12	\N	02456793	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
19	18	\N	alta	2017-08-06 01:57:39.829481	2017-08-06 01:57:39.829481	\N	12	\N	02456699	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
20	6	\N	alta	2017-08-06 01:59:10.646862	2017-08-06 01:59:10.646862	\N	12	\N	02456789	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
21	14	100	alta	2017-08-06 01:59:10.742357	2017-08-06 01:59:10.742357	\N	12	\N	02456792	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
22	17	100	alta	2017-08-06 02:12:43.305137	2017-08-06 02:12:43.305137	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
23	17	100	alta	2017-08-06 02:12:44.38488	2017-08-06 02:12:44.38488	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
24	17	100	alta	2017-08-06 02:12:44.667624	2017-08-06 02:12:44.667624	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
25	17	100	alta	2017-08-06 02:12:44.919333	2017-08-06 02:12:44.919333	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
26	17	100	alta	2017-08-06 02:12:57.185493	2017-08-06 02:12:57.185493	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
27	17	100	alta	2017-08-06 02:12:57.681416	2017-08-06 02:12:57.681416	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
28	17	100	alta	2017-08-06 02:12:58.000985	2017-08-06 02:12:58.000985	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
29	17	100	alta	2017-08-06 02:12:58.247741	2017-08-06 02:12:58.247741	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
30	17	100	alta	2017-08-06 02:12:58.494065	2017-08-06 02:12:58.494065	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
31	17	100	alta	2017-08-06 02:12:58.736499	2017-08-06 02:12:58.736499	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
32	17	100	alta	2017-08-06 02:12:59.169968	2017-08-06 02:12:59.169968	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
33	17	100	alta	2017-08-06 02:12:59.566704	2017-08-06 02:12:59.566704	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
34	17	100	alta	2017-08-06 02:13:00.214726	2017-08-06 02:13:00.214726	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
35	17	100	alta	2017-08-06 02:13:01.195763	2017-08-06 02:13:01.195763	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
36	17	100	alta	2017-08-06 02:13:01.492026	2017-08-06 02:13:01.492026	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
37	11	500	alta	2017-08-06 17:18:25.545866	2017-08-06 17:18:25.545866	\N	12	\N	02456789	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
38	18	300	alta	2017-08-06 17:18:25.765163	2017-08-06 17:18:25.765163	\N	12	\N	02456699	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
39	18	200	alta	2017-08-06 17:22:44.904529	2017-08-06 17:23:00.319361	\N	12	\N	02456699	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
40	18	150	alta	2017-08-06 17:36:58.55529	2017-08-06 17:36:58.55529	\N	12	\N	02456699	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
41	18	100	alta	2017-08-06 17:50:33.284546	2017-08-06 17:52:35.839899	\N	12	\N	02456699	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
43	18	10	alta	2017-08-06 17:55:45.916318	2017-08-06 17:56:19.571772	\N	12	\N	02456699	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
44	18	90	alta	2017-08-06 17:57:15.625772	2017-08-06 17:57:15.625772	\N	12	\N	02456699	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
45	2	100	alta	2017-08-07 05:01:07.499541	2017-08-07 05:02:20.991143	\N	12	\N	0002	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
46	18	90	alta	2017-08-07 05:01:07.871562	2017-08-07 05:02:21.003217	\N	12	\N	02456699	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
47	1	500	alta	2017-08-11 16:29:18.982998	2017-08-11 16:32:48.862246	\N	12	\N	0001	2	\N	100	1	\N	\N	\N	\N	\N	t	\N	\N
48	18	900	alta	2017-08-11 16:42:13.74337	2017-08-11 16:43:07.337078	\N	12	\N	02456699	2	\N	81	1	\N	\N	\N	\N	\N	t	\N	\N
49	17	800	alta	2017-08-11 16:47:41.269246	2017-08-11 16:48:00.512945	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
50	2	350	alta	2017-08-12 16:06:40.690724	2017-08-12 16:06:58.760652	\N	12	\N	0002	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
51	21	450	alta	2017-08-12 16:06:40.971709	2017-08-12 16:06:58.795116	\N	12	\N	12345678	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
52	6	50	alta	2017-08-12 16:14:44.774127	2017-08-12 16:15:16.237505	\N	12	\N	02456789	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
53	21	150	alta	2017-08-12 16:14:44.868889	2017-08-12 16:15:16.278585	\N	12	\N	12345678	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
54	2	50	alta	2017-08-12 16:14:44.918231	2017-08-12 16:15:16.289668	\N	12	\N	0002	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
55	16	100	alta	2017-08-12 16:32:05.422211	2017-08-12 16:32:17.40254	\N	12	\N	02456794	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
56	21	100	alta	2017-08-12 16:32:05.576688	2017-08-12 16:32:17.443634	\N	12	\N	12345678	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
57	17	100	alta	2017-08-12 16:32:05.621384	2017-08-12 16:32:17.455132	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
58	2	100	alta	2017-08-12 16:33:44.309421	2017-08-12 16:33:47.089052	\N	12	\N	0002	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
59	1	100	alta	2017-08-12 16:33:44.398559	2017-08-12 16:33:47.121613	\N	12	\N	0001	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
60	3	300	alta	2017-08-12 16:43:28.533343	2017-08-12 16:44:01.326164	\N	12	\N	02456789	2	\N	81	1	\N	\N	\N	\N	\N	t	\N	\N
61	18	200	alta	2017-08-12 16:43:28.661203	2017-08-12 16:44:01.360903	\N	12	\N	02456699	2	\N	37	1	\N	\N	\N	\N	\N	t	\N	\N
62	2	100	venta	2017-08-18 19:40:59.509322	2017-08-18 19:40:59.509322	16	1	0	0002	1	10.5	\N	2	\N	\N	25	\N	\N	f	\N	\N
63	2	350	venta	2017-08-18 21:50:42.767092	2017-08-18 21:50:42.767092	18	1	0	0002	1	10.5	\N	2	\N	\N	27	\N	\N	f	\N	\N
64	2	50	venta	2017-08-18 21:50:42.848609	2017-08-18 21:50:42.848609	18	1	0	0002	1	10.5	\N	2	\N	\N	27	\N	\N	f	\N	\N
65	2	100	venta	2017-08-18 21:50:42.906209	2017-08-18 21:50:42.906209	18	1	0	0002	1	10.5	\N	2	\N	\N	27	\N	\N	f	\N	\N
66	9	500	alta	2017-09-07 19:05:41.609184	2017-09-07 19:05:41.609184	\N	12	\N	30216514	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
67	9	430	\N	2017-09-07 19:05:41.7621	2017-09-07 19:05:41.7621	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
68	9	500	alta	2017-09-07 19:05:52.43819	2017-09-07 19:05:52.43819	\N	12	\N	30216514	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
69	9	430	\N	2017-09-07 19:05:52.458375	2017-09-07 19:05:52.458375	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
70	9	500	alta	2017-09-07 19:05:56.413873	2017-09-07 19:05:56.413873	\N	12	\N	30216514	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
71	9	430	\N	2017-09-07 19:05:56.432374	2017-09-07 19:05:56.432374	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
72	9	900	alta	2017-09-07 19:06:14.131883	2017-09-07 19:06:14.131883	\N	12	\N	30216514	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
73	9	430	\N	2017-09-07 19:06:14.158582	2017-09-07 19:06:14.158582	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
74	9	900	alta	2017-09-07 19:06:15.846458	2017-09-07 19:06:15.846458	\N	12	\N	30216514	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
75	9	430	\N	2017-09-07 19:06:15.859455	2017-09-07 19:06:15.859455	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
76	9	900	alta	2017-09-07 19:06:16.69292	2017-09-07 19:06:16.69292	\N	12	\N	30216514	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
77	9	430	\N	2017-09-07 19:06:16.713824	2017-09-07 19:06:16.713824	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
78	17	100	alta	2017-09-07 19:08:27.045543	2017-09-07 19:08:27.045543	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
79	1	500	alta	2017-09-07 19:08:27.268315	2017-09-07 19:08:27.268315	\N	12	\N	0001	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
80	9	900	alta	2017-09-07 19:08:27.32344	2017-09-07 19:08:27.32344	\N	12	\N	30216514	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
81	9	430	\N	2017-09-07 19:08:27.337258	2017-09-07 19:08:27.337258	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
82	17	100	alta	2017-09-07 19:08:29.239019	2017-09-07 19:08:29.239019	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
83	1	500	alta	2017-09-07 19:08:29.316701	2017-09-07 19:08:29.316701	\N	12	\N	0001	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
84	9	900	alta	2017-09-07 19:08:29.37168	2017-09-07 19:08:29.37168	\N	12	\N	30216514	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
85	9	430	\N	2017-09-07 19:08:29.38513	2017-09-07 19:08:29.38513	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
86	17	100	alta	2017-09-07 19:08:31.309201	2017-09-07 19:08:31.309201	\N	12	\N	02456799	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
87	1	500	alta	2017-09-07 19:08:31.364746	2017-09-07 19:08:31.364746	\N	12	\N	0001	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
88	9	900	alta	2017-09-07 19:08:31.419943	2017-09-07 19:08:31.419943	\N	12	\N	30216514	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
89	9	430	\N	2017-09-07 19:08:31.432995	2017-09-07 19:08:31.432995	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
90	17	100	venta	2017-09-10 19:59:43.490236	2017-09-10 19:59:43.490236	34	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	48	\N	\N	f	\N	\N
91	17	100	venta	2017-09-10 19:59:43.557199	2017-09-10 19:59:43.557199	34	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	48	\N	\N	f	\N	\N
92	17	100	venta	2017-09-10 19:59:43.610042	2017-09-10 19:59:43.610042	34	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	48	\N	\N	f	\N	\N
93	17	100	venta	2017-09-10 19:59:43.666972	2017-09-10 19:59:43.666972	34	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	48	\N	\N	f	\N	\N
94	21	10	alta	2017-09-10 22:08:42.114369	2017-09-10 22:08:47.086277	\N	12	\N	12345678	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
95	21	50	alta	2017-09-10 22:08:58.135554	2017-09-10 22:09:02.010071	\N	12	\N	12345678	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
96	21	100	alta	2017-09-10 22:09:13.752462	2017-09-10 22:09:17.33892	\N	12	\N	12345678	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
97	3	100	venta	2017-09-10 23:49:33.95285	2017-09-10 23:49:34.035625	42	1	0	02456789	1	9	\N	2	\N	\N	53	\N	\N	f	\N	\N
98	17	100	venta	2017-09-10 23:49:34.132252	2017-09-10 23:49:34.170411	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
99	17	100	venta	2017-09-10 23:49:34.223636	2017-09-10 23:49:34.268227	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
100	17	0	venta	2017-09-10 23:49:34.305473	2017-09-10 23:49:34.340168	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
101	17	0	venta	2017-09-10 23:49:34.395604	2017-09-10 23:49:34.437125	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
102	17	0	venta	2017-09-10 23:49:34.486168	2017-09-10 23:49:34.5147	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
103	17	0	venta	2017-09-10 23:49:34.57387	2017-09-10 23:49:34.60698	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
104	17	0	venta	2017-09-10 23:49:34.648687	2017-09-10 23:49:34.691746	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
105	17	0	venta	2017-09-10 23:49:34.728309	2017-09-10 23:49:34.763425	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
106	17	0	venta	2017-09-10 23:49:34.80122	2017-09-10 23:49:34.826986	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
107	17	0	venta	2017-09-10 23:49:34.887199	2017-09-10 23:49:34.918463	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
108	17	0	venta	2017-09-10 23:49:34.956761	2017-09-10 23:49:34.982797	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
109	17	0	venta	2017-09-10 23:49:35.037159	2017-09-10 23:49:35.071186	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
110	17	0	venta	2017-09-10 23:49:35.126368	2017-09-10 23:49:35.163789	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
111	17	0	venta	2017-09-10 23:49:35.200295	2017-09-10 23:49:35.233894	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
112	17	0	venta	2017-09-10 23:49:35.291366	2017-09-10 23:49:35.342024	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
113	17	0	venta	2017-09-10 23:49:35.392325	2017-09-10 23:49:35.427605	42	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	54	\N	\N	f	\N	\N
114	17	100	venta	2017-09-11 00:17:13.520829	2017-09-11 00:17:13.588028	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
115	17	0	venta	2017-09-11 00:18:34.031189	2017-09-11 00:18:34.069127	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
116	17	0	venta	2017-09-11 00:18:34.123324	2017-09-11 00:18:34.157876	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
117	17	0	venta	2017-09-11 00:18:34.221668	2017-09-11 00:18:34.255838	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
118	17	0	venta	2017-09-11 00:18:34.291986	2017-09-11 00:18:34.320075	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
119	17	0	venta	2017-09-11 00:18:34.3496	2017-09-11 00:18:34.378131	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
120	17	0	venta	2017-09-11 00:18:34.413112	2017-09-11 00:18:34.441122	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
121	17	0	venta	2017-09-11 00:18:34.469808	2017-09-11 00:18:34.497854	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
122	17	0	venta	2017-09-11 00:18:34.534252	2017-09-11 00:18:34.564742	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
123	17	0	venta	2017-09-11 00:18:34.609901	2017-09-11 00:18:34.643256	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
124	17	0	venta	2017-09-11 00:18:34.679919	2017-09-11 00:18:34.707959	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
125	17	0	venta	2017-09-11 00:18:34.746772	2017-09-11 00:18:34.774893	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
126	17	0	venta	2017-09-11 00:18:34.812639	2017-09-11 00:18:34.839764	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
127	17	0	venta	2017-09-11 00:18:34.89053	2017-09-11 00:18:34.919666	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
128	17	0	venta	2017-09-11 00:18:34.967319	2017-09-11 00:18:34.997184	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
129	17	0	venta	2017-09-11 00:18:35.032288	2017-09-11 00:18:35.060501	43	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	56	\N	\N	f	\N	\N
130	17	101	venta	2017-09-11 00:32:04.485679	2017-09-11 00:32:04.541841	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
131	17	100	venta	2017-09-11 00:33:03.460127	2017-09-11 00:33:03.508893	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
132	17	1	venta	2017-09-11 00:36:23.580713	2017-09-11 00:36:23.623285	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
133	17	1	venta	2017-09-11 00:36:23.673883	2017-09-11 00:36:23.713241	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
134	17	1	venta	2017-09-11 00:36:23.754402	2017-09-11 00:36:23.791897	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
135	17	1	venta	2017-09-11 00:36:23.846333	2017-09-11 00:36:23.879859	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
136	17	1	venta	2017-09-11 00:36:23.918407	2017-09-11 00:36:23.95673	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
137	17	1	venta	2017-09-11 00:36:23.99916	2017-09-11 00:36:24.038059	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
138	17	1	venta	2017-09-11 00:36:24.091756	2017-09-11 00:36:24.130687	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
139	17	1	venta	2017-09-11 00:36:24.17798	2017-09-11 00:36:24.212322	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
140	17	1	venta	2017-09-11 00:36:24.250291	2017-09-11 00:36:24.284125	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
141	17	1	venta	2017-09-11 00:36:24.336736	2017-09-11 00:36:24.385673	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
142	17	1	venta	2017-09-11 00:36:24.455817	2017-09-11 00:36:24.487593	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
143	17	1	venta	2017-09-11 00:36:24.528029	2017-09-11 00:36:24.561571	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
144	17	1	venta	2017-09-11 00:36:24.60918	2017-09-11 00:36:24.673075	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
145	17	1	venta	2017-09-11 00:36:24.715737	2017-09-11 00:36:24.750307	45	1	0	02456799	1	12.6885604507215994	\N	2	\N	\N	59	\N	\N	f	\N	\N
147	23	100	venta	2017-09-11 00:52:49.949228	2017-09-11 00:52:49.949228	49	1	\N	45678926	1	14.8726232350688008	\N	2	\N	\N	63	\N	\N	f	\N	\N
146	23	100	alta	2017-09-11 00:52:49.164097	2017-09-11 00:52:56.02195	\N	12	\N	45678926	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
148	23	900	alta	2017-09-11 00:53:17.185684	2017-09-11 00:53:17.185684	\N	12	\N	45678926	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
149	23	870	\N	2017-09-11 00:53:17.304611	2017-09-11 00:53:17.304611	23	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
150	23	900	alta	2017-09-11 00:53:23.479282	2017-09-11 00:53:23.479282	\N	12	\N	45678926	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
151	23	870	\N	2017-09-11 00:53:23.617753	2017-09-11 00:53:23.617753	23	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
152	23	900	alta	2017-09-11 00:53:45.684125	2017-09-11 00:53:45.684125	\N	12	\N	45678926	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
153	23	870	\N	2017-09-11 00:53:45.8566	2017-09-11 00:53:45.8566	23	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
154	23	900	alta	2017-09-11 00:53:52.900029	2017-09-11 00:53:52.900029	\N	12	\N	45678926	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
155	23	870	\N	2017-09-11 00:53:52.984632	2017-09-11 00:53:52.984632	23	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
156	23	800	alta	2017-09-11 00:54:24.233857	2017-09-11 00:54:24.233857	\N	12	\N	45678926	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
157	23	300	venta	2017-09-11 00:54:24.665142	2017-09-11 00:54:24.665142	31	1	\N	45678926	1	\N	\N	2	\N	\N	41	\N	\N	f	\N	\N
158	23	900	alta	2017-09-11 00:54:53.655671	2017-09-11 00:54:53.655671	\N	12	\N	45678926	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
159	23	870	\N	2017-09-11 00:54:53.770511	2017-09-11 00:54:53.770511	23	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
160	23	900	alta	2017-09-11 00:55:02.696442	2017-09-11 00:55:02.696442	\N	12	\N	45678926	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
161	23	870	\N	2017-09-11 00:55:02.916621	2017-09-11 00:55:02.916621	23	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
162	23	900	alta	2017-09-11 00:55:10.052594	2017-09-11 00:55:10.052594	\N	12	\N	45678926	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
163	23	870	\N	2017-09-11 00:55:10.207357	2017-09-11 00:55:10.207357	23	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N
164	23	20	venta	2017-09-11 00:56:11.519042	2017-09-11 00:56:11.969507	50	1	0	45678926	1	14.8726232350688008	\N	2	\N	\N	64	\N	\N	f	\N	\N
165	23	20	venta	2017-09-11 00:56:12.431669	2017-09-11 00:56:12.847485	50	1	0	45678926	1	14.8726232350688008	\N	2	\N	\N	64	\N	\N	f	\N	\N
166	10	100	alta	2017-09-11 01:24:51.355291	2017-09-11 01:24:51.355291	\N	12	\N	13245967	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
167	24	100	alta	2017-09-11 01:24:51.919886	2017-09-11 01:24:51.919886	\N	12	\N	5969214	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
168	26	500	alta	2017-09-11 01:24:52.205165	2017-09-11 01:24:52.205165	\N	12	\N	238944227	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
169	25	300	alta	2017-09-11 01:24:52.518404	2017-09-11 01:24:52.518404	\N	12	\N	238489024	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
170	5	850	alta	2017-09-11 01:25:29.194377	2017-09-11 01:25:35.978066	\N	12	\N	024567890	2	\N	\N	1	\N	\N	\N	\N	\N	t	\N	\N
171	25	450	alta	2017-09-11 01:26:25.81395	2017-09-11 01:26:25.81395	\N	12	\N	238489024	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
172	26	200	alta	2017-09-11 01:26:26.128347	2017-09-11 01:26:26.128347	\N	12	\N	238944227	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
173	21	300	alta	2017-09-11 01:26:26.414676	2017-09-11 01:26:26.414676	\N	12	\N	12345678	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
174	24	300	alta	2017-09-11 01:26:26.802025	2017-09-11 01:26:26.802025	\N	12	\N	5969214	2	\N	\N	1	\N	\N	\N	\N	\N	f	\N	\N
\.


--
-- Name: movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('movements_id_seq', 174, true);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY orders (id, status, delivery_address_id, created_at, updated_at, category, prospect_id, request_id, billing_address_id, carrier_id, store_id, confirm, delivery_notes) FROM stdin;
5	en espera	\N	2017-07-30 20:32:56.397148	2017-07-30 20:32:56.397148	especial	14	96	\N	\N	1	\N	\N
7	\N	\N	2017-08-18 17:58:15.162765	2017-08-18 17:58:15.162765	de línea	\N	\N	\N	\N	1	\N	\N
8	\N	\N	2017-08-18 17:58:23.58663	2017-08-18 17:58:23.58663	de línea	\N	\N	\N	\N	1	\N	\N
9	\N	\N	2017-08-18 17:58:25.189896	2017-08-18 17:58:25.189896	de línea	\N	\N	\N	\N	1	\N	\N
10	\N	\N	2017-08-18 17:58:26.368839	2017-08-18 17:58:26.368839	de línea	\N	\N	\N	\N	1	\N	\N
11	\N	\N	2017-08-18 17:58:27.551993	2017-08-18 17:58:27.551993	de línea	\N	\N	\N	\N	1	\N	\N
12	\N	\N	2017-08-18 17:58:28.224552	2017-08-18 17:58:28.224552	de línea	\N	\N	\N	\N	1	\N	\N
13	\N	\N	2017-08-18 17:58:28.490571	2017-08-18 17:58:28.490571	de línea	\N	\N	\N	\N	1	\N	\N
14	\N	\N	2017-08-18 17:58:28.765308	2017-08-18 17:58:28.765308	de línea	\N	\N	\N	\N	1	\N	\N
15	\N	\N	2017-08-18 17:58:30.576739	2017-08-18 17:58:30.576739	de línea	\N	\N	\N	\N	1	\N	\N
16	\N	\N	2017-08-18 19:40:59.119167	2017-08-18 19:40:59.119167	de línea	\N	\N	\N	\N	1	\N	\N
17	\N	\N	2017-08-18 19:48:10.920262	2017-08-18 19:48:10.920262	de línea	\N	\N	\N	\N	1	\N	\N
18	\N	\N	2017-08-18 21:50:42.141326	2017-08-18 21:50:42.141326	de línea	\N	\N	\N	\N	1	\N	\N
19	\N	\N	2017-08-18 21:52:01.471629	2017-08-18 21:52:01.471629	de línea	\N	\N	\N	\N	1	\N	\N
20	\N	\N	2017-08-18 21:52:57.191555	2017-08-18 21:52:57.191555	de línea	\N	\N	\N	\N	1	\N	\N
21	\N	\N	2017-08-18 22:03:05.147161	2017-08-18 22:03:05.147161	de línea	\N	\N	\N	\N	1	\N	\N
22	\N	\N	2017-08-18 22:03:28.633674	2017-08-18 22:03:28.633674	de línea	\N	\N	\N	\N	1	\N	\N
23	en espera	\N	2017-08-26 18:42:28.970944	2017-08-26 18:42:28.970944	especial	9	75	\N	\N	1	\N	\N
24	en espera	\N	2017-08-30 19:05:57.63169	2017-08-30 19:05:57.63169	de línea	\N	\N	\N	\N	1	\N	\N
2	en espera	\N	2017-07-18 17:46:42.338014	2017-08-30 21:09:17.611475	special	14	93	\N	\N	1	\N	\N
3	en espera	\N	2017-07-29 19:38:37.483716	2017-08-30 21:09:17.622452	special	14	95	\N	\N	1	\N	\N
6	preparando	\N	2017-07-30 22:45:55.38896	2017-09-06 16:37:02.271474	\N	\N	\N	\N	\N	1	\N	\N
1	preparando	\N	2017-07-18 17:12:41.694135	2017-09-06 16:39:23.836121	special	14	93	\N	\N	1	\N	\N
25	en espera	25	2017-09-08 21:02:40.74756	2017-09-08 21:02:40.74756	\N	\N	\N	\N	\N	39	\N	\N
4	en espera	\N	2017-07-30 15:34:02.862144	2017-09-08 22:32:24.272192	special	14	93	\N	\N	1	\N	\N
26	\N	16	2017-09-10 18:18:30.045598	2017-09-10 18:18:30.045598	de línea	\N	\N	\N	\N	1	\N	\N
27	\N	16	2017-09-10 18:56:54.397561	2017-09-10 18:56:54.397561	de línea	\N	\N	\N	\N	1	\N	\N
28	\N	16	2017-09-10 19:09:27.912258	2017-09-10 19:09:27.912258	de línea	\N	\N	\N	\N	1	\N	\N
29	\N	16	2017-09-10 19:09:40.839068	2017-09-10 19:09:40.839068	de línea	\N	\N	\N	\N	1	\N	\N
30	\N	16	2017-09-10 19:09:42.940406	2017-09-10 19:09:42.940406	de línea	\N	\N	\N	\N	1	\N	\N
31	\N	16	2017-09-10 19:13:10.750599	2017-09-10 19:13:10.750599	de línea	\N	\N	\N	\N	1	\N	\N
32	\N	16	2017-09-10 19:14:22.848338	2017-09-10 19:14:22.848338	de línea	\N	\N	\N	\N	1	\N	\N
33	\N	16	2017-09-10 19:48:39.707399	2017-09-10 19:48:52.275144	de línea	\N	\N	\N	\N	1	t	\N
34	\N	16	2017-09-10 19:59:42.877669	2017-09-10 20:00:45.765161	de línea	\N	\N	\N	\N	1	t	\N
35	\N	16	2017-09-10 21:34:55.340258	2017-09-10 21:34:55.340258	de línea	\N	\N	\N	\N	1	\N	\N
36	\N	16	2017-09-10 21:37:58.212592	2017-09-10 21:37:58.212592	de línea	\N	\N	\N	\N	1	\N	\N
37	\N	16	2017-09-10 21:38:24.346552	2017-09-10 21:38:24.346552	de línea	\N	\N	\N	\N	1	\N	\N
38	\N	16	2017-09-10 22:13:25.351531	2017-09-10 22:13:25.351531	de línea	\N	\N	\N	\N	1	\N	\N
39	\N	16	2017-09-10 22:13:40.231191	2017-09-10 22:13:40.231191	de línea	\N	\N	\N	\N	1	\N	\N
40	\N	16	2017-09-10 22:13:47.448324	2017-09-10 22:13:47.448324	de línea	\N	\N	\N	\N	1	\N	\N
41	\N	16	2017-09-10 22:14:42.23101	2017-09-10 22:14:42.23101	de línea	\N	\N	\N	\N	1	\N	\N
42	\N	16	2017-09-10 23:49:33.233322	2017-09-10 23:53:41.058247	de línea	\N	\N	\N	\N	1	t	\N
43	\N	16	2017-09-11 00:11:55.560497	2017-09-11 00:22:13.886215	de línea	\N	\N	\N	\N	1	t	\N
44	\N	16	2017-09-11 00:24:54.310513	2017-09-11 00:24:54.310513	de línea	\N	\N	\N	\N	1	\N	\N
45	\N	16	2017-09-11 00:30:01.17737	2017-09-11 00:39:57.283065	de línea	\N	\N	\N	\N	1	t	\N
46	\N	16	2017-09-11 00:40:43.319509	2017-09-11 00:40:43.319509	de línea	\N	\N	\N	\N	1	\N	\N
47	\N	16	2017-09-11 00:43:14.748921	2017-09-11 00:43:14.748921	de línea	\N	\N	\N	\N	1	\N	\N
48	\N	16	2017-09-11 00:49:30.352812	2017-09-11 00:49:30.352812	de línea	\N	\N	\N	\N	1	\N	\N
49	\N	16	2017-09-11 00:51:26.163436	2017-09-11 00:51:26.163436	de línea	\N	\N	\N	\N	1	\N	\N
50	\N	16	2017-09-11 00:56:10.656382	2017-09-11 00:56:10.656382	de línea	\N	\N	\N	\N	1	\N	\N
\.


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('orders_id_seq', 50, true);


--
-- Data for Name: orders_users; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY orders_users (id, order_id, user_id, created_at, updated_at) FROM stdin;
1	24	9	2017-08-30 19:07:47.236766	2017-08-30 19:07:47.236766
2	3	9	2017-09-01 00:31:20.966657	2017-09-01 00:31:20.966657
3	3	12	2017-09-01 01:06:17.66314	2017-09-01 01:06:17.66314
4	23	9	2017-09-01 01:23:36.835434	2017-09-01 01:23:36.835434
5	23	12	2017-09-01 01:35:55.828682	2017-09-01 01:35:55.828682
6	6	12	2017-09-06 16:37:02.217106	2017-09-06 16:37:02.217106
7	1	12	2017-09-06 16:39:11.479578	2017-09-06 16:39:11.479578
8	26	1	2017-09-10 18:18:30.127897	2017-09-10 18:18:30.127897
9	27	1	2017-09-10 18:56:54.425974	2017-09-10 18:56:54.425974
10	28	1	2017-09-10 19:09:27.949004	2017-09-10 19:09:27.949004
11	29	1	2017-09-10 19:09:40.849051	2017-09-10 19:09:40.849051
12	30	1	2017-09-10 19:09:42.951205	2017-09-10 19:09:42.951205
13	31	1	2017-09-10 19:13:10.767409	2017-09-10 19:13:10.767409
14	32	1	2017-09-10 19:14:22.867416	2017-09-10 19:14:22.867416
15	33	1	2017-09-10 19:48:39.739884	2017-09-10 19:48:39.739884
16	34	1	2017-09-10 19:59:42.901253	2017-09-10 19:59:42.901253
17	35	1	2017-09-10 21:34:55.535362	2017-09-10 21:34:55.535362
18	36	1	2017-09-10 21:37:58.261259	2017-09-10 21:37:58.261259
19	37	1	2017-09-10 21:38:24.374024	2017-09-10 21:38:24.374024
20	38	1	2017-09-10 22:13:25.391065	2017-09-10 22:13:25.391065
21	39	1	2017-09-10 22:13:40.246959	2017-09-10 22:13:40.246959
22	40	1	2017-09-10 22:13:47.463491	2017-09-10 22:13:47.463491
23	41	1	2017-09-10 22:14:42.248855	2017-09-10 22:14:42.248855
24	42	1	2017-09-10 23:49:33.385789	2017-09-10 23:49:33.385789
25	43	1	2017-09-11 00:11:55.621868	2017-09-11 00:11:55.621868
26	44	1	2017-09-11 00:24:54.342096	2017-09-11 00:24:54.342096
27	45	1	2017-09-11 00:30:01.211817	2017-09-11 00:30:01.211817
28	46	1	2017-09-11 00:40:43.355248	2017-09-11 00:40:43.355248
29	47	1	2017-09-11 00:43:14.765935	2017-09-11 00:43:14.765935
30	48	1	2017-09-11 00:49:30.395694	2017-09-11 00:49:30.395694
31	49	1	2017-09-11 00:51:26.252176	2017-09-11 00:51:26.252176
32	50	1	2017-09-11 00:56:10.755975	2017-09-11 00:56:10.755975
\.


--
-- Name: orders_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('orders_users_id_seq', 32, true);


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY payments (id, payment_date, amount, bill_received_id, supplier_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('payments_id_seq', 1, false);


--
-- Data for Name: pending_movements; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY pending_movements (id, product_id, quantity, created_at, updated_at, order_id, cost, unique_code, store_id, initial_price, supplier_id, movement_type, user_id, business_unit_id, prospect_id, bill_id, product_request_id, maximum_date, discount_applied, final_price) FROM stdin;
2	9	430	2017-07-18 17:46:42.39088	2017-07-18 17:46:42.39088	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	11	540	2017-07-29 19:38:37.613723	2017-07-29 19:38:37.613723	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	12	430	2017-07-30 15:34:03.114094	2017-07-30 15:34:03.114094	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
5	14	900	2017-07-30 20:32:56.651529	2017-07-30 20:32:56.651529	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
6	11	200	2017-08-09 01:38:36.539462	2017-08-09 01:38:36.539462	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	16	500	2017-08-18 17:58:15.592984	2017-08-18 17:58:15.592984	7	\N	02456794	1	43.5	\N	venta	1	2	\N	\N	7	\N	\N	\N
8	16	500	2017-08-18 17:58:23.63715	2017-08-18 17:58:23.63715	8	\N	02456794	1	43.5	\N	venta	1	2	\N	\N	9	\N	\N	\N
9	16	500	2017-08-18 17:58:25.241739	2017-08-18 17:58:25.241739	9	\N	02456794	1	43.5	\N	venta	1	2	\N	\N	11	\N	\N	\N
10	16	500	2017-08-18 17:58:26.427309	2017-08-18 17:58:26.427309	10	\N	02456794	1	43.5	\N	venta	1	2	\N	\N	13	\N	\N	\N
11	16	500	2017-08-18 17:58:27.589749	2017-08-18 17:58:27.589749	11	\N	02456794	1	43.5	\N	venta	1	2	\N	\N	15	\N	\N	\N
12	16	500	2017-08-18 17:58:28.264489	2017-08-18 17:58:28.264489	12	\N	02456794	1	43.5	\N	venta	1	2	\N	\N	17	\N	\N	\N
13	16	500	2017-08-18 17:58:28.540464	2017-08-18 17:58:28.540464	13	\N	02456794	1	43.5	\N	venta	1	2	\N	\N	19	\N	\N	\N
14	16	500	2017-08-18 17:58:28.806089	2017-08-18 17:58:28.806089	14	\N	02456794	1	43.5	\N	venta	1	2	\N	\N	21	\N	\N	\N
15	16	500	2017-08-18 17:58:30.633002	2017-08-18 17:58:30.633002	15	\N	02456794	1	43.5	\N	venta	1	2	\N	\N	23	\N	\N	\N
16	23	870	2017-08-26 18:42:29.244709	2017-08-26 18:42:29.244709	23	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
17	4	300	2017-09-10 19:09:23.732853	2017-09-10 19:09:23.732853	27	\N	012345678	1	\N	\N	venta	1	2	\N	\N	34	2017-09-30	\N	\N
18	14	200	2017-09-10 19:09:27.177166	2017-09-10 19:09:27.177166	27	\N	02456792	1	\N	\N	venta	1	2	\N	\N	35	\N	\N	\N
19	4	300	2017-09-10 19:09:32.541473	2017-09-10 19:09:32.541473	28	\N	012345678	1	\N	\N	venta	1	2	\N	\N	36	2017-09-30	\N	\N
20	14	200	2017-09-10 19:09:40.761112	2017-09-10 19:09:40.761112	28	\N	02456792	1	\N	\N	venta	1	2	\N	\N	37	\N	\N	\N
21	4	300	2017-09-10 19:09:42.113319	2017-09-10 19:09:42.113319	29	\N	012345678	1	\N	\N	venta	1	2	\N	\N	38	2017-09-30	\N	\N
22	14	200	2017-09-10 19:09:42.853316	2017-09-10 19:09:42.853316	29	\N	02456792	1	\N	\N	venta	1	2	\N	\N	39	\N	\N	\N
23	4	300	2017-09-10 19:09:44.470025	2017-09-10 19:09:44.470025	30	\N	012345678	1	\N	\N	venta	1	2	\N	\N	40	2017-09-30	\N	\N
25	7	200	2017-09-10 19:13:40.856195	2017-09-10 19:13:40.856195	31	\N	70976487	1	\N	\N	venta	1	2	\N	\N	42	\N	\N	\N
26	11	300	2017-09-10 19:14:22.947402	2017-09-10 19:14:22.947402	32	\N	43986239	1	\N	\N	venta	1	2	\N	\N	43	\N	\N	\N
27	12	200	2017-09-10 19:14:22.98774	2017-09-10 19:14:22.98774	32	\N	20326554	1	\N	\N	venta	1	2	\N	\N	44	\N	\N	\N
28	12	240	2017-09-10 19:48:39.902504	2017-09-10 19:48:39.902504	33	\N	20326554	1	\N	\N	venta	1	2	\N	\N	45	\N	\N	\N
29	11	2000	2017-09-10 19:59:42.957056	2017-09-10 19:59:42.957056	34	\N	43986239	1	14.3023185216329995	\N	venta	1	2	\N	\N	47	2017-09-27	\N	\N
30	17	800	2017-09-10 19:59:43.04231	2017-09-10 19:59:43.04231	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
31	17	100	2017-09-10 19:59:43.701385	2017-09-10 19:59:43.701385	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
32	17	100	2017-09-10 19:59:43.721054	2017-09-10 19:59:43.721054	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
33	17	100	2017-09-10 19:59:43.743348	2017-09-10 19:59:43.743348	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
34	17	100	2017-09-10 19:59:43.769672	2017-09-10 19:59:43.769672	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
35	17	100	2017-09-10 19:59:43.788544	2017-09-10 19:59:43.788544	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
36	17	100	2017-09-10 19:59:43.809852	2017-09-10 19:59:43.809852	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
37	17	100	2017-09-10 19:59:43.821963	2017-09-10 19:59:43.821963	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
38	17	100	2017-09-10 19:59:43.843121	2017-09-10 19:59:43.843121	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
39	17	100	2017-09-10 19:59:43.857122	2017-09-10 19:59:43.857122	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
40	17	100	2017-09-10 19:59:43.876239	2017-09-10 19:59:43.876239	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
41	17	100	2017-09-10 19:59:43.898419	2017-09-10 19:59:43.898419	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
42	17	100	2017-09-10 19:59:43.909048	2017-09-10 19:59:43.909048	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
43	17	100	2017-09-10 19:59:43.931324	2017-09-10 19:59:43.931324	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
44	17	100	2017-09-10 19:59:43.943034	2017-09-10 19:59:43.943034	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
45	17	100	2017-09-10 19:59:43.964202	2017-09-10 19:59:43.964202	34	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	48	\N	\N	\N
46	17	800	2017-09-10 21:38:23.934657	2017-09-10 21:38:23.934657	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
47	17	100	2017-09-10 21:38:23.974847	2017-09-10 21:38:23.974847	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
48	17	100	2017-09-10 21:38:23.995972	2017-09-10 21:38:23.995972	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
49	17	100	2017-09-10 21:38:24.019636	2017-09-10 21:38:24.019636	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
50	17	100	2017-09-10 21:38:24.041521	2017-09-10 21:38:24.041521	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
51	17	100	2017-09-10 21:38:24.064009	2017-09-10 21:38:24.064009	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
52	17	100	2017-09-10 21:38:24.088961	2017-09-10 21:38:24.088961	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
53	17	100	2017-09-10 21:38:24.109315	2017-09-10 21:38:24.109315	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
54	17	100	2017-09-10 21:38:24.129489	2017-09-10 21:38:24.129489	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
55	17	100	2017-09-10 21:38:24.150248	2017-09-10 21:38:24.150248	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
56	17	100	2017-09-10 21:38:24.163325	2017-09-10 21:38:24.163325	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
57	17	100	2017-09-10 21:38:24.183439	2017-09-10 21:38:24.183439	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
58	17	100	2017-09-10 21:38:24.19695	2017-09-10 21:38:24.19695	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
59	17	100	2017-09-10 21:38:24.218701	2017-09-10 21:38:24.218701	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
60	17	100	2017-09-10 21:38:24.239114	2017-09-10 21:38:24.239114	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
61	17	100	2017-09-10 21:38:24.251794	2017-09-10 21:38:24.251794	36	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	50	\N	\N	\N
62	17	800	2017-09-10 21:38:28.663566	2017-09-10 21:38:28.663566	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
63	17	100	2017-09-10 21:38:28.68201	2017-09-10 21:38:28.68201	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
64	17	100	2017-09-10 21:38:28.704537	2017-09-10 21:38:28.704537	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
65	17	100	2017-09-10 21:38:28.726724	2017-09-10 21:38:28.726724	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
66	17	100	2017-09-10 21:38:28.749303	2017-09-10 21:38:28.749303	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
67	17	100	2017-09-10 21:38:28.770637	2017-09-10 21:38:28.770637	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
68	17	100	2017-09-10 21:38:28.793082	2017-09-10 21:38:28.793082	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
69	17	100	2017-09-10 21:38:28.838008	2017-09-10 21:38:28.838008	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
70	17	100	2017-09-10 21:38:28.855893	2017-09-10 21:38:28.855893	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
71	17	100	2017-09-10 21:38:28.882826	2017-09-10 21:38:28.882826	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
72	17	100	2017-09-10 21:38:28.905836	2017-09-10 21:38:28.905836	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
73	17	100	2017-09-10 21:38:28.947222	2017-09-10 21:38:28.947222	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
74	17	100	2017-09-10 21:38:28.973489	2017-09-10 21:38:28.973489	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
75	17	100	2017-09-10 21:38:28.992854	2017-09-10 21:38:28.992854	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
76	17	100	2017-09-10 21:38:29.012586	2017-09-10 21:38:29.012586	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
77	17	100	2017-09-10 21:38:29.035384	2017-09-10 21:38:29.035384	37	0	02456799	1	12.6885604507215994	\N	venta	1	2	\N	\N	51	\N	\N	\N
78	21	900	2017-09-10 22:14:42.375251	2017-09-10 22:14:42.375251	41	\N	12345678	1	15	\N	venta	1	2	\N	\N	52	\N	\N	\N
79	4	\N	2017-09-11 00:41:00.485716	2017-09-11 00:41:00.485716	46	\N	012345678	1	11.1556488558300995	\N	venta	1	2	\N	\N	61	\N	\N	\N
80	4	\N	2017-09-11 00:43:30.882703	2017-09-11 00:43:30.882703	47	\N	012345678	1	11.1556488558300995	\N	venta	1	2	\N	\N	62	\N	\N	\N
\.


--
-- Name: pending_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('pending_movements_id_seq', 81, true);


--
-- Data for Name: product_requests; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY product_requests (id, product_id, quantity, status, order_id, urgency_level, maximum_date, created_at, updated_at, delivery_package_id) FROM stdin;
2	12	430	\N	4	\N	2017-07-25	2017-07-30 15:34:02.925194	2017-07-30 15:34:02.925194	\N
3	14	900	\N	5	\N	2017-07-31	2017-07-30 20:32:56.493025	2017-07-30 20:32:56.493025	\N
4	16	400	asignado	6	\N	\N	2017-07-30 22:49:04.424038	2017-07-30 22:49:04.424038	\N
5	16	500	asignado	6	\N	\N	2017-07-30 22:49:35.940021	2017-07-30 22:49:35.940021	\N
6	16	300	asignado	6	\N	\N	2017-07-30 22:49:38.801981	2017-07-30 22:49:38.801981	\N
7	16	500	sin asignar	7	alta	\N	2017-08-18 17:58:15.39676	2017-08-18 17:58:15.491854	\N
8	21	10	\N	7	alta	\N	2017-08-18 17:58:15.644383	2017-08-18 17:58:15.644383	\N
9	16	500	sin asignar	8	alta	\N	2017-08-18 17:58:23.603975	2017-08-18 17:58:23.617981	\N
10	21	10	\N	8	alta	\N	2017-08-18 17:58:23.658494	2017-08-18 17:58:23.658494	\N
11	16	500	sin asignar	9	alta	\N	2017-08-18 17:58:25.208765	2017-08-18 17:58:25.22248	\N
12	21	10	\N	9	alta	\N	2017-08-18 17:58:25.252402	2017-08-18 17:58:25.252402	\N
13	16	500	sin asignar	10	alta	\N	2017-08-18 17:58:26.393475	2017-08-18 17:58:26.407979	\N
14	21	10	\N	10	alta	\N	2017-08-18 17:58:26.447873	2017-08-18 17:58:26.447873	\N
15	16	500	sin asignar	11	alta	\N	2017-08-18 17:58:27.565883	2017-08-18 17:58:27.578756	\N
16	21	10	\N	11	alta	\N	2017-08-18 17:58:27.610015	2017-08-18 17:58:27.610015	\N
17	16	500	sin asignar	12	alta	\N	2017-08-18 17:58:28.24157	2017-08-18 17:58:28.254191	\N
18	21	10	\N	12	alta	\N	2017-08-18 17:58:28.284944	2017-08-18 17:58:28.284944	\N
19	16	500	sin asignar	13	alta	\N	2017-08-18 17:58:28.507427	2017-08-18 17:58:28.520752	\N
20	21	10	\N	13	alta	\N	2017-08-18 17:58:28.551091	2017-08-18 17:58:28.551091	\N
21	16	500	sin asignar	14	alta	\N	2017-08-18 17:58:28.784088	2017-08-18 17:58:28.796941	\N
22	21	10	\N	14	alta	\N	2017-08-18 17:58:28.816655	2017-08-18 17:58:28.816655	\N
23	16	500	sin asignar	15	alta	\N	2017-08-18 17:58:30.599331	2017-08-18 17:58:30.61396	\N
24	21	10	\N	15	alta	\N	2017-08-18 17:58:30.645238	2017-08-18 17:58:30.645238	\N
25	2	100	\N	16	alta	\N	2017-08-18 19:40:59.294889	2017-08-18 19:40:59.294889	\N
26	2	120	\N	17	alta	2017-08-29	2017-08-18 19:48:10.960135	2017-08-18 19:48:10.971223	\N
27	2	500	\N	18	alta	\N	2017-08-18 21:50:42.237612	2017-08-18 21:50:42.237612	\N
28	2	500	\N	19	alta	2017-08-29	2017-08-18 21:52:01.492719	2017-08-18 21:52:01.503865	\N
29	2	300	\N	20	alta	\N	2017-08-18 21:52:57.219024	2017-08-18 21:52:57.219024	\N
30	2	300	\N	21	alta	\N	2017-08-18 22:03:05.214836	2017-08-18 22:03:05.214836	\N
31	2	200	\N	22	alta	2017-08-29	2017-08-18 22:03:28.65741	2017-08-18 22:03:28.678449	\N
32	23	870	\N	23	\N	\N	2017-08-26 18:42:29.096702	2017-08-26 18:42:29.096702	\N
1	11	540	asignado	3	\N	2017-07-30	2017-07-29 19:53:42.764158	2017-09-06 17:55:45.352264	\N
33	17	0	\N	26	alta	\N	2017-09-10 18:55:30.83404	2017-09-10 18:55:30.83404	\N
58	2	100	\N	44	normal	\N	2017-09-11 00:25:25.254957	2017-09-11 00:25:25.254957	\N
34	4	300	sin asignar	27	alta	2017-09-30	2017-09-10 19:09:23.655221	2017-09-10 19:09:23.687038	\N
35	14	200	sin asignar	27	alta	\N	2017-09-10 19:09:27.13436	2017-09-10 19:09:27.158856	\N
59	17	101	\N	45	normal	\N	2017-09-11 00:31:02.0674	2017-09-11 00:31:02.0674	\N
36	4	300	sin asignar	28	alta	2017-09-30	2017-09-10 19:09:32.417471	2017-09-10 19:09:32.470038	\N
37	14	200	sin asignar	28	alta	\N	2017-09-10 19:09:40.71403	2017-09-10 19:09:40.742417	\N
60	2	100	\N	45	normal	\N	2017-09-11 00:36:34.728717	2017-09-11 00:36:34.728717	\N
38	4	300	sin asignar	29	alta	2017-09-30	2017-09-10 19:09:42.061688	2017-09-10 19:09:42.099683	\N
39	14	200	sin asignar	29	alta	\N	2017-09-10 19:09:42.813257	2017-09-10 19:09:42.836672	\N
40	4	300	sin asignar	30	alta	2017-09-30	2017-09-10 19:09:44.405471	2017-09-10 19:09:44.448374	\N
42	7	200	sin asignar	31	normal	\N	2017-09-10 19:13:40.825364	2017-09-10 19:13:40.84756	\N
43	11	300	sin asignar	32	normal	\N	2017-09-10 19:14:22.907364	2017-09-10 19:14:22.924802	\N
44	12	200	sin asignar	32	normal	\N	2017-09-10 19:14:22.968531	2017-09-10 19:14:22.979424	\N
45	12	240	sin asignar	33	alta	\N	2017-09-10 19:48:39.807687	2017-09-10 19:48:39.830545	\N
46	2	230	\N	33	normal	\N	2017-09-10 19:48:39.92026	2017-09-10 19:48:39.92026	\N
61	4	100	sin asignar	46	alta	\N	2017-09-11 00:40:46.355721	2017-09-11 00:40:51.359777	\N
47	11	2000	sin asignar	34	alta	2017-09-27	2017-09-10 19:59:42.916188	2017-09-10 19:59:42.944556	\N
48	17	400	\N	34	normal	\N	2017-09-10 19:59:42.980326	2017-09-10 19:59:42.980326	\N
49	2	50	\N	35	normal	\N	2017-09-10 21:35:13.01641	2017-09-10 21:35:13.01641	\N
50	17	20	\N	36	normal	\N	2017-09-10 21:38:23.781347	2017-09-10 21:38:23.781347	\N
51	17	20	\N	37	normal	\N	2017-09-10 21:38:28.627813	2017-09-10 21:38:28.627813	\N
52	21	900	sin asignar	41	normal	\N	2017-09-10 22:14:42.305114	2017-09-10 22:14:42.338847	\N
53	3	100	\N	42	normal	\N	2017-09-10 23:49:33.493142	2017-09-10 23:49:33.493142	\N
54	17	100	\N	42	normal	\N	2017-09-10 23:49:34.092899	2017-09-10 23:49:34.092899	\N
55	2	50	\N	42	alta	2017-09-20	2017-09-10 23:49:35.455486	2017-09-10 23:49:35.464224	\N
56	17	100	\N	43	normal	\N	2017-09-11 00:15:32.819242	2017-09-11 00:15:32.819242	\N
57	2	100	\N	43	alta	2017-09-28	2017-09-11 00:19:00.404562	2017-09-11 00:20:45.071661	\N
62	4	100	sin asignar	47	alta	\N	2017-09-11 00:43:19.876627	2017-09-11 00:43:26.116352	\N
63	23	100	asignado	49	normal	\N	2017-09-11 00:51:26.500583	2017-09-11 00:52:50.040616	\N
41	23	300	asignado	31	normal	\N	2017-09-10 19:13:38.951116	2017-09-11 00:54:24.759268	\N
64	23	20	\N	50	normal	\N	2017-09-11 00:56:10.890344	2017-09-11 00:56:10.890344	\N
\.


--
-- Name: product_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('product_requests_id_seq', 64, true);


--
-- Data for Name: product_sales; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY product_sales (id, sales_amount, sales_quantity, cost, created_at, updated_at, product_id, month, year) FROM stdin;
1	0	100	0	2017-08-18 21:50:42.63862	2017-08-18 21:50:42.885835	2	8	2017
2	0	20	0	2017-09-10 19:59:43.250526	2017-09-11 00:56:12.632873	23	9	2017
\.


--
-- Name: product_sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('product_sales_id_seq', 2, true);


--
-- Data for Name: production_orders; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY production_orders (id, user_id, created_at, updated_at, status) FROM stdin;
\.


--
-- Name: production_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('production_orders_id_seq', 1, false);


--
-- Data for Name: production_requests; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY production_requests (id, product_id, quantity, status, production_order_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: production_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('production_requests_id_seq', 1, false);


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY products (id, former_code, unique_code, description, product_type, exterior_material_color, interior_material_color, impression, exterior_color_or_design, main_material, resistance_main_material, inner_length, inner_width, inner_height, outer_length, outer_width, outer_height, design_type, number_of_pieces, accesories_kit, created_at, updated_at, price, bag_length, bag_width, bag_height, exhibitor_height, tray_quantity, tray_length, tray_width, tray_divisions, classification, line, image, pieces_per_package, business_unit_id, warehouse_id, cost, rack, level) FROM stdin;
10	6004	13245967	Bolsa personalizada	bolsa	\N	\N	f		papel kraft	No aplica	\N	\N	\N	\N	\N	\N		\N		2017-07-29 19:37:32.029294	2017-09-11 01:05:15.151359	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	\N	1	\N	\N	\N
17	7004	02456799	Bolsa personalizada con bandeja de color kraft	caja	kraft	kraft	\N				\N	\N	\N	\N	\N	\N		\N		2017-08-03 17:33:59.268054	2017-09-10 19:58:51.847509	12.6885604507215746	\N	\N	\N	\N	\N	\N	\N	\N	de línea		\N	1	1	1	8.43819563393554795	\N	\N
18	6001	02456699	Caja personalizada con bandeja de color kraft	caja			\N				\N	\N	\N	\N	\N	\N		\N		2017-08-03 22:41:15.355791	2017-09-10 19:58:51.869176	14.9958587495489724	\N	\N	\N	\N	\N	\N	\N	\N	de línea	empaque y embalaje	\N	1	1	1	7.72666959442216683	\N	\N
24	5969214	5969214	Nuevo producto de prueba	caja	kraft	kraft	\N	negro	caple	14 PTS	20	20	20	21	21	21	Muñeca	1	ninguno	2017-09-11 01:16:29.801068	2017-09-11 01:16:29.801068	10	\N	\N	\N	\N	\N	\N	\N	\N	de línea	hogar	\N	1	5	2	8	2A	1
2	0002	0002	caja chica	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	muñeca	\N	\N	2017-06-29 22:01:00.583575	2017-09-10 19:58:51.901646	10.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	1	1	8.9305817864254049	\N	\N
25	238489024	238489024	El otro nuevo producto 	bolsa	kraft	kraft	\N	kraft	papel bond	180 grs	20	10	30	21	11	31	Cierre automático	1	ninguno	2017-09-11 01:18:44.73575	2017-09-11 01:18:44.73575	8	\N	\N	\N	\N	\N	\N	\N	\N	de línea	ecológica	\N	1	1	2	6	3A	2
26	238944227	238944227	Exhibidor nuevo de paquete	exhibidor	bond	kraft	\N	blanco con azul		12kg - 32 ECT	\N	\N	\N	40	30	150		1	ninguno	2017-09-11 01:20:29.639685	2017-09-11 01:20:29.639685	120	\N	\N	\N	\N	\N	\N	\N	\N	de línea		\N	1	5	2	100	5h	4
12	6005	20326554	Bolsa personalizada	bolsa	\N	\N	f		papel kraft	No aplica	\N	\N	\N	\N	\N	\N		\N		2017-07-30 15:34:02.622507	2017-09-10 19:58:51.97802	11.8572550497134728	\N	\N	\N	\N	\N	\N	\N	\N	especial	\N	\N	10	1	1	8.04101117792095899	\N	\N
23	45678926	45678926	Un fabuloso producto bolsa especial 10x10	bolsa	kraft	kraft	f		papel kraft	No aplica	\N	\N	\N	\N	\N	\N		1	ninguno	2017-08-26 18:42:28.767224	2017-09-10 19:58:51.989067	14.8726232350687724	10	10	10	\N	\N	\N	\N	\N	de línea	diseños especiales	\N	10	5	1	8.6955704560864433	\N	\N
11	6004	43986239	Bolsa personalizada	bolsa	\N	\N	f		papel kraft	No aplica	\N	\N	\N	\N	\N	\N		\N		2017-07-29 19:38:37.211567	2017-09-10 19:58:52.000579	14.3023185216330191	\N	\N	\N	\N	\N	\N	\N	\N	especial	\N	\N	10	\N	2	9.09917920878038622	\N	\N
4	6004	012345678	Bolsa personalizada	bolsa	\N	\N	f	kraft	papel kraft	No aplica	\N	\N	\N	\N	\N	\N	N/A	1	N/A	2017-07-18 16:55:52.87415	2017-09-11 01:01:54.500576	11.1556488558301385	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	\N	1	9.23866917039615387	\N	\N
22		AG0001	Caja para cuadros grande	caja	kraft	kraft	\N	Kraft	corrugado	11kg - 29 ECT	50	40	10	50.5	40.5	10.5	Caja regular CR	1	ninguno	2017-08-17 17:49:10.59863	2017-08-17 18:27:56.608293	25.3999999999999986	\N	\N	\N	\N	\N	\N	\N	\N	de tienda	productos de tienda aguascalientes	\N	1	2	3	20	\N	\N
16	6009	02456794	Caja pequeña 	caja			\N				\N	\N	\N	\N	\N	\N		\N		2017-07-30 21:44:09.343873	2017-09-10 19:58:51.720772	43.5	\N	\N	\N	\N	\N	\N	\N	\N	de línea	oficina	\N	10	1	1	8.76994426069997957	\N	\N
1	0001	0001	caja chica	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2017-06-29 19:24:25.848224	2017-09-10 19:58:51.772277	12.0330340359413235	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	1	1	6.81169267244504173	\N	\N
13	6006	02456791	Caja pequeña	Caja	\N	\N	\N				\N	\N	\N	\N	\N	\N		\N		2017-07-30 16:03:55.939584	2017-09-10 19:58:51.790129	15.0209276743499132	\N	\N	\N	\N	\N	\N	\N	\N	especial	\N	\N	10	1	1	7.28272074091278743	\N	\N
14	6007	02456792	Caja grande	caja	\N	\N	f	Kraft	corrugado	7kg - 23 ECT	\N	\N	\N	18	9	9	Caja regular CR	0	N/A	2017-07-30 20:32:55.601053	2017-09-10 19:58:51.800718	11.4808940520858176	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	1	1	6.67572197819753477	\N	\N
21	12345678	12345678	Un nuevo producto sensacional de prueba color azul	caja	bond	kraft	\N	azul	Corrugado	11 ECT	30	30	30	31	31	31	Regalo	1	ninguno	2017-08-11 20:38:26.691035	2017-09-10 19:58:51.818099	15	\N	\N	\N	\N	\N	\N	\N	\N	de línea	hogar	\N	1	1	1	9.11695322197934743	\N	\N
15	6008	02456793	Caja mediana	caja	\N	\N	\N	Kraft			\N	\N	\N	\N	\N	\N		\N		2017-07-30 21:34:49.520782	2017-09-10 19:58:51.833447	13.4021660934251052	\N	\N	\N	\N	\N	\N	\N	\N	de línea	oficina	\N	10	1	1	8.24161904139030632	\N	\N
5	6004	024567890	Bolsa personalizada	bolsa	\N	\N	f	kraft	papel kraft	No aplica	\N	\N	\N	\N	\N	\N	N/A	1	N/A	2017-07-18 17:02:22.041812	2017-09-11 01:01:54.599486	15.2310614676934986	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	\N	1	7.82562093127458258	\N	\N
6	6004	970975387	es la nueva descripcion padre	bolsa			f	kraft	papel kraft	No aplica	\N	\N	\N	\N	\N	\N	N/A	1	N/A	2017-07-18 17:06:08.672811	2017-09-11 01:01:54.619018	10.7008295174754959	\N	\N	\N	\N	\N	\N	\N	\N	de línea		\N	10	\N	1	6.99802676434940629	\N	\N
7	6004	70976487	Bolsa personalizada	bolsa	\N	\N	f	kraft	papel kraft	No aplica	\N	\N	\N	\N	\N	\N	N/A	1	N/A	2017-07-18 17:08:31.546222	2017-09-11 01:01:54.631783	12.4165375318518816	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	\N	1	7.54135636341911031	\N	\N
8	6004	80976469	Bolsa personalizada	bolsa	\N	\N	f	kraft	papel kraft	No aplica	\N	\N	\N	\N	\N	\N	N/A	1	N/A	2017-07-18 17:12:41.577189	2017-09-11 01:01:54.643119	10.8688651821347886	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	\N	1	8.02002452973746571	\N	\N
9	6004	30216514	Bolsa personalizada	bolsa	\N	\N	f	kraft	papel kraft	No aplica	\N	\N	\N	\N	\N	\N	N/A	1	N/A	2017-07-18 17:46:42.205824	2017-09-11 01:01:54.677079	12.307556837439801	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	\N	1	8.03132872012343846	\N	\N
3	6004	324567	Bolsa personalizada	bolsa	\N	\N	f	Kraft	papel kraft	No aplica	\N	\N	\N	\N	\N	\N	N/A	1	N/A	2017-07-17 21:50:10.544658	2017-09-11 01:05:15.1144	9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10	\N	1	\N	\N	\N
\.


--
-- Data for Name: products_bills; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY products_bills (id, product_id, bill_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: products_bills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('products_bills_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('products_id_seq', 26, true);


--
-- Data for Name: prospect_sales; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY prospect_sales (id, prospect_id, sales_amount, sales_quantity, cost, created_at, updated_at, month, year) FROM stdin;
1	1	0	100	0	2017-08-18 21:50:42.545288	2017-08-18 21:50:42.879227	8	2017
2	1	0	20	0	2017-09-10 19:59:43.134196	2017-09-11 00:56:12.561437	9	2017
\.


--
-- Name: prospect_sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('prospect_sales_id_seq', 2, true);


--
-- Data for Name: prospects; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY prospects (id, store_id, created_at, updated_at, prospect_type, contact_first_name, contact_middle_name, contact_last_name, contact_position, direct_phone, extension, cell_phone, business_type, prospect_status, legal_or_business_name, billing_address_id, delivery_address_id, second_last_name, business_unit_id, email, business_group_id, store_code) FROM stdin;
5	1	2017-06-21 16:45:29.160577	2017-08-17 04:47:47.179749	Picar Papas	Pepe	Pecas	Pica	Picador	4491553390	1111	3331223344	\N	\N	Pepe Pecas Pica Papas	\N	\N	Papas	\N	\N	2	\N
6	1	2017-06-21 17:07:22.157355	2017-08-17 04:47:47.232327	que vende	Juan	Pedro	Gonzalez	Comprador	4491553390	1111	3331223344	\N	\N	otra empresa	\N	\N	Perez	\N	\N	2	\N
7	1	2017-06-21 18:22:18.600949	2017-08-17 04:47:47.242801	comercializadora	Pepe	Toño	Gomez	DUeño	3331231231	1234	3331234567	\N	\N	empresita sa de cv	\N	\N	Jimenez	\N	\N	2	\N
8	\N	2017-06-22 16:34:37.602863	2017-08-17 04:47:47.253221	nuevo giro	Favio	Ernesto	Velez	Asistente	3331231231	1234	3331234567	\N	\N	nuevo prospecto	9	12	Perez	\N	\N	2	\N
9	1	2017-06-23 21:02:28.816855	2017-08-17 04:47:47.264261	vendo	Juan	Pablo	Hernandez	Asistente	3331231231	1111	3331234567	\N	\N	soy un prospecto	\N	\N	Gomez	\N	\N	2	\N
10	\N	2017-06-24 18:51:51.25421	2017-08-17 04:47:47.274937	vende mamey	Juan	Eduardo	Camaney	Manager	3331231231	1234	3331234567	\N	\N	juan camaney	\N	\N	Melquiades	\N	\N	2	\N
12	1	2017-07-03 22:09:10.825604	2017-08-17 04:47:47.319264	otro	Juanito	Carlos	Camarena	Asistente	3331231231	1234	3331223344	\N	\N	juan perez	\N	\N	Colon	\N	\N	2	\N
11	1	2017-06-26 16:43:34.520611	2017-08-17 04:47:47.331159	Vende y transporta	Pepe	Pablo	Perez	Asistente	3331231231	1234	3331234567	\N	\N	Juan Perez	10	\N	Prado	\N	\N	2	\N
13	1	2017-07-04 17:16:41.662759	2017-08-17 04:47:47.341923	vende pruebas	Juan	Prueba	Perez	A prueba	3331231231	1234	3331234567	\N	\N	prospecto de prueba	\N	\N	Prueba	\N	\N	2	\N
15	1	2017-07-20 16:07:50.129725	2017-08-17 04:47:47.387795	Vende papas	Juan	Pedro	Estevez	Gerente	3331231231	45010	3331234567	\N	\N	Prospecto completamente nuevo	\N	\N	Fernandez	\N	\N	2	\N
16	1	2017-07-26 16:32:38.331405	2017-08-17 04:47:47.408964	Vende pinturas	Pablo		Picasso	Pintor	3331231231	45010	3331234567	\N	\N	Pablo Picasso	\N	\N	Perez	\N	\N	2	\N
1	3	2017-06-21 16:20:48.532032	2017-08-17 04:47:47.432944	Papelería	Juan	Ernesto	Perez	Compras	3331231231	1234	3331234567	\N	\N	Empresa grande SA de CV	11	\N	Prado	\N	\N	2	\N
2	3	2017-06-21 16:22:11.956626	2017-08-17 04:47:47.486255	Papelería	Juan	Ernesto	Perez	Compras	3331231231	1234	3331234567	\N	\N	Empresa grande SA de CV	\N	\N	\N	\N	\N	2	\N
3	3	2017-06-21 16:28:50.856672	2017-08-17 04:47:47.546595	vende cosas	Pepe	Pecas	Pica	Picador	4491553390	1111	3331223344	\N	\N	Empresa pequeña SA de CV	\N	\N	Papas	\N	\N	2	\N
4	3	2017-06-21 16:33:01.246399	2017-08-17 04:47:47.564663	fabrica cosas	Pepe	Pecas	Pica	Picador	4491553390	1111	3331223344	\N	\N	Empresa mediana SA de CV	\N	\N	Papas	\N	\N	2	\N
14	1	2017-07-11 19:08:53.09884	2017-08-17 04:47:47.586174	Agricultor	José	Juan	Gutierrez	Ingeniero	3331256859	1234	3338143330	\N	\N	Juan Bananas	\N	\N	Belmont	\N	\N	2	\N
17	1	2017-08-17 15:08:48.590616	2017-08-17 15:08:48.590616	Pruena	Pedro	Pruebas	Prueba	Probador	3331231231	12345	3331223344	persona física	\N	Juan Pruebas	\N	\N	Dos	\N	prueba@hotmail.com	\N	\N
18	1	2017-08-17 22:24:28.515801	2017-08-17 22:45:58.456951	Fabricante Bioplásticos	Grecia	Sofía	Simoneen	Coordinadora de Ventas	3331231231	1234	3331234567	persona moral	\N	Biofase	\N	18	Ordóñez	2	greciasofia@biofase.com.mx	2	\N
19	\N	2017-08-19 17:18:54.684409	2017-08-19 17:18:54.684409	comercialización de productos	Favio	Velez	Morales	\N	3334234234	1234	4324439086	persona física	\N	Ags Super Siete	\N	\N	Prueba	\N	favio.velez@hotmail.com	1	016AG
20	\N	2017-08-19 17:20:11.953172	2017-08-19 18:12:24.180007	comercialización de productos	Favio	Velez	Morales	\N	3334234234	1234	4324439086	persona física	\N	Qr Super Ocho	19	\N	Prueba	1	favio.velez@hotmail.com	1	018AG
21	\N	2017-08-19 18:27:28.489688	2017-08-19 18:35:40.199185	comercialización de productos	Pepe	Pecas	Pica	\N	3334234234	1234	4324439086	persona física	\N	Tienda Nueva	\N	22	Papas	1	pepepecas@prueba.com	1	TN001
22	\N	2017-08-19 18:37:48.429904	2017-08-19 18:37:48.429904	comercialización de productos	Juan	Sin	Miedo	\N	3334234234	1234	4324439086	persona física	\N	Una mas	\N	\N	Sin Ventas	1	sinmiedo@juan.com	1	00123
23	\N	2017-08-19 18:48:06.88643	2017-08-19 18:56:21.106834	comercialización de productos	Pepe	Toño	Perez	\N	3334234234	1234	4324439086	persona moral	\N	Tienda Nuevo Grupo	20	25	Hernandez	1	pepetono@hotmail.com	1	NGT001
24	\N	2017-08-20 21:05:25.503922	2017-08-20 21:39:06.525852	comercialización de productos	Juanitos	Bananas	TIene	\N	3334234234	1234	4324439086	persona moral	\N	Nueva tiendala	\N	\N	TIenda	1	pepetono@hotmail.com	1	4567
25	\N	2017-08-26 18:48:09.056284	2017-08-26 18:50:44.585383	comercialización de productos	Pedro	Periciano	Perez	\N	3334234234		4324439086	persona moral	\N	Nueva franquicia	\N	\N	Prado	1	prado@prueba.com	1	0007
\.


--
-- Name: prospects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('prospects_id_seq', 25, true);


--
-- Data for Name: request_users; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY request_users (id, request_id, user_id, created_at, updated_at) FROM stdin;
1	1	6	2017-06-19 17:54:21.917037	2017-06-19 17:54:21.917037
2	1	2	2017-06-20 01:23:33.874527	2017-06-20 01:23:33.874527
3	2	2	2017-06-20 02:12:18.406593	2017-06-20 02:12:18.406593
4	3	1	2017-06-20 02:16:30.774791	2017-06-20 02:16:30.774791
5	4	6	2017-06-20 02:21:36.012345	2017-06-20 02:21:36.012345
6	4	3	2017-06-20 02:21:36.052416	2017-06-20 02:21:36.052416
7	5	9	2017-06-21 18:08:15.485365	2017-06-21 18:08:15.485365
8	5	3	2017-06-21 18:08:15.670645	2017-06-21 18:08:15.670645
9	6	9	2017-06-21 18:13:20.016941	2017-06-21 18:13:20.016941
10	6	3	2017-06-21 18:13:20.078583	2017-06-21 18:13:20.078583
11	7	9	2017-06-21 18:15:05.318204	2017-06-21 18:15:05.325679
12	7	3	2017-06-21 18:15:05.321515	2017-06-21 18:15:05.32938
13	8	9	2017-06-21 18:18:58.311967	2017-06-21 18:18:58.319989
14	8	3	2017-06-21 18:18:58.317076	2017-06-21 18:18:58.322705
15	9	9	2017-06-21 18:19:15.930612	2017-06-21 18:19:15.938548
16	9	3	2017-06-21 18:19:15.933722	2017-06-21 18:19:15.941638
17	10	9	2017-06-21 18:43:20.200342	2017-06-21 18:43:20.20556
18	10	3	2017-06-21 18:43:20.203179	2017-06-21 18:43:20.207876
19	11	9	2017-06-21 19:19:46.344298	2017-06-21 19:19:46.351121
20	11	3	2017-06-21 19:19:46.347671	2017-06-21 19:19:46.354847
21	12	9	2017-06-21 22:02:36.001263	2017-06-21 22:02:36.012845
22	12	3	2017-06-21 22:02:36.008444	2017-06-21 22:02:36.023054
23	13	9	2017-06-29 18:46:11.86886	2017-06-29 18:46:11.919466
24	14	9	2017-06-29 18:51:20.69905	2017-06-29 18:51:20.707322
25	15	9	2017-06-29 18:54:04.500617	2017-06-29 18:54:04.509473
26	16	9	2017-06-29 18:55:33.810082	2017-06-29 18:55:33.8164
27	17	9	2017-06-29 19:08:09.66555	2017-06-29 19:08:09.670909
28	18	9	2017-06-30 16:25:40.944368	2017-06-30 16:25:40.988154
29	19	9	2017-06-30 16:40:10.94537	2017-06-30 16:40:10.94825
30	20	9	2017-07-02 17:37:11.731048	2017-07-02 17:37:11.761577
31	21	9	2017-07-02 18:17:06.282991	2017-07-02 18:17:06.285647
32	22	9	2017-07-02 18:22:56.61199	2017-07-02 18:22:56.614982
33	23	9	2017-07-02 18:29:09.326146	2017-07-02 18:29:09.32827
34	24	9	2017-07-03 20:45:14.055313	2017-07-03 20:45:14.060158
35	25	9	2017-07-04 17:20:22.294695	2017-07-04 17:20:22.335188
36	26	9	2017-07-05 01:52:29.160533	2017-07-05 01:52:29.283643
37	27	9	2017-07-05 01:55:00.871121	2017-07-05 01:55:00.874388
38	28	9	2017-07-05 02:06:42.341806	2017-07-05 02:06:42.377353
39	29	9	2017-07-05 02:18:12.458469	2017-07-05 02:18:12.462301
40	30	9	2017-07-05 02:38:44.709829	2017-07-05 02:38:44.713527
41	31	9	2017-07-05 02:55:41.051665	2017-07-05 02:55:41.089046
42	32	9	2017-07-05 02:59:43.850759	2017-07-05 02:59:43.853031
43	33	9	2017-07-05 17:06:07.111384	2017-07-05 17:06:07.121253
44	34	9	2017-07-05 17:35:37.392807	2017-07-05 17:35:37.397719
45	35	9	2017-07-05 17:44:01.307627	2017-07-05 17:44:01.310852
46	36	9	2017-07-05 17:46:38.754658	2017-07-05 17:46:38.764662
47	37	9	2017-07-05 18:26:02.187272	2017-07-05 18:26:02.201629
48	38	9	2017-07-05 19:53:15.610547	2017-07-05 19:53:15.637695
49	39	9	2017-07-05 20:11:02.110307	2017-07-05 20:11:02.113924
50	40	9	2017-07-05 20:15:44.848887	2017-07-05 20:15:44.882972
51	41	9	2017-07-05 20:28:04.880017	2017-07-05 20:28:04.883397
52	42	9	2017-07-05 23:27:26.910427	2017-07-05 23:27:26.963462
53	43	9	2017-07-05 23:50:05.277891	2017-07-05 23:50:05.281533
54	4	7	2017-07-07 01:05:52.188672	2017-07-07 01:05:52.188672
55	31	7	2017-07-07 01:11:16.259744	2017-07-07 01:11:16.259744
56	44	9	2017-07-07 04:21:22.953012	2017-07-07 04:21:23.01682
57	45	9	2017-07-07 04:21:50.164978	2017-07-07 04:21:50.167959
58	46	9	2017-07-07 04:28:10.519909	2017-07-07 04:28:10.524853
59	47	9	2017-07-07 04:30:25.354112	2017-07-07 04:30:25.366858
60	48	9	2017-07-07 19:03:13.27357	2017-07-07 19:03:13.287903
61	49	9	2017-07-07 19:34:29.147976	2017-07-07 19:34:29.173946
62	50	9	2017-07-07 19:35:25.173751	2017-07-07 19:35:25.197654
63	51	9	2017-07-07 20:05:02.469648	2017-07-07 20:05:02.489632
64	52	9	2017-07-07 21:31:32.673661	2017-07-07 21:31:32.676903
65	53	9	2017-07-07 21:33:12.643588	2017-07-07 21:33:12.648621
66	54	9	2017-07-07 21:36:21.293363	2017-07-07 21:36:21.297352
67	55	9	2017-07-07 21:41:59.782022	2017-07-07 21:41:59.78658
68	56	9	2017-07-07 21:45:52.019915	2017-07-07 21:45:52.024119
69	57	9	2017-07-07 21:46:32.537369	2017-07-07 21:46:32.540918
70	58	9	2017-07-07 21:49:47.993074	2017-07-07 21:49:47.996782
71	59	9	2017-07-07 22:48:33.653106	2017-07-07 22:48:33.725216
72	60	9	2017-07-07 22:53:14.950542	2017-07-07 22:53:14.950542
73	61	9	2017-07-08 19:47:34.953456	2017-07-08 19:47:34.953456
74	62	9	2017-07-08 20:09:09.799781	2017-07-08 20:09:09.799781
75	63	9	2017-07-08 20:17:22.971271	2017-07-08 20:17:22.971271
76	64	9	2017-07-08 20:20:35.074976	2017-07-08 20:20:35.074976
77	65	9	2017-07-08 20:22:00.393997	2017-07-08 20:22:00.393997
78	66	9	2017-07-08 20:30:49.214837	2017-07-08 20:30:49.214837
79	67	9	2017-07-08 22:14:04.83956	2017-07-08 22:14:04.83956
80	68	9	2017-07-08 22:20:09.254172	2017-07-08 22:20:09.254172
81	69	9	2017-07-08 22:59:45.221693	2017-07-08 22:59:45.221693
82	70	9	2017-07-08 23:03:40.088301	2017-07-08 23:03:40.088301
83	71	9	2017-07-08 23:04:24.551207	2017-07-08 23:04:24.551207
84	72	9	2017-07-09 16:18:42.177602	2017-07-09 16:18:42.177602
85	73	9	2017-07-09 18:07:43.443201	2017-07-09 18:07:43.443201
86	74	9	2017-07-09 18:13:56.739224	2017-07-09 18:13:56.739224
87	75	9	2017-07-09 20:16:40.679992	2017-07-09 20:16:40.679992
88	76	9	2017-07-09 20:24:45.195315	2017-07-09 20:24:45.195315
89	77	9	2017-07-09 22:03:41.686257	2017-07-09 22:03:41.686257
90	78	9	2017-07-09 22:42:24.070755	2017-07-09 22:42:24.070755
91	79	9	2017-07-09 22:52:28.548404	2017-07-09 22:52:28.548404
92	80	9	2017-07-11 17:11:35.862628	2017-07-11 17:11:35.862628
93	74	2	2017-07-11 18:53:52.329061	2017-07-11 18:53:52.329061
94	81	9	2017-07-11 19:13:45.405892	2017-07-11 19:13:45.405892
95	81	2	2017-07-11 21:10:02.94474	2017-07-11 21:10:02.94474
96	82	9	2017-07-12 15:32:47.17114	2017-07-12 15:32:47.17114
97	82	2	2017-07-12 15:39:22.905838	2017-07-12 15:39:22.905838
98	67	2	2017-07-13 15:51:24.225472	2017-07-13 15:51:24.225472
99	75	2	2017-07-13 17:49:29.483307	2017-07-13 17:49:29.483307
100	83	9	2017-07-13 18:06:20.064972	2017-07-13 18:06:20.06979
101	83	2	2017-07-13 18:06:43.314078	2017-07-13 18:06:43.314078
102	84	9	2017-07-14 14:37:39.33476	2017-07-14 14:37:39.398056
103	84	2	2017-07-14 14:38:31.671423	2017-07-14 14:38:31.671423
104	85	9	2017-07-14 17:33:51.902128	2017-07-14 17:33:51.915879
105	86	9	2017-07-14 17:36:54.635536	2017-07-14 17:36:54.635536
106	87	9	2017-07-14 17:37:25.278657	2017-07-14 17:37:25.278657
107	88	9	2017-07-14 17:52:40.724906	2017-07-14 17:52:40.724906
108	89	9	2017-07-14 17:52:51.088075	2017-07-14 17:52:51.088075
109	89	2	2017-07-14 17:53:54.795838	2017-07-14 17:53:54.795838
110	90	9	2017-07-14 18:57:06.528872	2017-07-14 18:57:06.528872
111	91	9	2017-07-14 18:57:49.221562	2017-07-14 18:57:49.221562
112	90	2	2017-07-14 18:58:34.103904	2017-07-14 18:58:34.103904
113	91	2	2017-07-14 19:29:05.049176	2017-07-14 19:29:05.049176
114	92	9	2017-07-14 19:35:29.991102	2017-07-14 19:35:29.991102
115	92	2	2017-07-14 19:37:15.746081	2017-07-14 19:37:15.746081
116	93	9	2017-07-14 19:54:16.387098	2017-07-14 19:54:16.387098
117	93	2	2017-07-14 20:00:28.243058	2017-07-14 20:00:28.243058
118	68	2	2017-07-14 21:49:20.938457	2017-07-14 21:49:20.938457
119	94	9	2017-07-14 22:52:54.432732	2017-07-14 22:52:54.432732
120	94	2	2017-07-14 22:54:08.967454	2017-07-14 22:54:08.967454
121	85	2	2017-07-20 18:30:35.979003	2017-07-20 18:30:35.979003
122	86	2	2017-07-20 19:30:50.797296	2017-07-20 19:30:50.797296
123	88	2	2017-07-20 22:58:40.583976	2017-07-20 22:58:40.583976
124	95	1	2017-07-21 19:25:42.183884	2017-07-21 19:25:42.183884
125	95	2	2017-07-21 19:26:57.554749	2017-07-21 19:26:57.554749
126	96	1	2017-07-22 16:27:24.00136	2017-07-22 16:27:24.00136
127	96	2	2017-07-22 16:51:27.441807	2017-07-22 16:51:27.441807
128	87	7	2017-07-29 03:20:29.713612	2017-07-29 03:20:29.713612
129	97	1	2017-08-03 14:45:37.978905	2017-08-03 14:45:37.978905
130	98	1	2017-08-03 14:46:42.041635	2017-08-03 14:46:42.041635
131	99	1	2017-08-03 14:48:49.701427	2017-08-03 14:48:49.701427
132	121	1	2017-08-04 19:09:46.98733	2017-08-04 19:09:46.98733
133	121	2	2017-08-04 19:11:32.615243	2017-08-04 19:11:32.615243
134	122	1	2017-08-05 17:32:42.788628	2017-08-05 17:32:42.788628
135	122	2	2017-08-05 17:51:15.708544	2017-08-05 17:51:15.708544
136	120	2	2017-08-05 18:16:07.082313	2017-08-05 18:16:07.082313
137	119	2	2017-08-06 23:58:58.957731	2017-08-06 23:58:58.957731
138	123	1	2017-08-26 16:59:45.702026	2017-08-26 16:59:45.702026
139	123	2	2017-08-26 17:00:17.635621	2017-08-26 17:00:17.635621
140	124	1	2017-08-26 17:53:14.243627	2017-08-26 17:53:14.243627
141	124	2	2017-08-26 17:53:55.427203	2017-08-26 17:53:55.427203
\.


--
-- Name: request_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('request_users_id_seq', 141, true);


--
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY requests (id, product_type, product_what, product_length, product_width, product_height, product_weight, for_what, quantity, inner_length, inner_width, inner_height, outer_length, outer_width, outer_height, bag_length, bag_width, bag_height, main_material, resistance_main_material, secondary_material, resistance_secondary_material, third_material, resistance_third_material, impression, inks, impression_finishing, delivery_date, maximum_sales_price, observations, notes, prospect_id, created_at, updated_at, final_quantity, payment_uploaded, authorisation_signed, date_finished, internal_cost, internal_price, sales_price, impression_where, design_like, resistance_like, rigid_color, paper_type_rigid, store_id, require_design, exterior_material_color, interior_material_color, status, exhibitor_height, tray_quantity, tray_length, tray_width, tray_divisions, name_type, contraencolado, authorised_without_doc, how_many, authorised_without_pay, boxes_stow, specification, what_measures, specification_document, sensitive_fields_changed, payment, authorisation, authorised, last_status, product_id) FROM stdin;
1	uno	algo	10	11.5	10.5	20.5	almacenar	100	12	15	24	13	16	25	6	6	8	corrugado	10 ECT	que que	ninguna	ninguno	ninguna	si	3	si	2017-07-28	45	hola	adios	1	2017-06-19 17:54:21.701569	2017-07-28 22:15:12.722831	700	f	f	2017-08-10	50.2999999999999972	60.5	80.0999999999999943	exterior	muñeca	PC 800	azul	delgado	1	\N	rojo	azul	solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
8	otrosss		\N	\N	\N	\N		600	\N	\N		\N	\N	\N	\N	\N	\N								\N		\N	\N			1	2017-06-21 18:18:58.305932	2017-07-28 22:15:37.024829	\N	t	t	\N	\N	\N	\N						1	t			solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	caja	algo	10	10	10	0.299999999999999989	almacenar	333	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	9kg - 26 ECT	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-06-29 18:54:04.493721	2017-07-05 01:38:56.183406	\N	f	f	\N	\N	\N	\N	seleccione					1	t	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
10	otra pero funcionando		\N	\N	\N	\N		\N	\N	\N		\N	\N	\N	\N	\N	\N								\N		\N	\N			7	2017-06-21 18:43:20.126128	2017-06-21 18:43:20.290583	\N	t	f	\N	\N	\N	\N						1	t			solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
12	el ultimo		\N	\N	\N	\N		444	\N	\N		\N	\N	\N	\N	\N	\N								\N		\N	\N			1	2017-06-21 22:02:35.977691	2017-06-21 22:02:35.977691	\N	f	f	\N	\N	\N	\N						1	t			solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
13	caja	algo	10	10	10	0.299999999999999989	almacenar	333	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	9kg - 26 ECT	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-06-29 18:46:11.854003	2017-06-29 18:46:11.854003	\N	f	f	\N	\N	\N	\N	seleccione					1	t	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
19	seleccione		\N	\N	\N	\N		\N	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-06-30 16:40:10.941302	2017-06-30 18:59:38.472865	\N	f	f	\N	\N	\N	\N	seleccione	0001				1	t			solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
20	caja	chocolates	10	5	2	300	almacenar	500	\N	\N		11	6	5	\N	\N	\N	caple	14 PTS	seleccione	seleccione	seleccione	seleccione	si	2	Barniz de máquina	2017-07-28	15.5	ninguna	\N	11	2017-07-02 17:37:11.69251	2017-07-02 17:41:36.028455	\N	\N	\N	\N	\N	\N	\N	exterior	Regalo				1	t	bond	bond	solicitada	\N	\N	\N	\N	\N		\N	\N	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
22	caja	regalos	5	5	9	400	almacenar	800	\N	\N		10	10	10	\N	\N	\N	caple	16 PTS	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-02 18:22:56.605599	2017-07-02 18:22:56.605599	\N	\N	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	10	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
23	caja	muchas cosas wuuuu	10	10	10	\N	seleccione	100	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-02 18:29:09.321806	2017-07-02 18:35:46.283955	\N	\N	\N	\N	\N	\N	\N	seleccione	Seleccione				1	t	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
21	caja	Que te importa	\N	\N	\N	\N	seleccione	999	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-02 18:17:06.277564	2017-07-04 21:57:12.228859	\N	f	f	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
25	caja	muchas cosas wuuuu	5	5	5	100	almacenar	325	\N	\N		11	11	11	\N	\N	\N	corrugado	11kg - 29 ECT	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	2017-07-13	5.40000000000000036	ninguna	\N	13	2017-07-04 17:20:22.196796	2017-07-04 21:30:41.070796	\N	f	f	\N	\N	\N	\N	seleccione	Muñeca				1	t	bond	bond	solicitada	\N	\N	\N	\N	\N		\N	\N	50	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
24	caja	mazapanes	5	5	1.5	500	almacenar	2000	\N	\N		20	8	6	\N	\N	\N	caple	20 PTS	seleccione	seleccione	seleccione	seleccione	si	4	Plastificado brillante	2017-07-26	\N		\N	10	2017-07-03 20:45:13.964871	2017-07-04 21:55:38.774537	\N	f	f	\N	\N	\N	\N	exterior	Muñeca				1	\N	bond	bond	solicitada	\N	\N	\N	\N	\N		\N	\N	50	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
9	cuantos?		\N	\N	\N	\N		500	\N	\N		\N	\N	\N	\N	\N	\N								\N		\N	\N			1	2017-06-21 18:19:15.925711	2017-07-04 23:40:54.15228	\N	t	t	\N	\N	\N	\N						1	t			solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
18	seleccione		\N	\N	\N	\N		\N	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-06-30 16:25:40.867649	2017-07-05 00:13:48.655418	\N	f	f	\N	\N	\N	\N	seleccione	0001				1	\N			solicitada	\N	\N	\N	\N	\N		\N	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
17	caja	algo	10	10	10	0.299999999999999989	almacenar	1234	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	9kg - 26 ECT	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-06-29 19:08:09.661238	2017-07-05 00:14:06.182821	\N	f	f	\N	\N	\N	\N	seleccione					1	t	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
14	caja	algo	10	10	10	0.299999999999999989	almacenar	333	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	9kg - 26 ECT	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-06-29 18:51:20.692296	2017-07-07 01:36:21.128731	\N	t	f	\N	\N	\N	\N	seleccione					1	t	kraft	kraft	autorizada	\N	\N	\N	\N	\N		\N	t	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
16	caja	algo	10	10	10	0.299999999999999989	almacenar	1234	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	9kg - 26 ECT	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-06-29 18:55:33.804936	2017-07-05 01:45:36.801814	\N	f	f	\N	\N	\N	\N	seleccione					1	t	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
11	uno	dasdas	\N	\N	\N	\N		11234	\N	\N		\N	\N	\N	\N	\N	\N								\N		\N	\N			7	2017-06-21 19:19:46.329129	2017-07-05 01:48:56.113387	\N	f	f	\N	\N	\N	\N						1	t			solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
26	cajas		\N	\N	\N	\N	seleccione	987	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	7	2017-07-05 01:52:28.918773	2017-07-05 01:52:28.918773	\N	\N	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
28	caja		\N	\N	\N	\N	seleccione	456	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 02:06:42.294755	2017-07-05 02:10:42.174192	\N	f	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
27	bolsas		\N	\N	\N	\N	seleccione	765	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	7	2017-07-05 01:55:00.844086	2017-07-11 17:01:02.572644	\N	t	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	autorizada	\N	\N	\N	\N	\N		\N	t		t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
29	exhibidor		\N	\N	\N	\N	seleccione	789	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	13	2017-07-05 02:18:12.430361	2017-07-05 02:37:27.843498	\N	f	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
30	exhibidor		\N	\N	\N	\N	seleccione	55	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	13	2017-07-05 02:38:44.691602	2017-07-05 02:42:41.003405	\N	f	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
31	bolsa		\N	\N	\N	\N	seleccione	33	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 02:55:41.033959	2017-07-05 02:56:09.517669	\N	f	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	prueba 2	algo	10	11.5	\N	\N		100	\N	\N		\N	\N	\N	\N	\N	\N								\N		\N	\N			1	2017-06-20 02:16:29.883346	2017-07-29 03:48:14.817883	\N	f	f	\N	\N	\N	\N						1	t			solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	prueba2		\N	\N	\N	\N		500	\N	\N		\N	\N	\N	\N	\N	\N								\N		\N	\N			1	2017-06-20 02:21:35.963261	2017-07-28 22:15:17.657133	\N	t	f	\N	\N	\N	\N						1	t			solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
5	Uno		\N	\N	\N	\N		900	\N	\N		\N	\N	\N	\N	\N	\N								\N		\N	\N			1	2017-06-21 18:08:15.200675	2017-07-28 22:15:28.517877	\N	t	f	\N	\N	\N	\N						1	t			solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
6	otro		\N	\N	\N	\N		800	\N	\N		\N	\N	\N	\N	\N	\N								\N		\N	\N			1	2017-06-21 18:13:19.256147	2017-07-28 22:15:31.205702	\N	t	t	\N	\N	\N	\N						1	t			solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	que ti		\N	\N	\N	\N		700	\N	\N		\N	\N	\N	\N	\N	\N								\N		\N	\N			1	2017-06-21 18:15:05.312868	2017-07-28 22:15:33.903535	\N	t	t	\N	\N	\N	\N						1	t			solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
32	caja		\N	\N	\N	\N	seleccione	44	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 02:59:43.819306	2017-07-05 03:01:07.686381	\N	f	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
33	caja		\N	\N	\N	\N	seleccione	1222	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 17:06:07.093921	2017-07-05 17:30:16.201618	\N	t	f	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	autorizada	\N	\N	\N	\N	\N		\N	f		t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
35	bolsa		\N	\N	\N	\N	seleccione	21	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 17:44:01.289034	2017-07-05 17:44:01.289034	\N	t	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
36	caja		\N	\N	\N	\N	seleccione	344	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 17:46:38.728143	2017-07-05 17:47:47.224784	\N	f	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	autorizada	\N	\N	\N	\N	\N		\N	t		f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
37	otro		\N	\N	\N	\N	seleccione	200	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 18:26:02.150071	2017-07-05 18:32:20.200416	\N	f	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	autorizada	\N	\N	\N	\N	\N	maletín	\N	t		f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
57	caja	cosas	10	10	10	10	almacenar	10000	\N	\N		\N	\N	\N	\N	\N	\N	sulfatada	Sugerir resistencia					no	\N		\N	\N		\N	9	2017-07-07 21:46:32.52662	2017-07-07 21:46:32.52662	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	nil	\N	1 - 3	\N	\N	\N	\N	\N	\N	\N	\N	\N
38	bolsa		\N	\N	\N	\N	seleccione	368	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 19:53:15.497535	2017-07-05 19:56:43.725871	\N	\N	f	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	autorizada	\N	\N	\N	\N	\N		\N	f		t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
39	bolsa		\N	\N	\N	\N	seleccione	234	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 20:11:02.085062	2017-07-05 20:12:21.500042	\N	\N	f	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	autorizada	\N	\N	\N	\N	\N		\N	f		t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
41	caja		\N	\N	\N	\N	seleccione	8765	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 20:28:04.856461	2017-07-06 19:13:26.342534	\N	\N	t	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	autorizada	\N	\N	\N	\N	\N		\N	f		t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
40	exhibidor		\N	\N	\N	\N	seleccione	49	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 20:15:44.824801	2017-07-05 20:17:16.160059	\N	\N	t	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	autorizada	\N	\N	\N	\N	\N		\N	f		t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
58	caja	nada	10	10	10	1	almacenar	1000	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	Sugerir resistencia					no	\N		\N	\N		\N	9	2017-07-07 21:49:47.985248	2017-07-07 21:49:47.985248	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	10	\N	1 - 3	\N	\N	\N	\N	\N	\N	\N	\N	\N
59	caja	cacahuates	10	10	19	0.5	sin información	1000	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		\N	\N		\N	9	2017-07-07 22:48:33.646264	2017-07-07 22:48:33.646264	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	1000	\N	1 - 3	\N	4	\N	\N	\N	\N	\N	\N	\N
34	exhibidor		\N	\N	\N	\N	seleccione	32	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 17:35:37.376037	2017-07-06 19:33:15.836314	\N	f	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	t		t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
44	caja	mazapanes	5	5	2	\N	seleccione	888	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	9	2017-07-07 04:21:22.785527	2017-07-07 04:21:22.785527	\N	\N	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
45	caja	mazapanes	10	10	10	\N	seleccione	500	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	9	2017-07-07 04:21:50.160321	2017-07-07 04:21:50.160321	\N	\N	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
46	caja	paletas	10	10	5	\N	seleccione	888	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	9	2017-07-07 04:28:10.497545	2017-07-07 04:28:10.497545	\N	\N	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
47	caja		\N	\N	\N	\N	seleccione	8000	\N	\N		10	10	10	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	9	2017-07-07 04:30:25.349923	2017-07-07 04:30:25.349923	\N	\N	\N	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
43	caja		\N	\N	\N	\N	seleccione	589	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 23:50:05.261068	2017-07-06 17:46:01.250869	\N	\N	t	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	autorizada	\N	\N	\N	\N	\N		\N	f		t	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
42	caja		\N	\N	\N	\N	seleccione	750	\N	\N		\N	\N	\N	\N	\N	\N	seleccione	seleccione	seleccione	seleccione	seleccione	seleccione	no	0	Seleccione	\N	\N		\N	11	2017-07-05 23:27:26.83374	2017-07-06 19:06:44.605729	\N	t	t	\N	\N	\N	\N	seleccione	Seleccione				1	\N	kraft	kraft	autorizada	\N	\N	\N	\N	\N		\N	f		f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
48	otro	cosas	5	5	5	0.200000000000000011		876	\N	\N		\N	\N	\N	\N	\N	\N	caple	Sugerir resistencia					no	\N		\N	\N		\N	9	2017-07-07 19:03:13.175445	2017-07-07 19:03:13.175445	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N	uno pues	\N	\N	10	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
49	bolsa	nada	5	5	5	0.5		1000	\N	\N		\N	\N	\N	\N	\N	\N	papel kraft	Sugerir resistencia					no	\N		\N	\N		\N	9	2017-07-07 19:34:29.077496	2017-07-07 19:34:29.077496	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		\N		\N	\N	\N	\N	\N	\N	\N	\N	\N
50	bolsa	nada	5	5	5	0.5		1000	\N	\N		\N	\N	\N	\N	\N	\N	papel kraft	Sugerir resistencia					no	\N		\N	\N		\N	9	2017-07-07 19:35:25.130775	2017-07-07 19:35:25.130775	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		\N		\N	\N	\N	\N	\N	\N	\N	\N	\N
51	bolsa	nada	5	5	5	0.800000000000000044		400	\N	\N		\N	\N	\N	\N	\N	\N	sugerir material	Sugerir resistencia					si	1	Sin acabados	\N	\N		\N	9	2017-07-07 20:05:02.464784	2017-07-07 20:05:02.464784	\N	\N	\N	\N	\N	\N	\N	exterior					1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	10	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N
52	caja	cosas	5	5	5	0.900000000000000022	almacenar	1000	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	Sugerir resistencia					si	1	Barniz UV	\N	\N		\N	9	2017-07-07 21:31:32.653015	2017-07-07 21:31:32.653015	\N	\N	\N	\N	\N	\N	\N	exterior	Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	8	\N	1 - 3	\N	\N	\N	\N	\N	\N	\N	\N	\N
53	caja	aguas	9	9	18	2.5		1000	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	Sugerir resistencia					no	\N		\N	\N		\N	9	2017-07-07 21:33:12.637192	2017-07-07 21:33:12.637192	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	6	\N	1 - 3	\N	\N	\N	\N	\N	\N	\N	\N	\N
54	caja	aguas	9	9	18	2.5		1000	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	Sugerir resistencia					no	\N		\N	\N		\N	9	2017-07-07 21:36:21.273017	2017-07-07 21:36:21.273017	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	6	\N	1 - 3	\N	\N	\N	\N	\N	\N	\N	\N	\N
55	caja	nada	10	10	10	0.699999999999999956	almacenar	1000	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	Sugerir resistencia					no	\N		\N	\N		\N	9	2017-07-07 21:41:59.758867	2017-07-07 21:41:59.758867	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		\N	1 - 3	\N	\N	\N	\N	\N	\N	\N	\N	\N
56	caja	nada	10	10	10	0.699999999999999956	almacenar	1000	\N	\N		\N	\N	\N	\N	\N	\N	corrugado	Sugerir resistencia					no	\N		\N	\N		\N	9	2017-07-07 21:45:51.995026	2017-07-07 21:45:51.995026	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N		\N	1 - 3	\N	\N	\N	\N	\N	\N	\N	\N	\N
60	caja	mazapanes	5	5	2	0.299999999999999989	almacenar	100	\N	\N		20	8	7	\N	\N	\N	caple	18 PTS					si	4	Barniz de máquina	2017-07-30	20		\N	9	2017-07-07 22:53:14.031886	2017-07-07 22:53:15.013775	\N	\N	\N	\N	\N	\N	\N	exterior	Regalo				1	\N	bond	bond	solicitada	\N	\N	\N	\N	\N		\N	\N	50	\N	10 o más	\N	1	\N	\N	\N	\N	\N	\N	\N
61	bolsa	alegrías	\N	\N	\N	\N		980	\N	\N		\N	\N	\N	30	10	45	papel kraft	Sugerir resistencia					si	2	Sin acabados	2017-07-30	8.5	ninguna	\N	9	2017-07-08 19:47:33.915427	2017-07-08 19:47:35.044758	\N	\N	\N	\N	\N	\N	\N	exterior					1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N		\N		\N	\N	\N	\N	\N	\N	\N
62	bolsa	pulseras	\N	\N	\N	0.599999999999999978		9000	\N	\N		\N	\N	\N	20	8	30	papel bond	No aplica					no	\N		2017-07-29	10		\N	9	2017-07-08 20:09:08.95469	2017-07-08 20:09:09.849521	\N	\N	\N	\N	\N	\N	\N						1	\N	bond	bond	solicitada	\N	\N	\N	\N	\N		\N	\N	100	\N		t		\N	\N	\N	\N	\N	\N	\N
63	bolsa	pulseras	\N	\N	\N	0.599999999999999978		5900	\N	\N		\N	\N	\N	20	8	30	papel bond	No aplica					no	\N		2017-07-29	10		\N	9	2017-07-08 20:17:22.183754	2017-07-08 20:17:23.056139	\N	\N	\N	\N	\N	\N	\N						1	\N	bond	bond	solicitada	\N	\N	\N	\N	\N		\N	\N	100	\N		t		\N	\N	\N	\N	\N	\N	\N
64	bolsa	pulseras	\N	\N	\N	0.599999999999999978		8900	\N	\N		\N	\N	\N	20	8	30	papel bond	No aplica					no	\N		2017-07-29	10		\N	9	2017-07-08 20:20:34.300224	2017-07-08 20:20:35.208713	\N	\N	\N	\N	\N	\N	\N						1	\N	bond	bond	solicitada	\N	\N	\N	\N	\N		\N	\N	100	\N		t		\N	\N	\N	\N	\N	\N	\N
65	bolsa	pulseras	\N	\N	\N	0.599999999999999978		5490	\N	\N		\N	\N	\N	20	8	30	papel bond	No aplica					no	\N		2017-07-29	10		\N	9	2017-07-08 20:21:59.563861	2017-07-08 20:22:00.495299	\N	\N	\N	\N	\N	\N	\N						1	\N	bond	bond	solicitada	\N	\N	\N	\N	\N		\N	\N	100	\N		t		\N	\N	\N	\N	\N	\N	\N
66	bolsa	pulseras	\N	\N	\N	0.599999999999999978		3450	\N	\N		\N	\N	\N	20	8	30	papel bond	No aplica					no	\N		2017-07-29	10		\N	9	2017-07-08 20:30:48.422716	2017-07-08 20:30:49.307066	\N	\N	\N	\N	\N	\N	\N						1	\N	bond	bond	solicitada	\N	\N	\N	\N	\N		\N	\N	100	\N		t		\N	\N	\N	\N	\N	\N	\N
69	bolsa		\N	\N	\N	\N		59000	\N	\N		\N	\N	\N	30	10	30	papel kraft	No aplica					no	\N		2017-07-12	10		\N	9	2017-07-08 22:59:44.832297	2017-07-08 22:59:45.343298	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N		\N		\N	\N	\N	\N	\N	\N	\N
71	bolsa		\N	\N	\N	\N		59000	\N	\N		\N	\N	\N	30	10	30	papel kraft	No aplica					no	\N		2017-07-12	10		\N	9	2017-07-08 23:04:24.4254	2017-07-08 23:04:24.624317	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N		\N		\N	\N	\N	\N	\N	\N	\N
73	bolsa	botellas	\N	\N	\N	1.5		450	\N	\N		\N	\N	\N	30	10	40	papel kraft	Sugerir resistencia					no	\N		2017-07-26	10		\N	9	2017-07-09 18:07:43.018571	2017-07-09 18:07:43.534705	\N	\N	t	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	2	\N		\N		\N	\N	\N	\N	\N	\N	\N
88	exhibidor	pan dulce	\N	\N	\N	2		45	\N	\N		\N	\N	\N	\N	\N	\N	sugerir material	Sugerir resistencia					si	4	Plastificado brillante	2017-08-07	140	Los archivos son los logos que deben llevar	\N	14	2017-07-14 17:52:40.55779	2017-07-20 22:58:40.420096	\N	\N	\N	\N	\N	\N	\N	exterior					1	\N	bond	kraft	cotizando	1.5	5	40	30	3		\N	\N	30	\N		\N		t	\N	\N	\N	\N	\N	\N
84	otro	pinturas	\N	\N	\N	\N		10	\N	\N		49	49	15	\N	\N	\N	corrugado	9kg - 26 ECT					no	\N		2017-08-30	45	hola	\N	14	2017-07-14 14:37:39.195638	2017-07-14 16:53:15.234798	\N	\N	\N	\N	30	37	\N						1	\N	bond	kraft	modificada-recotizar	\N	\N	\N	\N	\N	maletín	\N	\N	30	\N		\N	1	t	t	\N	\N	\N	\N	\N
74	bolsa	botellas	\N	\N	\N	1.5		450	\N	\N		\N	\N	\N	30	10	40	papel kraft	Sugerir resistencia					no	\N		2017-07-26	10		\N	9	2017-07-09 18:13:56.564232	2017-07-11 19:02:38.989079	\N	\N	\N	\N	8.5	10.5	\N						1	\N	kraft	kraft	cotizando	\N	\N	\N	\N	\N		\N	\N	2	\N		\N		t	\N	\N	\N	\N	\N	\N
72	bolsa		\N	\N	\N	\N		59000	\N	\N		\N	\N	\N	30	10	30	papel kraft	No aplica					no	\N		2017-07-12	10		\N	9	2017-07-09 16:18:41.698447	2017-07-09 21:10:11.992785	\N	t	t	\N	\N	\N	\N						1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	f	\N	f	5	t		t	\N	\N	\N	\N	\N	\N
79	exhibidor	mangos	\N	\N	\N	0.5		45	\N	\N		\N	\N	\N	\N	\N	\N	sugerir material	Sugerir resistencia					si	4	Plastificado brillante	2017-07-28	349	Que sea barato	\N	5	2017-07-09 22:52:27.733884	2017-07-09 22:52:28.580509	\N	\N	\N	\N	\N	\N	\N	exterior					1	\N	bond	bond	creada	150	4	30	20	6		\N	\N	100	\N		\N	1	t	\N	\N	\N	\N	\N	\N
77	caja	piedras	3	3	3	3	almacenar	550	\N	\N		30	20	35	\N	\N	\N	caple	16 PTS					si	2	Sin acabados	2017-07-27	5.29999999999999982	Son chocolates, no piedras	\N	5	2017-07-09 22:03:40.858134	2017-07-11 15:47:26.656184	\N	\N	\N	\N	\N	\N	\N	exterior	Regalo				1	\N	bond	bond	cancelada	\N	\N	\N	\N	\N		\N	\N	20	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
76	bolsa	botellas	\N	\N	\N	1.5		870	\N	\N		\N	\N	\N	10	10	10	papel kraft	No aplica					no	\N		\N	10		\N	9	2017-07-09 20:24:45.123758	2017-07-11 16:47:54.457148	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	cancelada	\N	\N	\N	\N	\N		\N	\N	3	\N		\N		t	\N	\N	\N	\N	\N	\N
80	exhibidor	plumas	\N	\N	\N	\N		60	\N	\N		\N	\N	\N	\N	\N	\N	sugerir material	Sugerir resistencia					si	4	Plastificado brillante	2017-07-30	200		\N	12	2017-07-11 17:11:35.447778	2017-07-11 17:11:35.89783	\N	\N	\N	\N	\N	\N	\N	exterior					1	\N	bond	bond	creada	150	5	40	40	20		\N	\N	200	\N		\N		t	\N	\N	\N	\N	\N	\N
78	exhibidor	mangos	\N	\N	\N	0.5		45	\N	\N		\N	\N	\N	\N	\N	\N							no	\N		2017-07-28	349	Que sea barato	\N	5	2017-07-09 22:42:23.268515	2017-07-11 18:32:02.944259	\N	\N	\N	\N	18.5	22.5	\N						1	\N	kraft	kraft	cotizando	150	4	30	20	6		\N	\N	100	\N		\N		t	\N	\N	\N	\N	\N	\N
81	caja	pan de plátano	\N	\N	\N	\N	almacenar	400	45	45	20	\N	\N	\N	\N	\N	\N	corrugado	11kg - 29 ECT					si	2	Sin acabados	2017-09-17	20		\N	14	2017-07-11 19:13:44.696165	2017-07-21 19:22:06.994063	\N	t	t	\N	27	33	40	exterior	Caja regular CR				1	\N	kraft	kraft	autorizada	\N	\N	\N	\N	\N		\N	f		f	7 - 9	\N	2	t	f	\N	f	t	\N	\N
83	caja	botellas	\N	\N	\N	2	almacenar	700	\N	\N		40	29	25	\N	\N	\N	corrugado	12kg - 32 ECT					no	\N		2017-07-27	20		\N	14	2017-07-13 18:06:19.943873	2017-07-13 18:08:22.797668	\N	\N	\N	\N	15	18	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	6	\N		\N	1	\N	\N	\N	\N	\N	\N	\N
70	bolsa		\N	\N	\N	\N		59000	\N	\N		\N	\N	\N	30	10	30	papel kraft	No aplica					no	\N		2017-07-12	10		\N	9	2017-07-08 23:03:39.914292	2017-07-12 17:13:17.102879	\N	\N	\N	\N	\N	\N	\N						1	\N	kraft	kraft	cancelada	\N	\N	\N	\N	\N		\N	\N	\N	\N		\N		t	\N	\N	\N	\N	\N	\N
82	bolsa	USBs	\N	\N	\N	\N		350	\N	\N		\N	\N	\N	30	30	20	papel kraft	No aplica					si	2	Sin acabados	2017-09-17	9.5	Que se vea muy padre	\N	14	2017-07-12 15:32:46.818619	2017-07-12 22:16:02.952261	\N	t	t	\N	6.5	8.5	10	exterior					1	t	kraft	kraft	cancelada	\N	\N	\N	\N	\N		\N	f	50	f		\N		t	\N	\N	\N	\N	\N	\N
67	bolsa	zanahorias	\N	\N	\N	\N		760	\N	\N		\N	\N	\N	40	15	60	papel bond	Sugerir resistencia					no	\N		2017-07-26	\N	ninguna	\N	9	2017-07-08 22:14:04.292509	2017-07-13 16:18:43.063984	\N	\N	\N	\N	10	14	\N						1	\N	bond	bond	costo asignado	\N	\N	\N	\N	\N		\N	\N	40	\N		t		\N	\N	\N	\N	\N	\N	\N
89	exhibidor	pan dulce	\N	\N	\N	2		45	\N	\N		\N	\N	\N	\N	\N	\N	sugerir material	Sugerir resistencia					si	\N	Plastificado brillante	2017-08-07	148	Los archivos son los logos que deben llevar	\N	14	2017-07-14 17:52:50.911293	2017-07-14 18:24:17.919909	\N	t	t	\N	140	160	180	exterior					1	\N	bond	kraft	modificada-recotizar	190	6	40	30	3		\N	f	30	f		\N		t	f	#<ActionDispatch::Http::UploadedFile:0x007f716a3e1c90>	f	t	\N	\N
91	exhibidor	pan dulce	\N	\N	\N	2		18	\N	\N		\N	\N	\N	\N	\N	\N	sugerir material	Sugerir resistencia					si	\N	Plastificado brillante	2017-08-07	140	Los archivos son los logos que deben llevar	\N	14	2017-07-14 18:57:49.020582	2017-07-14 19:32:51.609189	\N	\N	\N	\N	130	145	140	exterior					1	\N	bond	kraft	autorizada	150	5	45	30	3		\N	\N	30	\N		\N		t	t	\N	\N	t	\N	\N
68	bolsa	zanahorias	\N	\N	\N	\N		7600	\N	\N		\N	\N	\N	40	18	60	papel bond	Sugerir resistencia					no	\N		2017-07-26	\N	ninguna	\N	9	2017-07-08 22:20:08.721515	2017-07-14 22:42:19.090786	\N	\N	\N	\N	\N	\N	\N						1	\N	bond	bond	modificada-recotizar	\N	\N	\N	\N	\N		\N	\N	40	\N		t		t	t	\N	\N	\N	\N	\N
85	exhibidor	pan dulce	\N	\N	\N	2		40	\N	\N		\N	\N	\N	\N	\N	\N	sugerir material	Sugerir resistencia					si	\N	Plastificado brillante	2017-08-07	140	Los archivos son los logos que deben llevar	\N	14	2017-07-14 17:33:51.85351	2017-07-20 19:10:11.318033	\N	\N	\N	\N	100	120	140	exterior					1	\N	bond	kraft	precio asignado	1.5	5	40	30	3		\N	\N	30	\N		\N		\N	f	\N	\N	\N	\N	\N
86	exhibidor	pan dulce	\N	\N	\N	2		40	\N	\N		\N	\N	\N	\N	\N	\N	sugerir material	Sugerir resistencia					si	4	Plastificado brillante	2017-08-07	140	Los archivos son los logos que deben llevar	\N	14	2017-07-14 17:36:54.436723	2017-07-20 19:54:23.69463	\N	\N	\N	\N	121	131	140	exterior					1	\N	bond	kraft	precio asignado	1.5	5	40	30	3		\N	\N	30	\N		\N		t	f	\N	\N	\N	\N	\N
111	bolsa	Regalos	\N	\N	\N	\N		500	\N	\N		30	40	20	25	10	30	papel kraft	No aplica					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:52:19.925675	2017-08-03 14:52:19.925675	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N		\N		t	\N	\N	\N	\N	\N	\N
112	bolsa	Regalos	\N	\N	\N	\N		500	\N	\N		30	40	20	25	10	30	papel kraft	No aplica					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:52:23.535311	2017-08-03 14:52:23.535311	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N		\N		t	\N	\N	\N	\N	\N	\N
97	caja	Botellas	12	8	20	2	almacenar	100	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					si	2	Sin acabados	2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:45:33.102811	2017-08-03 14:45:38.016554	\N	\N	\N	\N	\N	\N	\N	exterior	Caja regular CR				1	\N	kraft	kraft	creada	\N	\N	\N	\N	\N		\N	\N	8	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
98	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:46:36.020651	2017-08-03 14:46:42.059219	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	creada	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
92	bolsa	panes	6	6	3	0.400000000000000022		420	\N	\N		\N	\N	\N	30	15	40	papel kraft	No aplica					no	\N		2017-07-25	10	son panes	\N	14	2017-07-14 19:35:29.821387	2017-07-14 19:39:33.454928	\N	\N	\N	\N	6	8	10						1	\N	kraft	kraft	modificada-recotizar	\N	\N	\N	\N	\N		\N	\N	30	\N		\N		t	t	\N	\N	\N	\N	\N
90	exhibidor	pan dulce	\N	\N	\N	2		17	\N	\N		\N	\N	\N	\N	\N	\N	sugerir material	Sugerir resistencia					si	\N	Plastificado brillante	2017-08-07	150	Los archivos son los logos que deben llevar	\N	14	2017-07-14 18:57:06.234235	2017-07-14 19:27:52.670547	\N	\N	\N	\N	140	150	155	exterior					1	\N	bond	kraft	modificada-recotizar	160	5	50	40	6		\N	\N	30	\N		\N		t	t	\N	\N	f	\N	\N
94	bolsa	celulares	15	7	1	0.200000000000000011		322	\N	\N		\N	\N	\N	22	10	25	papel kraft	Sugerir resistencia					no	\N		2017-07-26	10		\N	14	2017-07-14 22:52:54.213669	2017-07-22 16:23:19.640959	\N	t	t	\N	6	8	10						1	t	kraft	kraft	precio asignado	\N	\N	\N	\N	\N		\N	f	1	f		\N		t	f	#<ActionDispatch::Http::UploadedFile:0x007fa4b6d96888>	#<ActionDispatch::Http::UploadedFile:0x007fa4b6d96900>	t	cancelada	\N
93	bolsa	panes	5	5	3	0.400000000000000022		430	\N	\N		\N	\N	\N	38	17	40	papel kraft	No aplica					no	\N		2017-07-25	10		\N	14	2017-07-14 19:54:16.229442	2017-07-18 17:23:00.241339	\N	t	t	\N	8	9	12.5						1	\N	kraft	kraft	código asignado	\N	\N	\N	\N	\N		\N	f	35	f		\N		t	f	#<ActionDispatch::Http::UploadedFile:0x007f716ab48a38>	#<ActionDispatch::Http::UploadedFile:0x007f716ab48ab0>	t	\N	\N
2	nuevo	algo	10	11.5	10.5	20.5	almacenar	100	12	15	24	13	16	25	6	6	8	corrugado	10 ECT	que que	ninguna	ninguno	ninguna	si	3	si	2017-08-17	45	dasda	que queee	1	2017-06-20 02:12:18.256335	2017-07-29 03:48:09.691386	700	f	f	2017-08-10	50.2999999999999972	60.5	80.0999999999999943	exterior	muñeca	PC 800	azul	delgado	1	\N	rojo	azul	solicitada	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
95	bolsa	Lentes	\N	\N	\N	\N		540	\N	\N		\N	\N	\N	15	6	15	papel kraft	No aplica					si	2	Sin acabados	2017-07-30	10		\N	14	2017-07-21 19:25:41.922656	2017-07-30 15:05:04.046284	\N	t	t	\N	6	8	10	exterior					1	\N	kraft	kraft	código asignado	\N	\N	\N	\N	\N		\N	t	1	t		\N		t	f	#<ActionDispatch::Http::UploadedFile:0x007f4781fa4478>	#<ActionDispatch::Http::UploadedFile:0x007f4781fa44f0>	t	autorizada	11
99	bolsa	Regalos	\N	\N	\N	\N		500	\N	\N		30	40	20	25	10	30	papel kraft	No aplica					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:48:48.215623	2017-08-03 14:48:49.724647	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N		\N		t	\N	\N	\N	\N	\N	\N
96	caja	lentes	\N	\N	\N	1	almacenar	900	\N	\N		18	9	9	\N	\N	\N	corrugado	7kg - 23 ECT					si	2	Barniz de máquina	2017-07-31	20		\N	14	2017-07-22 16:27:23.899188	2017-07-30 20:32:56.221193	\N	t	t	\N	16	18	20	exterior	Caja regular CR				1	\N	kraft	kraft	código asignado	\N	\N	\N	\N	\N		\N	f	1	f	ninguna	\N	1	t	f	#<ActionDispatch::Http::UploadedFile:0x007f8336e2a070>	#<ActionDispatch::Http::UploadedFile:0x007f8336e2a110>	t	cancelada	14
100	caja	Botellas	12	8	20	2	almacenar	100	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					si	2	Sin acabados	2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:50:34.178763	2017-08-03 14:50:34.178763	\N	\N	\N	\N	\N	\N	\N	exterior	Caja regular CR				1	\N	kraft	kraft	creada	\N	\N	\N	\N	\N		\N	\N	8	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
101	caja	Botellas	12	8	20	2	almacenar	100	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					si	2	Sin acabados	2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:50:44.901759	2017-08-03 14:50:44.901759	\N	\N	\N	\N	\N	\N	\N	exterior	Caja regular CR				1	\N	kraft	kraft	creada	\N	\N	\N	\N	\N		\N	\N	8	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
102	caja	Botellas	12	8	20	2	almacenar	100	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					si	2	Sin acabados	2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:50:46.016346	2017-08-03 14:50:46.016346	\N	\N	\N	\N	\N	\N	\N	exterior	Caja regular CR				1	\N	kraft	kraft	creada	\N	\N	\N	\N	\N		\N	\N	8	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
103	caja	Botellas	12	8	20	2	almacenar	100	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					si	2	Sin acabados	2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:50:46.951973	2017-08-03 14:50:46.951973	\N	\N	\N	\N	\N	\N	\N	exterior	Caja regular CR				1	\N	kraft	kraft	creada	\N	\N	\N	\N	\N		\N	\N	8	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
104	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:51:22.262924	2017-08-03 14:51:22.262924	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	creada	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
105	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:51:24.098511	2017-08-03 14:51:24.098511	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	creada	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
106	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:51:25.047876	2017-08-03 14:51:25.047876	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	creada	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
107	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:51:28.550122	2017-08-03 14:51:28.550122	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	creada	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
108	bolsa	Regalos	\N	\N	\N	\N		500	\N	\N		30	40	20	25	10	30	papel kraft	No aplica					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:52:07.690347	2017-08-03 14:52:07.690347	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N		\N		t	\N	\N	\N	\N	\N	\N
109	bolsa	Regalos	\N	\N	\N	\N		500	\N	\N		30	40	20	25	10	30	papel kraft	No aplica					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:52:09.647862	2017-08-03 14:52:09.647862	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N		\N		t	\N	\N	\N	\N	\N	\N
110	bolsa	Regalos	\N	\N	\N	\N		500	\N	\N		30	40	20	25	10	30	papel kraft	No aplica					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:52:10.219376	2017-08-03 14:52:10.219376	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N		\N		t	\N	\N	\N	\N	\N	\N
113	bolsa	Regalos	\N	\N	\N	\N		500	\N	\N		30	40	20	25	10	30	papel kraft	No aplica					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:52:29.163308	2017-08-03 14:52:29.163308	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	\N	\N		\N		t	\N	\N	\N	\N	\N	\N
114	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:53:05.391782	2017-08-03 14:53:05.391782	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	creada	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
115	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:53:37.806137	2017-08-03 14:53:37.806137	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
116	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:53:38.872577	2017-08-03 14:53:38.872577	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
117	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:53:40.052582	2017-08-03 14:53:40.052582	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
118	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:53:40.927776	2017-08-03 14:53:40.927776	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	\N	\N
87	exhibidor	pan dulce	\N	\N	\N	2		34	\N	\N		\N	\N	\N	\N	\N	\N	sugerir material	Sugerir resistencia					si	3	Plastificado brillante	2017-08-07	145	Los archivos son los logos que deben llevar	\N	14	2017-07-14 17:37:25.145081	2017-08-04 17:49:13.976449	\N	\N	\N	\N	\N	\N	\N	exterior					1	\N	bond	kraft	cotizando	1.5	5	40	30	3		\N	\N	30	\N		\N		t	\N	\N	\N	\N	modificada	\N
120	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007	Ahora sí????	No le entiendo nada!!!!	15	2017-08-03 14:53:42.386239	2017-08-05 18:32:47.45847	\N	\N	\N	\N	18	19	\N		Caja regular CR				1	\N	kraft	kraft	costo asignado	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	cotizando	\N
75	bolsa	botellas	\N	\N	\N	1.5		870	\N	\N		\N	\N	\N	10	10	10	papel kraft	No aplica					no	\N		\N	10		\N	9	2017-07-09 20:16:37.033738	2017-08-26 18:42:28.864542	\N	t	t	\N	7	9	10						1	\N	kraft	kraft	código asignado	\N	\N	\N	\N	\N		\N	f	3	f		\N		t	f	#<ActionDispatch::Http::UploadedFile:0x007fad2b137d08>	#<ActionDispatch::Http::UploadedFile:0x007fad2b137d80>	t	precio asignado	23
122	caja	galletas	5	5	2	0.299999999999999989	almacenar	500	\N	\N		30	40	9	\N	\N	\N	caple	16 PTS					si	2	Barniz de máquina	2017-08-31	12.3000000000000007		\N	16	2017-08-05 17:32:40.178791	2017-08-05 18:02:05.308992	\N	t	t	\N	10	11.5	12.3000000000000007	exterior	Regalo				1	t	bond	bond	autorizada	\N	\N	\N	\N	\N		\N	f	50	f	10 o más	\N	1	t	f	#<ActionDispatch::Http::UploadedFile:0x007fad2b9814a0>	#<ActionDispatch::Http::UploadedFile:0x007fad2b981518>	t	cancelada	\N
121	exhibidor	Celulares	15	2	8	1		20	\N	\N		\N	\N	\N	\N	\N	\N	sugerir material	Sugerir resistencia					si	\N	Barniz UV	2017-08-31	120	Que quede padre	\N	16	2017-08-04 19:09:40.996726	2017-08-04 19:37:10.314038	\N	t	t	\N	80	100	120	exterior					1	\N	bond	bond	autorizada	150	4	40	30	10		\N	f	20	f		\N		t	f	#<ActionDispatch::Http::UploadedFile:0x007f0316bfb0d8>	#<ActionDispatch::Http::UploadedFile:0x007f0316bfb150>	t	precio asignado	\N
119	caja	Lápices	12	8	20	2	almacenar	1000	\N	\N		30	40	20	\N	\N	\N	corrugado	11kg - 29 ECT					no	\N		2017-08-23	20.3000000000000007		\N	15	2017-08-03 14:53:41.761053	2017-08-06 23:58:58.869232	\N	\N	\N	\N	\N	\N	\N		Caja regular CR				1	\N	kraft	kraft	cotizando	\N	\N	\N	\N	\N		\N	\N	100	\N	1 - 3	\N	1	t	\N	\N	\N	\N	solicitada	\N
123	bolsa	cubiertos desechables	10	10	20	0.299999999999999989		1000	\N	\N		\N	\N	\N	20	20	25	papel kraft	No aplica					no	\N		2017-08-30	8.55000000000000071	Ya lo cambié ahora sí de nuevo	Ahora sí no le entiendo nada	18	2017-08-26 16:59:44.499155	2017-08-26 18:28:09.45941	\N	\N	\N	\N	\N	\N	\N		Caja regular CR	11kg - 29 ECT			1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	24	\N		\N		t	\N	\N	\N	\N	solicitada	\N
124	bolsa	cubiertos desechables	10	10	10	0.299999999999999989		20000	\N	\N		\N	\N	\N	11	12	30	papel kraft	No aplica					no	\N		2017-08-31	8.44999999999999929	Ya no cualquier cosa	No le entendí 	18	2017-08-26 17:53:12.289781	2017-08-26 18:29:09.103588	\N	\N	\N	\N	\N	\N	\N		Caja regular CR	11kg - 29 ECT			1	\N	kraft	kraft	solicitada	\N	\N	\N	\N	\N		\N	\N	24	\N		\N		t	\N	\N	\N	\N	devuelta	\N
\.


--
-- Name: requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('requests_id_seq', 124, true);


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY roles (id, name, description, created_at, updated_at, translation) FROM stdin;
1	store	Crea prospectos, cotizaciones y pedidos, autoriza, cancela o reactiva cotizaciones y pedidos	2017-06-19 16:02:34.351723	2017-07-27 18:24:21.593522	\N
2	manager	Asigna precio a cotizaciones y puede asignar costo a las entradas de materiales	2017-06-19 16:02:52.493072	2017-07-27 18:24:59.804213	\N
3	designer	Da respuesta a las solicitudes de diseño	2017-06-19 16:03:33.123089	2017-07-27 18:25:25.353489	\N
4	product-admin	Crea y modifica productos, asigna costos a entradas de mercancías, crea usuarios product-staff	2017-07-15 17:10:33.975228	2017-07-27 18:25:45.637699	\N
5	director	Tiene acceso a todos los procesos y funciones de manager, puede crear usuarios manager	2017-07-15 17:11:41.349935	2017-07-27 18:27:50.419687	\N
6	store-admin	Con acceso a todas las secciones, reportes y funcionalidades de tienda y puede crear usuarios store	2017-07-15 17:12:21.041286	2017-07-27 18:32:13.683352	\N
9	platform-admin	Crea usuarios de todos los tipos, actualiza formularios	2017-07-26 18:16:39.615057	2017-07-27 18:33:50.474923	\N
10	product-staff	Crea y modifica productos, asigna costos a entradas de mercancías	2017-07-27 18:35:27.708875	2017-07-27 18:35:27.708875	\N
12	admin-desk	Crea usuarios tipo drivers, crea envíos y factura, elabora pedidos y cotizaciones	2017-07-27 18:36:41.749755	2017-07-27 18:36:41.749755	\N
13	designer-admin	Da respuesta a las solicitudes de diseño y puede crear usuarios designer	2017-07-27 18:37:09.084792	2017-07-27 18:37:09.084792	\N
14	driver	Entrega mercancía	2017-07-27 18:37:32.741045	2017-07-27 18:37:32.741045	\N
15	viewer	Da seguimiento a pedidos y cotizaciones	2017-07-27 18:38:02.920133	2017-07-27 18:38:02.920133	\N
8	warehouse-staff	Maneja inventario, órdenes de producción, prepara pedidos	2017-07-15 17:13:28.876461	2017-07-29 01:25:47.651598	\N
11	warehouse-admin	Maneja inventario, órdenes de producción, prepara pedidos y crea usuarios wharehouse-staff	2017-07-27 18:36:10.459325	2017-07-29 01:26:17.396573	\N
\.


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('roles_id_seq', 15, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY schema_migrations (version) FROM stdin;
20170531025802
20170531031624
20170601212349
20170601212535
20170605195623
20170606013447
20170606174842
20170606175343
20170606191231
20170606202219
20170606202253
20170606202314
20170606202348
20170606202409
20170606202424
20170606222359
20170606222414
20170606222448
20170606235623
20170612165915
20170613174532
20170613174742
20170613175958
20170613180037
20170613180108
20170613180543
20170613181245
20170613182114
20170613183052
20170613183111
20170613184818
20170613185231
20170613185920
20170613190419
20170613190437
20170613213257
20170613213541
20170613213633
20170613213810
20170613214000
20170613214310
20170613214445
20170613214849
20170613215357
20170613215510
20170613224310
20170613230227
20170613230416
20170613231152
20170613234425
20170613234500
20170613234551
20170613235137
20170613235318
20170614154011
20170616000424
20170616164937
20170616170556
20170616181621
20170616181752
20170616182014
20170616182048
20170616182149
20170616182241
20170617030657
20170617031848
20170617035951
20170617041920
20170619152515
20170619152616
20170619152727
20170619153221
20170619153336
20170619153401
20170619153610
20170619153626
20170619175053
20170621152725
20170621160411
20170621161545
20170621163707
20170621164624
20170621201610
20170621201630
20170622165422
20170622165617
20170622183548
20170622183627
20170622183846
20170622184513
20170622184999
20170626180035
20170626180600
20170626181238
20170626181515
20170627221430
20170628172934
20170630195828
20170630203024
20170630203106
20170630205120
20170630205145
20170630212731
20170630212905
20170630213026
20170630213104
20170630220602
20170630220626
20170630220731
20170630220745
20170630234518
20170630235651
20170630235853
20170701171754
20170701222345
20170702192823
20170702193229
20170702193719
20170702194035
20170702195519
20170702214640
20170702214757
20170702214804
20170703182847
20170703183452
20170703183507
20170703183530
20170703183551
20170703184407
20170703184421
20170703184743
20170703184817
20170704165213
20170705161826
20170707173912
20170707193305
20170707193321
20170707200256
20170707220546
20170707222445
20170709162255
20170712191552
20170712191901
20170712214155
20170712222046
20170712222556
20170713200057
20170713212029
20170713213326
20170713223156
20170713223950
20170717200925
20170717210310
20170718160325
20170718160616
20170718160727
20170718162024
20170718165540
20170718171013
20170718171102
20170718203206
20170718203244
20170718205024
20170719014339
20170720225255
20170720225258
20170721203138
20170722222459
20170722222542
20170722222905
20170722223709
20170722223918
20170725164436
20170725164451
20170725170349
20170725170537
20170725170832
20170725171222
20170725173123
20170725173149
20170725173342
20170725173350
20170725174617
20170725174640
20170725174907
20170725175114
20170725175342
20170725175431
20170725175547
20170725180156
20170725180255
20170725182359
20170725182649
20170725182949
20170725184321
20170725184410
20170725185014
20170725185121
20170725185350
20170725185526
20170725185538
20170725185711
20170725185747
20170725190232
20170725190438
20170725190911
20170725191623
20170725192358
20170725193121
20170725221333
20170725222403
20170725230731
20170726002220
20170726002235
20170726002700
20170726220155
20170726220206
20170726220722
20170726220755
20170727191419
20170727191502
20170727191946
20170730150241
20170730234235
20170731002849
20170731003204
20170731004159
20170731005620
20170731005638
20170731010432
20170731010600
20170731223949
20170731224314
20170802190703
20170806143935
20170807193155
20170809023547
20170809023829
20170809023928
20170809023941
20170809023957
20170809030746
20170809033228
20170809033251
20170809034225
20170809034533
20170809035109
20170809035520
20170810184126
20170810191451
20170810231811
20170810231927
20170810232221
20170810235555
20170811000745
20170812193124
20170812202900
20170814170620
20170814172259
20170814172332
20170814172706
20170814173110
20170814174447
20170814174536
20170816001502
20170816002927
20170816003411
20170816005722
20170816011629
20170816020400
20170816034454
20170816193736
20170817025245
20170817043858
20170817044058
20170817151458
20170817151619
20170817161922
20170817173051
20170816001235
20170818190019
20170818215552
20170818223053
20170818225732
20170818230502
20170819173433
20170826192943
20170830152656
20170830185706
20170830190026
20170901170112
20170905184308
20170905185504
20170905185945
20170905191329
20170906144248
20170906185652
20170907204154
20170911011402
\.


--
-- Data for Name: store_sales; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY store_sales (id, store_id, month, year, sales_amount, sales_quantity, cost, created_at, updated_at) FROM stdin;
\.


--
-- Name: store_sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('store_sales_id_seq', 1, false);


--
-- Data for Name: store_types; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY store_types (id, store_type, business_unit_id, created_at, updated_at) FROM stdin;
1	tienda propia	1	2017-07-31 15:11:37.72302	2017-07-31 15:11:37.72302
2	corporativo	1	2017-07-31 15:11:46.822972	2017-07-31 15:11:46.822972
3	distribuidor	6	2017-07-31 15:15:18.504593	2017-07-31 15:15:18.504593
4	franquicia	6	2017-07-31 15:15:25.897221	2017-07-31 15:15:25.897221
\.


--
-- Name: store_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('store_types_id_seq', 4, true);


--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY stores (id, created_at, updated_at, store_code, store_name, discount, delivery_address_id, business_unit_id, store_type_id, email, cost_type_id, cost_type_selected_since, months_in_inventory, reorder_point, critical_point, contact_first_name, contact_middle_name, contact_last_name, direct_phone, extension, type_of_person, prospect_status, second_last_name, business_group_id, cell_phone, billing_address_id) FROM stdin;
2	2017-06-19 16:07:50.029007	2017-08-16 03:47:34.024985	001	diseños de carton	0.5	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
1	2017-06-19 16:07:18.976634	2017-08-16 03:47:34.057663	000	aguascalientes	0.200000000000000011	16	2	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	2017-06-22 18:54:45.268562	2017-08-16 03:47:34.068677	003	calzada	35	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
5	2017-07-31 22:12:24.503104	2017-08-16 03:47:34.080421	009	Tamauilipas	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
6	2017-07-31 22:22:11.622627	2017-08-16 03:47:34.09066	010	Tamauilipas2	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	2017-07-31 22:24:14.388015	2017-08-16 03:47:34.10184	011	Tamauilipas03	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
8	2017-07-31 22:25:06.801283	2017-08-16 03:47:34.112974	011	Tamauilipas03	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
9	2017-07-31 22:25:36.898867	2017-08-16 03:47:34.123849	011	Tamauilipas03	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
10	2017-07-31 22:28:24.943222	2017-08-16 03:47:34.136329	011	Tamauilipas03	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
11	2017-07-31 22:30:50.395663	2017-08-16 03:47:34.146791	009	Tamauilipas	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
12	2017-07-31 22:31:31.855431	2017-08-16 03:47:34.157296	012	calzada	0.119999999999999996	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
13	2017-07-31 22:32:31.469371	2017-08-16 03:47:34.168746	012	calzada	0.119999999999999996	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
14	2017-07-31 22:34:32.152024	2017-08-16 03:47:34.17931	013	calzada2	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	2017-07-31 22:35:55.260782	2017-08-16 03:47:34.190191	014	Tamauilipas04	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
16	2017-07-31 22:36:49.42783	2017-08-16 03:47:34.2022	009	Tamauilipas23	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
17	2017-07-31 22:37:45.733538	2017-08-16 03:47:34.212407	014	calzada34	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
18	2017-07-31 22:38:10.625639	2017-08-16 03:47:34.22356	014	calzada34	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
19	2017-07-31 22:41:27.309008	2017-08-16 03:47:34.235129	014	calzada34	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
20	2017-07-31 22:45:28.472634	2017-08-16 03:47:34.245746	014	Tamauilipas	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
21	2017-07-31 22:46:07.671754	2017-08-16 03:47:34.256689	0091	Tamauilipasprueba	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	2017-06-22 18:55:01.481167	2017-08-16 03:47:34.267803	003	calzada	0.349999999999999978	\N	1	1	\N	1	2017-08-15	3	50	25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
22	2017-08-19 16:33:00.576583	2017-08-19 16:33:00.576583	009AG	Aguascalientes nueva	\N	\N	2	4	favio.velez@hotmail.com	1	2017-08-19	3	50	25	Favio	Prueba	\N	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
23	2017-08-19 16:36:52.372257	2017-08-19 16:36:52.372257	009AG	Aguascalientes nueva	\N	\N	2	4	favio.velez@hotmail.com	1	2017-08-19	3	50	25	Favio	Prueba	\N	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
24	2017-08-19 16:37:13.184867	2017-08-19 16:37:13.184867	009AG	Aguascalientes nueva	\N	\N	2	4	favio.velez@hotmail.com	1	2017-08-19	3	50	25	Favio	Prueba	\N	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
25	2017-08-19 16:44:26.251706	2017-08-19 16:44:26.251706	009AG	Aguascalientes nueva	\N	\N	2	4	favio.velez@hotmail.com	1	2017-08-19	3	50	25	Favio	Prueba	\N	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
26	2017-08-19 16:50:51.127979	2017-08-19 16:50:51.127979	010AG	Ags Super Nueva	\N	\N	2	1	favio.velez@hotmail.com	1	2017-08-19	3	50	25	Favio		\N	3334234234	1234	persona física	\N	Morales	\N	4324439086	\N
27	2017-08-19 16:53:18.935721	2017-08-19 16:53:18.935721	011AG	Ags Super Dos	\N	\N	2	1	favio.velez@hotmail.com	1	2017-08-19	3	50	25	Favio	Prueba	\N	3334234234	1234	persona física	\N	Morales	\N	4324439086	\N
28	2017-08-19 16:59:35.79432	2017-08-19 16:59:35.79432	012AG	Ags Super Tres	\N	\N	2	1	pruen@hotmail.com	1	2017-08-19	3	50	25	Favio	Velez	\N	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
29	2017-08-19 17:02:09.031716	2017-08-19 17:02:09.031716	012AG	Ags Super Tres	\N	\N	2	1	pruen@hotmail.com	1	2017-08-19	3	50	25	Favio	Velez	\N	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
30	2017-08-19 17:03:50.316268	2017-08-19 17:03:50.316268	013AG	Ags Super Cuatro	\N	\N	2	1	pruen@hotmail.com	1	2017-08-19	3	50	25	Favio	Velez	\N	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
31	2017-08-19 17:07:27.460455	2017-08-19 17:07:27.460455	013AG	Ags Super Cinco	\N	\N	2	1	pruen@hotmail.com	1	2017-08-19	3	50	25	Favio	Velez	\N	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
32	2017-08-19 17:09:54.735458	2017-08-19 17:09:54.735458	015AG	Ags Super Seis	\N	\N	2	1	favio.velez@hotmail.com	1	2017-08-19	3	50	25	Favio	Velez	\N	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
33	2017-08-19 17:15:18.259023	2017-08-19 17:15:18.259023	016AG	Ags Super Siete	\N	\N	2	1	favio.velez@hotmail.com	1	2017-08-19	3	50	25	Favio	Velez	\N	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
34	2017-08-19 17:16:38.084625	2017-08-19 17:16:38.084625	016AG	Ags Super Siete	\N	\N	2	1	favio.velez@hotmail.com	1	2017-08-19	3	50	25	Favio	Velez	\N	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
35	2017-08-19 17:18:54.537779	2017-08-19 17:18:54.537779	016AG	Ags Super Siete	\N	\N	2	1	favio.velez@hotmail.com	1	2017-08-19	3	50	25	Favio	Velez	Morales	3334234234	1234	persona física	\N	Prueba	\N	4324439086	\N
36	2017-08-19 17:20:11.833065	2017-08-19 18:13:23.863697	018AG	Qr Super Ocho	\N	19	6	1	favio.velez@hotmail.com	1	2017-08-19	3	50	25	Favio	Velez	Morales	3334234234	1234	persona física	\N	Prueba	\N	4324439086	19
37	2017-08-19 18:27:28.382951	2017-08-19 18:35:41.781842	TN001	Tienda Nueva	\N	23	7	4	pepepecas@prueba.com	1	2017-08-19	3	50	25	Pepe	Pecas	Pica	3334234234	1234	persona física	\N	Papas	\N	4324439086	\N
38	2017-08-19 18:37:48.354248	2017-08-19 18:44:21.460854	00123	Una mas	\N	24	8	1	sinmiedo@juan.com	1	2017-08-19	3	50	25	Juan	Sin	Miedo	3334234234	1234	persona física	\N	Sin Ventas	\N	4324439086	\N
39	2017-08-19 18:48:06.862717	2017-08-19 18:56:21.040023	NGT001	Tienda Nuevo Grupo	\N	25	9	4	pepetono@hotmail.com	1	2017-08-19	3	50	25	Pepe	Toño	Perez	3334234234	1234	persona moral	\N	Hernandez	4	4324439086	20
40	2017-08-20 21:02:40.78642	2017-08-20 21:02:40.78642	4567	Nueva tienda	\N	\N	4	4	pepetono@hotmail.com	1	2017-08-20	3	50	25	Juanito	Bananas	TIene	3334234234	1234	persona física	\N	TIenda	1	4324439086	\N
41	2017-08-20 21:05:25.200041	2017-08-20 21:39:06.405154	4567	Nueva tiendala	\N	\N	5	4	pepetono@hotmail.com	1	2017-08-20	3	50	25	Juanitos	Bananas	TIene	3334234234	1234	persona moral	\N	TIenda	2	4324439086	\N
42	2017-08-26 18:48:08.807291	2017-08-26 18:50:44.506763	0007	Nueva franquicia	\N	\N	10	1	prado@prueba.com	1	2017-08-26	3	50	25	Pedro	Periciano	Perez	3334234234		persona moral	\N	Prado	5	4324439086	\N
\.


--
-- Name: stores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('stores_id_seq', 42, true);


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY suppliers (id, name, business_type, created_at, updated_at, type_of_person, contact_first_name, contact_middle_name, contact_last_name, contact_position, direct_phone, extension, cell_phone, email, supplier_status, delivery_address_id, last_purchase_bill_date, last_purhcase_folio, store_id) FROM stdin;
2	Sandra Parra Ríos	\N	2017-08-11 16:20:40.31305	2017-08-17 17:15:33.133463	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
4	Srita. Lorena Tapia Félix	\N	2017-08-11 16:20:40.335132	2017-08-17 17:15:33.154401	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
5	Dr. Lorena Velázquez Varela	\N	2017-08-11 16:20:40.346259	2017-08-17 17:15:33.165264	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
6	Sr. Yolanda Magaña Carmona	\N	2017-08-11 16:20:40.356987	2017-08-17 17:15:33.188136	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
7	Dr. Susana Sotelo Rosales	\N	2017-08-11 16:20:40.36829	2017-08-17 17:15:33.222344	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
8	Rosario Franco Vidal	\N	2017-08-11 16:20:40.379237	2017-08-17 17:15:33.264659	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
9	Norma Vásquez Cabrera	\N	2017-08-11 16:20:40.390568	2017-08-17 17:15:33.276811	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
11	Moisés Franco Palma	\N	2017-08-11 16:20:40.412615	2017-08-17 17:15:33.330502	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
12	Micaela Valadez Gil	\N	2017-08-11 16:20:40.424245	2017-08-17 17:15:33.367185	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
13	Srita. Reyna Carranza Salazar	\N	2017-08-11 16:20:40.434798	2017-08-17 17:15:33.386579	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
14	Andrea Andrade Gálvez	\N	2017-08-11 16:20:40.445683	2017-08-17 17:15:33.399059	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
15	Ing. Fabiola Rangel Tovar	\N	2017-08-11 16:20:40.456832	2017-08-17 17:15:33.408438	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
16	Sra. Andrea Juárez Álvarez	\N	2017-08-11 16:20:40.468037	2017-08-17 17:15:33.4202	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
17	Víctor Hugo Piña Tapia	\N	2017-08-11 16:20:40.478907	2017-08-17 17:15:33.431051	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
18	Ing. Edith Figueroa Lara	\N	2017-08-11 16:20:40.48981	2017-08-17 17:15:33.442782	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
20	César Zúñiga Macías	\N	2017-08-11 16:20:40.512434	2017-08-17 17:15:33.53109	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
21	Silvia Félix Treviño	\N	2017-08-11 16:20:40.523129	2017-08-17 17:15:33.553267	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
22	Arturo Cázares Méndez	\N	2017-08-11 16:20:40.534264	2017-08-17 17:15:33.598149	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
23	Arturo Sotelo Santillán	\N	2017-08-11 16:20:40.545862	2017-08-17 17:15:33.608171	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
24	Benjamín Montes Barajas	\N	2017-08-11 16:20:40.556396	2017-08-17 17:15:33.621414	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
25	Srita. Óscar Ávila Balderas	\N	2017-08-11 16:20:40.567392	2017-08-17 17:15:33.629923	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
26	Srita. Gerardo Arenas Lara	\N	2017-08-11 16:20:40.579173	2017-08-17 17:15:33.641695	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
28	Arturo Islas Castellanos	\N	2017-08-11 16:20:40.601265	2017-08-17 17:15:33.663989	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
29	Sra. Carlos Alberto Cruz Duarte	\N	2017-08-11 16:20:40.611805	2017-08-17 17:15:33.674536	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
30	Sra. Héctor Núñez Barrios	\N	2017-08-11 16:20:40.631584	2017-08-17 17:15:33.68583	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
31	José Alberto Velasco Zapata	\N	2017-08-11 16:20:40.644804	2017-08-17 17:15:33.757766	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
32	Gabriela Félix Aranda	\N	2017-08-11 16:20:40.656404	2017-08-17 17:15:33.7761	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
34	Isidro Segura Palacios	\N	2017-08-11 16:20:40.678742	2017-08-17 17:15:33.81832	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
35	Ofelia Téllez Toledo	\N	2017-08-11 16:20:40.68963	2017-08-17 17:15:33.838622	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
36	Sr. Elena Padilla Carrera	\N	2017-08-11 16:20:40.701019	2017-08-17 17:15:33.862724	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
37	Srita. Raquel Ochoa Castellanos	\N	2017-08-11 16:20:40.711879	2017-08-17 17:15:33.896881	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
38	Mario Navarro Alarcón	\N	2017-08-11 16:20:40.723554	2017-08-17 17:15:33.906674	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
39	María Ocampo Mejía	\N	2017-08-11 16:20:40.733686	2017-08-17 17:15:33.919374	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
40	Sandra Miranda Montiel	\N	2017-08-11 16:20:40.745447	2017-08-17 17:15:33.928962	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
41	Lucía Franco Galván	\N	2017-08-11 16:20:40.756721	2017-08-17 17:15:33.940278	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
42	Dr. Armando Rangel Fernández	\N	2017-08-11 16:20:40.767064	2017-08-17 17:15:33.951028	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
43	Raquel Dávila Carrasco	\N	2017-08-11 16:20:40.777874	2017-08-17 17:15:33.963603	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
45	Abel Herrera Pérez	\N	2017-08-11 16:20:40.800031	2017-08-17 17:15:33.984223	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
46	Ing. Moisés Ortiz Armenta	\N	2017-08-11 16:20:40.810974	2017-08-17 17:15:33.997712	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
47	Ing. Enrique Solís Ortega	\N	2017-08-11 16:20:40.822239	2017-08-17 17:15:34.006361	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
48	Raúl Vidal Carrasco	\N	2017-08-11 16:20:40.833121	2017-08-17 17:15:34.030776	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
49	Reyna Arroyo Ortega	\N	2017-08-11 16:20:40.843983	2017-08-17 17:15:34.051135	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
50	Marcela Huerta Saucedo	\N	2017-08-11 16:20:40.866386	2017-08-17 17:15:34.061708	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
51	Gerardo Pacheco Barragán	\N	2017-08-11 16:20:40.899701	2017-08-17 17:15:34.073475	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
53	Guillermo Mejía Vásquez	\N	2017-08-11 16:20:41.000431	2017-08-17 17:15:34.117843	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
54	Paula Rojas Aguirre	\N	2017-08-11 16:20:41.011669	2017-08-17 17:15:34.139881	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
55	Jorge Piña de la Cruz	\N	2017-08-11 16:20:41.022323	2017-08-17 17:15:34.174232	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
56	Ing. Socorro Aparicio Vera	\N	2017-08-11 16:20:41.032823	2017-08-17 17:15:34.195635	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
57	Mario Alberto Saldaña Zapata	\N	2017-08-11 16:20:41.043819	2017-08-17 17:15:34.241382	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
58	Dr. Lidia Maldonado Vera	\N	2017-08-11 16:20:41.055163	2017-08-17 17:15:34.273459	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
59	Eduardo Ayala Castañeda	\N	2017-08-11 16:20:41.065996	2017-08-17 17:15:34.306032	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
61	Srita. Martha Piña Serrano	\N	2017-08-11 16:20:41.088947	2017-08-17 17:15:34.327816	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
62	Ing. Marcos del Ángel Quintana	\N	2017-08-11 16:20:41.099141	2017-08-17 17:15:34.34966	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
63	Ing. Salvador Ponce Peña	\N	2017-08-11 16:20:41.110196	2017-08-17 17:15:34.372772	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
64	Srita. Bertha Palacios Granados	\N	2017-08-11 16:20:41.143788	2017-08-17 17:15:34.383872	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
65	María de Lourdes Saldaña Quintana	\N	2017-08-11 16:20:41.154442	2017-08-17 17:15:34.396354	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
66	Ing. Reyna Morán León	\N	2017-08-11 16:20:41.165456	2017-08-17 17:15:34.405247	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
68	Beatriz Nieto Zaragoza	\N	2017-08-11 16:20:41.187588	2017-08-17 17:15:34.471447	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
69	Dr. Bertha Morán Peralta	\N	2017-08-11 16:20:41.198474	2017-08-17 17:15:34.482903	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
70	Rigoberto Zavala Quintana	\N	2017-08-11 16:20:41.210055	2017-08-17 17:15:34.494728	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
71	José Enríquez Solís	\N	2017-08-11 16:20:41.220724	2017-08-17 17:15:34.505518	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
72	Dr. Marina Carbajal Sandoval	\N	2017-08-11 16:20:41.231864	2017-08-17 17:15:34.519644	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
73	Sr. Roberto de León Ramos	\N	2017-08-11 16:20:41.243326	2017-08-17 17:15:34.550815	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
74	Rosa María Carbajal Salas	\N	2017-08-11 16:20:41.254955	2017-08-17 17:15:34.572544	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
75	Ángela Galicia Bernal	\N	2017-08-11 16:20:41.265793	2017-08-17 17:15:34.582367	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
77	Sra. Ofelia Acosta Carmona	\N	2017-08-11 16:20:41.287384	2017-08-17 17:15:34.605101	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
78	María Luisa Gaytán Gámez	\N	2017-08-11 16:20:41.298663	2017-08-17 17:15:34.615645	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
79	Victoria Arenas Alvarado	\N	2017-08-11 16:20:41.309335	2017-08-17 17:15:34.627128	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
80	Sr. Gregorio Sierra Navarrete	\N	2017-08-11 16:20:41.320512	2017-08-17 17:15:34.637875	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
81	Norma Esquivel Olivares	\N	2017-08-11 16:20:41.331823	2017-08-17 17:15:34.650748	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
82	Ing. Araceli Moreno Durán	\N	2017-08-11 16:20:41.342425	2017-08-17 17:15:34.660533	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
84	Esteban Arriaga Barajas	\N	2017-08-11 16:20:41.365061	2017-08-17 17:15:34.682085	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
85	Ing. Victoria Domínguez Villegas	\N	2017-08-11 16:20:41.375767	2017-08-17 17:15:34.694016	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
86	José Antonio Arias Alcántara	\N	2017-08-11 16:20:41.386883	2017-08-17 17:15:34.704196	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
87	Dr. Gilberto Sandoval Ángeles	\N	2017-08-11 16:20:41.39797	2017-08-17 17:15:34.715657	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
88	Sr. Alejandro Muñoz Cervantes	\N	2017-08-11 16:20:41.409055	2017-08-17 17:15:34.726917	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
89	Dr. Jaime Ortega Gámez	\N	2017-08-11 16:20:41.420294	2017-08-17 17:15:34.737282	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
90	Jesús Muñiz Covarrubias	\N	2017-08-11 16:20:41.431096	2017-08-17 17:15:34.749148	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
91	Antonia de la Torre Morán	\N	2017-08-11 16:20:41.44223	2017-08-17 17:15:34.760954	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
93	Dr. Miguel Carranza Cano	\N	2017-08-11 16:20:41.487713	2017-08-17 17:15:34.804098	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
94	Ing. Félix Meléndez Cortez	\N	2017-08-11 16:20:41.498569	2017-08-17 17:15:34.81567	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
95	Antonia Villa Martínez	\N	2017-08-11 16:20:41.509048	2017-08-17 17:15:34.826447	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
101	\N	persona moral	2017-08-17 15:35:32.91199	2017-08-17 15:35:32.91199	Artículos de Cartón	Bertha		Muñoz	Gerente de Franquicias	331256859	1234	3331234567	bertha@disenos.com	\N	\N	\N	\N	1
102	\N	persona moral	2017-08-17 15:36:19.480809	2017-08-17 15:36:19.480809	Artículos de Cartón	Bertha		Muñoz	Gerente de Franquicias	331256859	1234	3331234567	bertha@disenos.com	\N	\N	\N	\N	1
103	\N	persona moral	2017-08-17 15:38:35.101546	2017-08-17 15:38:35.101546	Artículos de Cartón	Bertha		Muñoz	Gerente de Franquicias	331256859	1234	3331234567	bertha@disenos.com	\N	\N	\N	\N	1
104	\N	persona moral	2017-08-17 15:49:08.179241	2017-08-17 15:49:08.179241	Artículos de Cartón	Favio	Velez	Morales	Gerente de Franquicias	333123456	1234	3331234567	bertha@disenos.com	\N	\N	\N	\N	1
1	Srita. Humberto Rosales Ochoa	\N	2017-08-11 16:20:40.267894	2017-08-17 17:15:33.111983	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
3	Sandra Dávila Zúñiga	\N	2017-08-11 16:20:40.324122	2017-08-17 17:15:33.142783	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
10	Sra. Ramón Navarrete Guerrero	\N	2017-08-11 16:20:40.401534	2017-08-17 17:15:33.286711	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
19	Gabriela Garduño Arredondo	\N	2017-08-11 16:20:40.501029	2017-08-17 17:15:33.486051	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
27	Bertha Álvarez Rojas	\N	2017-08-11 16:20:40.589364	2017-08-17 17:15:33.653662	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
33	María de Lourdes González Espinoza	\N	2017-08-11 16:20:40.668378	2017-08-17 17:15:33.807601	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
44	Sra. José Angel Solano Valdez	\N	2017-08-11 16:20:40.789472	2017-08-17 17:15:33.973075	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
52	Catalina Ortiz Ojeda	\N	2017-08-11 16:20:40.965544	2017-08-17 17:15:34.084287	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
60	Angelina Sandoval Olivares	\N	2017-08-11 16:20:41.076879	2017-08-17 17:15:34.317286	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
67	Guadalupe Santiago Martínez	\N	2017-08-11 16:20:41.176585	2017-08-17 17:15:34.448366	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
76	Sr. Gilberto Salas Tapia	\N	2017-08-11 16:20:41.276646	2017-08-17 17:15:34.593981	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
83	Sr. José Antonio Zepeda Medrano	\N	2017-08-11 16:20:41.353724	2017-08-17 17:15:34.672235	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
92	Esther Reséndiz Trujillo	\N	2017-08-11 16:20:41.45313	2017-08-17 17:15:34.794332	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
96	Sr. Lorenzo Francisco Carbajal	\N	2017-08-11 16:20:41.521502	2017-08-17 17:15:34.836606	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
97	Víctor Arroyo Mejía	\N	2017-08-11 16:20:41.552944	2017-08-17 17:15:34.848498	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
98	Israel Zamora Arreola	\N	2017-08-11 16:20:41.564065	2017-08-17 17:15:34.859081	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
99	Ing. Norma Rentería Balderas	\N	2017-08-11 16:20:41.57553	2017-08-17 17:15:34.870136	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
100	Ing. Rodrigo Olvera Arias	\N	2017-08-11 16:20:41.586063	2017-08-17 17:15:34.882065	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
\.


--
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('suppliers_id_seq', 104, true);


--
-- Data for Name: user_requests; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY user_requests (id, user_id, request_id) FROM stdin;
\.


--
-- Name: user_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('user_requests_id_seq', 1, false);


--
-- Data for Name: user_sales; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY user_sales (id, user_id, month, year, sales_amount, sales_quantity, cost, created_at, updated_at) FROM stdin;
\.


--
-- Name: user_sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('user_sales_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, first_name, middle_name, last_name, store_id, role_id) FROM stdin;
14	masnuevo@nuevo.com	$2a$11$rAKTDCk0.41pwD0Xg8.veegcSHolciAAsW0/ntKpQkytaT1daVLEK	\N	\N	\N	1	2017-07-31 22:09:44.567676	2017-07-31 22:09:44.567676	127.0.0.1	127.0.0.1	2017-07-31 22:09:44.478136	2017-07-31 22:09:44.569212	mas	nuevo	nuevo	1	1
23	sinmiedo@juan.com	$2a$11$UKb35og7ngJyblBxlYV1U.qqx4JeTVdIzSfbkH3mqtCXb6DPvPVU6	\N	\N	\N	1	2017-08-19 18:38:50.569401	2017-08-19 18:38:50.569401	127.0.0.1	127.0.0.1	2017-08-19 18:38:27.91217	2017-08-19 18:38:50.570892	Juan	Sin	Miedo	38	6
2	dr.luis@disenos.com	$2a$11$Zf7GlcLKC3Bmq25JTfuA9.gaxynmsknu7mS.Np0SQaJ6OD0jk66Hq	\N	\N	\N	25	2017-08-26 17:53:30.420963	2017-08-26 16:59:59.914041	127.0.0.1	127.0.0.1	2017-06-19 16:54:58.505738	2017-08-26 17:53:30.423074	luis	\N	cerda	2	5
3	diseno@disenos.com	$2a$11$rQkBoEIieNR0tHAcRJhHQ.W1HwUOhW.7.DFhVCs.AoKI/tpx1mG2y	\N	\N	\N	11	2017-07-29 03:34:36.51703	2017-07-29 00:22:14.958131	127.0.0.1	127.0.0.1	2017-06-19 16:55:35.503713	2017-08-03 14:55:09.92212	Montse	\N	diseñadora	1	3
4	user@user.com	$2a$11$tQmbReIjtmbFsiEX/1gvc.DoEHPMWVSeEHY.iwv14HBnMYHYQzbNi	\N	\N	\N	1	2017-06-19 17:10:42.906548	2017-06-19 17:10:42.906548	127.0.0.1	127.0.0.1	2017-06-19 17:10:42.883517	2017-08-03 14:56:54.694319	Pancho	\N	Villa	3	1
5	nuevo@nuevo.com	$2a$11$Xj/hj5kmH/pv8hIuVnb4geT9HB6AvlWFzJu8QcMXQVtgTZPyXQVaC	\N	\N	\N	2	2017-06-29 00:28:12.802036	2017-06-19 17:20:06.739962	127.0.0.1	127.0.0.1	2017-06-19 17:20:06.686872	2017-08-03 14:57:12.888947	Juancho	\N	Villa	3	1
8	patricia@patricia.com	$2a$11$DnDs/ZfVj42MTChGCfnYi..vCgEL4Sd150Hrh/tjrDDembafcWYsK	\N	\N	\N	1	2017-06-20 01:01:02.84162	2017-06-20 01:01:02.84162	127.0.0.1	127.0.0.1	2017-06-20 01:01:02.824673	2017-06-20 01:01:02.842815	patricia		cerda	2	2
6	newuser@user.com	$2a$11$ThrQ/zywGVgO/zHvAMMaEOHqZW5WWxKfS4o8Exs/mYCMa.v/cgvi.	\N	\N	\N	3	2017-06-20 02:21:01.152933	2017-06-19 17:35:42.096213	127.0.0.1	127.0.0.1	2017-06-19 17:34:05.417626	2017-06-20 02:21:01.154456	soy	el nuevo	mas nuevo	1	1
7	diego@diego.com	$2a$11$WXEBsnKYCrTPKKdEKTEsduN6yWsd0z0BQYp/YS/VE0WcNJ6gk1cgi	\N	\N	\N	5	2017-07-29 03:10:51.680487	2017-07-29 03:08:16.49033	127.0.0.1	127.0.0.1	2017-06-20 01:00:19.744852	2017-07-29 03:10:51.681798	diego	gildardo	cerda	1	2
24	rod@pepetono.com	$2a$11$LeL/OD3.57kicg.iO8Lure5Ee3WdodyvccvYV.LB0j/0QKhwxDSMy	\N	\N	\N	1	2017-08-19 18:50:13.788194	2017-08-19 18:50:13.788194	127.0.0.1	127.0.0.1	2017-08-19 18:49:57.742958	2017-08-19 18:50:13.789454	Pepe	Toño	Perez	39	6
9	favio.nuevo@hotmail.com	$2a$11$yrrCELX2iIl2bwIhRUd24O0XtT0IAyfCVm/p985EJdQrBWrKzNhRC	89284b2e26f8f32d0f0b52aefb8d1fd10d51c6b8bcad8ce50b5b51cc71de4085	2017-07-20 16:24:52.602179	\N	26	2017-07-20 17:54:44.089719	2017-07-20 16:05:15.582541	127.0.0.1	127.0.0.1	2017-06-21 16:27:21.311808	2017-07-20 17:54:44.091678	favio	velez	morales	1	1
20	otraprueba@prueba.com	$2a$11$uiToYNTOjxsIb9VB6yL29.93jOxCK5I3N1QBiV3lJaufoK2CzlhGy	\N	\N	\N	2	2017-08-19 18:03:14.561784	2017-08-19 17:42:46.661632	127.0.0.1	127.0.0.1	2017-08-19 17:42:46.588116	2017-08-19 18:03:14.563496	Favio	Velez	Morales	36	6
11	store_admin@disenos.com	$2a$11$6Ei5zMLb8KHLQOK2n/O5FeAilZCUCNZqv4pJ9Yy712UgVJTiBvIDK	\N	\N	\N	1	2017-07-20 20:25:02.9952	2017-07-20 20:25:02.9952	127.0.0.1	127.0.0.1	2017-07-20 20:25:02.746086	2017-07-20 20:25:02.996297	Favio	Francisco	Velez	1	6
15	prueba2@prueba.com	$2a$11$Ak3zxk082NttNn7G1pl6guWyajJJh1EVmATyIuqfLcqKxA.pIqG3a	\N	\N	\N	0	\N	\N	\N	\N	2017-08-07 02:58:21.609277	2017-08-07 02:58:21.609277	Juanito	Prueba	Soy Prueba	1	1
16	tresprueba@prueba.com	$2a$11$rweyshjFNSq3pbHKedIak.OtPM4dsu9Hr29Pbx2JdgP3QANI.c8hq	\N	\N	\N	0	\N	\N	\N	\N	2017-08-07 03:18:29.383873	2017-08-07 03:18:29.383873	Prueba	Tres	Tres Pruebas	1	1
17	quintaprueba@prueba.com	$2a$11$H9Nq7ZhJjtbwpP6suIjkRuQj.YiETfvCKpY51RwVsl4alaMKCWcmK	\N	\N	\N	0	\N	\N	\N	\N	2017-08-07 03:57:54.320846	2017-08-07 03:57:54.320846	Prueba	Cinco	Quinta Prueba	1	1
18	sextaprueba@prueba.com	$2a$11$9TdVoJ7OMq1x5TH6DxzcrewY4prLn5YXuflBVPCdCWhUIkIITLtJ.	\N	\N	\N	0	\N	\N	\N	\N	2017-08-07 03:58:59.00665	2017-08-07 03:58:59.00665	Prueba	Seis	Sexta Prueba	1	1
21	cuando@probar.com	$2a$11$GzKPeJ2XVJtvEeeHUF8HFOPiagY.W3eq726RWUCuL3SVWkxOlMm3G	\N	\N	\N	1	2017-08-19 18:20:24.035323	2017-08-19 18:20:24.035323	127.0.0.1	127.0.0.1	2017-08-19 18:20:23.993073	2017-08-19 18:20:24.036929	Juan	Pruena	Prueba 	3	6
19	septimaprueba@prueba.com	$2a$11$9vHpZUTlGVZZrSmncMYoNuiwgrA4WWFs7SvNavcnNE6RNgAeI28tC	\N	\N	\N	0	\N	\N	\N	\N	2017-08-07 04:00:15.349674	2017-08-07 04:00:15.349674	Pruebass	Siete	Septima Pruebas	1	1
13	admin@platformadmin.com	$2a$11$hkTggVajFqNj64uYBmUl5OUPsEG/MmutNh44HDkIRuzPAGEYnUlUG	\N	\N	\N	29	2017-08-26 18:46:44.98262	2017-08-20 21:37:56.564767	127.0.0.1	127.0.0.1	2017-07-31 14:57:14.196962	2017-08-26 18:46:44.983939	admin	\N	admin	2	9
22	como@probar.com	$2a$11$/Oevh5cPiwl0ZoPSg2N8NuhYA8vRkdVMKe/9.nM4bSoepa6cIllPO	\N	\N	\N	1	2017-08-19 18:28:22.510885	2017-08-19 18:28:22.510885	127.0.0.1	127.0.0.1	2017-08-19 18:28:22.475069	2017-08-19 18:28:22.512345	Favio	Velez	Morales	37	6
1	favio.velez@hotmail.com	$2a$11$i.celshhnh0ObZnBZdP7Aeli3kMaqh4ZpRBFI24EDRImY3/lzHX/O	\N	\N	\N	89	2017-09-11 00:55:27.121957	2017-09-10 23:40:35.504783	127.0.0.1	127.0.0.1	2017-06-19 16:32:12.020183	2017-09-11 00:55:27.143467	Favio	\N	Velez	1	6
10	rosy@disenos.com	$2a$11$2ec2PePCrfJrHllVKzgCy.KtrovaJnj9pqekUvFg9rNTwinUZEVaG	\N	\N	\N	20	2017-09-11 01:13:10.916205	2017-08-30 20:35:38.376521	127.0.0.1	127.0.0.1	2017-07-15 17:15:50.594907	2017-09-11 01:13:10.956911	Rosy		Diseños De Cartón	2	4
12	almacen@disenos.com	$2a$11$7ibaVDMl6X5.AIHLQXUo/OjxXJZc6LrkEUK5rvV5.JUvZT6u8o7ma	\N	\N	\N	26	2017-09-11 01:20:48.134835	2017-09-11 00:52:24.909634	127.0.0.1	127.0.0.1	2017-07-29 01:23:16.418137	2017-09-11 01:20:48.151097	Juan	Octavio	Lopez	2	8
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('users_id_seq', 24, true);


--
-- Data for Name: warehouse_entries; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY warehouse_entries (id, product_id, quantity, entry_number, created_at, updated_at, movement_id) FROM stdin;
56	1	100	2	2017-08-12 16:33:44.412691	2017-08-12 16:33:44.423117	59
1	15	400	\N	2017-07-31 01:53:16.194453	2017-07-31 02:31:33.479607	4
3	16	200	\N	2017-07-31 01:53:27.373665	2017-07-31 03:13:45.935464	6
4	15	250	\N	2017-07-31 01:53:33.55611	2017-07-31 03:16:34.936867	5
2	16	500	\N	2017-07-31 01:53:21.228322	2017-07-31 03:17:33.054083	7
5	6	\N	\N	2017-08-06 01:57:35.993652	2017-08-06 01:57:36.111088	8
6	16	\N	\N	2017-08-06 01:57:36.143859	2017-08-06 01:57:36.159557	9
58	18	200	12	2017-08-12 16:43:28.674484	2017-08-12 16:43:28.685788	61
7	15	\N	\N	2017-08-06 01:57:36.200078	2017-08-06 01:57:36.212713	10
8	18	\N	\N	2017-08-06 01:57:36.243568	2017-08-06 01:57:36.25645	11
9	6	\N	\N	2017-08-06 01:57:39.243191	2017-08-06 01:57:39.256403	12
10	16	\N	\N	2017-08-06 01:57:39.287171	2017-08-06 01:57:39.299638	13
60	1	500	3	2017-09-07 19:08:27.282711	2017-09-07 19:08:27.293537	79
11	15	\N	\N	2017-08-06 01:57:39.320458	2017-08-06 01:57:39.332893	14
12	18	\N	\N	2017-08-06 01:57:39.354223	2017-08-06 01:57:39.365789	15
13	6	\N	\N	2017-08-06 01:57:39.741535	2017-08-06 01:57:39.755317	16
14	16	\N	\N	2017-08-06 01:57:39.774308	2017-08-06 01:57:39.786549	17
62	1	500	4	2017-09-07 19:08:29.329856	2017-09-07 19:08:29.341736	83
15	15	\N	\N	2017-08-06 01:57:39.808311	2017-08-06 01:57:39.820207	18
16	18	\N	\N	2017-08-06 01:57:39.841638	2017-08-06 01:57:39.852576	19
17	6	\N	\N	2017-08-06 01:59:10.708767	2017-08-06 01:59:10.722843	20
18	14	100	\N	2017-08-06 01:59:10.752245	2017-08-06 01:59:10.764791	21
64	1	500	5	2017-09-07 19:08:31.378156	2017-09-07 19:08:31.389434	87
65	21	10	4	2017-09-10 22:08:42.208305	2017-09-10 22:08:42.282875	94
66	21	50	5	2017-09-10 22:08:58.153851	2017-09-10 22:08:58.166558	95
67	21	100	6	2017-09-10 22:09:13.775744	2017-09-10 22:09:13.795124	96
57	3	200	1	2017-08-12 16:43:28.608289	2017-09-10 23:49:34.052921	60
24	17	99	16	2017-08-06 02:12:57.702272	2017-09-11 00:36:23.804217	27
21	17	100	16	2017-08-06 02:12:44.683435	2017-09-10 23:49:34.36071	24
25	17	99	16	2017-08-06 02:12:58.012254	2017-09-11 00:36:23.891331	28
26	17	99	16	2017-08-06 02:12:58.255238	2017-09-11 00:36:23.968474	29
34	11	500	1	2017-08-06 17:18:25.692405	2017-08-06 17:18:25.746808	37
35	18	300	4	2017-08-06 17:18:25.779382	2017-08-06 17:18:25.792162	38
36	18	200	5	2017-08-06 17:22:44.926319	2017-08-06 17:22:44.950247	39
37	18	150	6	2017-08-06 17:36:58.600498	2017-08-06 17:36:58.643496	40
38	18	100	7	2017-08-06 17:50:33.299992	2017-08-06 17:50:33.315466	41
40	18	10	8	2017-08-06 17:55:45.935507	2017-08-06 17:55:45.948724	43
41	18	90	9	2017-08-06 17:57:15.647331	2017-08-06 17:57:15.670523	44
46	17	599	16	2017-08-11 16:47:41.287674	2017-09-11 00:32:04.5649	49
22	17	99	16	2017-08-06 02:12:44.927142	2017-09-11 00:36:23.636198	25
43	18	90	10	2017-08-07 05:01:07.8838	2017-08-07 05:01:07.895816	46
23	17	99	16	2017-08-06 02:12:57.226059	2017-09-11 00:36:23.724516	26
44	1	500	1	2017-08-11 16:29:19.073872	2017-08-11 16:29:19.138207	47
19	17	99	16	2017-08-06 02:12:43.345085	2017-09-11 00:36:24.056892	22
45	18	900	11	2017-08-11 16:42:13.762898	2017-08-11 16:42:13.774234	48
28	17	99	16	2017-08-06 02:12:58.75358	2017-09-11 00:36:24.146378	31
29	17	99	16	2017-08-06 02:12:59.185924	2017-09-11 00:36:24.223012	32
30	17	99	16	2017-08-06 02:12:59.606858	2017-09-11 00:36:24.300596	33
48	21	450	1	2017-08-12 16:06:40.985715	2017-08-12 16:06:40.996091	51
31	17	99	16	2017-08-06 02:13:00.226389	2017-09-11 00:36:24.401793	34
49	6	50	5	2017-08-12 16:14:44.84165	2017-08-12 16:14:44.855705	52
32	17	99	16	2017-08-06 02:13:01.233909	2017-09-11 00:36:24.50041	35
50	21	150	2	2017-08-12 16:14:44.88618	2017-08-12 16:14:44.898853	53
33	17	99	16	2017-08-06 02:13:01.498997	2017-09-11 00:36:24.577221	36
27	17	99	16	2017-08-06 02:12:58.509929	2017-09-11 00:36:24.689013	30
52	16	100	6	2017-08-12 16:32:05.489022	2017-08-12 16:32:05.507752	55
20	17	99	16	2017-08-06 02:12:44.428795	2017-09-11 00:36:24.76545	23
53	21	100	3	2017-08-12 16:32:05.589575	2017-08-12 16:32:05.600575	56
68	23	80	2	2017-09-11 00:52:50.22704	2017-09-11 00:56:12.073044	146
69	23	780	2	2017-09-11 00:54:24.865908	2017-09-11 00:56:12.98427	156
70	10	100	1	2017-09-11 01:24:51.654233	2017-09-11 01:24:51.78274	166
71	24	100	1	2017-09-11 01:24:52.022767	2017-09-11 01:24:52.086758	167
72	26	500	1	2017-09-11 01:24:52.307131	2017-09-11 01:24:52.397651	168
73	25	300	1	2017-09-11 01:24:52.598258	2017-09-11 01:24:52.683806	169
74	5	850	1	2017-09-11 01:25:29.29771	2017-09-11 01:25:29.391928	170
75	25	450	2	2017-09-11 01:26:25.89962	2017-09-11 01:26:25.983337	171
76	26	200	2	2017-09-11 01:26:26.233725	2017-09-11 01:26:26.294928	172
77	21	300	7	2017-09-11 01:26:26.619271	2017-09-11 01:26:26.683591	173
78	24	300	2	2017-09-11 01:26:26.909823	2017-09-11 01:26:26.992644	174
\.


--
-- Name: warehouse_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('warehouse_entries_id_seq', 78, true);


--
-- Data for Name: warehouses; Type: TABLE DATA; Schema: public; Owner: faviovelez
--

COPY warehouses (id, name, delivery_address_id, created_at, updated_at, business_unit_id, store_id, warehouse_code, business_group_id) FROM stdin;
2	Comercializadora	\N	2017-08-12 19:49:18.743033	2017-08-12 19:49:18.743033	5	\N	AG001	1
1	Diseños	17	2017-08-11 19:14:43.861572	2017-08-12 19:50:55.775926	1	\N	AG000	1
3	Aguascalientes	\N	2017-08-12 19:52:16.336497	2017-08-12 19:52:16.336497	2	\N	AT000	2
4	almacén Nueva Aguascalientes	\N	2017-08-19 00:22:19.622396	2017-08-19 00:22:19.622396	2	\N	AT005AG	\N
5	almacén Nueva Aguascalientes	\N	2017-08-19 00:24:44.050361	2017-08-19 00:24:44.050361	2	\N	AT005AG	\N
6	almacén Nueva Aguascalientes	\N	2017-08-19 00:26:06.73535	2017-08-19 00:26:06.73535	2	\N	AT005AG	\N
7	almacén Aguascalientes nueva	\N	2017-08-19 16:27:23.824512	2017-08-19 16:27:23.824512	2	\N	AT009AG	\N
8	almacén Aguascalientes nueva	\N	2017-08-19 16:29:04.328998	2017-08-19 16:29:04.328998	2	\N	AT009AG	\N
9	almacén Aguascalientes nueva	\N	2017-08-19 16:30:28.274009	2017-08-19 16:30:28.274009	2	\N	AT009AG	\N
10	almacén Aguascalientes nueva	\N	2017-08-19 16:33:00.525777	2017-08-19 16:33:00.525777	2	\N	AT009AG	\N
11	almacén Aguascalientes nueva	\N	2017-08-19 16:36:52.332747	2017-08-19 16:36:52.332747	2	\N	AT009AG	\N
12	almacén Aguascalientes nueva	\N	2017-08-19 16:37:13.106135	2017-08-19 16:37:13.106135	2	\N	AT009AG	\N
13	almacén Aguascalientes nueva	\N	2017-08-19 16:44:26.183402	2017-08-19 16:44:26.183402	2	\N	AT009AG	\N
14	almacén Ags Super Nueva	\N	2017-08-19 16:50:51.107675	2017-08-19 16:50:51.107675	2	\N	AT010AG	\N
15	almacén Ags Super Dos	\N	2017-08-19 16:53:18.896028	2017-08-19 16:53:18.896028	2	\N	AT011AG	\N
16	almacén Ags Super Tres	\N	2017-08-19 16:59:35.698621	2017-08-19 16:59:35.698621	2	\N	AT012AG	\N
17	almacén Ags Super Tres	\N	2017-08-19 17:02:08.975919	2017-08-19 17:02:08.975919	2	\N	AT012AG	\N
18	almacén Ags Super Cuatro	\N	2017-08-19 17:03:50.247212	2017-08-19 17:03:50.247212	2	\N	AT013AG	\N
19	almacén Ags Super Cinco	\N	2017-08-19 17:07:27.399513	2017-08-19 17:07:27.399513	2	\N	AT013AG	\N
20	almacén Ags Super Seis	\N	2017-08-19 17:09:54.660974	2017-08-19 17:09:54.660974	2	\N	AT015AG	\N
21	almacén Ags Super Siete	\N	2017-08-19 17:15:18.18129	2017-08-19 17:15:18.18129	2	\N	AT016AG	\N
22	almacén Ags Super Siete	\N	2017-08-19 17:16:38.027574	2017-08-19 17:16:38.027574	2	\N	AT016AG	\N
23	almacén Ags Super Siete	\N	2017-08-19 17:18:54.454839	2017-08-19 17:18:54.454839	2	\N	AT016AG	\N
24	almacén Ags Super Ocho	\N	2017-08-19 17:20:11.796465	2017-08-19 17:20:11.796465	2	\N	AT018AG	\N
25	almacén Tienda Nueva	\N	2017-08-19 18:27:28.264246	2017-08-19 18:27:28.264246	7	\N	ATTN001	\N
26	almacén Una mas	\N	2017-08-19 18:37:48.30787	2017-08-19 18:37:48.30787	8	\N	AT00123	\N
27	almacén Tienda Nuevo Grupo	\N	2017-08-19 18:48:06.746134	2017-08-19 18:48:06.746134	9	\N	ATNGT001	\N
28	almacén Nueva tienda	\N	2017-08-20 21:05:25.310501	2017-08-20 21:05:25.310501	4	41	AT4567	1
29	almacén Nueva franquicia	\N	2017-08-26 18:48:08.937418	2017-08-26 18:48:08.937418	10	42	AT9997	5
\.


--
-- Name: warehouses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: faviovelez
--

SELECT pg_catalog.setval('warehouses_id_seq', 29, true);


--
-- Name: additional_discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY additional_discounts
    ADD CONSTRAINT additional_discounts_pkey PRIMARY KEY (id);


--
-- Name: bill_receiveds_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bill_receiveds
    ADD CONSTRAINT bill_receiveds_pkey PRIMARY KEY (id);


--
-- Name: billing_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY billing_addresses
    ADD CONSTRAINT billing_addresses_pkey PRIMARY KEY (id);


--
-- Name: bills_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bills
    ADD CONSTRAINT bills_pkey PRIMARY KEY (id);


--
-- Name: business_group_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_group_sales
    ADD CONSTRAINT business_group_sales_pkey PRIMARY KEY (id);


--
-- Name: business_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_groups
    ADD CONSTRAINT business_groups_pkey PRIMARY KEY (id);


--
-- Name: business_groups_suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_groups_suppliers
    ADD CONSTRAINT business_groups_suppliers_pkey PRIMARY KEY (id);


--
-- Name: business_unit_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_unit_sales
    ADD CONSTRAINT business_unit_sales_pkey PRIMARY KEY (id);


--
-- Name: business_units_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_units
    ADD CONSTRAINT business_units_pkey PRIMARY KEY (id);


--
-- Name: carriers_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY carriers
    ADD CONSTRAINT carriers_pkey PRIMARY KEY (id);


--
-- Name: cost_types_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY cost_types
    ADD CONSTRAINT cost_types_pkey PRIMARY KEY (id);


--
-- Name: delivery_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY delivery_addresses
    ADD CONSTRAINT delivery_addresses_pkey PRIMARY KEY (id);


--
-- Name: delivery_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY delivery_attempts
    ADD CONSTRAINT delivery_attempts_pkey PRIMARY KEY (id);


--
-- Name: delivery_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY delivery_packages
    ADD CONSTRAINT delivery_packages_pkey PRIMARY KEY (id);


--
-- Name: design_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY design_costs
    ADD CONSTRAINT design_costs_pkey PRIMARY KEY (id);


--
-- Name: design_request_users_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY design_request_users
    ADD CONSTRAINT design_request_users_pkey PRIMARY KEY (id);


--
-- Name: design_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY design_requests
    ADD CONSTRAINT design_requests_pkey PRIMARY KEY (id);


--
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- Name: images_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: inventories_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY inventories
    ADD CONSTRAINT inventories_pkey PRIMARY KEY (id);


--
-- Name: inventory_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY inventory_configurations
    ADD CONSTRAINT inventory_configurations_pkey PRIMARY KEY (id);


--
-- Name: movements_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements
    ADD CONSTRAINT movements_pkey PRIMARY KEY (id);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: orders_users_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders_users
    ADD CONSTRAINT orders_users_pkey PRIMARY KEY (id);


--
-- Name: payments_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: pending_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY pending_movements
    ADD CONSTRAINT pending_movements_pkey PRIMARY KEY (id);


--
-- Name: product_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY product_requests
    ADD CONSTRAINT product_requests_pkey PRIMARY KEY (id);


--
-- Name: product_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY product_sales
    ADD CONSTRAINT product_sales_pkey PRIMARY KEY (id);


--
-- Name: production_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY production_orders
    ADD CONSTRAINT production_orders_pkey PRIMARY KEY (id);


--
-- Name: production_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY production_requests
    ADD CONSTRAINT production_requests_pkey PRIMARY KEY (id);


--
-- Name: products_bills_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY products_bills
    ADD CONSTRAINT products_bills_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: prospect_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY prospect_sales
    ADD CONSTRAINT prospect_sales_pkey PRIMARY KEY (id);


--
-- Name: prospects_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY prospects
    ADD CONSTRAINT prospects_pkey PRIMARY KEY (id);


--
-- Name: request_users_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY request_users
    ADD CONSTRAINT request_users_pkey PRIMARY KEY (id);


--
-- Name: requests_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: store_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY store_sales
    ADD CONSTRAINT store_sales_pkey PRIMARY KEY (id);


--
-- Name: store_types_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY store_types
    ADD CONSTRAINT store_types_pkey PRIMARY KEY (id);


--
-- Name: stores_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: user_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY user_requests
    ADD CONSTRAINT user_requests_pkey PRIMARY KEY (id);


--
-- Name: user_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY user_sales
    ADD CONSTRAINT user_sales_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: warehouse_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY warehouse_entries
    ADD CONSTRAINT warehouse_entries_pkey PRIMARY KEY (id);


--
-- Name: warehouses_pkey; Type: CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY warehouses
    ADD CONSTRAINT warehouses_pkey PRIMARY KEY (id);


--
-- Name: index_bill_receiveds_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_bill_receiveds_on_business_unit_id ON bill_receiveds USING btree (business_unit_id);


--
-- Name: index_bill_receiveds_on_product_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_bill_receiveds_on_product_id ON bill_receiveds USING btree (product_id);


--
-- Name: index_bill_receiveds_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_bill_receiveds_on_store_id ON bill_receiveds USING btree (store_id);


--
-- Name: index_bill_receiveds_on_supplier_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_bill_receiveds_on_supplier_id ON bill_receiveds USING btree (supplier_id);


--
-- Name: index_bills_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_bills_on_business_unit_id ON bills USING btree (business_unit_id);


--
-- Name: index_bills_on_issuing_company_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_bills_on_issuing_company_id ON bills USING btree (issuing_company_id);


--
-- Name: index_bills_on_order_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_bills_on_order_id ON bills USING btree (order_id);


--
-- Name: index_bills_on_prospect_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_bills_on_prospect_id ON bills USING btree (prospect_id);


--
-- Name: index_bills_on_receiving_company_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_bills_on_receiving_company_id ON bills USING btree (receiving_company_id);


--
-- Name: index_bills_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_bills_on_store_id ON bills USING btree (store_id);


--
-- Name: index_business_group_sales_on_business_group_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_business_group_sales_on_business_group_id ON business_group_sales USING btree (business_group_id);


--
-- Name: index_business_groups_suppliers_on_business_group_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_business_groups_suppliers_on_business_group_id ON business_groups_suppliers USING btree (business_group_id);


--
-- Name: index_business_groups_suppliers_on_supplier_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_business_groups_suppliers_on_supplier_id ON business_groups_suppliers USING btree (supplier_id);


--
-- Name: index_business_unit_sales_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_business_unit_sales_on_business_unit_id ON business_unit_sales USING btree (business_unit_id);


--
-- Name: index_business_units_on_billing_address_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_business_units_on_billing_address_id ON business_units USING btree (billing_address_id);


--
-- Name: index_business_units_on_business_group_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_business_units_on_business_group_id ON business_units USING btree (business_group_id);


--
-- Name: index_carriers_on_delivery_address_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_carriers_on_delivery_address_id ON carriers USING btree (delivery_address_id);


--
-- Name: index_delivery_attempts_on_movement_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_delivery_attempts_on_movement_id ON delivery_attempts USING btree (movement_id);


--
-- Name: index_delivery_attempts_on_order_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_delivery_attempts_on_order_id ON delivery_attempts USING btree (order_id);


--
-- Name: index_delivery_attempts_on_product_request_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_delivery_attempts_on_product_request_id ON delivery_attempts USING btree (product_request_id);


--
-- Name: index_delivery_packages_on_delivery_attempt_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_delivery_packages_on_delivery_attempt_id ON delivery_packages USING btree (delivery_attempt_id);


--
-- Name: index_delivery_packages_on_order_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_delivery_packages_on_order_id ON delivery_packages USING btree (order_id);


--
-- Name: index_design_request_users_on_design_request_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_design_request_users_on_design_request_id ON design_request_users USING btree (design_request_id);


--
-- Name: index_design_request_users_on_user_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_design_request_users_on_user_id ON design_request_users USING btree (user_id);


--
-- Name: index_design_requests_on_request_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_design_requests_on_request_id ON design_requests USING btree (request_id);


--
-- Name: index_documents_on_design_request_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_documents_on_design_request_id ON documents USING btree (design_request_id);


--
-- Name: index_documents_on_request_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_documents_on_request_id ON documents USING btree (request_id);


--
-- Name: index_expenses_on_bill_received_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_expenses_on_bill_received_id ON expenses USING btree (bill_received_id);


--
-- Name: index_expenses_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_expenses_on_business_unit_id ON expenses USING btree (business_unit_id);


--
-- Name: index_expenses_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_expenses_on_store_id ON expenses USING btree (store_id);


--
-- Name: index_expenses_on_user_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_expenses_on_user_id ON expenses USING btree (user_id);


--
-- Name: index_images_on_product_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_images_on_product_id ON images USING btree (product_id);


--
-- Name: index_inventories_on_product_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_inventories_on_product_id ON inventories USING btree (product_id);


--
-- Name: index_inventory_configurations_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_inventory_configurations_on_business_unit_id ON inventory_configurations USING btree (business_unit_id);


--
-- Name: index_inventory_configurations_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_inventory_configurations_on_store_id ON inventory_configurations USING btree (store_id);


--
-- Name: index_movements_on_bill_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_movements_on_bill_id ON movements USING btree (bill_id);


--
-- Name: index_movements_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_movements_on_business_unit_id ON movements USING btree (business_unit_id);


--
-- Name: index_movements_on_delivery_package_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_movements_on_delivery_package_id ON movements USING btree (delivery_package_id);


--
-- Name: index_movements_on_order_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_movements_on_order_id ON movements USING btree (order_id);


--
-- Name: index_movements_on_product_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_movements_on_product_id ON movements USING btree (product_id);


--
-- Name: index_movements_on_product_request_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_movements_on_product_request_id ON movements USING btree (product_request_id);


--
-- Name: index_movements_on_prospect_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_movements_on_prospect_id ON movements USING btree (prospect_id);


--
-- Name: index_movements_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_movements_on_store_id ON movements USING btree (store_id);


--
-- Name: index_movements_on_supplier_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_movements_on_supplier_id ON movements USING btree (supplier_id);


--
-- Name: index_movements_on_user_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_movements_on_user_id ON movements USING btree (user_id);


--
-- Name: index_orders_on_billing_address_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_orders_on_billing_address_id ON orders USING btree (billing_address_id);


--
-- Name: index_orders_on_carrier_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_orders_on_carrier_id ON orders USING btree (carrier_id);


--
-- Name: index_orders_on_delivery_address_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_orders_on_delivery_address_id ON orders USING btree (delivery_address_id);


--
-- Name: index_orders_on_prospect_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_orders_on_prospect_id ON orders USING btree (prospect_id);


--
-- Name: index_orders_on_request_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_orders_on_request_id ON orders USING btree (request_id);


--
-- Name: index_orders_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_orders_on_store_id ON orders USING btree (store_id);


--
-- Name: index_orders_users_on_order_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_orders_users_on_order_id ON orders_users USING btree (order_id);


--
-- Name: index_orders_users_on_user_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_orders_users_on_user_id ON orders_users USING btree (user_id);


--
-- Name: index_payments_on_bill_received_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_payments_on_bill_received_id ON payments USING btree (bill_received_id);


--
-- Name: index_payments_on_supplier_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_payments_on_supplier_id ON payments USING btree (supplier_id);


--
-- Name: index_pending_movements_on_bill_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_pending_movements_on_bill_id ON pending_movements USING btree (bill_id);


--
-- Name: index_pending_movements_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_pending_movements_on_business_unit_id ON pending_movements USING btree (business_unit_id);


--
-- Name: index_pending_movements_on_order_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_pending_movements_on_order_id ON pending_movements USING btree (order_id);


--
-- Name: index_pending_movements_on_product_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_pending_movements_on_product_id ON pending_movements USING btree (product_id);


--
-- Name: index_pending_movements_on_product_request_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_pending_movements_on_product_request_id ON pending_movements USING btree (product_request_id);


--
-- Name: index_pending_movements_on_prospect_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_pending_movements_on_prospect_id ON pending_movements USING btree (prospect_id);


--
-- Name: index_pending_movements_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_pending_movements_on_store_id ON pending_movements USING btree (store_id);


--
-- Name: index_pending_movements_on_supplier_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_pending_movements_on_supplier_id ON pending_movements USING btree (supplier_id);


--
-- Name: index_pending_movements_on_user_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_pending_movements_on_user_id ON pending_movements USING btree (user_id);


--
-- Name: index_product_requests_on_delivery_package_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_product_requests_on_delivery_package_id ON product_requests USING btree (delivery_package_id);


--
-- Name: index_product_requests_on_order_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_product_requests_on_order_id ON product_requests USING btree (order_id);


--
-- Name: index_product_requests_on_product_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_product_requests_on_product_id ON product_requests USING btree (product_id);


--
-- Name: index_product_sales_on_product_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_product_sales_on_product_id ON product_sales USING btree (product_id);


--
-- Name: index_production_orders_on_user_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_production_orders_on_user_id ON production_orders USING btree (user_id);


--
-- Name: index_production_requests_on_product_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_production_requests_on_product_id ON production_requests USING btree (product_id);


--
-- Name: index_production_requests_on_production_order_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_production_requests_on_production_order_id ON production_requests USING btree (production_order_id);


--
-- Name: index_products_bills_on_bill_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_products_bills_on_bill_id ON products_bills USING btree (bill_id);


--
-- Name: index_products_bills_on_product_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_products_bills_on_product_id ON products_bills USING btree (product_id);


--
-- Name: index_products_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_products_on_business_unit_id ON products USING btree (business_unit_id);


--
-- Name: index_products_on_warehouse_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_products_on_warehouse_id ON products USING btree (warehouse_id);


--
-- Name: index_prospect_sales_on_prospect_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_prospect_sales_on_prospect_id ON prospect_sales USING btree (prospect_id);


--
-- Name: index_prospects_on_billing_address_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_prospects_on_billing_address_id ON prospects USING btree (billing_address_id);


--
-- Name: index_prospects_on_business_group_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_prospects_on_business_group_id ON prospects USING btree (business_group_id);


--
-- Name: index_prospects_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_prospects_on_business_unit_id ON prospects USING btree (business_unit_id);


--
-- Name: index_prospects_on_delivery_address_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_prospects_on_delivery_address_id ON prospects USING btree (delivery_address_id);


--
-- Name: index_prospects_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_prospects_on_store_id ON prospects USING btree (store_id);


--
-- Name: index_request_users_on_request_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_request_users_on_request_id ON request_users USING btree (request_id);


--
-- Name: index_request_users_on_user_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_request_users_on_user_id ON request_users USING btree (user_id);


--
-- Name: index_requests_on_product_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_requests_on_product_id ON requests USING btree (product_id);


--
-- Name: index_requests_on_prospect_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_requests_on_prospect_id ON requests USING btree (prospect_id);


--
-- Name: index_requests_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_requests_on_store_id ON requests USING btree (store_id);


--
-- Name: index_store_sales_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_store_sales_on_store_id ON store_sales USING btree (store_id);


--
-- Name: index_store_types_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_store_types_on_business_unit_id ON store_types USING btree (business_unit_id);


--
-- Name: index_stores_on_billing_address_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_stores_on_billing_address_id ON stores USING btree (billing_address_id);


--
-- Name: index_stores_on_business_group_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_stores_on_business_group_id ON stores USING btree (business_group_id);


--
-- Name: index_stores_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_stores_on_business_unit_id ON stores USING btree (business_unit_id);


--
-- Name: index_stores_on_cost_type_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_stores_on_cost_type_id ON stores USING btree (cost_type_id);


--
-- Name: index_stores_on_delivery_address_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_stores_on_delivery_address_id ON stores USING btree (delivery_address_id);


--
-- Name: index_stores_on_store_type_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_stores_on_store_type_id ON stores USING btree (store_type_id);


--
-- Name: index_suppliers_on_delivery_address_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_suppliers_on_delivery_address_id ON suppliers USING btree (delivery_address_id);


--
-- Name: index_suppliers_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_suppliers_on_store_id ON suppliers USING btree (store_id);


--
-- Name: index_user_requests_on_request_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_user_requests_on_request_id ON user_requests USING btree (request_id);


--
-- Name: index_user_requests_on_user_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_user_requests_on_user_id ON user_requests USING btree (user_id);


--
-- Name: index_user_sales_on_user_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_user_sales_on_user_id ON user_sales USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_role_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_users_on_role_id ON users USING btree (role_id);


--
-- Name: index_users_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_users_on_store_id ON users USING btree (store_id);


--
-- Name: index_warehouse_entries_on_movement_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_warehouse_entries_on_movement_id ON warehouse_entries USING btree (movement_id);


--
-- Name: index_warehouse_entries_on_product_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_warehouse_entries_on_product_id ON warehouse_entries USING btree (product_id);


--
-- Name: index_warehouses_on_business_group_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_warehouses_on_business_group_id ON warehouses USING btree (business_group_id);


--
-- Name: index_warehouses_on_business_unit_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_warehouses_on_business_unit_id ON warehouses USING btree (business_unit_id);


--
-- Name: index_warehouses_on_delivery_address_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_warehouses_on_delivery_address_id ON warehouses USING btree (delivery_address_id);


--
-- Name: index_warehouses_on_store_id; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE INDEX index_warehouses_on_store_id ON warehouses USING btree (store_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: faviovelez
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_00979c89fe; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY user_sales
    ADD CONSTRAINT fk_rails_00979c89fe FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_02ce79b5b4; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY warehouses
    ADD CONSTRAINT fk_rails_02ce79b5b4 FOREIGN KEY (delivery_address_id) REFERENCES delivery_addresses(id);


--
-- Name: fk_rails_0756b72a6a; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY product_requests
    ADD CONSTRAINT fk_rails_0756b72a6a FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- Name: fk_rails_098a52d9b6; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY design_requests
    ADD CONSTRAINT fk_rails_098a52d9b6 FOREIGN KEY (request_id) REFERENCES requests(id);


--
-- Name: fk_rails_09b4d3ff00; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY pending_movements
    ADD CONSTRAINT fk_rails_09b4d3ff00 FOREIGN KEY (product_request_id) REFERENCES product_requests(id);


--
-- Name: fk_rails_0d861297f6; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements
    ADD CONSTRAINT fk_rails_0d861297f6 FOREIGN KEY (bill_id) REFERENCES bills(id);


--
-- Name: fk_rails_0edb9dd0ee; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT fk_rails_0edb9dd0ee FOREIGN KEY (billing_address_id) REFERENCES billing_addresses(id);


--
-- Name: fk_rails_137b6598e5; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT fk_rails_137b6598e5 FOREIGN KEY (request_id) REFERENCES requests(id);


--
-- Name: fk_rails_150d465a19; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_unit_sales
    ADD CONSTRAINT fk_rails_150d465a19 FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_1b3a585bc1; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bill_receiveds
    ADD CONSTRAINT fk_rails_1b3a585bc1 FOREIGN KEY (supplier_id) REFERENCES suppliers(id);


--
-- Name: fk_rails_1c267779d8; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY delivery_packages
    ADD CONSTRAINT fk_rails_1c267779d8 FOREIGN KEY (delivery_attempt_id) REFERENCES delivery_attempts(id);


--
-- Name: fk_rails_21537d49a4; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY warehouses
    ADD CONSTRAINT fk_rails_21537d49a4 FOREIGN KEY (business_group_id) REFERENCES business_groups(id);


--
-- Name: fk_rails_224fd3a1ee; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements
    ADD CONSTRAINT fk_rails_224fd3a1ee FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_25069fb842; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY expenses
    ADD CONSTRAINT fk_rails_25069fb842 FOREIGN KEY (bill_received_id) REFERENCES bill_receiveds(id);


--
-- Name: fk_rails_25702a7833; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY inventory_configurations
    ADD CONSTRAINT fk_rails_25702a7833 FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_27fc785359; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY pending_movements
    ADD CONSTRAINT fk_rails_27fc785359 FOREIGN KEY (prospect_id) REFERENCES prospects(id);


--
-- Name: fk_rails_2f24c9d415; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY requests
    ADD CONSTRAINT fk_rails_2f24c9d415 FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_2f28dfa502; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT fk_rails_2f28dfa502 FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_31ac4b5504; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY delivery_attempts
    ADD CONSTRAINT fk_rails_31ac4b5504 FOREIGN KEY (product_request_id) REFERENCES product_requests(id);


--
-- Name: fk_rails_33ad463348; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements
    ADD CONSTRAINT fk_rails_33ad463348 FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_33d8bab367; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY requests
    ADD CONSTRAINT fk_rails_33d8bab367 FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_3433fcbc70; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY products_bills
    ADD CONSTRAINT fk_rails_3433fcbc70 FOREIGN KEY (bill_id) REFERENCES bills(id);


--
-- Name: fk_rails_387b8ef2d3; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY store_sales
    ADD CONSTRAINT fk_rails_387b8ef2d3 FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_3b02b0895d; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_3b02b0895d FOREIGN KEY (prospect_id) REFERENCES prospects(id);


--
-- Name: fk_rails_3b5d665ed5; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bill_receiveds
    ADD CONSTRAINT fk_rails_3b5d665ed5 FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_3e6c1fef88; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bills
    ADD CONSTRAINT fk_rails_3e6c1fef88 FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_3eb2f07fab; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY products
    ADD CONSTRAINT fk_rails_3eb2f07fab FOREIGN KEY (warehouse_id) REFERENCES warehouses(id);


--
-- Name: fk_rails_402185a86a; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY prospects
    ADD CONSTRAINT fk_rails_402185a86a FOREIGN KEY (delivery_address_id) REFERENCES delivery_addresses(id);


--
-- Name: fk_rails_406f39f4f0; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY suppliers
    ADD CONSTRAINT fk_rails_406f39f4f0 FOREIGN KEY (delivery_address_id) REFERENCES delivery_addresses(id);


--
-- Name: fk_rails_414eec8334; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY prospects
    ADD CONSTRAINT fk_rails_414eec8334 FOREIGN KEY (billing_address_id) REFERENCES billing_addresses(id);


--
-- Name: fk_rails_425ac2caed; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY pending_movements
    ADD CONSTRAINT fk_rails_425ac2caed FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- Name: fk_rails_488389293a; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY pending_movements
    ADD CONSTRAINT fk_rails_488389293a FOREIGN KEY (bill_id) REFERENCES bills(id);


--
-- Name: fk_rails_492e99c8a3; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY product_requests
    ADD CONSTRAINT fk_rails_492e99c8a3 FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_49b6bbba95; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY production_requests
    ADD CONSTRAINT fk_rails_49b6bbba95 FOREIGN KEY (production_order_id) REFERENCES production_orders(id);


--
-- Name: fk_rails_4ce9d9811a; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY expenses
    ADD CONSTRAINT fk_rails_4ce9d9811a FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_4d3ed4cdb0; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT fk_rails_4d3ed4cdb0 FOREIGN KEY (design_request_id) REFERENCES design_requests(id);


--
-- Name: fk_rails_4e330eb95f; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT fk_rails_4e330eb95f FOREIGN KEY (business_group_id) REFERENCES business_groups(id);


--
-- Name: fk_rails_4eed3f1a37; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY carriers
    ADD CONSTRAINT fk_rails_4eed3f1a37 FOREIGN KEY (delivery_address_id) REFERENCES delivery_addresses(id);


--
-- Name: fk_rails_4f4fadc8a6; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY delivery_attempts
    ADD CONSTRAINT fk_rails_4f4fadc8a6 FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- Name: fk_rails_4fbda9f062; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY pending_movements
    ADD CONSTRAINT fk_rails_4fbda9f062 FOREIGN KEY (supplier_id) REFERENCES suppliers(id);


--
-- Name: fk_rails_515b9da291; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY pending_movements
    ADD CONSTRAINT fk_rails_515b9da291 FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_5205cbe319; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY products
    ADD CONSTRAINT fk_rails_5205cbe319 FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_5689e963ba; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders_users
    ADD CONSTRAINT fk_rails_5689e963ba FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_5badea5885; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY inventory_configurations
    ADD CONSTRAINT fk_rails_5badea5885 FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_5fdcb2f4a9; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT fk_rails_5fdcb2f4a9 FOREIGN KEY (store_type_id) REFERENCES store_types(id);


--
-- Name: fk_rails_642f17018b; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_642f17018b FOREIGN KEY (role_id) REFERENCES roles(id);


--
-- Name: fk_rails_65a5eda43a; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY delivery_attempts
    ADD CONSTRAINT fk_rails_65a5eda43a FOREIGN KEY (movement_id) REFERENCES movements(id);


--
-- Name: fk_rails_68f2e08fe5; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_units
    ADD CONSTRAINT fk_rails_68f2e08fe5 FOREIGN KEY (billing_address_id) REFERENCES billing_addresses(id);


--
-- Name: fk_rails_6d85ee2f30; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY production_orders
    ADD CONSTRAINT fk_rails_6d85ee2f30 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_707830cb5c; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY expenses
    ADD CONSTRAINT fk_rails_707830cb5c FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_7b1e5b9c04; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY warehouses
    ADD CONSTRAINT fk_rails_7b1e5b9c04 FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_7d62a3bb49; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements
    ADD CONSTRAINT fk_rails_7d62a3bb49 FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- Name: fk_rails_7d7a75fe97; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_groups_suppliers
    ADD CONSTRAINT fk_rails_7d7a75fe97 FOREIGN KEY (business_group_id) REFERENCES business_groups(id);


--
-- Name: fk_rails_7ef7e306cf; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements
    ADD CONSTRAINT fk_rails_7ef7e306cf FOREIGN KEY (product_request_id) REFERENCES product_requests(id);


--
-- Name: fk_rails_84d7dbb2b8; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY request_users
    ADD CONSTRAINT fk_rails_84d7dbb2b8 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_8c4145bce6; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY suppliers
    ADD CONSTRAINT fk_rails_8c4145bce6 FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_8cd81aedb4; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY prospects
    ADD CONSTRAINT fk_rails_8cd81aedb4 FOREIGN KEY (business_group_id) REFERENCES business_groups(id);


--
-- Name: fk_rails_93bb15f8e6; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY prospects
    ADD CONSTRAINT fk_rails_93bb15f8e6 FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_95d554e6ce; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY product_requests
    ADD CONSTRAINT fk_rails_95d554e6ce FOREIGN KEY (delivery_package_id) REFERENCES delivery_packages(id);


--
-- Name: fk_rails_991dffa454; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY warehouses
    ADD CONSTRAINT fk_rails_991dffa454 FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_9e3b5effdc; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY pending_movements
    ADD CONSTRAINT fk_rails_9e3b5effdc FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_9fa1dd8f1c; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_9fa1dd8f1c FOREIGN KEY (delivery_address_id) REFERENCES delivery_addresses(id);


--
-- Name: fk_rails_a1dda658bf; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_groups_suppliers
    ADD CONSTRAINT fk_rails_a1dda658bf FOREIGN KEY (supplier_id) REFERENCES suppliers(id);


--
-- Name: fk_rails_a317807031; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY production_requests
    ADD CONSTRAINT fk_rails_a317807031 FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_a338f67265; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT fk_rails_a338f67265 FOREIGN KEY (cost_type_id) REFERENCES cost_types(id);


--
-- Name: fk_rails_a352115b8a; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bill_receiveds
    ADD CONSTRAINT fk_rails_a352115b8a FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_a3e8e29093; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_group_sales
    ADD CONSTRAINT fk_rails_a3e8e29093 FOREIGN KEY (business_group_id) REFERENCES business_groups(id);


--
-- Name: fk_rails_aacd40fb8f; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements
    ADD CONSTRAINT fk_rails_aacd40fb8f FOREIGN KEY (delivery_package_id) REFERENCES delivery_packages(id);


--
-- Name: fk_rails_ad5833f15d; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY pending_movements
    ADD CONSTRAINT fk_rails_ad5833f15d FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_aff7515fbd; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY design_request_users
    ADD CONSTRAINT fk_rails_aff7515fbd FOREIGN KEY (design_request_id) REFERENCES design_requests(id);


--
-- Name: fk_rails_b16b3af240; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements
    ADD CONSTRAINT fk_rails_b16b3af240 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_b1cf1f22ab; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY prospect_sales
    ADD CONSTRAINT fk_rails_b1cf1f22ab FOREIGN KEY (prospect_id) REFERENCES prospects(id);


--
-- Name: fk_rails_b352b3e324; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY delivery_packages
    ADD CONSTRAINT fk_rails_b352b3e324 FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- Name: fk_rails_b3873bee4d; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bills
    ADD CONSTRAINT fk_rails_b3873bee4d FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- Name: fk_rails_b3cb052e93; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_b3cb052e93 FOREIGN KEY (request_id) REFERENCES requests(id);


--
-- Name: fk_rails_b5ca6d892e; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY warehouse_entries
    ADD CONSTRAINT fk_rails_b5ca6d892e FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_b7a8fe49ff; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_b7a8fe49ff FOREIGN KEY (billing_address_id) REFERENCES billing_addresses(id);


--
-- Name: fk_rails_b84ae7e5f0; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders_users
    ADD CONSTRAINT fk_rails_b84ae7e5f0 FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- Name: fk_rails_bd36e75ae4; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY images
    ADD CONSTRAINT fk_rails_bd36e75ae4 FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_c2072fcf35; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements
    ADD CONSTRAINT fk_rails_c2072fcf35 FOREIGN KEY (prospect_id) REFERENCES prospects(id);


--
-- Name: fk_rails_c3ee69df61; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY expenses
    ADD CONSTRAINT fk_rails_c3ee69df61 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_c6f326481e; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_c6f326481e FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_caaf3200a8; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY products_bills
    ADD CONSTRAINT fk_rails_caaf3200a8 FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_cf0924baef; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY prospects
    ADD CONSTRAINT fk_rails_cf0924baef FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_cff05179e9; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements
    ADD CONSTRAINT fk_rails_cff05179e9 FOREIGN KEY (supplier_id) REFERENCES suppliers(id);


--
-- Name: fk_rails_d63e170995; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT fk_rails_d63e170995 FOREIGN KEY (bill_received_id) REFERENCES bill_receiveds(id);


--
-- Name: fk_rails_d651349850; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY business_units
    ADD CONSTRAINT fk_rails_d651349850 FOREIGN KEY (business_group_id) REFERENCES business_groups(id);


--
-- Name: fk_rails_da3be5f026; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY product_sales
    ADD CONSTRAINT fk_rails_da3be5f026 FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_dd60a6c3e9; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY user_requests
    ADD CONSTRAINT fk_rails_dd60a6c3e9 FOREIGN KEY (request_id) REFERENCES requests(id);


--
-- Name: fk_rails_de8c07e72e; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY user_requests
    ADD CONSTRAINT fk_rails_de8c07e72e FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_e4faf5fbc4; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT fk_rails_e4faf5fbc4 FOREIGN KEY (delivery_address_id) REFERENCES delivery_addresses(id);


--
-- Name: fk_rails_e5f4323f0e; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT fk_rails_e5f4323f0e FOREIGN KEY (supplier_id) REFERENCES suppliers(id);


--
-- Name: fk_rails_e94eb46135; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY inventories
    ADD CONSTRAINT fk_rails_e94eb46135 FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_ea231b0eee; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY design_request_users
    ADD CONSTRAINT fk_rails_ea231b0eee FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_ea6aafd0d5; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY warehouse_entries
    ADD CONSTRAINT fk_rails_ea6aafd0d5 FOREIGN KEY (movement_id) REFERENCES movements(id);


--
-- Name: fk_rails_eaaa7aa1a3; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY store_types
    ADD CONSTRAINT fk_rails_eaaa7aa1a3 FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_eb6f205e9c; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bills
    ADD CONSTRAINT fk_rails_eb6f205e9c FOREIGN KEY (prospect_id) REFERENCES prospects(id);


--
-- Name: fk_rails_eeecf323a3; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_eeecf323a3 FOREIGN KEY (carrier_id) REFERENCES carriers(id);


--
-- Name: fk_rails_ef812490f2; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY pending_movements
    ADD CONSTRAINT fk_rails_ef812490f2 FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_f0be2fda72; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_f0be2fda72 FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_f138f3e53d; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY requests
    ADD CONSTRAINT fk_rails_f138f3e53d FOREIGN KEY (prospect_id) REFERENCES prospects(id);


--
-- Name: fk_rails_f4fe3a6148; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bills
    ADD CONSTRAINT fk_rails_f4fe3a6148 FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_f61ce68d1c; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY movements
    ADD CONSTRAINT fk_rails_f61ce68d1c FOREIGN KEY (business_unit_id) REFERENCES business_units(id);


--
-- Name: fk_rails_f6b62ea959; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY bill_receiveds
    ADD CONSTRAINT fk_rails_f6b62ea959 FOREIGN KEY (store_id) REFERENCES stores(id);


--
-- Name: fk_rails_f8c8825ba9; Type: FK CONSTRAINT; Schema: public; Owner: faviovelez
--

ALTER TABLE ONLY request_users
    ADD CONSTRAINT fk_rails_f8c8825ba9 FOREIGN KEY (request_id) REFERENCES requests(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

