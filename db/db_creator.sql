CREATE TYPE privilege AS ENUM ('user', 'mod', 'admin', 'owner');

-- Definitely missing some stuff from original file
-- There should be another type defined here but I forgot what it was
CREATE TABLE user (
	user_id		uuid		NOT NULL,
	username	VARCHAR(64) NOT NULL	UNIQUE,
	dob			date,
	level		privilege	DEFAULT 'user',
	first_name	VARCHAR(64),
	last_name	VARCHAR(64),
	email		VARCHAR(128),
	description bytea,
	profile_pic	bytea,
	PRIMARY KEY (user_id)
);

CREATE TABLE messages (
	sender_id		uuid		NOT NULL,
	receiver_id		uuid		NOT NULL,
	message_hash	INTEGER 	NOT NULL,
	sent_time		timestampz	NOT NULL,
	message			bytea		NOT NULL,
	PRIMARY KEY (message_hash, sent_time),
	FOREIGN KEY (sender_id) REFERENCES user,
	FOREIGN KEY (receiver_id) REFERENCES user,
);

CREATE TABLE setting (
	email_on_message	BOOLEAN		DEFAULT false,
	user_id				uuid		NOT NULL,
	PRIMARY KEY (user_id),
	FOREIGN KEY (user_id) REFERENCES user,
);

CREATE TABLE card (
	last_4_digits	VARCHAR(4)	NOT NULL,
	name_on_card	VARCHAR(64)	NOT NULL,
	expiration		VARCHAR(4)	NOT NULL,
	next_token		INTEGER,
	cc_id			uuid		NOT NULL,
	user_id			uuid		NOT NULL ON DELETE CASCADE,
	FOREIGN KEY (user_id) REFERENCES user,
	PRIMARY KEY (cc_id)
);

CREATE TABLE listing (
	listing_id		uuid			NOT NULL,
	price			REAL			NOT NULL,
	broken_price	REAL,
	images			bytea, -- Need to move this to its own table
	description		bytea,
	name			VARCHAR(256)	NOT NULL,
	PRIMARY KEY (listing_id),
);

CREATE TABLE posts (
	listing_id			uuid		NOT NULL,
	user_id				uuid		NOT NULL,
	creation_timestamp	timestampz	NOT NULL,
	FOREIGN KEY (listing_id) REFERENCES listing,
	FOREIGN KEY (user_id) REFERENCES user,
	PRIMARY KEY (listing_id, user_id),
);

CREATE TABLE rents (
	user_id			uuid		NOT NULL,
	listing_id		uuid		NOT NULL,
	rental_id		uuid		NOT NULL,
	start_timestamp timestampz 	NOT NULL,
	end_timestamp	timestampz,
	amount_paid		REAL,
	broken			BOOLEAN 	DEFAULT false,
	PRIMARY KEY (rental_id)
	FOREIGN KEY (user_id) REFERENCES user
	FOREIGN KEY (listing_id) REFERENCES listing
);