-- Database should be named: el_zagal_shriners

CREATE TABLE "user" (
	"id" serial NOT NULL,
	"username" varchar(80) NOT NULL UNIQUE,
	"password" varchar(1000) NOT NULL,
	"first_name" varchar(80) NOT NULL,
	"last_name" varchar(80) NOT NULL,
	"email" varchar(500) NOT NULL,
	"primary_member_id" bigint NOT NULL,
	"is_authorized" BOOLEAN NOT NULL DEFAULT 'false',
	"is_verified" BOOLEAN NOT NULL DEFAULT 'false',
	"review_pending" BOOLEAN NOT NULL DEFAULT 'false',
	"dues_paid" DATE,
	"membership_number" int,
	"admin_level" int NOT NULL DEFAULT '0',
	CONSTRAINT "user_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "vendors" (
	"id" serial NOT NULL,
	"name" varchar(1000) NOT NULL,
	"address" varchar(1000),
	"city" varchar(100) NOT NULL,
	"state_code" varchar(2) NOT NULL,
	"zip" numeric(5,0),
	"website_url" varchar(1000),
	CONSTRAINT "vendors_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "discounts" (
	"id" serial NOT NULL,
	"vendor_id" bigint NOT NULL,
	"discount_description" varchar(1000) NOT NULL,
	"discount_summary" varchar(15) NOT NULL,
	"start_date" DATE,
	"expiration_date" DATE,
	"discount_usage" varchar(255) NOT NULL,
	"category_id" int NOT NULL,
	"is_shown" BOOLEAN NOT NULL DEFAULT 'true',
	"is_regional" BOOLEAN NOT NULL DEFAULT 'false',
	CONSTRAINT "discounts_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "categories" (
	"id" serial NOT NULL,
	"name" varchar(255) NOT NULL,
	"icon_class" varchar(255) NOT NULL,
	CONSTRAINT "categories_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "discounts_tracked" (
	"id" serial NOT NULL,
	"discount_id" bigint NOT NULL,
	"user_id" bigint NOT NULL,
	"date" DATE NOT NULL,
	CONSTRAINT "discounts_tracked_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "location" (
	"id" serial NOT NULL,
	"city" varchar(100) NOT NULL,
	"state_code" varchar(2) NOT NULL,
	"lng" DECIMAL NOT NULL,
	"lat" DECIMAL NOT NULL,
	CONSTRAINT "location_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);

CREATE TABLE "dependent_tokens" (
	"id" serial NOT NULL,
	"primary_member_id" bigint NOT NULL,
	"token" varchar(75) NOT NULL,
	"email" varchar(50) NOT NULL,
	CONSTRAINT "dependent_tokens_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);


-- Use this after adding dependent tokens table
ALTER TABLE "dependent_tokens" ADD CONSTRAINT "dependent_tokens_fk0" FOREIGN KEY ("primary_member_id") REFERENCES "user"("id");

ALTER TABLE "user" ADD CONSTRAINT "user_fk0" FOREIGN KEY ("primary_member_id") REFERENCES "user"("id");

-- DOUBLE CHECK THAT THE "DELETE ON CASCADE" IS WORKING AS INTENDED || Tested working in Postico
ALTER TABLE "discounts" ADD CONSTRAINT "discounts_fk0" FOREIGN KEY ("vendor_id") REFERENCES "vendors"("id") ON DELETE CASCADE;
ALTER TABLE "discounts" ADD CONSTRAINT "discounts_fk1" FOREIGN KEY ("category_id") REFERENCES "categories"("id");

-- DOUBLE CHECK THAT THE "DELETE ON CASCADE" IS WORKING AS INTENDED || Tested working in Postico
ALTER TABLE "discounts_tracked" ADD CONSTRAINT "discounts_tracked_fk0" FOREIGN KEY ("discount_id") REFERENCES "discounts"("id") ON DELETE CASCADE;
ALTER TABLE "discounts_tracked" ADD CONSTRAINT "discounts_tracked_fk1" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE;

-- SAMPLE USERS 15
INSERT INTO "user" ("username", "password", "first_name", "last_name", "email", "primary_member_id", "dues_paid", "membership_number", "admin_level", "is_authorized")
VALUES ('johnsmith', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'John', 'Smith', 'johnsmith@gmail.com', 1, '2022/1/1', '4325346', 0, 'true'),
('janesmith', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Jane', 'Smith', 'janesmith@gmail.com', 1, '2022/1/1', '4325346', 4, 'true'),
('bobsmith', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Bob', 'Smith', 'bobsmith@gmail.com', 3, '2022/1/1', '4325346', 0, 'true'),
('maryjane', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Mary', 'Jane', 'maryjane@gmail.com', 4, '2022/1/1', '4325346', 4, 'true'),
('susansmith', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Susan', 'Smith', 'susansmith@gmail.com', 5, '2022/1/1', '4325346', 0, 'true'),
('johndoe', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'John', 'Doe', 'johndoe@gmail.com', 1, '2022/1/1', '4325346', 0, 'true'),
('janedoe', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Jane', 'Doe', 'janedoe@gmail.com', 7, '2022/1/1', '4325346', 4, 'true'),
('bobdoe', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Bob', 'Doe', 'bobdoe@gmail.com', 1, '2022/1/1', '4325346', 0, 'true'),
('maryjaney', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Mary', 'Jane', 'maryjane@gmail.com', 9, '2022/1/1', '4325346', 0, 'true'),
('susandoe', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Susan', 'Doe', 'susandoe@gmail.com', 3, '2022/1/1', '4325346', 4, 'true'),
('johnsmithy', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'John', 'Smith', 'johnsmith@gmail.com', 4, '2022/1/1', '4325346', 0, 'true'),
('janesmither', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Jane', 'Smith', 'janesmith@gmail.com', 5, '2022/1/1', '4325346', 4, 'true'),
('bobsmit', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Bob', 'Smith', 'bobsmith@gmail.com', 1, '2022/1/1', '4325346', 0, 'true'),
('maryjan', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Mary', 'Jane', 'maryjane@gmail.com', 7, '2022/1/1', '4325346', 4, 'true'),
('susansmi', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Susan', 'Smith', 'susansmith@gmail.com', 9, '2022/1/1', '4325346', 0, 'true'),
('admin', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Admin', 'Admin', 'Admin@gmail.com', 16, '2022/1/1', '4325346', 4, 'true'),
('member', '$2a$10$UrXwP8Jo9s3YzM/1ce8miuhKR8RnoymEzKVM5Y1yyznu5z2QRT8ky', 'Member', 'Member', 'Admin@gmail.com', 17, '2022/1/1', '4325346', 0, 'true');


-- SAMPLE CITIES
INSERT INTO "location" ("city", "state_code", "lng", "lat")
VALUES ('Fargo', 'ND', '-96.789803', '46.877186'),
		('Jamestown', 'ND', '-98.708534', '46.909538'),
		('Moorhead', 'MN', '-96.7678', '46.8738'),
		('Detroit Lakes', 'MN', '-95.848160', '46.827316'),
		('Bismarck', 'ND', '-100.778275', '46.825905'),
		('Mandan', 'ND', '-100.889580', '46.826660'),
		('Ada', 'MN', '-96.515346', '47.299689'),
		('Williston', 'ND', '-103.6180', '48.1470'),
		('Valley City', 'ND', '-98.003159', '46.923313');

-- SAMPLE CATEGORIES 9 items
INSERT INTO "categories" ("name", "icon_class")
VALUES ('Food', 'food'),
		('Drinks', 'drinks'),
		('Sports', 'sports'),
		('Entertainment', 'entertainment'),
		('Lodging', 'lodging'),
		('Shopping', 'shopping'),
		('Rentals', 'rentals'),
		('Home', 'home'),
		('Services', 'services'),
		('Other', 'other'),
		('Health/Beauty', 'health');

--Sample Vendors 20 items
INSERT INTO "vendors"("name","address","city","state_code","zip")
VALUES ('Joe''s Diner', '123 Main St', 'Fargo', 'ND', '12345'),
		('Mary''s Flower Shop', '456 Elm St', 'Fargo', 'ND', '54321'),
		('John''s Barbershop', '789 Oak St', 'Jamestown', 'ND', '13579'),
		('Sam''s Grocery', '012 3rd Ave', 'Moorhead', 'MN', '24680'),
		('Anderson''s Bakery', '345 6th St', 'Ada', 'MN', '01234'),
		('Susan''s Sewing', '678 9th Ave', ' Detroit Lakes', 'MN', '98765'),
		('Mike''s Mechanic', '901 12th St', 'Mandan', 'ND', '56789'),
		('Bill''s Books', '234 15th Ave', 'Valley City', 'ND', '43210'),
		('Joe''s Pizza', '567 18th St', 'Jamestown', 'ND', '76543'),
		('Tom''s Tailor', '890 21st Ave', 'Moorhead', 'MN', '21098'),
		('Joe''s pizzeria', '123 main street', 'Bismarck', 'ND', '10001'),
		('Smith and Co', '456 first avenue', 'Bismarck', 'MN', '10003'),
		('Tom''s diner', '789 second street', 'Bismarck', 'ND', '10002'),
		('Mary''s Beauty salon', '321 third avenue', 'Fargo', 'ND', '10003'),
		('Mike''s garage', '654 fourth street', 'Fargo', 'ND', '10004'),
		('Bill''s bar', '987 fifth avenue', 'Fargo', 'ND', '10005'),
		('John''s plumbing', '741 sixth street', 'Moorhead', 'MN', '10006'),
		('Susan''s bookstore', '852 seventh avenue', 'Moorhead', 'MN', '10007'),
		('Larry''s bakery', '963 eighth avenue', 'Ada', 'MN', '10008'),
		('Carol''s restaurant', '753 ninth avenue', 'Ada', 'MN', '10009');

--Sample discounts 35 items
INSERT INTO "discounts"("vendor_id","discount_description","discount_summary","start_date","expiration_date","discount_usage","category_id")
VALUES (random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present your ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','10% off',NULL,NULL,'Present ID',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','15% off',NULL,NULL,'Sdgljner425',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','20% off',NULL,NULL,'Mention Shriner',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Wings',NULL,NULL,'3gh456herwg',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO Beer',NULL,NULL,'BOGOBEER',random() * 8 + 1),
		(random() * 19 + 1,'A description of the discount will go here','BOGO 50% off',NULL,NULL,'50 Off',random() * 8 + 1);

--Sample discount tracking
INSERT INTO "discounts_tracked"("discount_id","user_id","date")
VALUES (random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-10-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-01'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-02-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-06-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-11-14'),
		(random() * 34 + 1,random() * 14 + 1,'2022-08-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14'),
		(random() * 34 + 1,random() * 14 + 1,'2021-12-14');

