
-- Table: public.mssubclass

CREATE TABLE mssubclass
(
    description character varying(53) ,
    code bigint NOT NULL,
    CONSTRAINT pk_mssubclass PRIMARY KEY (code)
);

-- Table: public.mszoning

CREATE TABLE mszoning
(
    id bigint NOT NULL,
    description character varying(29) ,
    code character varying(7) ,
    CONSTRAINT pk_mszoning PRIMARY KEY (id)
);


CREATE TABLE typequality
(
    id bigint NOT NULL,
    code character varying(2) ,
    description character varying(15) ,
    CONSTRAINT pk_quality PRIMARY KEY (id)
);

CREATE TABLE amesdbtemp
(
    "Exter Cond" bigint,
    "Exter Qual" bigint,
    "Heating QC" bigint,
    "Kitchen Qual" bigint,
    "MS Zoning" bigint,
    pid bigint, 
    "Roof Style" character varying(7),
    "Roof Matl" character varying(7),
    "Exterior 1st" character varying(7),
    "Exterior 2nd" character varying(7),
    "Mas Vnr Type" character varying(7),
    "Mas Vnr Area" bigint,
    foundation character varying(6),
    heating character varying(5),
    "Central Air" boolean,
    electrical character varying(5),
    "1st Flr SF" bigint,
    "2nd Flr SF" bigint,
    "Low Qual Fin SF" bigint,
    "Kitchen AbvGr" bigint,
    "TotRms AbvGrd" bigint,
    functional character varying(4),
    fireplaces bigint,
    "Fireplace Qu" character varying(2),
    "Paved Drive" character varying(1),
    "Wood Deck SF" bigint,
    "Open Porch SF" bigint,
    "Enclosed Porch" bigint,
    "3Ssn Porch" bigint,
    "Screen Porch" bigint,
    fence character varying(5),
    "MS SubClass" bigint,
	CONSTRAINT pk_amesdb PRIMARY KEY (pid)
);

CREATE TABLE saleproperty
(
    pid bigint NOT NULL,
    "Sale Date" timestamp without time zone,
    "Sale Type" character varying(5) ,
    "Sale Condition" character varying(7) ,
    saleprice bigint,
    CONSTRAINT pk_saleproperty PRIMARY KEY (pid),
    CONSTRAINT fk_saleproperty_amesdbtemp FOREIGN KEY (pid)
        REFERENCES public.amesdbtemp (pid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE floordetail
(
    pid bigint NOT NULL,
    "Floor" bigint NOT NULL,
    bedrooms bigint,
    "Full Bath" bigint,
    "Half Bath" bigint,
    CONSTRAINT pk_floordetail PRIMARY KEY (pid, "Floor"),
    CONSTRAINT fk_floordetail_amesdbtemp FOREIGN KEY (pid)
        REFERENCES public.amesdbtemp (pid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);