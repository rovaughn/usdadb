create table food (
	food_id             integer primary key,
	food_group_id       integer not null references food_group(food_group_id),
	long_description    text not null,
	short_description   text not null,
	common_name         text null,
	manufacturer        text null,
	survey              boolean not null,
	refuse_description  text null,
	refuse_percentage   integer null,
	scientific_name     text null,
	nitrogen_factor     decimal(4, 2) null,
	protein_factor      decimal(4, 2) null,
	fat_factor          decimal(4, 2) null,
	cho_factor          decimal(4, 2) null
);

create table food_nutrient (
	food_id            integer not null references food(food_id),
	nutrient_id        integer not null references nutrient(nutrient_id),
	amount_100g        decimal(10, 3) not null,
	data_points        integer null,
	std_error          decimal(8, 3) null,
	source_id          integer null references source(source_id),
	derivation_id      text null references derivation(derivation_id),
	reference_food_id  integer null references food(food_id),
	nutrients_added    boolean not null,
	studies            integer null,
	min                decimal(10, 3) null,
	max                decimal(10, 3) null,
	degrees_freedom    integer null,
	lower_error_95     decimal(10, 3) null,
	upper_error_95     decimal(10, 3) null,
	statistical_note   text null,
	updated            text null
);

create table weight (
	food_id      integer not null references food(food_id),
	sequence     integer not null,
	amount       decimal(5, 3) not null,
	measurement  text not null,
	gram_weight  decimal(7, 1) not null,
	data_points  integer null,
	std_dev      decimal(7, 3) null
);

create table footnote (
	food_id      integer not null references food(food_id),
	no           integer null,
	type         char not null,
	nutrient_id  integer null,
	description  text not null
);

create table food_group (
	food_group_id  integer primary key,
	description    text not null
);

create table food_langual_factor (
	food_id            integer not null references food(food_id),
	langual_factor_id  text not null references langual_factor(langual_factor_id)
);

create table langual_factor (
	langual_factor_id  text primary key,
	description        text not null
);

create table nutrient (
	nutrient_id     integer primary key,
	units           text not null,
	tagname         text null,
	description     text not null,
	decimal_places  integer not null,
	sort_order      integer not null
);

create table source (
	source_id    integer primary key,
	description  text not null
);

create table derivation (
	derivation_id  text primary key,
	description    text not null
);

create table food_nutrient_source (
	food_id         integer not null references food(food_id),
	nutrient_id     integer not null references nutrient(nutrient_id),
	data_source_id  text not null references data_source(data_source_id)
);

create table data_source (
	data_source_id  text primary key,
	authors         text null,
	title           text not null,
	year            integer null,
	journal         text null,
	volume_city     text null,
	issue_state     text null,
	start_page      integer null,
	end_page        integer null
);
