{ pkgs, readConfig }:

with pkgs;

let

  dotDir = ".config/zsh";

in {
  enable = true;

  dotDir = "${dotDir}";

  enableCompletion = true;

  enableAutosuggestions = false;

  initExtra = readConfig "init-extra.zsh";

  shellAliases = {
    "-g G" = "| grep -i";
    "-g H" = "| head";
    "-g L" = "| less";
    "-g NUL" = "> /dev/null 2>&1";
    "-g T" = "| tail";
    "-g F" = "| ${fzf}/bin/fzf -m";

    s = "sudo";
    se = "sudo -e";

    sc = "systemctl";
    scu = "systemctl --user";

    q = "quit";

    R = ". $HOME/${dotDir}/.zshrc; echo reloaded";

    cat = "${bat}/bin/bat";
    c = "${bat}/bin/bat";

    f = "${fd}/bin/fd";

    g = "${git}/bin/git";

    p = "${pass}/bin/pass";

    grep = "grep --color=auto";
    less = "less -R";

    la = "${exa}/bin/exa -aF";
    ll = "${exa}/bin/exa -lF";
    lla = "${exa}/bin/exa -laF";
    ls = "${exa}/bin/exa";

    pping = "${prettyping}/bin/prettyping";

    r = "${rsync}/bin/rsync -vhr --info=progress2";
    ru = "${rsync}/bin/rsync -vharzu --info=progress2";
    rud = "${rsync}/bin/rsync -vharzu --delete --info=progress2";

    yd = "${youtube-dl-light}/bin/youtube-dl";
    ydl = "${youtube-dl-light}/bin/youtube-dl --list-formats";
    ydb = "${youtube-dl-light}/bin/youtube-dl -f bestvideo+bestaudio";
    ydm = ''${youtube-dl-light}/bin/youtube-dl -f "bestvideo[height<=480]+bestaudio/best[height<=480]"'';
    yda = "${youtube-dl-light}/bin/youtube-dl --extract-audio --audio-format mp3";

    va = "${vagrant}/bin/vagrant";
    vau = "${vagrant}/bin/vagrant up";
    vap = "${vagrant}/bin/vagrant provision";
    vad = "${vagrant}/bin/vagrant destroy";
    vah = "${vagrant}/bin/vagrant halt";
    vas = "${vagrant}/bin/vagrant suspend";
    var = "${vagrant}/bin/vagrant resume";
    varl = "${vagrant}/bin/vagrant reload";
    vast = "${vagrant}/bin/vagrant status";
    vag = "${vagrant}/bin/vagrant global-status";
    vash = "${vagrant}/bin/vagrant ssh";

    dc = "${docker-compose}/bin/docker-compose";
    dcu = "${docker-compose}/bin/docker-compose up -d";
    dcd = "${docker-compose}/bin/docker-compose down";
    dcr = "${docker-compose}/bin/docker-compose restart";
    dcl = "${docker-compose}/bin/docker-compose logs";
    dclf = "${docker-compose}/bin/docker-compose logs -f";

    nosr = "sudo nixos-rebuild switch";

    s7vpn = "sudo ${openvpn}/bin/openvpn $HOME/s7/client.ovpn";
    s7gc = "s7_git_config";
  };

  history = {
    share = false;
  };
}
