#
# Cookbook Name:: osx
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

tmp = Chef::Config[:file_cache_path]
dlUrl = 'http://lib.roland.co.jp/support/jp/downloads/res/'

case node['platform_version']
when /10.8/
  dlUrl << '62472116/ua101_mx8d_v100.tgz'
  pkgid = 'jp.co.roland.RDUSB007D.SN108'
  pkgsum = 'ee2009016f9e71d773377faf900df71df9102a683b6f6931c5b7dd76c898f0eb'
  dlfile = 'ua101_mx8d_v100.tgz'
  filename = 'UA101USBDriver/UA101_USBDriver108.pkg'
when /10.9/
  dlUrl << '63061732/ua101_mx9d_v100.tgz'
  pkgid = 'jp.co.roland.UA101.app.109.pkg'
  pkgsum = 'c9354853151bb1ce1d8858b3943f4fd21cf5b1478988d2f8f4896c0c64bfbdd0'
  dlfile = 'ua101_mx9d_v100.tgz'
  filename = 'ua101_mx9d_v100/UA101_USBDriver109.pkg'
else
  dlUrl = ''
end

bash "UA-101 driver" do
  cwd tmp
  code <<-EOH
    wget #{dlUrl}
    tar -zxf #{dlfile} #{filename}
    installer -pkg "#{tmp}/#{filename}" -target / 
  EOH
  not_if "pkgutil --pkgs | grep #{pkgid}"
  not_if { File.exist? "#{tmp}/#{dlfile}" }
end

dmg_package "Install Adobe Flash Player" do
  volumes_dir "Flash Player"
  source "http://fpdownload.macromedia.com/get/flashplayer/current/licensing/mac/install_flash_player_11_osx_pkg.dmg"
  type "pkg"
  action :install
  package_id "com.adobe.pkg.FlashPlayer"
  checksum "92e1885970522da6b9fd67b60aa55406c1e3f0eae20ed0550614d02e0fa671be"
end

dmg_package "Google Chrome" do
  dmg_name "googlechrome"
  source "https://dl-ssl.google.com/chrome/mac/stable/GGRM/googlechrome.dmg"
  checksum "7daa2dc5c46d9bfb14f1d7ff4b33884325e5e63e694810adc58f14795165c91a"
  action :install
end


dmg_package "GoogleJapaneseInput" do
  source "https://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg"
  checksum "1cad917a9ef48dac5088649ee73d20bd965287ef30ab544a94127a07fab51700"
  type "pkg"
  package_id "com.google.pkg.GoogleJapaneseInput"
  action :install
end

