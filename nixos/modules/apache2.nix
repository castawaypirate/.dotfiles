{ config, pkgs, ... }:

{
  services.httpd = {
    enable = true;
    enablePHP = true;
    # profile pictures may be up to 10MB; the post limit leaves room for the multipart overhead
    phpOptions = ''
      upload_max_filesize = 10M
      post_max_size = 12M
    '';
    
    user = "castaway";
    group = "users";
    
    adminAddr = "admin@localhost";
    
    # Local development only: every vhost listens on loopback (IPv4 + IPv6)
    virtualHosts = {
      "localhost" = {
        listen = [ { ip = "127.0.0.1"; port = 80; } { ip = "[::1]"; port = 80; } ];
        # Pixelated NixOS logo page, copied into the Nix store so it always exists
        documentRoot = ../www;
        extraConfig = ''
          Alias /adminer "${pkgs.adminer}/"
          <Directory "${pkgs.adminer}/">
            DirectoryIndex adminer.php
            Require all granted
          </Directory>
        '';
      };
      
      "blogdotbackend" = {
        listen = [ { ip = "127.0.0.1"; port = 6969; } { ip = "[::1]"; port = 6969; } ];
        documentRoot = "/home/castaway/Projects/blogdot/blog.backend";
        extraConfig = ''
          <Directory "/home/castaway/Projects/blogdot/blog.backend">
            DirectoryIndex index.php
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
          </Directory>
        '';
      };

      "blogdotfrontend" = {
        listen = [ { ip = "127.0.0.1"; port = 7000; } { ip = "[::1]"; port = 7000; } ];
        documentRoot = "/home/castaway/Projects/blogdot/blog.frontend";
        extraConfig = ''
          <Directory "/home/castaway/Projects/blogdot/blog.frontend">
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
          </Directory>

          ProxyPass /api http://localhost:6969/api
          ProxyPassReverse /api http://localhost:6969/api
          
          ProxyPass /uploads http://localhost:6969/uploads
          ProxyPassReverse /uploads http://localhost:6969/uploads
        '';
      };

    };
  };
}
