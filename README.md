# WordPress Image

Run WordPress in a container with the power of FrankenPHP.

```shellsession
$ podman run ghcr.io/bionicosmos/wordpress:latest
```

## Volumes

For persistence, The following locations should be mounted outside the container.

### WordPress

- `/app/public/wp-config.php`: the configuration file
- `/app/public/wp-content`: the data directory (themes, plugins, uploads, etc.)

### FrankenPHP (Caddy)

- `/config`: the configuration directory
- `/data`: the data directory

## Example

```shellsession
$ podman run \
  --name wordpress \
  -dtp 8080:80 \
  -v ./wordpress/wp-config.php:/app/public/wp-config.php \
  -v ./wordpress/wp-content:/app/public/wp-content \
  -v caddy-data:/data \
  -v caddy-config:/config \
  ghcr.io/bionicosmos/wordpress:2610
```

> [!NOTE]
> For security reasons, the site root directory `/app/public` and its contents are read-only, with the exception of `wp-content`. Consequently, when initializing WordPress using the web installer, please follow these steps:
>
> 1. Start the container by mounting **only** an empty `wp-content` directory. Then proceed with the installation wizard in your browser.
> 2. At the final step, WordPress will prompt you to copy the generated configuration text into `wp-config.php`.
> 3. Once you reach this screen, stop and remove the container. Create the `wp-config.php` file manually on your host, then re-create the container by mounting both `wp-config.php` and `wp-content`, as shown in the example above.
>
> Additionally, it is recommended to add `define("FS_METHOD", "direct");` to `wp-config.php` to allow normal updates and installations directly from the WordPress dashboard.
