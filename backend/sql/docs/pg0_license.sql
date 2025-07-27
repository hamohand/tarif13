DROP TABLE IF EXISTS license;

CREATE TABLE license (
     id BIGSERIAL PRIMARY KEY,
     activation_date TIMESTAMP WITHOUT TIME ZONE, -- Correspond à activationDate
     valid_until TIMESTAMP WITHOUT TIME ZONE      -- Correspond à validUntil
    -- Ajoutez d'autres contraintes ou colonnes si votre entité License en a plus.
);
