CREATE TABLE IF NOT EXISTS users (
  user_id           VARCHAR(36) PRIMARY KEY CHECK (user_id ~* '^[0-9a-f-]{36,36}$'),
  identity_number   BIGINT NOT NULL,
  full_name         VARCHAR(512) NOT NULL DEFAULT '',
  access_token      VARCHAR(512) NOT NULL DEFAULT '',
  avatar_url        VARCHAR(1024) NOT NULL DEFAULT '',
  trace_id          VARCHAR(36) NOT NULL CHECK (trace_id ~* '^[0-9a-f-]{36,36}$'),
  state             VARCHAR(128) NOT NULL,
  active_at             TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  subscribed_at     TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE UNIQUE INDEX IF NOT EXISTS users_identityx ON users(identity_number);
CREATE INDEX IF NOT EXISTS users_subscribedx ON users(subscribed_at);


CREATE TABLE IF NOT EXISTS messages (
  message_id            VARCHAR(36) PRIMARY KEY CHECK (user_id ~* '^[0-9a-f-]{36,36}$'),
  user_id               VARCHAR(36) NOT NULL CHECK (user_id ~* '^[0-9a-f-]{36,36}$'),
  category              VARCHAR(512) NOT NULL,
  data                  TEXT NOT NULL,
  created_at            TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  state                 VARCHAR(128) NOT NULL,
  last_distribute_at    TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX IF NOT EXISTS messages_state_updatedx ON messages(state, updated_at);


CREATE TABLE IF NOT EXISTS distributed_messages (
  message_id            VARCHAR(36) PRIMARY KEY CHECK (message_id ~* '^[0-9a-f-]{36,36}$'),
  conversation_id       VARCHAR(36) NOT NULL CHECK (conversation_id ~* '^[0-9a-f-]{36,36}$'),
  recipient_id          VARCHAR(36) NOT NULL CHECK (recipient_id ~* '^[0-9a-f-]{36,36}$'),
  user_id               VARCHAR(36) NOT NULL CHECK (user_id ~* '^[0-9a-f-]{36,36}$'),
  parent_id             VARCHAR(36) NOT NULL CHECK (parent_id ~* '^[0-9a-f-]{36,36}$'),
  shard                 VARCHAR(36) NOT NULL,
  category              VARCHAR(512) NOT NULL,
  data                  TEXT NOT NULL,
  status                VARCHAR(512) NOT NULL,
  active_at             TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  created_at            TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS message_shard_status_activex ON distributed_messages(shard, status, active_at);
CREATE INDEX IF NOT EXISTS message_status ON distributed_messages(status);


CREATE TABLE IF NOT EXISTS properties (
  key         VARCHAR(512) PRIMARY KEY,
  value       VARCHAR(8192) NOT NULL,
  updated_at  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS packets (
  packet_id         VARCHAR(36) PRIMARY KEY CHECK (packet_id ~* '^[0-9a-f-]{36,36}$'),
  user_id           VARCHAR(36) NOT NULL CHECK (user_id ~* '^[0-9a-f-]{36,36}$'),
  asset_id          VARCHAR(36) NOT NULL CHECK (asset_id ~* '^[0-9a-f-]{36,36}$'),
  amount            VARCHAR(128) NOT NULL,
  greeting          VARCHAR(36) NOT NULL,
  total_count       BIGINT NOT NULL,
  remaining_count   BIGINT NOT NULL,
  remaining_amount  VARCHAR(128) NOT NULL,
  state             VARCHAR(36) NOT NULL,
  created_at        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS packets_state_createdx ON packets(state, created_at);


CREATE TABLE IF NOT EXISTS participants (
  packet_id         VARCHAR(36) NOT NULL REFERENCES packets(packet_id) ON DELETE CASCADE,
  user_id           VARCHAR(36) NOT NULL CHECK (user_id ~* '^[0-9a-f-]{36,36}$'),
  amount            VARCHAR(128) NOT NULL,
  created_at        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
  paid_at           TIMESTAMP WITH TIME ZONE,
  PRIMARY KEY(packet_id, user_id)
);

CREATE INDEX IF NOT EXISTS participants_created_paidx ON participants(created_at, paid_at);


CREATE TABLE IF NOT EXISTS assets (
  asset_id         VARCHAR(36) PRIMARY KEY CHECK (asset_id ~* '^[0-9a-f-]{36,36}$'),
  symbol           VARCHAR(512) NOT NULL,
  name             VARCHAR(512) NOT NULL,
  icon_url         VARCHAR(1024) NOT NULL,
  price_btc        VARCHAR(128) NOT NULL,
  price_usd        VARCHAR(128) NOT NULL
);


CREATE TABLE IF NOT EXISTS blacklists (
  user_id	          VARCHAR(36) PRIMARY KEY CHECK (user_id ~* '^[0-9a-f-]{36,36}$')
);
