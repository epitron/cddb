CREATE TABLE `nodes` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `parent_id` int(11) default NULL,
  `type` varchar(255) collate utf8_unicode_ci default NULL,
  `lent_to_id` int(11) default NULL,
  `comment` text collate utf8_unicode_ci,
  `disc_path` varchar(255) collate utf8_unicode_ci default NULL,
  `crate_id` int(11) default NULL,
  `sleeve_id` int(11) default NULL,
  `size` int(11) default NULL,
  `date` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_nodes_on_name` (`name`),
  KEY `index_nodes_on_parent_id` (`parent_id`),
  KEY `index_nodes_on_type` (`type`),
  KEY `index_nodes_on_lent_to_id` (`lent_to_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) collate utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) collate utf8_unicode_ci NOT NULL,
  `data` text collate utf8_unicode_ci,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20090923143718');

INSERT INTO schema_migrations (version) VALUES ('20090923144706');