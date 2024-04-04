{
  config,
  lib,
  pkgs,
  ...
}: let
  # Custom function to create the Gerbera service
  mkGerberaService = name: cfg: {
    Unit = {
      Description = "Gerbera Media Server";
      After = ["network.target"];
      Wants = ["network.target"];
    };
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      User = cfg.user;
      Group = cfg.group;
      ExecStart = "${pkgs.gerbera}/bin/gerbera -c ${cfg.configFile}";
      Restart = "on-failure";
    };
  };
in {
  # Define the systemd service for Gerbera
  systemd.user.services.gerbera = mkGerberaService "gerbera" {
    user = "zack"; # Run the service as user Zack
    group = "users"; # Assuming 'users' is the desired group
    configFile = "/home/zack/.config/gerbera/config.xml"; # Path to Gerbera's configuration file
  };

  xdg.configFile."gerbera/config.xml" = {
    text = ''      <?xml version="1.0" encoding="UTF-8"?>
      <config version="2" xmlns="http://mediatomb.cc/config/2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://mediatomb.cc/config/2 http://mediatomb.cc/config/2.xsd">
        <!--
           See https://gerbera.io or read the docs for more
           information on creating and using config.xml configuration files.
          -->
        <server>
          <ui enabled="yes" show-tooltips="yes">
            <accounts enabled="no" session-timeout="30">
              <account user="gerbera" password="gerbera" />
            </accounts>
          </ui>
          <name>Gerbera</name>
          <udn>uuid:0a6ae022-d37b-4a24-934c-44a082ef777d</udn>
          <home>/home/zack/</home>
          <webroot>/nix/store/m6zb4pjvkkzm54qzfpa5zvfjgw39vw6q-gerbera-1.12.1/share/gerbera/web</webroot>
          <!--
              How frequently (in seconds) to send ssdp:alive advertisements.
              Minimum alive value accepted is: 62

              The advertisement will be sent every (A/2)-30 seconds,
              and will have a cache-control max-age of A where A is
              the value configured here. Ex: A value of 62 will result
              in an SSDP advertisement being sent every second.
          -->
          <alive>180</alive>
          <storage>
            <sqlite3 enabled="yes">
              <database-file>gerbera.db</database-file>
            </sqlite3>
          </storage>
          <containers enabled="yes">
            <container location="/LastAdded" title="Recently Added" sort="-last_updated">
              <filter>upnp:class derivedfrom "object.item" and last_updated &gt; "@last7"</filter>
            </container>
            <container location="/LastModified" title="Recently Modified" sort="-last_modified">
              <filter>upnp:class derivedfrom "object.item" and last_modified &gt; "@last7"</filter>
            </container>
          </containers>
          <extended-runtime-options>
            <mark-played-items enabled="no" suppress-cds-updates="yes">
              <string mode="prepend">*</string>
              <mark>
                <content>video</content>
              </mark>
            </mark-played-items>
          </extended-runtime-options>
        </server>
        <import hidden-files="no">
          <scripting script-charset="UTF-8">
            <common-script>/nix/store/m6zb4pjvkkzm54qzfpa5zvfjgw39vw6q-gerbera-1.12.1/share/gerbera/js/common.js</common-script>
            <playlist-script>/nix/store/m6zb4pjvkkzm54qzfpa5zvfjgw39vw6q-gerbera-1.12.1/share/gerbera/js/playlists.js</playlist-script>
            <metafile-script>/nix/store/m6zb4pjvkkzm54qzfpa5zvfjgw39vw6q-gerbera-1.12.1/share/gerbera/js/metadata.js</metafile-script>
            <virtual-layout type="builtin">
              <import-script>/nix/store/m6zb4pjvkkzm54qzfpa5zvfjgw39vw6q-gerbera-1.12.1/share/gerbera/js/import.js</import-script>
            </virtual-layout>
          </scripting>
          <mappings>
            <extension-mimetype ignore-unknown="no">
              <map from="asf" to="video/x-ms-asf" />
              <map from="asx" to="video/x-ms-asx" />
              <map from="dff" to="audio/x-dff" />
              <map from="dsd" to="audio/x-dsd" />
              <map from="dsf" to="audio/x-dsf" />
              <map from="flv" to="video/x-flv" />
              <map from="m2ts" to="video/mp2t" />
              <map from="m3u" to="audio/x-mpegurl" />
              <map from="m3u8" to="audio/x-mpegurl" />
              <map from="m4a" to="audio/mp4" />
              <map from="mka" to="audio/x-matroska" />
              <map from="mkv" to="video/x-matroska" />
              <map from="mp3" to="audio/mpeg" />
              <map from="mts" to="video/mp2t" />
              <map from="oga" to="audio/ogg" />
              <map from="ogg" to="audio/ogg" />
              <map from="ogm" to="video/ogg" />
              <map from="ogv" to="video/ogg" />
              <map from="ogx" to="application/ogg" />
              <map from="pls" to="audio/x-scpls" />
              <map from="ts" to="video/mp2t" />
              <map from="tsa" to="audio/mp2t" />
              <map from="tsv" to="video/mp2t" />
              <map from="wax" to="audio/x-ms-wax" />
              <map from="wm" to="video/x-ms-wm" />
              <map from="wma" to="audio/x-ms-wma" />
              <map from="wmv" to="video/x-ms-wmv" />
              <map from="wmx" to="video/x-ms-wmx" />
              <map from="wv" to="audio/x-wavpack" />
              <map from="wvx" to="video/x-ms-wvx" />
              <!-- Uncomment the line below for PS3 divx support -->
              <!-- <map from="avi" to="video/divx" /> -->
              <!-- Uncomment the line below for D-Link DSM / ZyXEL DMA-1000 -->
              <!-- <map from="avi" to="video/avi" /> -->
            </extension-mimetype>
            <mimetype-upnpclass>
              <map from="application/ogg" to="object.item.audioItem.musicTrack" />
              <map from="audio/*" to="object.item.audioItem.musicTrack" />
              <map from="image/*" to="object.item.imageItem" />
              <map from="video/*" to="object.item.videoItem" />
            </mimetype-upnpclass>
            <mimetype-contenttype>
              <treat mimetype="application/ogg" as="ogg" />
              <treat mimetype="audio/L16" as="pcm" />
              <treat mimetype="audio/flac" as="flac" />
              <treat mimetype="audio/mp4" as="mp4" />
              <treat mimetype="audio/mpeg" as="mp3" />
              <treat mimetype="audio/ogg" as="ogg" />
              <treat mimetype="audio/x-dsd" as="dsd" />
              <treat mimetype="audio/x-flac" as="flac" />
              <treat mimetype="audio/x-matroska" as="mka" />
              <treat mimetype="audio/x-mpegurl" as="playlist" />
              <treat mimetype="audio/x-ms-wma" as="wma" />
              <treat mimetype="audio/x-scpls" as="playlist" />
              <treat mimetype="audio/x-wav" as="pcm" />
              <treat mimetype="audio/x-wavpack" as="wv" />
              <treat mimetype="image/jpeg" as="jpg" />
              <treat mimetype="image/png" as="png" />
              <treat mimetype="video/mkv" as="mkv" />
              <treat mimetype="video/mp4" as="mp4" />
              <treat mimetype="video/mpeg" as="mpeg" />
              <treat mimetype="video/x-matroska" as="mkv" />
              <treat mimetype="video/x-mkv" as="mkv" />
              <treat mimetype="video/x-ms-asf" as="asf" />
              <treat mimetype="video/x-ms-asx" as="playlist" />
              <treat mimetype="video/x-msvideo" as="avi" />
            </mimetype-contenttype>
            <mimetype-dlnatransfermode>
              <map from="application/ogg" to="Streaming" />
              <map from="application/x-srt" to="Background" />
              <map from="audio/*" to="Streaming" />
              <map from="image/*" to="Interactive" />
              <map from="srt" to="Background" />
              <map from="text/*" to="Background" />
              <map from="video/*" to="Streaming" />
            </mimetype-dlnatransfermode>
            <contenttype-dlnaprofile>
              <map from="asf" to="VC_ASF_AP_L2_WMA" />
              <map from="avi" to="AVI" />
              <map from="dsd" to="DSF" />
              <map from="flac" to="FLAC" />
              <map from="jpg" to="JPEG_LRG" />
              <map from="mka" to="MKV" />
              <map from="mkv" to="MKV" />
              <map from="mp3" to="MP3" />
              <map from="mp4" to="AVC_MP4_EU" />
              <map from="mpeg" to="MPEG_PS_PAL" />
              <map from="ogg" to="OGG" />
              <map from="pcm" to="LPCM" />
              <map from="png" to="PNG_LRG" />
              <map from="wma" to="WMAFULL" />
            </contenttype-dlnaprofile>
          </mappings>
          <online-content>
            <AppleTrailers enabled="no" refresh="43200" update-at-start="no" resolution="640" />
          </online-content>
        </import>
        <transcoding enabled="no">
          <mimetype-profile-mappings>
            <transcode mimetype="application/ogg" using="vlcmpeg" />
            <transcode mimetype="audio/ogg" using="ogg2mp3" />
            <transcode mimetype="video/x-flv" using="vlcmpeg" />
          </mimetype-profile-mappings>
          <profiles>
            <profile name="ogg2mp3" enabled="no" type="external">
              <mimetype>audio/mpeg</mimetype>
              <accept-url>no</accept-url>
              <first-resource>yes</first-resource>
              <accept-ogg-theora>no</accept-ogg-theora>
              <agent command="ffmpeg" arguments="-y -i %in -f mp3 %out" />
              <buffer size="1048576" chunk-size="131072" fill-size="262144" />
            </profile>
            <profile name="vlcmpeg" enabled="no" type="external">
              <mimetype>video/mpeg</mimetype>
              <accept-url>yes</accept-url>
              <first-resource>yes</first-resource>
              <accept-ogg-theora>yes</accept-ogg-theora>
              <agent command="vlc" arguments="-I dummy %in --sout #transcode{venc=ffmpeg,vcodec=mp2v,vb=4096,fps=25,aenc=ffmpeg,acodec=mpga,ab=192,samplerate=44100,channels=2}:standard{access=file,mux=ps,dst=%out} vlc:quit" />
              <buffer size="14400000" chunk-size="512000" fill-size="120000" />
            </profile>
          </profiles>
        </transcoding>
      </config>'';
  };

  # Enable the service to start automatically
  systemd.user.startServices = true;
}
