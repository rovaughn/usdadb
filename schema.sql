
create table food (
    id                 integer primary key,
    food_group         integer not null references food_group(id),
    long_description   text not null,
    short_description  text not null,
    common_name        text null,
    manufacturer       text null,
    survey             boolean not null,
    refuse_description text null,
    refuse_percentage  integer null,
    scientific_name    text null,
    nitrogen_factor    decimal(4, 2) null,
    protein_factor     decimal(4, 2) null,
    fat_factor         decimal(4, 2) null,
    cho_factor         decimal(4, 2) null
);

create table food_nutrient (
    food             integer not null references food(id),
    nutrient         integer not null references nutrient(id),
    amount_100g      decimal(10, 3) not null,
    data_points      integer null,
    std_error        decimal(8, 3) null,
    source           integer null references source(id),
    derivation       text null references derivation(id),
    reference_food   integer null references food(id),
    nutrients_added  boolean not null,
    studies          integer null,
    min              decimal(10, 3) null,
    max              decimal(10, 3) null,
    degrees_freedom  integer null,
    lower_error_95   decimal(10, 3) null,
    upper_error_95   decimal(10, 3) null,
    statistical_note text null,
    updated          text null
);

create table weight (
    food        integer not null references food(id),
    sequence    integer not null,
    amount      decimal(5, 3) not null,
    measurement text not null,
    gram_weight decimal(7, 1) not null,
    data_points integer null,
    std_dev     decimal(7, 3) null
);

create table footnote (
    food integer not null references food(id),
    no integer null,
    type integer not null references footnote_type(id),
    nutrient integer null,
    description text not null
);

create table footnote_type (
    letter char primary key
);

insert into footnote_type (letter) values ('D');
insert into footnote_type (letter) values ('M');
insert into footnote_type (letter) values ('N');

create table food_group (
    id          integer primary key,
    description text not null
);

create table food_langual_factor (
    food   integer not null references food(id),
    factor text not null references langual_factor(id)
);

create table langual_factor (
    id          text primary key,
    description text not null
);

create table nutrient (
    id             integer primary key,
    units          text not null,
    tagname        text null,
    description    text not null,
    decimal_places integer not null,
    sort_order     integer not null
);

create table source (
    id          integer primary key,
    description text not null
);

create table derivation (
    id          text primary key,
    description text not null
);

create table food_nutrient_source (
    food        integer not null references food(id),
    nutrient    integer not null references nutrient(id),
    data_source text not null references data_source(id)
);

create table data_source (
    id          text primary key,
    authors     text null,
    title       text not null,
    year        integer null,
    journal     text null,
    volume_city text null,
    issue_state text null,
    start_page  integer null,
    end_page    integer null
);

