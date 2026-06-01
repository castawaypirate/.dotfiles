{ config, pkgs, ... }:

{
  services.httpd = {
    enable = true;
    enablePHP = true;
    
    user = "castaway";
    group = "users";
    
    adminAddr = "admin@localhost";
    
    virtualHosts = {
      "localhost" = {
        documentRoot = "/var/www/localhost";
        extraConfig = ''
          Alias /adminer "${pkgs.adminer}/"
          <Directory "${pkgs.adminer}/">
            DirectoryIndex adminer.php
            Require all granted
          </Directory>
        '';
      };
      
      "blogdotbackend" = {
        listen = [{ port = 6969; }];
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
        listen = [{ port = 7000; }];
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
