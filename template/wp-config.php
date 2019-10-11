<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wordpress' );

/** MySQL database password */
define( 'DB_PASSWORD', '123.com' );

/** MySQL hostname */
define( 'DB_HOST', '127.0.0.1' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'dla=j WFJ$>WP@8w48Sg)-DC^;g5(j)eya|H;KyQz.3lZNSw~(}.82&;cF<|3bBL' );
define( 'SECURE_AUTH_KEY',  '{zMSI_!}zvj*OJi49~v|u`<6*tee{-EgbcC0<u<<9lV>]S) 9a{Z5aYg>DOcrSej' );
define( 'LOGGED_IN_KEY',    '`/yG|z &vo|jr2T8pIiN:1obH3Wb$LU%cUZ-]@^@p<mZGbCOQ(j`j-5s}3gt{(Ua' );
define( 'NONCE_KEY',        'oQ%LjK]WTZECJ^e4W-l x*hq1_[5p%U0Zt!08s*L#<gMp8x?):R>&.:w)qj?Lz4y' );
define( 'AUTH_SALT',        '>0;NQy?6E?H;i/BFy`&RI7j_~p,Mhnyd:9}pgx& <_zNqPeOx0T{AmX^F~lqfc],' );
define( 'SECURE_AUTH_SALT', ' Qb](td!{,97oFXrl(v796/3)zx2!umfyzFN2@,$!&gKTC%W2-^+larnEjyWqmXw' );
define( 'LOGGED_IN_SALT',   '(fe)^`LrH>q+qWQ</Ismn;+`@t)}scviN15toQ$/]/]4q>D>oAH=wl=EVYD|sde|' );
define( 'NONCE_SALT',       'KLk$2b*6.oqbqJ]vFI?kKR`-<%W+~%9<Zs-TWd,mv)nv^(33G8YR>EWhL`zXK)4;' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
define( 'ALLOW_UNFILTERED_UPLOADS', true );
