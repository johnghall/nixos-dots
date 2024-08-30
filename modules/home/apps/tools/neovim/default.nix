{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.neovim;

  lazy-nix-helper-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "lazy-nix-helper.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "b-src";
      repo = "lazy-nix-helper.nvim";
      rev = "63b20ed071647bb492ed3256fbda709e4bfedc45";
      hash = "sha256-TBDZGj0NXkWvJZJ5ngEqbhovf6RPm9N+Rmphz92CS3Q=";
    };
  };

  sanitizePluginName = input: let
    name = strings.getName input;
    intermediate = strings.removePrefix "vimplugin-" name;
    result = strings.removePrefix "lua5.1-" intermediate;
  in
    result;

  pluginList = plugins: strings.concatMapStrings (plugin: "  [\"${sanitizePluginName plugin.name}\"] = \"${plugin.outPath}\",\n") plugins;
in {
  options.apps.tools.neovim = with types; {
    enable = mkBoolOpt false "Enable Neovim";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      catppuccin.enable = false;
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        # Formatters
        black # Python
        prettierd # Multi-language
        shfmt
        isort
        rustywind

        # LSP
        # vscode-langservers-extracted
        nodePackages.vscode-json-languageserver
        nodePackages.typescript-language-server
        tailwindcss-language-server
        clang

        # Tools
        git
        html-tidy
        cmake
        fzf
        charm-freeze
        gcc
        gnumake
        nodejs
        fswatch # File watcher utility, replacing libuv.fs_event for neovim 10.0
        sqlite
        postgresql
        mongosh
        gerbera
        vscode-extensions.vadimcn.vscode-lldb.adapter
        cargo
        rustc
      ];
      plugins = with pkgs.vimPlugins; [
        lazy-nix-helper-nvim
        lazy-nvim
      ];
      extraLuaConfig = ''
         local plugins = {
         	${pluginList config.programs.neovim.plugins}
         }
         local lazy_nix_helper_path = "${lazy-nix-helper-nvim}"
         if not vim.loop.fs_stat(lazy_nix_helper_path) then
         	lazy_nix_helper_path = vim.fn.stdpath("data") .. "/lazy_nix_helper/lazy_nix_helper.nvim"
         	if not vim.loop.fs_stat(lazy_nix_helper_path) then
         		vim.fn.system({
         			"git",
         			"clone",
         			"--filter=blob:none",
         			"https://github.com/b-src/lazy_nix_helper.nvim.git",
         			lazy_nix_helper_path,
         		})
         	end
         end

         -- add the Lazy Nix Helper plugin to the vim runtime
         vim.opt.rtp:prepend(lazy_nix_helper_path)

         -- call the Lazy Nix Helper setup function
         local non_nix_lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
         local lazy_nix_helper_opts = { lazypath = non_nix_lazypath, input_plugin_table = plugins }
         require("lazy-nix-helper").setup(lazy_nix_helper_opts)

         -- get the lazypath from Lazy Nix Helper
         local lazypath = require("lazy-nix-helper").lazypath()
         if not vim.loop.fs_stat(lazypath) then
         	vim.fn.system({
         		"git",
         		"clone",
         		"--filter=blob:none",
         		"https://github.com/folke/lazy.nvim.git",
         		"--branch=stable", -- latest stable release
         		lazypath,
         	})
         end
         vim.opt.rtp:prepend(lazypath)

        require("lazy").setup({
           spec = {
             -- add LazyVim and import its plugins
             { "LazyVim/LazyVim", import = "lazyvim.plugins" },
             -- import/override with your plugins
             { import = "plugins" },
           },
           defaults = {
             -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
             -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
             lazy = false,
             -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
             -- have outdated releases, which may break your Neovim install.
             version = false, -- always use the latest git commit
             -- version = "*", -- try installing the latest stable version for plugins that support semver
           },
           install = { colorscheme = { "tokyonight", "habamax" } },
           checker = {
             enabled = true, -- check for plugin updates periodically
             notify = false, -- notify on update
           }, -- automatically check for plugin updates
           performance = {
             rtp = {
               -- disable some rtp plugins
               disabled_plugins = {
                 "gzip",
                 -- "matchit",
                 -- "matchparen",
                 -- "netrwPlugin",
                 "tarPlugin",
                 "tohtml",
                 "tutor",
                 "zipPlugin",
               },
             },
           },
         })
      '';
    };

    xdg.configFile = {
      "nvim" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
